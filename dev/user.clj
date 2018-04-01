;; Copyright © 2016-2018, JUXT LTD.

(ns user
  (:require
   [clojure.tools.namespace.repl :refer :all]
   [io.aviso.ansi]
   [integrant.repl.state]
   [io.aviso.ansi]
   [spyscope.core]))

(when (System/getProperty "load_nrepl")
  (require 'nrepl))

(defn dev
  "Call this to launch the dev system"
  []
  (println "[Rock] Loading Clojure code, please wait...")
  (require 'dev)
  (in-ns 'dev))
