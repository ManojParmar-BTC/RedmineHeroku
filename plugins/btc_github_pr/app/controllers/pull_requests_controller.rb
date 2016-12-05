class PullRequestsController < ApplicationController
  #unloadable
  PR_DIFF_URL = "https://patch-diff.githubusercontent.com/raw/"
  
  def index
    @project = Project.find(params[:project_id])
    @pull_requests = PullRequest.where(project_id: @project.id).order(id: :desc)
  end

  def github_hook
    if verify_signature?
      begin
        if params[:pull_request].present?
          pull_request = PullRequest.find_or_create_by(git_id: params[:pull_request][:id], project_id: Project.find_by(identifier: params[:project_id]).id)
          pull_request.update_attributes(no: params[:pull_request][:number],
                                          git_id: params[:pull_request][:id],
                                          html_url: params[:pull_request][:html_url],
                                          difference_url: params[:pull_request][:html_url]+"/files",
                                          state: params[:pull_request][:state],
                                          title: params[:pull_request][:title],
                                          difference_html: html_content_for_files(params[:pull_request][:html_url], params[:pull_request][:number]))
        end
      rescue Exception => e
        puts e.message  
        puts e.backtrace.inspect  
      end  
    end

    if params[:issue].present?
      begin
        project = Project.find_by(identifier: params[:project_id])
        issue = Issue.find_or_create_by(github_id: params[:issue][:id])

        unless IssuePriority.where(project_id: project.id).present?
          IssuePriority.create(name: "Normal", project_id: project.id)
        end
        
        issue.update_attributes(subject: params[:issue][:title], 
                                description: params[:issue][:body], 
                                priority_id: IssuePriority.where(project_id: project.id).first.id, 
                                tracker_id: project.trackers.first, 
                                project_id: project.id,
                                status_id: IssueStatus.find_or_create_by(name: params[:issue][:state]).id, 
                                author_id: User.where(admin: true).first.id, 
                                start_date: Date.parse(params[:issue][:created_at]));
      rescue => e
        puts "error #{e}"
      end
    end
    render nothing: true, status: :ok    
  end

  def view_changed_files
    @pull_request = PullRequest.find params[:id]
  end

  def verify_signature?
    request.body.rewind
    payload_body = request.body.read
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), Rails.configuration.secret_token, payload_body)
    return Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
  end

  def get_diff(path)
    begin
      uri = URI(path)
      Net::HTTP.get_response(uri).body
    rescue => e
      puts "error #{e}"
    end
  end

  def html_content_for_files(pr_diff_url, pr_no)
      author = pr_diff_url.split("/")[3]  
      repo = pr_diff_url.split("/")[4]
      url = PR_DIFF_URL + "#{author}/#{repo}/pull/#{pr_no}.diff"
      files_differences = get_diff(url).gsub!("\n", "<br/>")
      files_differences.gsub!(/^diff --git/, "<b> File Changed: </b>")
      files_differences.gsub!(files_differences[files_differences.index("a/")..files_differences.index("b/")], "")
      lines = files_differences.split("<br/>")
      lines.delete_if {|line| line.start_with?("---") || line.start_with?("+++") }
      html_content = "<table>";
      lines.each do |line|
        if line.start_with? "-"
          html_content << "<tr style='background-color: pink'><td>"+ line + "</td></tr>"
        elsif line.start_with? "+"
          html_content << "<tr style='background-color: #c1e9c1'><td>"+ line + "</td></tr>"
        else
          html_content << "<tr><td>" + line + "</td></tr>"
        end      
      end
      html_content << "</table>"      
  end
end
