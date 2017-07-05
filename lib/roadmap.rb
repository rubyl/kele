module Roadmap
  def get_roadmap(id)
    response = self.class.get(api_url("roadmaps/#{id}"), user_auth)
    @roadmap_data = JSON.parse(response.body)
  end

  def get_checkpoint(id)
    response = self.class.get(api_url("checkpoints/#{id}"), user_auth)
    @checkpoint_data = JSON.parse(response.body)
  end
end
