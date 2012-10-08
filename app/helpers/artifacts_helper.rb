module ArtifactsHelper
  
    TYPE = {'Text' => 1, 'Binary' => 2, 'Zip' => 3}
    
    def get_ArtifactTypeText(artifact_type)
      artifact_type = TYPE.index(artifact_type)
      "<span class='label label-default'>#{artifact_type}</span>"
  end 

end
