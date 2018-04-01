(ns rock.main
  (:require
   [camel-snake-kebab.core :refer [->snake_case_string]]
   [cheshire.core :as json]
   [clojure.java.io :as io]))

(defn creds->map [creds]
  (zipmap
    [:access-key :secret-key]
    ((juxt (memfn getAWSAccessKeyId)
           (memfn getAWSSecretKey)) creds)))

(defn refresh-creds []
  (.refresh (com.amazonaws.auth.DefaultAWSCredentialsProviderChain/getInstance)))

(defn -main []
  (.mkdirs (io/file "target"))
  (spit "target/packer.json"
        (json/encode
          {:variables {}
           :builders
           [(merge #_(creds->map (.getCredentials (com.amazonaws.auth.DefaultAWSCredentialsProviderChain/getInstance)))
                   {:profile "mask"
                    :region "eu-west-1"}

                   {:type "amazon-ebs"
                    :instance-type "t2.small"
                    :ssh-username "root"
                    :ami-name "juxt-rock-003"
                    :source-ami "ami-0b8ec472"
                    ;; Regions to copy
                    ;;:ami-regions "eu-central-1"
                    }

                   {:ami-groups ["all"]})
            ]
           :provisioners
           [{:type :shell
             :script "resources/packer/install-base"}
            {:type :file
             :source "resources/packer/files/etc/timesyncd.conf"
             :destination "/etc/timesyncd.conf"}
            {:type :shell
             :script "resources/packer/remove-llmnr"}]}

          {:key-fn ->snake_case_string
           :pretty true})))
