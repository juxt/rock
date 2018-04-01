(ns rock.rebel.main
  (:require
    rebel-readline.clojure.main
    rebel-readline.core
    io.aviso.ansi))

(defn -main
  [& args]
  (rebel-readline.core/ensure-terminal
    (rebel-readline.clojure.main/repl
      :init (fn []
              (try
                (println "[Rock] Loading Clojure code, please wait...")
                (require 'dev)
                (in-ns 'dev)
                (println (io.aviso.ansi/bold-yellow "[Rock] Now enter (go) to start the dev system"))
                (catch Exception e
                  (.printStackTrace e)
                  (println "[Rock] Failed to require dev, this usually means there was a syntax error. See exception above.")
                  (println "[Rock] Please correct it, and enter (fixed!) to resume development.")))))))
