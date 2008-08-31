diff --git a/activerecord/lib/active_record/connection_adapters/mysql_adapter.rb b/activerecord/lib/active_record/connection_adapters/mysql_adapter.rb
index f00a2c8..023b519 100755
--- a/activerecord/lib/active_record/connection_adapters/mysql_adapter.rb
+++ b/activerecord/lib/active_record/connection_adapters/mysql_adapter.rb
@@ -509,13 +509,46 @@ module ActiveRecord
           # Turn this off. http://dev.rubyonrails.org/ticket/6778
           execute("SET SQL_AUTO_IS_NULL=0")
         end
+        
+        require 'drb'
+        include DRb::DRbUndumped
 
         def select(sql, name = nil)
-          @connection.query_with_result = true
-          result = execute(sql, name)
-          rows = result.all_hashes
-          result.free
-          rows
+          DrbNetworkReader.query(sql, name)
+        end
+        
+        class DrbNetworkReader
+          require 'drb'
+          
+          def self.query(sql, name)
+            singleton.query(sql, name)
+          end
+          
+          def self.singleton
+            @singleton ||= new
+          end
+          
+          def initialize
+            start_service
+          end
+          
+          def service
+            @service ||= DRb.start_service
+          end
+          
+          alias_method :start_service, :service
+          
+          def address
+            @address ||= 'druby://127.0.0.1:10000'
+          end
+          
+          def object
+            @object ||= DRbObject.new(nil, address)
+          end
+          
+          def query(sql, name)
+            object.select(sql, name)
+          end
         end
 
         def supports_views?
