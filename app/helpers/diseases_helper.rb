module DiseasesHelper
  def omim_link(omim_id)  #Generate omim entry link from omim id
    "http://www.omim.org/entry/" + omim_id.to_s
  end
end
