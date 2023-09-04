;; Copyright © 2023, JUXT LTD.

(ns juxt.rock.tasks
  (:require
   [aero.core :as aero]
   [babashka.http-client :as http]
   [cheshire.core :as json]

   [clojure.java.io :as io]))

(defn get-ami-info [{:keys [region type]}]
  (let [{:keys [status body]}
        (http/get
         "https://5nplxwo1k1.execute-api.eu-central-1.amazonaws.com/prod")]
    (when (= status 200)
      (first
       (let [amis (get (json/parse-string body) "arch_amis")]
         (filter
          (fn [ami] (and (= region (get ami "region"))
                         (= type (get ami "type"))))
          amis))))))

(defmethod aero/reader 'juxt.rock/latest-ami
  [_ _ args]
  (or
   (when-let [ami-info (get-ami-info args)]
     (get ami-info "ami"))
   "ERROR"))

(defn generate-packer-config []
  (let [destfile (io/file "rock.json")]
    (spit
     destfile
     (->
      (aero/read-config "rock.edn" {})
      (get :packer-config)
      (json/generate-string {:pretty true})))
    (println "Generated packer configuration to" (.getAbsolutePath destfile))))
