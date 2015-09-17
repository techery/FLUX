require "./tools/immutabler/core.rb"

gen_path = "./MasterApp/gen"

immutabler :FLXMiddlewareModels do
   output_dir(gen_path)
   prefix('FLX')
   
   link_to :FLXBaseAction
   link_to :FLXBaseState

   model :ActionStackNode do
       fields do
           prop :createdAt, :NSDate
           prop :action, :FLXBaseAction
       end
   end

   model :StoreStateNode do
       fields do
           prop :createdAt, :NSDate
           prop :storeClassString, :string
           prop :state, :FLXBaseState
       end
   end
end
