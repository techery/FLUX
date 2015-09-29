require "./tools/immutabler/core.rb"

gen_path = "./MasterApp/gen"

immutabler :FLXMiddlewareModels do
   output_dir(gen_path)
   prefix('FLX')

   model :ActionStackNode do
       fields do
           prop :createdAt, :NSDate
           prop :action, :NSObject
       end
   end

   model :StoreStateNode do
       fields do
           prop :createdAt, :NSDate
           prop :storeClassString, :string
           prop :state, :NSObject
       end
   end
end
