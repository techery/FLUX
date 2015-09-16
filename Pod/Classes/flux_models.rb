require "./tools/immutabler/core.rb"

gen_path = "./MasterApp/gen"

immutabler :TEMiddlewareModels do
   output_dir(gen_path)
   prefix('TE')
   
   link_to :TEBaseAction
   link_to :TEBaseState

   model :ActionStackNode do
       fields do
           prop :createdAt, :NSDate
           prop :action, :TEBaseAction
       end
   end

   model :StoreStateNode do
       fields do
           prop :createdAt, :NSDate
           prop :storeClassString, :string
           prop :state, :TEBaseState
       end
   end
end
