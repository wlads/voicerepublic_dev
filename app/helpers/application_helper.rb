module ApplicationHelper
  
  # limit number of words beeing displayed.
  #
  def limit_words(txt, num)
    txt = "" if txt.nil?
    arr = txt.split(" ")
    arr.length > num-1 ? arr[0..num-1].join(" ").concat(" ...") : txt
  end
  
  def app_mode
    Rails.env
  end

  def git_revision
    gi = KluuuCode::GitInfo.new(Rails.root)
    gi.latest
  end
  
end
