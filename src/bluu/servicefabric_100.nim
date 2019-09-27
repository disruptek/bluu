
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ServiceFabricClient
## version: 1.0.0
## termsOfService: (not provided)
## license: (not provided)
## 
## 
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_593421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593421): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "servicefabric"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ClusterHealthsGet_593643 = ref object of OpenApiRestCall_593421
proc url_ClusterHealthsGet_593645(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterHealthsGet_593644(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get cluster healths
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   ApplicationsHealthStateFilter: JString
  ##                                : The filter of the applications health state
  ##   EventsHealthStateFilter: JString
  ##                          : The filter of the events health state
  ##   NodesHealthStateFilter: JString
  ##                         : The filter of the nodes health state
  section = newJObject()
  var valid_593804 = query.getOrDefault("timeout")
  valid_593804 = validateParameter(valid_593804, JInt, required = false, default = nil)
  if valid_593804 != nil:
    section.add "timeout", valid_593804
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593805 = query.getOrDefault("api-version")
  valid_593805 = validateParameter(valid_593805, JString, required = true,
                                 default = nil)
  if valid_593805 != nil:
    section.add "api-version", valid_593805
  var valid_593806 = query.getOrDefault("ApplicationsHealthStateFilter")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "ApplicationsHealthStateFilter", valid_593806
  var valid_593807 = query.getOrDefault("EventsHealthStateFilter")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "EventsHealthStateFilter", valid_593807
  var valid_593808 = query.getOrDefault("NodesHealthStateFilter")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "NodesHealthStateFilter", valid_593808
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593831: Call_ClusterHealthsGet_593643; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get cluster healths
  ## 
  let valid = call_593831.validator(path, query, header, formData, body)
  let scheme = call_593831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593831.url(scheme.get, call_593831.host, call_593831.base,
                         call_593831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593831, url, valid)

proc call*(call_593902: Call_ClusterHealthsGet_593643; apiVersion: string;
          timeout: int = 0; ApplicationsHealthStateFilter: string = "";
          EventsHealthStateFilter: string = ""; NodesHealthStateFilter: string = ""): Recallable =
  ## clusterHealthsGet
  ## Get cluster healths
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   ApplicationsHealthStateFilter: string
  ##                                : The filter of the applications health state
  ##   EventsHealthStateFilter: string
  ##                          : The filter of the events health state
  ##   NodesHealthStateFilter: string
  ##                         : The filter of the nodes health state
  var query_593903 = newJObject()
  add(query_593903, "timeout", newJInt(timeout))
  add(query_593903, "api-version", newJString(apiVersion))
  add(query_593903, "ApplicationsHealthStateFilter",
      newJString(ApplicationsHealthStateFilter))
  add(query_593903, "EventsHealthStateFilter", newJString(EventsHealthStateFilter))
  add(query_593903, "NodesHealthStateFilter", newJString(NodesHealthStateFilter))
  result = call_593902.call(nil, query_593903, nil, nil, nil)

var clusterHealthsGet* = Call_ClusterHealthsGet_593643(name: "clusterHealthsGet",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/$/GetClusterHealth", validator: validate_ClusterHealthsGet_593644,
    base: "", url: url_ClusterHealthsGet_593645, schemes: {Scheme.Https})
type
  Call_ClusterManifestsGet_593943 = ref object of OpenApiRestCall_593421
proc url_ClusterManifestsGet_593945(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterManifestsGet_593944(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get cluster manifests
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_593946 = query.getOrDefault("timeout")
  valid_593946 = validateParameter(valid_593946, JInt, required = false, default = nil)
  if valid_593946 != nil:
    section.add "timeout", valid_593946
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593947 = query.getOrDefault("api-version")
  valid_593947 = validateParameter(valid_593947, JString, required = true,
                                 default = nil)
  if valid_593947 != nil:
    section.add "api-version", valid_593947
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593948: Call_ClusterManifestsGet_593943; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get cluster manifests
  ## 
  let valid = call_593948.validator(path, query, header, formData, body)
  let scheme = call_593948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593948.url(scheme.get, call_593948.host, call_593948.base,
                         call_593948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593948, url, valid)

proc call*(call_593949: Call_ClusterManifestsGet_593943; apiVersion: string;
          timeout: int = 0): Recallable =
  ## clusterManifestsGet
  ## Get cluster manifests
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  var query_593950 = newJObject()
  add(query_593950, "timeout", newJInt(timeout))
  add(query_593950, "api-version", newJString(apiVersion))
  result = call_593949.call(nil, query_593950, nil, nil, nil)

var clusterManifestsGet* = Call_ClusterManifestsGet_593943(
    name: "clusterManifestsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/$/GetClusterManifest",
    validator: validate_ClusterManifestsGet_593944, base: "",
    url: url_ClusterManifestsGet_593945, schemes: {Scheme.Https})
type
  Call_ClusterLoadInformationsGet_593951 = ref object of OpenApiRestCall_593421
proc url_ClusterLoadInformationsGet_593953(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterLoadInformationsGet_593952(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get cluster load informations
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_593954 = query.getOrDefault("timeout")
  valid_593954 = validateParameter(valid_593954, JInt, required = false, default = nil)
  if valid_593954 != nil:
    section.add "timeout", valid_593954
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593955 = query.getOrDefault("api-version")
  valid_593955 = validateParameter(valid_593955, JString, required = true,
                                 default = nil)
  if valid_593955 != nil:
    section.add "api-version", valid_593955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593956: Call_ClusterLoadInformationsGet_593951; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get cluster load informations
  ## 
  let valid = call_593956.validator(path, query, header, formData, body)
  let scheme = call_593956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593956.url(scheme.get, call_593956.host, call_593956.base,
                         call_593956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593956, url, valid)

proc call*(call_593957: Call_ClusterLoadInformationsGet_593951; apiVersion: string;
          timeout: int = 0): Recallable =
  ## clusterLoadInformationsGet
  ## Get cluster load informations
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  var query_593958 = newJObject()
  add(query_593958, "timeout", newJInt(timeout))
  add(query_593958, "api-version", newJString(apiVersion))
  result = call_593957.call(nil, query_593958, nil, nil, nil)

var clusterLoadInformationsGet* = Call_ClusterLoadInformationsGet_593951(
    name: "clusterLoadInformationsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/$/GetLoadInformation",
    validator: validate_ClusterLoadInformationsGet_593952, base: "",
    url: url_ClusterLoadInformationsGet_593953, schemes: {Scheme.Https})
type
  Call_UpgradeProgressesGet_593959 = ref object of OpenApiRestCall_593421
proc url_UpgradeProgressesGet_593961(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_UpgradeProgressesGet_593960(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get upgrade progresses
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_593962 = query.getOrDefault("timeout")
  valid_593962 = validateParameter(valid_593962, JInt, required = false, default = nil)
  if valid_593962 != nil:
    section.add "timeout", valid_593962
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593963 = query.getOrDefault("api-version")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "api-version", valid_593963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593964: Call_UpgradeProgressesGet_593959; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get upgrade progresses
  ## 
  let valid = call_593964.validator(path, query, header, formData, body)
  let scheme = call_593964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593964.url(scheme.get, call_593964.host, call_593964.base,
                         call_593964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593964, url, valid)

proc call*(call_593965: Call_UpgradeProgressesGet_593959; apiVersion: string;
          timeout: int = 0): Recallable =
  ## upgradeProgressesGet
  ## Get upgrade progresses
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  var query_593966 = newJObject()
  add(query_593966, "timeout", newJInt(timeout))
  add(query_593966, "api-version", newJString(apiVersion))
  result = call_593965.call(nil, query_593966, nil, nil, nil)

var upgradeProgressesGet* = Call_UpgradeProgressesGet_593959(
    name: "upgradeProgressesGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/$/GetUpgradeProgress",
    validator: validate_UpgradeProgressesGet_593960, base: "",
    url: url_UpgradeProgressesGet_593961, schemes: {Scheme.Https})
type
  Call_ClusterUpgradesResume_593967 = ref object of OpenApiRestCall_593421
proc url_ClusterUpgradesResume_593969(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterUpgradesResume_593968(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resume cluster upgrades
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_593970 = query.getOrDefault("timeout")
  valid_593970 = validateParameter(valid_593970, JInt, required = false, default = nil)
  if valid_593970 != nil:
    section.add "timeout", valid_593970
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593971 = query.getOrDefault("api-version")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "api-version", valid_593971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resumeClusterUpgrade: JObject (required)
  ##                       : The upgrade of the cluster
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593973: Call_ClusterUpgradesResume_593967; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resume cluster upgrades
  ## 
  let valid = call_593973.validator(path, query, header, formData, body)
  let scheme = call_593973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593973.url(scheme.get, call_593973.host, call_593973.base,
                         call_593973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593973, url, valid)

proc call*(call_593974: Call_ClusterUpgradesResume_593967; apiVersion: string;
          resumeClusterUpgrade: JsonNode; timeout: int = 0): Recallable =
  ## clusterUpgradesResume
  ## Resume cluster upgrades
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   resumeClusterUpgrade: JObject (required)
  ##                       : The upgrade of the cluster
  var query_593975 = newJObject()
  var body_593976 = newJObject()
  add(query_593975, "timeout", newJInt(timeout))
  add(query_593975, "api-version", newJString(apiVersion))
  if resumeClusterUpgrade != nil:
    body_593976 = resumeClusterUpgrade
  result = call_593974.call(nil, query_593975, nil, nil, body_593976)

var clusterUpgradesResume* = Call_ClusterUpgradesResume_593967(
    name: "clusterUpgradesResume", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/MoveToNextUpgradeDomain",
    validator: validate_ClusterUpgradesResume_593968, base: "",
    url: url_ClusterUpgradesResume_593969, schemes: {Scheme.Https})
type
  Call_ClusterPackagesRegister_593977 = ref object of OpenApiRestCall_593421
proc url_ClusterPackagesRegister_593979(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterPackagesRegister_593978(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Register cluster packages
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_593980 = query.getOrDefault("timeout")
  valid_593980 = validateParameter(valid_593980, JInt, required = false, default = nil)
  if valid_593980 != nil:
    section.add "timeout", valid_593980
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593981 = query.getOrDefault("api-version")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "api-version", valid_593981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   registerClusterPackage: JObject (required)
  ##                         : The package of the register cluster
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593983: Call_ClusterPackagesRegister_593977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Register cluster packages
  ## 
  let valid = call_593983.validator(path, query, header, formData, body)
  let scheme = call_593983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593983.url(scheme.get, call_593983.host, call_593983.base,
                         call_593983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593983, url, valid)

proc call*(call_593984: Call_ClusterPackagesRegister_593977;
          registerClusterPackage: JsonNode; apiVersion: string; timeout: int = 0): Recallable =
  ## clusterPackagesRegister
  ## Register cluster packages
  ##   timeout: int
  ##          : The timeout in seconds
  ##   registerClusterPackage: JObject (required)
  ##                         : The package of the register cluster
  ##   apiVersion: string (required)
  ##             : The version of the api
  var query_593985 = newJObject()
  var body_593986 = newJObject()
  add(query_593985, "timeout", newJInt(timeout))
  if registerClusterPackage != nil:
    body_593986 = registerClusterPackage
  add(query_593985, "api-version", newJString(apiVersion))
  result = call_593984.call(nil, query_593985, nil, nil, body_593986)

var clusterPackagesRegister* = Call_ClusterPackagesRegister_593977(
    name: "clusterPackagesRegister", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/Provision",
    validator: validate_ClusterPackagesRegister_593978, base: "",
    url: url_ClusterPackagesRegister_593979, schemes: {Scheme.Https})
type
  Call_ClusterHealthsSend_593987 = ref object of OpenApiRestCall_593421
proc url_ClusterHealthsSend_593989(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterHealthsSend_593988(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Report cluster healths
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_593990 = query.getOrDefault("timeout")
  valid_593990 = validateParameter(valid_593990, JInt, required = false, default = nil)
  if valid_593990 != nil:
    section.add "timeout", valid_593990
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593991 = query.getOrDefault("api-version")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "api-version", valid_593991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   clusterHealthReport: JObject (required)
  ##                      : The report of the cluster health
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593993: Call_ClusterHealthsSend_593987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Report cluster healths
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_ClusterHealthsSend_593987;
          clusterHealthReport: JsonNode; apiVersion: string; timeout: int = 0): Recallable =
  ## clusterHealthsSend
  ## Report cluster healths
  ##   timeout: int
  ##          : The timeout in seconds
  ##   clusterHealthReport: JObject (required)
  ##                      : The report of the cluster health
  ##   apiVersion: string (required)
  ##             : The version of the api
  var query_593995 = newJObject()
  var body_593996 = newJObject()
  add(query_593995, "timeout", newJInt(timeout))
  if clusterHealthReport != nil:
    body_593996 = clusterHealthReport
  add(query_593995, "api-version", newJString(apiVersion))
  result = call_593994.call(nil, query_593995, nil, nil, body_593996)

var clusterHealthsSend* = Call_ClusterHealthsSend_593987(
    name: "clusterHealthsSend", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/ReportClusterHealth",
    validator: validate_ClusterHealthsSend_593988, base: "",
    url: url_ClusterHealthsSend_593989, schemes: {Scheme.Https})
type
  Call_ClusterUpgradesRollback_593997 = ref object of OpenApiRestCall_593421
proc url_ClusterUpgradesRollback_593999(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterUpgradesRollback_593998(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rollback cluster upgrades
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594000 = query.getOrDefault("timeout")
  valid_594000 = validateParameter(valid_594000, JInt, required = false, default = nil)
  if valid_594000 != nil:
    section.add "timeout", valid_594000
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594001 = query.getOrDefault("api-version")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "api-version", valid_594001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594002: Call_ClusterUpgradesRollback_593997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rollback cluster upgrades
  ## 
  let valid = call_594002.validator(path, query, header, formData, body)
  let scheme = call_594002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594002.url(scheme.get, call_594002.host, call_594002.base,
                         call_594002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594002, url, valid)

proc call*(call_594003: Call_ClusterUpgradesRollback_593997; apiVersion: string;
          timeout: int = 0): Recallable =
  ## clusterUpgradesRollback
  ## Rollback cluster upgrades
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  var query_594004 = newJObject()
  add(query_594004, "timeout", newJInt(timeout))
  add(query_594004, "api-version", newJString(apiVersion))
  result = call_594003.call(nil, query_594004, nil, nil, nil)

var clusterUpgradesRollback* = Call_ClusterUpgradesRollback_593997(
    name: "clusterUpgradesRollback", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/RollbackUpgrade",
    validator: validate_ClusterUpgradesRollback_593998, base: "",
    url: url_ClusterUpgradesRollback_593999, schemes: {Scheme.Https})
type
  Call_ClusterPackagesUnregister_594005 = ref object of OpenApiRestCall_593421
proc url_ClusterPackagesUnregister_594007(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterPackagesUnregister_594006(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unregister cluster packages
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594008 = query.getOrDefault("timeout")
  valid_594008 = validateParameter(valid_594008, JInt, required = false, default = nil)
  if valid_594008 != nil:
    section.add "timeout", valid_594008
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594009 = query.getOrDefault("api-version")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "api-version", valid_594009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   unregisterClusterPackage: JObject (required)
  ##                           : The package of the unregister cluster
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594011: Call_ClusterPackagesUnregister_594005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unregister cluster packages
  ## 
  let valid = call_594011.validator(path, query, header, formData, body)
  let scheme = call_594011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594011.url(scheme.get, call_594011.host, call_594011.base,
                         call_594011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594011, url, valid)

proc call*(call_594012: Call_ClusterPackagesUnregister_594005; apiVersion: string;
          unregisterClusterPackage: JsonNode; timeout: int = 0): Recallable =
  ## clusterPackagesUnregister
  ## Unregister cluster packages
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   unregisterClusterPackage: JObject (required)
  ##                           : The package of the unregister cluster
  var query_594013 = newJObject()
  var body_594014 = newJObject()
  add(query_594013, "timeout", newJInt(timeout))
  add(query_594013, "api-version", newJString(apiVersion))
  if unregisterClusterPackage != nil:
    body_594014 = unregisterClusterPackage
  result = call_594012.call(nil, query_594013, nil, nil, body_594014)

var clusterPackagesUnregister* = Call_ClusterPackagesUnregister_594005(
    name: "clusterPackagesUnregister", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/Unprovision",
    validator: validate_ClusterPackagesUnregister_594006, base: "",
    url: url_ClusterPackagesUnregister_594007, schemes: {Scheme.Https})
type
  Call_ClusterUpgradesUpdate_594015 = ref object of OpenApiRestCall_593421
proc url_ClusterUpgradesUpdate_594017(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterUpgradesUpdate_594016(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update cluster upgrades
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594018 = query.getOrDefault("timeout")
  valid_594018 = validateParameter(valid_594018, JInt, required = false, default = nil)
  if valid_594018 != nil:
    section.add "timeout", valid_594018
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594019 = query.getOrDefault("api-version")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "api-version", valid_594019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateClusterUpgrade: JObject (required)
  ##                       : The description of the update cluster upgrade
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594021: Call_ClusterUpgradesUpdate_594015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update cluster upgrades
  ## 
  let valid = call_594021.validator(path, query, header, formData, body)
  let scheme = call_594021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594021.url(scheme.get, call_594021.host, call_594021.base,
                         call_594021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594021, url, valid)

proc call*(call_594022: Call_ClusterUpgradesUpdate_594015; apiVersion: string;
          updateClusterUpgrade: JsonNode; timeout: int = 0): Recallable =
  ## clusterUpgradesUpdate
  ## Update cluster upgrades
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   updateClusterUpgrade: JObject (required)
  ##                       : The description of the update cluster upgrade
  var query_594023 = newJObject()
  var body_594024 = newJObject()
  add(query_594023, "timeout", newJInt(timeout))
  add(query_594023, "api-version", newJString(apiVersion))
  if updateClusterUpgrade != nil:
    body_594024 = updateClusterUpgrade
  result = call_594022.call(nil, query_594023, nil, nil, body_594024)

var clusterUpgradesUpdate* = Call_ClusterUpgradesUpdate_594015(
    name: "clusterUpgradesUpdate", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/UpdateUpgrade",
    validator: validate_ClusterUpgradesUpdate_594016, base: "",
    url: url_ClusterUpgradesUpdate_594017, schemes: {Scheme.Https})
type
  Call_ClusterUpgradesStart_594025 = ref object of OpenApiRestCall_593421
proc url_ClusterUpgradesStart_594027(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterUpgradesStart_594026(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Start cluster upgrades
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594028 = query.getOrDefault("timeout")
  valid_594028 = validateParameter(valid_594028, JInt, required = false, default = nil)
  if valid_594028 != nil:
    section.add "timeout", valid_594028
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594029 = query.getOrDefault("api-version")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "api-version", valid_594029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   startClusterUpgrade: JObject (required)
  ##                      : The description of the start cluster upgrade
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594031: Call_ClusterUpgradesStart_594025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Start cluster upgrades
  ## 
  let valid = call_594031.validator(path, query, header, formData, body)
  let scheme = call_594031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594031.url(scheme.get, call_594031.host, call_594031.base,
                         call_594031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594031, url, valid)

proc call*(call_594032: Call_ClusterUpgradesStart_594025; apiVersion: string;
          startClusterUpgrade: JsonNode; timeout: int = 0): Recallable =
  ## clusterUpgradesStart
  ## Start cluster upgrades
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   startClusterUpgrade: JObject (required)
  ##                      : The description of the start cluster upgrade
  var query_594033 = newJObject()
  var body_594034 = newJObject()
  add(query_594033, "timeout", newJInt(timeout))
  add(query_594033, "api-version", newJString(apiVersion))
  if startClusterUpgrade != nil:
    body_594034 = startClusterUpgrade
  result = call_594032.call(nil, query_594033, nil, nil, body_594034)

var clusterUpgradesStart* = Call_ClusterUpgradesStart_594025(
    name: "clusterUpgradesStart", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/Upgrade",
    validator: validate_ClusterUpgradesStart_594026, base: "",
    url: url_ClusterUpgradesStart_594027, schemes: {Scheme.Https})
type
  Call_ApplicationTypesList_594035 = ref object of OpenApiRestCall_593421
proc url_ApplicationTypesList_594037(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ApplicationTypesList_594036(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List application types
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594038 = query.getOrDefault("timeout")
  valid_594038 = validateParameter(valid_594038, JInt, required = false, default = nil)
  if valid_594038 != nil:
    section.add "timeout", valid_594038
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594039 = query.getOrDefault("api-version")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "api-version", valid_594039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594040: Call_ApplicationTypesList_594035; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List application types
  ## 
  let valid = call_594040.validator(path, query, header, formData, body)
  let scheme = call_594040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594040.url(scheme.get, call_594040.host, call_594040.base,
                         call_594040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594040, url, valid)

proc call*(call_594041: Call_ApplicationTypesList_594035; apiVersion: string;
          timeout: int = 0): Recallable =
  ## applicationTypesList
  ## List application types
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  var query_594042 = newJObject()
  add(query_594042, "timeout", newJInt(timeout))
  add(query_594042, "api-version", newJString(apiVersion))
  result = call_594041.call(nil, query_594042, nil, nil, nil)

var applicationTypesList* = Call_ApplicationTypesList_594035(
    name: "applicationTypesList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/ApplicationTypes",
    validator: validate_ApplicationTypesList_594036, base: "",
    url: url_ApplicationTypesList_594037, schemes: {Scheme.Https})
type
  Call_ApplicationTypesRegister_594043 = ref object of OpenApiRestCall_593421
proc url_ApplicationTypesRegister_594045(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ApplicationTypesRegister_594044(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Register application types
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594046 = query.getOrDefault("timeout")
  valid_594046 = validateParameter(valid_594046, JInt, required = false, default = nil)
  if valid_594046 != nil:
    section.add "timeout", valid_594046
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594047 = query.getOrDefault("api-version")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "api-version", valid_594047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   registerApplicationType: JObject (required)
  ##                          : The type of the register application
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594049: Call_ApplicationTypesRegister_594043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Register application types
  ## 
  let valid = call_594049.validator(path, query, header, formData, body)
  let scheme = call_594049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594049.url(scheme.get, call_594049.host, call_594049.base,
                         call_594049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594049, url, valid)

proc call*(call_594050: Call_ApplicationTypesRegister_594043; apiVersion: string;
          registerApplicationType: JsonNode; timeout: int = 0): Recallable =
  ## applicationTypesRegister
  ## Register application types
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   registerApplicationType: JObject (required)
  ##                          : The type of the register application
  var query_594051 = newJObject()
  var body_594052 = newJObject()
  add(query_594051, "timeout", newJInt(timeout))
  add(query_594051, "api-version", newJString(apiVersion))
  if registerApplicationType != nil:
    body_594052 = registerApplicationType
  result = call_594050.call(nil, query_594051, nil, nil, body_594052)

var applicationTypesRegister* = Call_ApplicationTypesRegister_594043(
    name: "applicationTypesRegister", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/ApplicationTypes/$/Provision",
    validator: validate_ApplicationTypesRegister_594044, base: "",
    url: url_ApplicationTypesRegister_594045, schemes: {Scheme.Https})
type
  Call_ApplicationTypesGet_594053 = ref object of OpenApiRestCall_593421
proc url_ApplicationTypesGet_594055(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationTypeName" in path,
        "`applicationTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/ApplicationTypes/"),
               (kind: VariableSegment, value: "applicationTypeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationTypesGet_594054(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get application types
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationTypeName: JString (required)
  ##                      : The name of the application type
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `applicationTypeName` field"
  var valid_594070 = path.getOrDefault("applicationTypeName")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "applicationTypeName", valid_594070
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594071 = query.getOrDefault("timeout")
  valid_594071 = validateParameter(valid_594071, JInt, required = false, default = nil)
  if valid_594071 != nil:
    section.add "timeout", valid_594071
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594072 = query.getOrDefault("api-version")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "api-version", valid_594072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594073: Call_ApplicationTypesGet_594053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get application types
  ## 
  let valid = call_594073.validator(path, query, header, formData, body)
  let scheme = call_594073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594073.url(scheme.get, call_594073.host, call_594073.base,
                         call_594073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594073, url, valid)

proc call*(call_594074: Call_ApplicationTypesGet_594053; apiVersion: string;
          applicationTypeName: string; timeout: int = 0): Recallable =
  ## applicationTypesGet
  ## Get application types
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type
  var path_594075 = newJObject()
  var query_594076 = newJObject()
  add(query_594076, "timeout", newJInt(timeout))
  add(query_594076, "api-version", newJString(apiVersion))
  add(path_594075, "applicationTypeName", newJString(applicationTypeName))
  result = call_594074.call(path_594075, query_594076, nil, nil, nil)

var applicationTypesGet* = Call_ApplicationTypesGet_594053(
    name: "applicationTypesGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/ApplicationTypes/{applicationTypeName}",
    validator: validate_ApplicationTypesGet_594054, base: "",
    url: url_ApplicationTypesGet_594055, schemes: {Scheme.Https})
type
  Call_ApplicationManifestsGet_594077 = ref object of OpenApiRestCall_593421
proc url_ApplicationManifestsGet_594079(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationTypeName" in path,
        "`applicationTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/ApplicationTypes/"),
               (kind: VariableSegment, value: "applicationTypeName"),
               (kind: ConstantSegment, value: "/$/GetApplicationManifest")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationManifestsGet_594078(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get application manifests
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationTypeName: JString (required)
  ##                      : The name of the application type
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `applicationTypeName` field"
  var valid_594080 = path.getOrDefault("applicationTypeName")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "applicationTypeName", valid_594080
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   ApplicationTypeVersion: JString (required)
  ##                         : The version of the application type
  section = newJObject()
  var valid_594081 = query.getOrDefault("timeout")
  valid_594081 = validateParameter(valid_594081, JInt, required = false, default = nil)
  if valid_594081 != nil:
    section.add "timeout", valid_594081
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594082 = query.getOrDefault("api-version")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "api-version", valid_594082
  var valid_594083 = query.getOrDefault("ApplicationTypeVersion")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "ApplicationTypeVersion", valid_594083
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594084: Call_ApplicationManifestsGet_594077; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get application manifests
  ## 
  let valid = call_594084.validator(path, query, header, formData, body)
  let scheme = call_594084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594084.url(scheme.get, call_594084.host, call_594084.base,
                         call_594084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594084, url, valid)

proc call*(call_594085: Call_ApplicationManifestsGet_594077; apiVersion: string;
          applicationTypeName: string; ApplicationTypeVersion: string;
          timeout: int = 0): Recallable =
  ## applicationManifestsGet
  ## Get application manifests
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type
  ##   ApplicationTypeVersion: string (required)
  ##                         : The version of the application type
  var path_594086 = newJObject()
  var query_594087 = newJObject()
  add(query_594087, "timeout", newJInt(timeout))
  add(query_594087, "api-version", newJString(apiVersion))
  add(path_594086, "applicationTypeName", newJString(applicationTypeName))
  add(query_594087, "ApplicationTypeVersion", newJString(ApplicationTypeVersion))
  result = call_594085.call(path_594086, query_594087, nil, nil, nil)

var applicationManifestsGet* = Call_ApplicationManifestsGet_594077(
    name: "applicationManifestsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/ApplicationTypes/{applicationTypeName}/$/GetApplicationManifest",
    validator: validate_ApplicationManifestsGet_594078, base: "",
    url: url_ApplicationManifestsGet_594079, schemes: {Scheme.Https})
type
  Call_ServiceManifestsGet_594088 = ref object of OpenApiRestCall_593421
proc url_ServiceManifestsGet_594090(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationTypeName" in path,
        "`applicationTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/ApplicationTypes/"),
               (kind: VariableSegment, value: "applicationTypeName"),
               (kind: ConstantSegment, value: "/$/GetServiceManifest")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceManifestsGet_594089(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get service manifests
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationTypeName: JString (required)
  ##                      : The name of the application type
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `applicationTypeName` field"
  var valid_594091 = path.getOrDefault("applicationTypeName")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "applicationTypeName", valid_594091
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   ApplicationTypeVersion: JString (required)
  ##                         : The version of the application type
  ##   ServiceManifestName: JString (required)
  ##                      : The name of the service manifest
  section = newJObject()
  var valid_594092 = query.getOrDefault("timeout")
  valid_594092 = validateParameter(valid_594092, JInt, required = false, default = nil)
  if valid_594092 != nil:
    section.add "timeout", valid_594092
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594093 = query.getOrDefault("api-version")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "api-version", valid_594093
  var valid_594094 = query.getOrDefault("ApplicationTypeVersion")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "ApplicationTypeVersion", valid_594094
  var valid_594095 = query.getOrDefault("ServiceManifestName")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "ServiceManifestName", valid_594095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594096: Call_ServiceManifestsGet_594088; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service manifests
  ## 
  let valid = call_594096.validator(path, query, header, formData, body)
  let scheme = call_594096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594096.url(scheme.get, call_594096.host, call_594096.base,
                         call_594096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594096, url, valid)

proc call*(call_594097: Call_ServiceManifestsGet_594088; apiVersion: string;
          applicationTypeName: string; ApplicationTypeVersion: string;
          ServiceManifestName: string; timeout: int = 0): Recallable =
  ## serviceManifestsGet
  ## Get service manifests
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type
  ##   ApplicationTypeVersion: string (required)
  ##                         : The version of the application type
  ##   ServiceManifestName: string (required)
  ##                      : The name of the service manifest
  var path_594098 = newJObject()
  var query_594099 = newJObject()
  add(query_594099, "timeout", newJInt(timeout))
  add(query_594099, "api-version", newJString(apiVersion))
  add(path_594098, "applicationTypeName", newJString(applicationTypeName))
  add(query_594099, "ApplicationTypeVersion", newJString(ApplicationTypeVersion))
  add(query_594099, "ServiceManifestName", newJString(ServiceManifestName))
  result = call_594097.call(path_594098, query_594099, nil, nil, nil)

var serviceManifestsGet* = Call_ServiceManifestsGet_594088(
    name: "serviceManifestsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/ApplicationTypes/{applicationTypeName}/$/GetServiceManifest",
    validator: validate_ServiceManifestsGet_594089, base: "",
    url: url_ServiceManifestsGet_594090, schemes: {Scheme.Https})
type
  Call_ServiceTypesGet_594100 = ref object of OpenApiRestCall_593421
proc url_ServiceTypesGet_594102(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationTypeName" in path,
        "`applicationTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/ApplicationTypes/"),
               (kind: VariableSegment, value: "applicationTypeName"),
               (kind: ConstantSegment, value: "/$/GetServiceTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceTypesGet_594101(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get service types
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationTypeName: JString (required)
  ##                      : The name of the application type
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `applicationTypeName` field"
  var valid_594103 = path.getOrDefault("applicationTypeName")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "applicationTypeName", valid_594103
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   ApplicationTypeVersion: JString (required)
  ##                         : The version of the application type
  section = newJObject()
  var valid_594104 = query.getOrDefault("timeout")
  valid_594104 = validateParameter(valid_594104, JInt, required = false, default = nil)
  if valid_594104 != nil:
    section.add "timeout", valid_594104
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594105 = query.getOrDefault("api-version")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "api-version", valid_594105
  var valid_594106 = query.getOrDefault("ApplicationTypeVersion")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "ApplicationTypeVersion", valid_594106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594107: Call_ServiceTypesGet_594100; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service types
  ## 
  let valid = call_594107.validator(path, query, header, formData, body)
  let scheme = call_594107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594107.url(scheme.get, call_594107.host, call_594107.base,
                         call_594107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594107, url, valid)

proc call*(call_594108: Call_ServiceTypesGet_594100; apiVersion: string;
          applicationTypeName: string; ApplicationTypeVersion: string;
          timeout: int = 0): Recallable =
  ## serviceTypesGet
  ## Get service types
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type
  ##   ApplicationTypeVersion: string (required)
  ##                         : The version of the application type
  var path_594109 = newJObject()
  var query_594110 = newJObject()
  add(query_594110, "timeout", newJInt(timeout))
  add(query_594110, "api-version", newJString(apiVersion))
  add(path_594109, "applicationTypeName", newJString(applicationTypeName))
  add(query_594110, "ApplicationTypeVersion", newJString(ApplicationTypeVersion))
  result = call_594108.call(path_594109, query_594110, nil, nil, nil)

var serviceTypesGet* = Call_ServiceTypesGet_594100(name: "serviceTypesGet",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/ApplicationTypes/{applicationTypeName}/$/GetServiceTypes",
    validator: validate_ServiceTypesGet_594101, base: "", url: url_ServiceTypesGet_594102,
    schemes: {Scheme.Https})
type
  Call_ApplicationTypesUnregister_594111 = ref object of OpenApiRestCall_593421
proc url_ApplicationTypesUnregister_594113(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationTypeName" in path,
        "`applicationTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/ApplicationTypes/"),
               (kind: VariableSegment, value: "applicationTypeName"),
               (kind: ConstantSegment, value: "/$/Unprovision")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationTypesUnregister_594112(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unregister application types
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationTypeName: JString (required)
  ##                      : The name of the application type
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `applicationTypeName` field"
  var valid_594114 = path.getOrDefault("applicationTypeName")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "applicationTypeName", valid_594114
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594115 = query.getOrDefault("timeout")
  valid_594115 = validateParameter(valid_594115, JInt, required = false, default = nil)
  if valid_594115 != nil:
    section.add "timeout", valid_594115
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594116 = query.getOrDefault("api-version")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "api-version", valid_594116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   unregisterApplicationType: JObject (required)
  ##                            : The type of the unregister application
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594118: Call_ApplicationTypesUnregister_594111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unregister application types
  ## 
  let valid = call_594118.validator(path, query, header, formData, body)
  let scheme = call_594118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594118.url(scheme.get, call_594118.host, call_594118.base,
                         call_594118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594118, url, valid)

proc call*(call_594119: Call_ApplicationTypesUnregister_594111;
          unregisterApplicationType: JsonNode; apiVersion: string;
          applicationTypeName: string; timeout: int = 0): Recallable =
  ## applicationTypesUnregister
  ## Unregister application types
  ##   timeout: int
  ##          : The timeout in seconds
  ##   unregisterApplicationType: JObject (required)
  ##                            : The type of the unregister application
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type
  var path_594120 = newJObject()
  var query_594121 = newJObject()
  var body_594122 = newJObject()
  add(query_594121, "timeout", newJInt(timeout))
  if unregisterApplicationType != nil:
    body_594122 = unregisterApplicationType
  add(query_594121, "api-version", newJString(apiVersion))
  add(path_594120, "applicationTypeName", newJString(applicationTypeName))
  result = call_594119.call(path_594120, query_594121, nil, nil, body_594122)

var applicationTypesUnregister* = Call_ApplicationTypesUnregister_594111(
    name: "applicationTypesUnregister", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/ApplicationTypes/{applicationTypeName}/$/Unprovision",
    validator: validate_ApplicationTypesUnregister_594112, base: "",
    url: url_ApplicationTypesUnregister_594113, schemes: {Scheme.Https})
type
  Call_ApplicationsList_594123 = ref object of OpenApiRestCall_593421
proc url_ApplicationsList_594125(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ApplicationsList_594124(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## List applications
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   continuation-token: JString
  ##                     : The token of the continuation
  section = newJObject()
  var valid_594126 = query.getOrDefault("timeout")
  valid_594126 = validateParameter(valid_594126, JInt, required = false, default = nil)
  if valid_594126 != nil:
    section.add "timeout", valid_594126
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594127 = query.getOrDefault("api-version")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "api-version", valid_594127
  var valid_594128 = query.getOrDefault("continuation-token")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "continuation-token", valid_594128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594129: Call_ApplicationsList_594123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List applications
  ## 
  let valid = call_594129.validator(path, query, header, formData, body)
  let scheme = call_594129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594129.url(scheme.get, call_594129.host, call_594129.base,
                         call_594129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594129, url, valid)

proc call*(call_594130: Call_ApplicationsList_594123; apiVersion: string;
          timeout: int = 0; continuationToken: string = ""): Recallable =
  ## applicationsList
  ## List applications
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   continuationToken: string
  ##                    : The token of the continuation
  var query_594131 = newJObject()
  add(query_594131, "timeout", newJInt(timeout))
  add(query_594131, "api-version", newJString(apiVersion))
  add(query_594131, "continuation-token", newJString(continuationToken))
  result = call_594130.call(nil, query_594131, nil, nil, nil)

var applicationsList* = Call_ApplicationsList_594123(name: "applicationsList",
    meth: HttpMethod.HttpGet, host: "azure.local:19080", route: "/Applications",
    validator: validate_ApplicationsList_594124, base: "",
    url: url_ApplicationsList_594125, schemes: {Scheme.Https})
type
  Call_ApplicationsCreate_594132 = ref object of OpenApiRestCall_593421
proc url_ApplicationsCreate_594134(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ApplicationsCreate_594133(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Create applications
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594135 = query.getOrDefault("timeout")
  valid_594135 = validateParameter(valid_594135, JInt, required = false, default = nil)
  if valid_594135 != nil:
    section.add "timeout", valid_594135
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594136 = query.getOrDefault("api-version")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "api-version", valid_594136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   applicationDescription: JObject (required)
  ##                         : The description of the application
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594138: Call_ApplicationsCreate_594132; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create applications
  ## 
  let valid = call_594138.validator(path, query, header, formData, body)
  let scheme = call_594138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594138.url(scheme.get, call_594138.host, call_594138.base,
                         call_594138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594138, url, valid)

proc call*(call_594139: Call_ApplicationsCreate_594132; apiVersion: string;
          applicationDescription: JsonNode; timeout: int = 0): Recallable =
  ## applicationsCreate
  ## Create applications
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationDescription: JObject (required)
  ##                         : The description of the application
  var query_594140 = newJObject()
  var body_594141 = newJObject()
  add(query_594140, "timeout", newJInt(timeout))
  add(query_594140, "api-version", newJString(apiVersion))
  if applicationDescription != nil:
    body_594141 = applicationDescription
  result = call_594139.call(nil, query_594140, nil, nil, body_594141)

var applicationsCreate* = Call_ApplicationsCreate_594132(
    name: "applicationsCreate", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/$/Create",
    validator: validate_ApplicationsCreate_594133, base: "",
    url: url_ApplicationsCreate_594134, schemes: {Scheme.Https})
type
  Call_ApplicationsGet_594142 = ref object of OpenApiRestCall_593421
proc url_ApplicationsGet_594144(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationsGet_594143(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get applications
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594145 = path.getOrDefault("applicationName")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "applicationName", valid_594145
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594146 = query.getOrDefault("timeout")
  valid_594146 = validateParameter(valid_594146, JInt, required = false, default = nil)
  if valid_594146 != nil:
    section.add "timeout", valid_594146
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594147 = query.getOrDefault("api-version")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "api-version", valid_594147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594148: Call_ApplicationsGet_594142; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get applications
  ## 
  let valid = call_594148.validator(path, query, header, formData, body)
  let scheme = call_594148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594148.url(scheme.get, call_594148.host, call_594148.base,
                         call_594148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594148, url, valid)

proc call*(call_594149: Call_ApplicationsGet_594142; applicationName: string;
          apiVersion: string; timeout: int = 0): Recallable =
  ## applicationsGet
  ## Get applications
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  var path_594150 = newJObject()
  var query_594151 = newJObject()
  add(query_594151, "timeout", newJInt(timeout))
  add(path_594150, "applicationName", newJString(applicationName))
  add(query_594151, "api-version", newJString(apiVersion))
  result = call_594149.call(path_594150, query_594151, nil, nil, nil)

var applicationsGet* = Call_ApplicationsGet_594142(name: "applicationsGet",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Applications/{applicationName}", validator: validate_ApplicationsGet_594143,
    base: "", url: url_ApplicationsGet_594144, schemes: {Scheme.Https})
type
  Call_ApplicationsRemove_594152 = ref object of OpenApiRestCall_593421
proc url_ApplicationsRemove_594154(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/$/Delete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationsRemove_594153(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Remove applications
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594155 = path.getOrDefault("applicationName")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "applicationName", valid_594155
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   ForceRemove: JBool
  ##              : The force remove flag to skip services check
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594156 = query.getOrDefault("timeout")
  valid_594156 = validateParameter(valid_594156, JInt, required = false, default = nil)
  if valid_594156 != nil:
    section.add "timeout", valid_594156
  var valid_594157 = query.getOrDefault("ForceRemove")
  valid_594157 = validateParameter(valid_594157, JBool, required = false, default = nil)
  if valid_594157 != nil:
    section.add "ForceRemove", valid_594157
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594158 = query.getOrDefault("api-version")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "api-version", valid_594158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594159: Call_ApplicationsRemove_594152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove applications
  ## 
  let valid = call_594159.validator(path, query, header, formData, body)
  let scheme = call_594159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594159.url(scheme.get, call_594159.host, call_594159.base,
                         call_594159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594159, url, valid)

proc call*(call_594160: Call_ApplicationsRemove_594152; applicationName: string;
          apiVersion: string; timeout: int = 0; ForceRemove: bool = false): Recallable =
  ## applicationsRemove
  ## Remove applications
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   ForceRemove: bool
  ##              : The force remove flag to skip services check
  ##   apiVersion: string (required)
  ##             : The version of the api
  var path_594161 = newJObject()
  var query_594162 = newJObject()
  add(query_594162, "timeout", newJInt(timeout))
  add(path_594161, "applicationName", newJString(applicationName))
  add(query_594162, "ForceRemove", newJBool(ForceRemove))
  add(query_594162, "api-version", newJString(apiVersion))
  result = call_594160.call(path_594161, query_594162, nil, nil, nil)

var applicationsRemove* = Call_ApplicationsRemove_594152(
    name: "applicationsRemove", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/Delete",
    validator: validate_ApplicationsRemove_594153, base: "",
    url: url_ApplicationsRemove_594154, schemes: {Scheme.Https})
type
  Call_ApplicationHealthsGet_594163 = ref object of OpenApiRestCall_593421
proc url_ApplicationHealthsGet_594165(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/$/GetHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationHealthsGet_594164(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get application healths
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594166 = path.getOrDefault("applicationName")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "applicationName", valid_594166
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   EventsHealthStateFilter: JString
  ##                          : The filter of the events health state
  ##   DeployedApplicationsHealthStateFilter: JString
  ##                                        : The filter of the deployed application health state
  section = newJObject()
  var valid_594167 = query.getOrDefault("timeout")
  valid_594167 = validateParameter(valid_594167, JInt, required = false, default = nil)
  if valid_594167 != nil:
    section.add "timeout", valid_594167
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594168 = query.getOrDefault("api-version")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "api-version", valid_594168
  var valid_594169 = query.getOrDefault("EventsHealthStateFilter")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "EventsHealthStateFilter", valid_594169
  var valid_594170 = query.getOrDefault("DeployedApplicationsHealthStateFilter")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "DeployedApplicationsHealthStateFilter", valid_594170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594171: Call_ApplicationHealthsGet_594163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get application healths
  ## 
  let valid = call_594171.validator(path, query, header, formData, body)
  let scheme = call_594171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594171.url(scheme.get, call_594171.host, call_594171.base,
                         call_594171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594171, url, valid)

proc call*(call_594172: Call_ApplicationHealthsGet_594163; applicationName: string;
          apiVersion: string; timeout: int = 0; EventsHealthStateFilter: string = "";
          DeployedApplicationsHealthStateFilter: string = ""): Recallable =
  ## applicationHealthsGet
  ## Get application healths
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   EventsHealthStateFilter: string
  ##                          : The filter of the events health state
  ##   DeployedApplicationsHealthStateFilter: string
  ##                                        : The filter of the deployed application health state
  var path_594173 = newJObject()
  var query_594174 = newJObject()
  add(query_594174, "timeout", newJInt(timeout))
  add(path_594173, "applicationName", newJString(applicationName))
  add(query_594174, "api-version", newJString(apiVersion))
  add(query_594174, "EventsHealthStateFilter", newJString(EventsHealthStateFilter))
  add(query_594174, "DeployedApplicationsHealthStateFilter",
      newJString(DeployedApplicationsHealthStateFilter))
  result = call_594172.call(path_594173, query_594174, nil, nil, nil)

var applicationHealthsGet* = Call_ApplicationHealthsGet_594163(
    name: "applicationHealthsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Applications/{applicationName}/$/GetHealth",
    validator: validate_ApplicationHealthsGet_594164, base: "",
    url: url_ApplicationHealthsGet_594165, schemes: {Scheme.Https})
type
  Call_ServiceGroupFromTemplatesCreate_594175 = ref object of OpenApiRestCall_593421
proc url_ServiceGroupFromTemplatesCreate_594177(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationName"), (
        kind: ConstantSegment,
        value: "/$/GetServiceGroups/$/CreateServiceGroupFromTemplate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceGroupFromTemplatesCreate_594176(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create service group from templates
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594178 = path.getOrDefault("applicationName")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "applicationName", valid_594178
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594179 = query.getOrDefault("timeout")
  valid_594179 = validateParameter(valid_594179, JInt, required = false, default = nil)
  if valid_594179 != nil:
    section.add "timeout", valid_594179
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594180 = query.getOrDefault("api-version")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "api-version", valid_594180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   serviceDescriptionTemplate: JObject (required)
  ##                             : The template of the service description
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594182: Call_ServiceGroupFromTemplatesCreate_594175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create service group from templates
  ## 
  let valid = call_594182.validator(path, query, header, formData, body)
  let scheme = call_594182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594182.url(scheme.get, call_594182.host, call_594182.base,
                         call_594182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594182, url, valid)

proc call*(call_594183: Call_ServiceGroupFromTemplatesCreate_594175;
          applicationName: string; apiVersion: string;
          serviceDescriptionTemplate: JsonNode; timeout: int = 0): Recallable =
  ## serviceGroupFromTemplatesCreate
  ## Create service group from templates
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   serviceDescriptionTemplate: JObject (required)
  ##                             : The template of the service description
  var path_594184 = newJObject()
  var query_594185 = newJObject()
  var body_594186 = newJObject()
  add(query_594185, "timeout", newJInt(timeout))
  add(path_594184, "applicationName", newJString(applicationName))
  add(query_594185, "api-version", newJString(apiVersion))
  if serviceDescriptionTemplate != nil:
    body_594186 = serviceDescriptionTemplate
  result = call_594183.call(path_594184, query_594185, nil, nil, body_594186)

var serviceGroupFromTemplatesCreate* = Call_ServiceGroupFromTemplatesCreate_594175(
    name: "serviceGroupFromTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/GetServiceGroups/$/CreateServiceGroupFromTemplate",
    validator: validate_ServiceGroupFromTemplatesCreate_594176, base: "",
    url: url_ServiceGroupFromTemplatesCreate_594177, schemes: {Scheme.Https})
type
  Call_ServiceGroupsRemove_594187 = ref object of OpenApiRestCall_593421
proc url_ServiceGroupsRemove_594189(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/$/GetServiceGroups/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/$/Delete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceGroupsRemove_594188(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Remove service groups
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  ##   serviceName: JString (required)
  ##              : The name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594190 = path.getOrDefault("applicationName")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "applicationName", valid_594190
  var valid_594191 = path.getOrDefault("serviceName")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "serviceName", valid_594191
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594192 = query.getOrDefault("timeout")
  valid_594192 = validateParameter(valid_594192, JInt, required = false, default = nil)
  if valid_594192 != nil:
    section.add "timeout", valid_594192
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594193 = query.getOrDefault("api-version")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "api-version", valid_594193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594194: Call_ServiceGroupsRemove_594187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove service groups
  ## 
  let valid = call_594194.validator(path, query, header, formData, body)
  let scheme = call_594194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594194.url(scheme.get, call_594194.host, call_594194.base,
                         call_594194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594194, url, valid)

proc call*(call_594195: Call_ServiceGroupsRemove_594187; applicationName: string;
          apiVersion: string; serviceName: string; timeout: int = 0): Recallable =
  ## serviceGroupsRemove
  ## Remove service groups
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   serviceName: string (required)
  ##              : The name of the service
  var path_594196 = newJObject()
  var query_594197 = newJObject()
  add(query_594197, "timeout", newJInt(timeout))
  add(path_594196, "applicationName", newJString(applicationName))
  add(query_594197, "api-version", newJString(apiVersion))
  add(path_594196, "serviceName", newJString(serviceName))
  result = call_594195.call(path_594196, query_594197, nil, nil, nil)

var serviceGroupsRemove* = Call_ServiceGroupsRemove_594187(
    name: "serviceGroupsRemove", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/GetServiceGroups/{serviceName}/$/Delete",
    validator: validate_ServiceGroupsRemove_594188, base: "",
    url: url_ServiceGroupsRemove_594189, schemes: {Scheme.Https})
type
  Call_ServicesList_594198 = ref object of OpenApiRestCall_593421
proc url_ServicesList_594200(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/$/GetServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesList_594199(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List services
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594201 = path.getOrDefault("applicationName")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "applicationName", valid_594201
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594202 = query.getOrDefault("timeout")
  valid_594202 = validateParameter(valid_594202, JInt, required = false, default = nil)
  if valid_594202 != nil:
    section.add "timeout", valid_594202
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594203 = query.getOrDefault("api-version")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "api-version", valid_594203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594204: Call_ServicesList_594198; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List services
  ## 
  let valid = call_594204.validator(path, query, header, formData, body)
  let scheme = call_594204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594204.url(scheme.get, call_594204.host, call_594204.base,
                         call_594204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594204, url, valid)

proc call*(call_594205: Call_ServicesList_594198; applicationName: string;
          apiVersion: string; timeout: int = 0): Recallable =
  ## servicesList
  ## List services
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  var path_594206 = newJObject()
  var query_594207 = newJObject()
  add(query_594207, "timeout", newJInt(timeout))
  add(path_594206, "applicationName", newJString(applicationName))
  add(query_594207, "api-version", newJString(apiVersion))
  result = call_594205.call(path_594206, query_594207, nil, nil, nil)

var servicesList* = Call_ServicesList_594198(name: "servicesList",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Applications/{applicationName}/$/GetServices",
    validator: validate_ServicesList_594199, base: "", url: url_ServicesList_594200,
    schemes: {Scheme.Https})
type
  Call_ServicesCreate_594208 = ref object of OpenApiRestCall_593421
proc url_ServicesCreate_594210(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/$/GetServices/$/Create")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesCreate_594209(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Create services
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594211 = path.getOrDefault("applicationName")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "applicationName", valid_594211
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594212 = query.getOrDefault("timeout")
  valid_594212 = validateParameter(valid_594212, JInt, required = false, default = nil)
  if valid_594212 != nil:
    section.add "timeout", valid_594212
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594213 = query.getOrDefault("api-version")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "api-version", valid_594213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   createServiceDescription: JObject (required)
  ##                           : The description of the service
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594215: Call_ServicesCreate_594208; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create services
  ## 
  let valid = call_594215.validator(path, query, header, formData, body)
  let scheme = call_594215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594215.url(scheme.get, call_594215.host, call_594215.base,
                         call_594215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594215, url, valid)

proc call*(call_594216: Call_ServicesCreate_594208;
          createServiceDescription: JsonNode; applicationName: string;
          apiVersion: string; timeout: int = 0): Recallable =
  ## servicesCreate
  ## Create services
  ##   createServiceDescription: JObject (required)
  ##                           : The description of the service
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  var path_594217 = newJObject()
  var query_594218 = newJObject()
  var body_594219 = newJObject()
  if createServiceDescription != nil:
    body_594219 = createServiceDescription
  add(query_594218, "timeout", newJInt(timeout))
  add(path_594217, "applicationName", newJString(applicationName))
  add(query_594218, "api-version", newJString(apiVersion))
  result = call_594216.call(path_594217, query_594218, nil, nil, body_594219)

var servicesCreate* = Call_ServicesCreate_594208(name: "servicesCreate",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Applications/{applicationName}/$/GetServices/$/Create",
    validator: validate_ServicesCreate_594209, base: "", url: url_ServicesCreate_594210,
    schemes: {Scheme.Https})
type
  Call_ServiceFromTemplatesCreate_594220 = ref object of OpenApiRestCall_593421
proc url_ServiceFromTemplatesCreate_594222(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationName"), (
        kind: ConstantSegment, value: "/$/GetServices/$/CreateFromTemplate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceFromTemplatesCreate_594221(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create service from templates
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594223 = path.getOrDefault("applicationName")
  valid_594223 = validateParameter(valid_594223, JString, required = true,
                                 default = nil)
  if valid_594223 != nil:
    section.add "applicationName", valid_594223
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594224 = query.getOrDefault("timeout")
  valid_594224 = validateParameter(valid_594224, JInt, required = false, default = nil)
  if valid_594224 != nil:
    section.add "timeout", valid_594224
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594225 = query.getOrDefault("api-version")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = nil)
  if valid_594225 != nil:
    section.add "api-version", valid_594225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   serviceDescriptionTemplate: JObject (required)
  ##                             : The template of the service description
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594227: Call_ServiceFromTemplatesCreate_594220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create service from templates
  ## 
  let valid = call_594227.validator(path, query, header, formData, body)
  let scheme = call_594227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594227.url(scheme.get, call_594227.host, call_594227.base,
                         call_594227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594227, url, valid)

proc call*(call_594228: Call_ServiceFromTemplatesCreate_594220;
          applicationName: string; apiVersion: string;
          serviceDescriptionTemplate: JsonNode; timeout: int = 0): Recallable =
  ## serviceFromTemplatesCreate
  ## Create service from templates
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   serviceDescriptionTemplate: JObject (required)
  ##                             : The template of the service description
  var path_594229 = newJObject()
  var query_594230 = newJObject()
  var body_594231 = newJObject()
  add(query_594230, "timeout", newJInt(timeout))
  add(path_594229, "applicationName", newJString(applicationName))
  add(query_594230, "api-version", newJString(apiVersion))
  if serviceDescriptionTemplate != nil:
    body_594231 = serviceDescriptionTemplate
  result = call_594228.call(path_594229, query_594230, nil, nil, body_594231)

var serviceFromTemplatesCreate* = Call_ServiceFromTemplatesCreate_594220(
    name: "serviceFromTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/GetServices/$/CreateFromTemplate",
    validator: validate_ServiceFromTemplatesCreate_594221, base: "",
    url: url_ServiceFromTemplatesCreate_594222, schemes: {Scheme.Https})
type
  Call_ServiceGroupsCreate_594232 = ref object of OpenApiRestCall_593421
proc url_ServiceGroupsCreate_594234(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationName"), (
        kind: ConstantSegment, value: "/$/GetServices/$/CreateServiceGroup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceGroupsCreate_594233(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Create service groups
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the service group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594235 = path.getOrDefault("applicationName")
  valid_594235 = validateParameter(valid_594235, JString, required = true,
                                 default = nil)
  if valid_594235 != nil:
    section.add "applicationName", valid_594235
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594236 = query.getOrDefault("timeout")
  valid_594236 = validateParameter(valid_594236, JInt, required = false, default = nil)
  if valid_594236 != nil:
    section.add "timeout", valid_594236
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594237 = query.getOrDefault("api-version")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "api-version", valid_594237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   createServiceGroupDescription: JObject (required)
  ##                                : The description of the service group
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594239: Call_ServiceGroupsCreate_594232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create service groups
  ## 
  let valid = call_594239.validator(path, query, header, formData, body)
  let scheme = call_594239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594239.url(scheme.get, call_594239.host, call_594239.base,
                         call_594239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594239, url, valid)

proc call*(call_594240: Call_ServiceGroupsCreate_594232;
          createServiceGroupDescription: JsonNode; applicationName: string;
          apiVersion: string; timeout: int = 0): Recallable =
  ## serviceGroupsCreate
  ## Create service groups
  ##   timeout: int
  ##          : The timeout in seconds
  ##   createServiceGroupDescription: JObject (required)
  ##                                : The description of the service group
  ##   applicationName: string (required)
  ##                  : The name of the service group
  ##   apiVersion: string (required)
  ##             : The version of the api
  var path_594241 = newJObject()
  var query_594242 = newJObject()
  var body_594243 = newJObject()
  add(query_594242, "timeout", newJInt(timeout))
  if createServiceGroupDescription != nil:
    body_594243 = createServiceGroupDescription
  add(path_594241, "applicationName", newJString(applicationName))
  add(query_594242, "api-version", newJString(apiVersion))
  result = call_594240.call(path_594241, query_594242, nil, nil, body_594243)

var serviceGroupsCreate* = Call_ServiceGroupsCreate_594232(
    name: "serviceGroupsCreate", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/GetServices/$/CreateServiceGroup",
    validator: validate_ServiceGroupsCreate_594233, base: "",
    url: url_ServiceGroupsCreate_594234, schemes: {Scheme.Https})
type
  Call_ServicesGet_594244 = ref object of OpenApiRestCall_593421
proc url_ServicesGet_594246(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/$/GetServices/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesGet_594245(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get services
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  ##   serviceName: JString (required)
  ##              : The name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594247 = path.getOrDefault("applicationName")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = nil)
  if valid_594247 != nil:
    section.add "applicationName", valid_594247
  var valid_594248 = path.getOrDefault("serviceName")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "serviceName", valid_594248
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594249 = query.getOrDefault("timeout")
  valid_594249 = validateParameter(valid_594249, JInt, required = false, default = nil)
  if valid_594249 != nil:
    section.add "timeout", valid_594249
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594250 = query.getOrDefault("api-version")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = nil)
  if valid_594250 != nil:
    section.add "api-version", valid_594250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594251: Call_ServicesGet_594244; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get services
  ## 
  let valid = call_594251.validator(path, query, header, formData, body)
  let scheme = call_594251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594251.url(scheme.get, call_594251.host, call_594251.base,
                         call_594251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594251, url, valid)

proc call*(call_594252: Call_ServicesGet_594244; applicationName: string;
          apiVersion: string; serviceName: string; timeout: int = 0): Recallable =
  ## servicesGet
  ## Get services
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   serviceName: string (required)
  ##              : The name of the service
  var path_594253 = newJObject()
  var query_594254 = newJObject()
  add(query_594254, "timeout", newJInt(timeout))
  add(path_594253, "applicationName", newJString(applicationName))
  add(query_594254, "api-version", newJString(apiVersion))
  add(path_594253, "serviceName", newJString(serviceName))
  result = call_594252.call(path_594253, query_594254, nil, nil, nil)

var servicesGet* = Call_ServicesGet_594244(name: "servicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local:19080", route: "/Applications/{applicationName}/$/GetServices/{serviceName}",
                                        validator: validate_ServicesGet_594245,
                                        base: "", url: url_ServicesGet_594246,
                                        schemes: {Scheme.Https})
type
  Call_ServiceGroupDescriptionsGet_594255 = ref object of OpenApiRestCall_593421
proc url_ServiceGroupDescriptionsGet_594257(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/$/GetServices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/$/GetServiceGroupDescription")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceGroupDescriptionsGet_594256(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get service group descriptions
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  ##   serviceName: JString (required)
  ##              : The name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594258 = path.getOrDefault("applicationName")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "applicationName", valid_594258
  var valid_594259 = path.getOrDefault("serviceName")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = nil)
  if valid_594259 != nil:
    section.add "serviceName", valid_594259
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594260 = query.getOrDefault("timeout")
  valid_594260 = validateParameter(valid_594260, JInt, required = false, default = nil)
  if valid_594260 != nil:
    section.add "timeout", valid_594260
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594261 = query.getOrDefault("api-version")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "api-version", valid_594261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594262: Call_ServiceGroupDescriptionsGet_594255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service group descriptions
  ## 
  let valid = call_594262.validator(path, query, header, formData, body)
  let scheme = call_594262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594262.url(scheme.get, call_594262.host, call_594262.base,
                         call_594262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594262, url, valid)

proc call*(call_594263: Call_ServiceGroupDescriptionsGet_594255;
          applicationName: string; apiVersion: string; serviceName: string;
          timeout: int = 0): Recallable =
  ## serviceGroupDescriptionsGet
  ## Get service group descriptions
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   serviceName: string (required)
  ##              : The name of the service
  var path_594264 = newJObject()
  var query_594265 = newJObject()
  add(query_594265, "timeout", newJInt(timeout))
  add(path_594264, "applicationName", newJString(applicationName))
  add(query_594265, "api-version", newJString(apiVersion))
  add(path_594264, "serviceName", newJString(serviceName))
  result = call_594263.call(path_594264, query_594265, nil, nil, nil)

var serviceGroupDescriptionsGet* = Call_ServiceGroupDescriptionsGet_594255(
    name: "serviceGroupDescriptionsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/GetServices/{serviceName}/$/GetServiceGroupDescription",
    validator: validate_ServiceGroupDescriptionsGet_594256, base: "",
    url: url_ServiceGroupDescriptionsGet_594257, schemes: {Scheme.Https})
type
  Call_ServiceGroupMembersGet_594266 = ref object of OpenApiRestCall_593421
proc url_ServiceGroupMembersGet_594268(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/$/GetServices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/$/GetServiceGroupMembers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceGroupMembersGet_594267(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get service group members
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  ##   serviceName: JString (required)
  ##              : The name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594269 = path.getOrDefault("applicationName")
  valid_594269 = validateParameter(valid_594269, JString, required = true,
                                 default = nil)
  if valid_594269 != nil:
    section.add "applicationName", valid_594269
  var valid_594270 = path.getOrDefault("serviceName")
  valid_594270 = validateParameter(valid_594270, JString, required = true,
                                 default = nil)
  if valid_594270 != nil:
    section.add "serviceName", valid_594270
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594271 = query.getOrDefault("timeout")
  valid_594271 = validateParameter(valid_594271, JInt, required = false, default = nil)
  if valid_594271 != nil:
    section.add "timeout", valid_594271
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594272 = query.getOrDefault("api-version")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = nil)
  if valid_594272 != nil:
    section.add "api-version", valid_594272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594273: Call_ServiceGroupMembersGet_594266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service group members
  ## 
  let valid = call_594273.validator(path, query, header, formData, body)
  let scheme = call_594273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594273.url(scheme.get, call_594273.host, call_594273.base,
                         call_594273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594273, url, valid)

proc call*(call_594274: Call_ServiceGroupMembersGet_594266;
          applicationName: string; apiVersion: string; serviceName: string;
          timeout: int = 0): Recallable =
  ## serviceGroupMembersGet
  ## Get service group members
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   serviceName: string (required)
  ##              : The name of the service
  var path_594275 = newJObject()
  var query_594276 = newJObject()
  add(query_594276, "timeout", newJInt(timeout))
  add(path_594275, "applicationName", newJString(applicationName))
  add(query_594276, "api-version", newJString(apiVersion))
  add(path_594275, "serviceName", newJString(serviceName))
  result = call_594274.call(path_594275, query_594276, nil, nil, nil)

var serviceGroupMembersGet* = Call_ServiceGroupMembersGet_594266(
    name: "serviceGroupMembersGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/GetServices/{serviceName}/$/GetServiceGroupMembers",
    validator: validate_ServiceGroupMembersGet_594267, base: "",
    url: url_ServiceGroupMembersGet_594268, schemes: {Scheme.Https})
type
  Call_ServiceGroupsUpdate_594277 = ref object of OpenApiRestCall_593421
proc url_ServiceGroupsUpdate_594279(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/$/GetServices/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/$/UpdateServiceGroup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceGroupsUpdate_594278(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Update service groups
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  ##   serviceName: JString (required)
  ##              : The name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594280 = path.getOrDefault("applicationName")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = nil)
  if valid_594280 != nil:
    section.add "applicationName", valid_594280
  var valid_594281 = path.getOrDefault("serviceName")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "serviceName", valid_594281
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594282 = query.getOrDefault("timeout")
  valid_594282 = validateParameter(valid_594282, JInt, required = false, default = nil)
  if valid_594282 != nil:
    section.add "timeout", valid_594282
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594283 = query.getOrDefault("api-version")
  valid_594283 = validateParameter(valid_594283, JString, required = true,
                                 default = nil)
  if valid_594283 != nil:
    section.add "api-version", valid_594283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateServiceGroupDescription: JObject (required)
  ##                                : The description of the service group update
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594285: Call_ServiceGroupsUpdate_594277; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update service groups
  ## 
  let valid = call_594285.validator(path, query, header, formData, body)
  let scheme = call_594285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594285.url(scheme.get, call_594285.host, call_594285.base,
                         call_594285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594285, url, valid)

proc call*(call_594286: Call_ServiceGroupsUpdate_594277; applicationName: string;
          apiVersion: string; serviceName: string;
          updateServiceGroupDescription: JsonNode; timeout: int = 0): Recallable =
  ## serviceGroupsUpdate
  ## Update service groups
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   serviceName: string (required)
  ##              : The name of the service
  ##   updateServiceGroupDescription: JObject (required)
  ##                                : The description of the service group update
  var path_594287 = newJObject()
  var query_594288 = newJObject()
  var body_594289 = newJObject()
  add(query_594288, "timeout", newJInt(timeout))
  add(path_594287, "applicationName", newJString(applicationName))
  add(query_594288, "api-version", newJString(apiVersion))
  add(path_594287, "serviceName", newJString(serviceName))
  if updateServiceGroupDescription != nil:
    body_594289 = updateServiceGroupDescription
  result = call_594286.call(path_594287, query_594288, nil, nil, body_594289)

var serviceGroupsUpdate* = Call_ServiceGroupsUpdate_594277(
    name: "serviceGroupsUpdate", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/GetServices/{serviceName}/$/UpdateServiceGroup",
    validator: validate_ServiceGroupsUpdate_594278, base: "",
    url: url_ServiceGroupsUpdate_594279, schemes: {Scheme.Https})
type
  Call_ApplicationUpgradesGet_594290 = ref object of OpenApiRestCall_593421
proc url_ApplicationUpgradesGet_594292(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/$/GetUpgradeProgress")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationUpgradesGet_594291(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get application upgrades
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594293 = path.getOrDefault("applicationName")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "applicationName", valid_594293
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594294 = query.getOrDefault("timeout")
  valid_594294 = validateParameter(valid_594294, JInt, required = false, default = nil)
  if valid_594294 != nil:
    section.add "timeout", valid_594294
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594295 = query.getOrDefault("api-version")
  valid_594295 = validateParameter(valid_594295, JString, required = true,
                                 default = nil)
  if valid_594295 != nil:
    section.add "api-version", valid_594295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594296: Call_ApplicationUpgradesGet_594290; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get application upgrades
  ## 
  let valid = call_594296.validator(path, query, header, formData, body)
  let scheme = call_594296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594296.url(scheme.get, call_594296.host, call_594296.base,
                         call_594296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594296, url, valid)

proc call*(call_594297: Call_ApplicationUpgradesGet_594290;
          applicationName: string; apiVersion: string; timeout: int = 0): Recallable =
  ## applicationUpgradesGet
  ## Get application upgrades
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  var path_594298 = newJObject()
  var query_594299 = newJObject()
  add(query_594299, "timeout", newJInt(timeout))
  add(path_594298, "applicationName", newJString(applicationName))
  add(query_594299, "api-version", newJString(apiVersion))
  result = call_594297.call(path_594298, query_594299, nil, nil, nil)

var applicationUpgradesGet* = Call_ApplicationUpgradesGet_594290(
    name: "applicationUpgradesGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Applications/{applicationName}/$/GetUpgradeProgress",
    validator: validate_ApplicationUpgradesGet_594291, base: "",
    url: url_ApplicationUpgradesGet_594292, schemes: {Scheme.Https})
type
  Call_ApplicationUpgradesResume_594300 = ref object of OpenApiRestCall_593421
proc url_ApplicationUpgradesResume_594302(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/$/MoveNextUpgradeDomain")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationUpgradesResume_594301(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resume application upgrades
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594303 = path.getOrDefault("applicationName")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "applicationName", valid_594303
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594304 = query.getOrDefault("timeout")
  valid_594304 = validateParameter(valid_594304, JInt, required = false, default = nil)
  if valid_594304 != nil:
    section.add "timeout", valid_594304
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594305 = query.getOrDefault("api-version")
  valid_594305 = validateParameter(valid_594305, JString, required = true,
                                 default = nil)
  if valid_594305 != nil:
    section.add "api-version", valid_594305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resumeApplicationUpgrade: JObject (required)
  ##                           : The upgrade of the resume application
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594307: Call_ApplicationUpgradesResume_594300; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resume application upgrades
  ## 
  let valid = call_594307.validator(path, query, header, formData, body)
  let scheme = call_594307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594307.url(scheme.get, call_594307.host, call_594307.base,
                         call_594307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594307, url, valid)

proc call*(call_594308: Call_ApplicationUpgradesResume_594300;
          resumeApplicationUpgrade: JsonNode; applicationName: string;
          apiVersion: string; timeout: int = 0): Recallable =
  ## applicationUpgradesResume
  ## Resume application upgrades
  ##   timeout: int
  ##          : The timeout in seconds
  ##   resumeApplicationUpgrade: JObject (required)
  ##                           : The upgrade of the resume application
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  var path_594309 = newJObject()
  var query_594310 = newJObject()
  var body_594311 = newJObject()
  add(query_594310, "timeout", newJInt(timeout))
  if resumeApplicationUpgrade != nil:
    body_594311 = resumeApplicationUpgrade
  add(path_594309, "applicationName", newJString(applicationName))
  add(query_594310, "api-version", newJString(apiVersion))
  result = call_594308.call(path_594309, query_594310, nil, nil, body_594311)

var applicationUpgradesResume* = Call_ApplicationUpgradesResume_594300(
    name: "applicationUpgradesResume", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationName}/$/MoveNextUpgradeDomain",
    validator: validate_ApplicationUpgradesResume_594301, base: "",
    url: url_ApplicationUpgradesResume_594302, schemes: {Scheme.Https})
type
  Call_ApplicationHealthsSend_594312 = ref object of OpenApiRestCall_593421
proc url_ApplicationHealthsSend_594314(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/$/ReportHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationHealthsSend_594313(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Send application health
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594315 = path.getOrDefault("applicationName")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "applicationName", valid_594315
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594316 = query.getOrDefault("timeout")
  valid_594316 = validateParameter(valid_594316, JInt, required = false, default = nil)
  if valid_594316 != nil:
    section.add "timeout", valid_594316
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594317 = query.getOrDefault("api-version")
  valid_594317 = validateParameter(valid_594317, JString, required = true,
                                 default = nil)
  if valid_594317 != nil:
    section.add "api-version", valid_594317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   applicationHealthReport: JObject (required)
  ##                          : The report of the application health
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594319: Call_ApplicationHealthsSend_594312; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send application health
  ## 
  let valid = call_594319.validator(path, query, header, formData, body)
  let scheme = call_594319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594319.url(scheme.get, call_594319.host, call_594319.base,
                         call_594319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594319, url, valid)

proc call*(call_594320: Call_ApplicationHealthsSend_594312;
          applicationName: string; apiVersion: string;
          applicationHealthReport: JsonNode; timeout: int = 0): Recallable =
  ## applicationHealthsSend
  ## Send application health
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationHealthReport: JObject (required)
  ##                          : The report of the application health
  var path_594321 = newJObject()
  var query_594322 = newJObject()
  var body_594323 = newJObject()
  add(query_594322, "timeout", newJInt(timeout))
  add(path_594321, "applicationName", newJString(applicationName))
  add(query_594322, "api-version", newJString(apiVersion))
  if applicationHealthReport != nil:
    body_594323 = applicationHealthReport
  result = call_594320.call(path_594321, query_594322, nil, nil, body_594323)

var applicationHealthsSend* = Call_ApplicationHealthsSend_594312(
    name: "applicationHealthsSend", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationName}/$/ReportHealth",
    validator: validate_ApplicationHealthsSend_594313, base: "",
    url: url_ApplicationHealthsSend_594314, schemes: {Scheme.Https})
type
  Call_ApplicationUpgradeRollbacksStart_594324 = ref object of OpenApiRestCall_593421
proc url_ApplicationUpgradeRollbacksStart_594326(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/$/RollbackUpgrade")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationUpgradeRollbacksStart_594325(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Start application upgrade rollbacks
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594327 = path.getOrDefault("applicationName")
  valid_594327 = validateParameter(valid_594327, JString, required = true,
                                 default = nil)
  if valid_594327 != nil:
    section.add "applicationName", valid_594327
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594328 = query.getOrDefault("timeout")
  valid_594328 = validateParameter(valid_594328, JInt, required = false, default = nil)
  if valid_594328 != nil:
    section.add "timeout", valid_594328
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594329 = query.getOrDefault("api-version")
  valid_594329 = validateParameter(valid_594329, JString, required = true,
                                 default = nil)
  if valid_594329 != nil:
    section.add "api-version", valid_594329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594330: Call_ApplicationUpgradeRollbacksStart_594324;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Start application upgrade rollbacks
  ## 
  let valid = call_594330.validator(path, query, header, formData, body)
  let scheme = call_594330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594330.url(scheme.get, call_594330.host, call_594330.base,
                         call_594330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594330, url, valid)

proc call*(call_594331: Call_ApplicationUpgradeRollbacksStart_594324;
          applicationName: string; apiVersion: string; timeout: int = 0): Recallable =
  ## applicationUpgradeRollbacksStart
  ## Start application upgrade rollbacks
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  var path_594332 = newJObject()
  var query_594333 = newJObject()
  add(query_594333, "timeout", newJInt(timeout))
  add(path_594332, "applicationName", newJString(applicationName))
  add(query_594333, "api-version", newJString(apiVersion))
  result = call_594331.call(path_594332, query_594333, nil, nil, nil)

var applicationUpgradeRollbacksStart* = Call_ApplicationUpgradeRollbacksStart_594324(
    name: "applicationUpgradeRollbacksStart", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationName}/$/RollbackUpgrade",
    validator: validate_ApplicationUpgradeRollbacksStart_594325, base: "",
    url: url_ApplicationUpgradeRollbacksStart_594326, schemes: {Scheme.Https})
type
  Call_ApplicationUpgradesUpdate_594334 = ref object of OpenApiRestCall_593421
proc url_ApplicationUpgradesUpdate_594336(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/$/UpdateUpgrade")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationUpgradesUpdate_594335(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update application upgrades
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594337 = path.getOrDefault("applicationName")
  valid_594337 = validateParameter(valid_594337, JString, required = true,
                                 default = nil)
  if valid_594337 != nil:
    section.add "applicationName", valid_594337
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594338 = query.getOrDefault("timeout")
  valid_594338 = validateParameter(valid_594338, JInt, required = false, default = nil)
  if valid_594338 != nil:
    section.add "timeout", valid_594338
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594339 = query.getOrDefault("api-version")
  valid_594339 = validateParameter(valid_594339, JString, required = true,
                                 default = nil)
  if valid_594339 != nil:
    section.add "api-version", valid_594339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateApplicationUpgrade: JObject (required)
  ##                           : The description of the update application upgrade
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594341: Call_ApplicationUpgradesUpdate_594334; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update application upgrades
  ## 
  let valid = call_594341.validator(path, query, header, formData, body)
  let scheme = call_594341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594341.url(scheme.get, call_594341.host, call_594341.base,
                         call_594341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594341, url, valid)

proc call*(call_594342: Call_ApplicationUpgradesUpdate_594334;
          applicationName: string; apiVersion: string;
          updateApplicationUpgrade: JsonNode; timeout: int = 0): Recallable =
  ## applicationUpgradesUpdate
  ## Update application upgrades
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   updateApplicationUpgrade: JObject (required)
  ##                           : The description of the update application upgrade
  var path_594343 = newJObject()
  var query_594344 = newJObject()
  var body_594345 = newJObject()
  add(query_594344, "timeout", newJInt(timeout))
  add(path_594343, "applicationName", newJString(applicationName))
  add(query_594344, "api-version", newJString(apiVersion))
  if updateApplicationUpgrade != nil:
    body_594345 = updateApplicationUpgrade
  result = call_594342.call(path_594343, query_594344, nil, nil, body_594345)

var applicationUpgradesUpdate* = Call_ApplicationUpgradesUpdate_594334(
    name: "applicationUpgradesUpdate", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationName}/$/UpdateUpgrade",
    validator: validate_ApplicationUpgradesUpdate_594335, base: "",
    url: url_ApplicationUpgradesUpdate_594336, schemes: {Scheme.Https})
type
  Call_ApplicationUpgradesStart_594346 = ref object of OpenApiRestCall_593421
proc url_ApplicationUpgradesStart_594348(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/$/Upgrade")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationUpgradesStart_594347(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Start application upgrades
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594349 = path.getOrDefault("applicationName")
  valid_594349 = validateParameter(valid_594349, JString, required = true,
                                 default = nil)
  if valid_594349 != nil:
    section.add "applicationName", valid_594349
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594350 = query.getOrDefault("timeout")
  valid_594350 = validateParameter(valid_594350, JInt, required = false, default = nil)
  if valid_594350 != nil:
    section.add "timeout", valid_594350
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594351 = query.getOrDefault("api-version")
  valid_594351 = validateParameter(valid_594351, JString, required = true,
                                 default = nil)
  if valid_594351 != nil:
    section.add "api-version", valid_594351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   startApplicationUpgrade: JObject (required)
  ##                          : The description of the start application upgrade
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594353: Call_ApplicationUpgradesStart_594346; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Start application upgrades
  ## 
  let valid = call_594353.validator(path, query, header, formData, body)
  let scheme = call_594353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594353.url(scheme.get, call_594353.host, call_594353.base,
                         call_594353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594353, url, valid)

proc call*(call_594354: Call_ApplicationUpgradesStart_594346;
          applicationName: string; apiVersion: string;
          startApplicationUpgrade: JsonNode; timeout: int = 0): Recallable =
  ## applicationUpgradesStart
  ## Start application upgrades
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   startApplicationUpgrade: JObject (required)
  ##                          : The description of the start application upgrade
  var path_594355 = newJObject()
  var query_594356 = newJObject()
  var body_594357 = newJObject()
  add(query_594356, "timeout", newJInt(timeout))
  add(path_594355, "applicationName", newJString(applicationName))
  add(query_594356, "api-version", newJString(apiVersion))
  if startApplicationUpgrade != nil:
    body_594357 = startApplicationUpgrade
  result = call_594354.call(path_594355, query_594356, nil, nil, body_594357)

var applicationUpgradesStart* = Call_ApplicationUpgradesStart_594346(
    name: "applicationUpgradesStart", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/Upgrade",
    validator: validate_ApplicationUpgradesStart_594347, base: "",
    url: url_ApplicationUpgradesStart_594348, schemes: {Scheme.Https})
type
  Call_NodesList_594358 = ref object of OpenApiRestCall_593421
proc url_NodesList_594360(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_NodesList_594359(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## List nodes
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   continuation-token: JString
  ##                     : The token of the continuation
  section = newJObject()
  var valid_594361 = query.getOrDefault("timeout")
  valid_594361 = validateParameter(valid_594361, JInt, required = false, default = nil)
  if valid_594361 != nil:
    section.add "timeout", valid_594361
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594362 = query.getOrDefault("api-version")
  valid_594362 = validateParameter(valid_594362, JString, required = true,
                                 default = nil)
  if valid_594362 != nil:
    section.add "api-version", valid_594362
  var valid_594363 = query.getOrDefault("continuation-token")
  valid_594363 = validateParameter(valid_594363, JString, required = false,
                                 default = nil)
  if valid_594363 != nil:
    section.add "continuation-token", valid_594363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594364: Call_NodesList_594358; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List nodes
  ## 
  let valid = call_594364.validator(path, query, header, formData, body)
  let scheme = call_594364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594364.url(scheme.get, call_594364.host, call_594364.base,
                         call_594364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594364, url, valid)

proc call*(call_594365: Call_NodesList_594358; apiVersion: string; timeout: int = 0;
          continuationToken: string = ""): Recallable =
  ## nodesList
  ## List nodes
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   continuationToken: string
  ##                    : The token of the continuation
  var query_594366 = newJObject()
  add(query_594366, "timeout", newJInt(timeout))
  add(query_594366, "api-version", newJString(apiVersion))
  add(query_594366, "continuation-token", newJString(continuationToken))
  result = call_594365.call(nil, query_594366, nil, nil, nil)

var nodesList* = Call_NodesList_594358(name: "nodesList", meth: HttpMethod.HttpGet,
                                    host: "azure.local:19080", route: "/Nodes",
                                    validator: validate_NodesList_594359,
                                    base: "", url: url_NodesList_594360,
                                    schemes: {Scheme.Https})
type
  Call_NodesGet_594367 = ref object of OpenApiRestCall_593421
proc url_NodesGet_594369(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NodesGet_594368(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Get nodes
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_594370 = path.getOrDefault("nodeName")
  valid_594370 = validateParameter(valid_594370, JString, required = true,
                                 default = nil)
  if valid_594370 != nil:
    section.add "nodeName", valid_594370
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594371 = query.getOrDefault("timeout")
  valid_594371 = validateParameter(valid_594371, JInt, required = false, default = nil)
  if valid_594371 != nil:
    section.add "timeout", valid_594371
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594372 = query.getOrDefault("api-version")
  valid_594372 = validateParameter(valid_594372, JString, required = true,
                                 default = nil)
  if valid_594372 != nil:
    section.add "api-version", valid_594372
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594373: Call_NodesGet_594367; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get nodes
  ## 
  let valid = call_594373.validator(path, query, header, formData, body)
  let scheme = call_594373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594373.url(scheme.get, call_594373.host, call_594373.base,
                         call_594373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594373, url, valid)

proc call*(call_594374: Call_NodesGet_594367; apiVersion: string; nodeName: string;
          timeout: int = 0): Recallable =
  ## nodesGet
  ## Get nodes
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_594375 = newJObject()
  var query_594376 = newJObject()
  add(query_594376, "timeout", newJInt(timeout))
  add(query_594376, "api-version", newJString(apiVersion))
  add(path_594375, "nodeName", newJString(nodeName))
  result = call_594374.call(path_594375, query_594376, nil, nil, nil)

var nodesGet* = Call_NodesGet_594367(name: "nodesGet", meth: HttpMethod.HttpGet,
                                  host: "azure.local:19080",
                                  route: "/Nodes/{nodeName}",
                                  validator: validate_NodesGet_594368, base: "",
                                  url: url_NodesGet_594369,
                                  schemes: {Scheme.Https})
type
  Call_NodesEnable_594377 = ref object of OpenApiRestCall_593421
proc url_NodesEnable_594379(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/Activate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NodesEnable_594378(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Enable nodes
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_594380 = path.getOrDefault("nodeName")
  valid_594380 = validateParameter(valid_594380, JString, required = true,
                                 default = nil)
  if valid_594380 != nil:
    section.add "nodeName", valid_594380
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594381 = query.getOrDefault("timeout")
  valid_594381 = validateParameter(valid_594381, JInt, required = false, default = nil)
  if valid_594381 != nil:
    section.add "timeout", valid_594381
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594382 = query.getOrDefault("api-version")
  valid_594382 = validateParameter(valid_594382, JString, required = true,
                                 default = nil)
  if valid_594382 != nil:
    section.add "api-version", valid_594382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594383: Call_NodesEnable_594377; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enable nodes
  ## 
  let valid = call_594383.validator(path, query, header, formData, body)
  let scheme = call_594383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594383.url(scheme.get, call_594383.host, call_594383.base,
                         call_594383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594383, url, valid)

proc call*(call_594384: Call_NodesEnable_594377; apiVersion: string;
          nodeName: string; timeout: int = 0): Recallable =
  ## nodesEnable
  ## Enable nodes
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_594385 = newJObject()
  var query_594386 = newJObject()
  add(query_594386, "timeout", newJInt(timeout))
  add(query_594386, "api-version", newJString(apiVersion))
  add(path_594385, "nodeName", newJString(nodeName))
  result = call_594384.call(path_594385, query_594386, nil, nil, nil)

var nodesEnable* = Call_NodesEnable_594377(name: "nodesEnable",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local:19080",
                                        route: "/Nodes/{nodeName}/$/Activate",
                                        validator: validate_NodesEnable_594378,
                                        base: "", url: url_NodesEnable_594379,
                                        schemes: {Scheme.Https})
type
  Call_NodesDisable_594387 = ref object of OpenApiRestCall_593421
proc url_NodesDisable_594389(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/Deactivate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NodesDisable_594388(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Disable nodes
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_594390 = path.getOrDefault("nodeName")
  valid_594390 = validateParameter(valid_594390, JString, required = true,
                                 default = nil)
  if valid_594390 != nil:
    section.add "nodeName", valid_594390
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594391 = query.getOrDefault("timeout")
  valid_594391 = validateParameter(valid_594391, JInt, required = false, default = nil)
  if valid_594391 != nil:
    section.add "timeout", valid_594391
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594392 = query.getOrDefault("api-version")
  valid_594392 = validateParameter(valid_594392, JString, required = true,
                                 default = nil)
  if valid_594392 != nil:
    section.add "api-version", valid_594392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   disableNode: JObject (required)
  ##              : The node
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594394: Call_NodesDisable_594387; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Disable nodes
  ## 
  let valid = call_594394.validator(path, query, header, formData, body)
  let scheme = call_594394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594394.url(scheme.get, call_594394.host, call_594394.base,
                         call_594394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594394, url, valid)

proc call*(call_594395: Call_NodesDisable_594387; apiVersion: string;
          nodeName: string; disableNode: JsonNode; timeout: int = 0): Recallable =
  ## nodesDisable
  ## Disable nodes
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   nodeName: string (required)
  ##           : The name of the node
  ##   disableNode: JObject (required)
  ##              : The node
  var path_594396 = newJObject()
  var query_594397 = newJObject()
  var body_594398 = newJObject()
  add(query_594397, "timeout", newJInt(timeout))
  add(query_594397, "api-version", newJString(apiVersion))
  add(path_594396, "nodeName", newJString(nodeName))
  if disableNode != nil:
    body_594398 = disableNode
  result = call_594395.call(path_594396, query_594397, nil, nil, body_594398)

var nodesDisable* = Call_NodesDisable_594387(name: "nodesDisable",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/Deactivate", validator: validate_NodesDisable_594388,
    base: "", url: url_NodesDisable_594389, schemes: {Scheme.Https})
type
  Call_DeployedApplicationsList_594399 = ref object of OpenApiRestCall_593421
proc url_DeployedApplicationsList_594401(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetApplications")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeployedApplicationsList_594400(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List deployed applications
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_594402 = path.getOrDefault("nodeName")
  valid_594402 = validateParameter(valid_594402, JString, required = true,
                                 default = nil)
  if valid_594402 != nil:
    section.add "nodeName", valid_594402
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594403 = query.getOrDefault("timeout")
  valid_594403 = validateParameter(valid_594403, JInt, required = false, default = nil)
  if valid_594403 != nil:
    section.add "timeout", valid_594403
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594404 = query.getOrDefault("api-version")
  valid_594404 = validateParameter(valid_594404, JString, required = true,
                                 default = nil)
  if valid_594404 != nil:
    section.add "api-version", valid_594404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594405: Call_DeployedApplicationsList_594399; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List deployed applications
  ## 
  let valid = call_594405.validator(path, query, header, formData, body)
  let scheme = call_594405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594405.url(scheme.get, call_594405.host, call_594405.base,
                         call_594405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594405, url, valid)

proc call*(call_594406: Call_DeployedApplicationsList_594399; apiVersion: string;
          nodeName: string; timeout: int = 0): Recallable =
  ## deployedApplicationsList
  ## List deployed applications
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_594407 = newJObject()
  var query_594408 = newJObject()
  add(query_594408, "timeout", newJInt(timeout))
  add(query_594408, "api-version", newJString(apiVersion))
  add(path_594407, "nodeName", newJString(nodeName))
  result = call_594406.call(path_594407, query_594408, nil, nil, nil)

var deployedApplicationsList* = Call_DeployedApplicationsList_594399(
    name: "deployedApplicationsList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications",
    validator: validate_DeployedApplicationsList_594400, base: "",
    url: url_DeployedApplicationsList_594401, schemes: {Scheme.Https})
type
  Call_DeployedApplicationsGet_594409 = ref object of OpenApiRestCall_593421
proc url_DeployedApplicationsGet_594411(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetApplications/"),
               (kind: VariableSegment, value: "applicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeployedApplicationsGet_594410(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get deployed applications
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  ##   nodeName: JString (required)
  ##           : The name of the node
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594412 = path.getOrDefault("applicationName")
  valid_594412 = validateParameter(valid_594412, JString, required = true,
                                 default = nil)
  if valid_594412 != nil:
    section.add "applicationName", valid_594412
  var valid_594413 = path.getOrDefault("nodeName")
  valid_594413 = validateParameter(valid_594413, JString, required = true,
                                 default = nil)
  if valid_594413 != nil:
    section.add "nodeName", valid_594413
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594414 = query.getOrDefault("timeout")
  valid_594414 = validateParameter(valid_594414, JInt, required = false, default = nil)
  if valid_594414 != nil:
    section.add "timeout", valid_594414
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594415 = query.getOrDefault("api-version")
  valid_594415 = validateParameter(valid_594415, JString, required = true,
                                 default = nil)
  if valid_594415 != nil:
    section.add "api-version", valid_594415
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594416: Call_DeployedApplicationsGet_594409; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get deployed applications
  ## 
  let valid = call_594416.validator(path, query, header, formData, body)
  let scheme = call_594416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594416.url(scheme.get, call_594416.host, call_594416.base,
                         call_594416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594416, url, valid)

proc call*(call_594417: Call_DeployedApplicationsGet_594409;
          applicationName: string; apiVersion: string; nodeName: string;
          timeout: int = 0): Recallable =
  ## deployedApplicationsGet
  ## Get deployed applications
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_594418 = newJObject()
  var query_594419 = newJObject()
  add(query_594419, "timeout", newJInt(timeout))
  add(path_594418, "applicationName", newJString(applicationName))
  add(query_594419, "api-version", newJString(apiVersion))
  add(path_594418, "nodeName", newJString(nodeName))
  result = call_594417.call(path_594418, query_594419, nil, nil, nil)

var deployedApplicationsGet* = Call_DeployedApplicationsGet_594409(
    name: "deployedApplicationsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}",
    validator: validate_DeployedApplicationsGet_594410, base: "",
    url: url_DeployedApplicationsGet_594411, schemes: {Scheme.Https})
type
  Call_DeployedCodePackagesGet_594420 = ref object of OpenApiRestCall_593421
proc url_DeployedCodePackagesGet_594422(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetApplications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/$/GetCodePackages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeployedCodePackagesGet_594421(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get deployed code packages
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  ##   nodeName: JString (required)
  ##           : The name of the node
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594423 = path.getOrDefault("applicationName")
  valid_594423 = validateParameter(valid_594423, JString, required = true,
                                 default = nil)
  if valid_594423 != nil:
    section.add "applicationName", valid_594423
  var valid_594424 = path.getOrDefault("nodeName")
  valid_594424 = validateParameter(valid_594424, JString, required = true,
                                 default = nil)
  if valid_594424 != nil:
    section.add "nodeName", valid_594424
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594425 = query.getOrDefault("timeout")
  valid_594425 = validateParameter(valid_594425, JInt, required = false, default = nil)
  if valid_594425 != nil:
    section.add "timeout", valid_594425
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594426 = query.getOrDefault("api-version")
  valid_594426 = validateParameter(valid_594426, JString, required = true,
                                 default = nil)
  if valid_594426 != nil:
    section.add "api-version", valid_594426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594427: Call_DeployedCodePackagesGet_594420; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get deployed code packages
  ## 
  let valid = call_594427.validator(path, query, header, formData, body)
  let scheme = call_594427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594427.url(scheme.get, call_594427.host, call_594427.base,
                         call_594427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594427, url, valid)

proc call*(call_594428: Call_DeployedCodePackagesGet_594420;
          applicationName: string; apiVersion: string; nodeName: string;
          timeout: int = 0): Recallable =
  ## deployedCodePackagesGet
  ## Get deployed code packages
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_594429 = newJObject()
  var query_594430 = newJObject()
  add(query_594430, "timeout", newJInt(timeout))
  add(path_594429, "applicationName", newJString(applicationName))
  add(query_594430, "api-version", newJString(apiVersion))
  add(path_594429, "nodeName", newJString(nodeName))
  result = call_594428.call(path_594429, query_594430, nil, nil, nil)

var deployedCodePackagesGet* = Call_DeployedCodePackagesGet_594420(
    name: "deployedCodePackagesGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}/$/GetCodePackages",
    validator: validate_DeployedCodePackagesGet_594421, base: "",
    url: url_DeployedCodePackagesGet_594422, schemes: {Scheme.Https})
type
  Call_DeployedApplicationHealthsGet_594431 = ref object of OpenApiRestCall_593421
proc url_DeployedApplicationHealthsGet_594433(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetApplications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/$/GetHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeployedApplicationHealthsGet_594432(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get deployed application healths
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  ##   nodeName: JString (required)
  ##           : The name of the node
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594434 = path.getOrDefault("applicationName")
  valid_594434 = validateParameter(valid_594434, JString, required = true,
                                 default = nil)
  if valid_594434 != nil:
    section.add "applicationName", valid_594434
  var valid_594435 = path.getOrDefault("nodeName")
  valid_594435 = validateParameter(valid_594435, JString, required = true,
                                 default = nil)
  if valid_594435 != nil:
    section.add "nodeName", valid_594435
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   DeployedServicePackagesHealthStateFilter: JString
  ##                                           : The filter of the deployed service packages health state
  ##   EventsHealthStateFilter: JString
  ##                          : The filter of the events health state
  section = newJObject()
  var valid_594436 = query.getOrDefault("timeout")
  valid_594436 = validateParameter(valid_594436, JInt, required = false, default = nil)
  if valid_594436 != nil:
    section.add "timeout", valid_594436
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594437 = query.getOrDefault("api-version")
  valid_594437 = validateParameter(valid_594437, JString, required = true,
                                 default = nil)
  if valid_594437 != nil:
    section.add "api-version", valid_594437
  var valid_594438 = query.getOrDefault("DeployedServicePackagesHealthStateFilter")
  valid_594438 = validateParameter(valid_594438, JString, required = false,
                                 default = nil)
  if valid_594438 != nil:
    section.add "DeployedServicePackagesHealthStateFilter", valid_594438
  var valid_594439 = query.getOrDefault("EventsHealthStateFilter")
  valid_594439 = validateParameter(valid_594439, JString, required = false,
                                 default = nil)
  if valid_594439 != nil:
    section.add "EventsHealthStateFilter", valid_594439
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594440: Call_DeployedApplicationHealthsGet_594431; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get deployed application healths
  ## 
  let valid = call_594440.validator(path, query, header, formData, body)
  let scheme = call_594440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594440.url(scheme.get, call_594440.host, call_594440.base,
                         call_594440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594440, url, valid)

proc call*(call_594441: Call_DeployedApplicationHealthsGet_594431;
          applicationName: string; apiVersion: string; nodeName: string;
          timeout: int = 0; DeployedServicePackagesHealthStateFilter: string = "";
          EventsHealthStateFilter: string = ""): Recallable =
  ## deployedApplicationHealthsGet
  ## Get deployed application healths
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   nodeName: string (required)
  ##           : The name of the node
  ##   DeployedServicePackagesHealthStateFilter: string
  ##                                           : The filter of the deployed service packages health state
  ##   EventsHealthStateFilter: string
  ##                          : The filter of the events health state
  var path_594442 = newJObject()
  var query_594443 = newJObject()
  add(query_594443, "timeout", newJInt(timeout))
  add(path_594442, "applicationName", newJString(applicationName))
  add(query_594443, "api-version", newJString(apiVersion))
  add(path_594442, "nodeName", newJString(nodeName))
  add(query_594443, "DeployedServicePackagesHealthStateFilter",
      newJString(DeployedServicePackagesHealthStateFilter))
  add(query_594443, "EventsHealthStateFilter", newJString(EventsHealthStateFilter))
  result = call_594441.call(path_594442, query_594443, nil, nil, nil)

var deployedApplicationHealthsGet* = Call_DeployedApplicationHealthsGet_594431(
    name: "deployedApplicationHealthsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}/$/GetHealth",
    validator: validate_DeployedApplicationHealthsGet_594432, base: "",
    url: url_DeployedApplicationHealthsGet_594433, schemes: {Scheme.Https})
type
  Call_DeployedReplicasGet_594444 = ref object of OpenApiRestCall_593421
proc url_DeployedReplicasGet_594446(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetApplications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/$/GetReplicas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeployedReplicasGet_594445(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get deployed replicas
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  ##   nodeName: JString (required)
  ##           : The name of the node
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594447 = path.getOrDefault("applicationName")
  valid_594447 = validateParameter(valid_594447, JString, required = true,
                                 default = nil)
  if valid_594447 != nil:
    section.add "applicationName", valid_594447
  var valid_594448 = path.getOrDefault("nodeName")
  valid_594448 = validateParameter(valid_594448, JString, required = true,
                                 default = nil)
  if valid_594448 != nil:
    section.add "nodeName", valid_594448
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594449 = query.getOrDefault("timeout")
  valid_594449 = validateParameter(valid_594449, JInt, required = false, default = nil)
  if valid_594449 != nil:
    section.add "timeout", valid_594449
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594450 = query.getOrDefault("api-version")
  valid_594450 = validateParameter(valid_594450, JString, required = true,
                                 default = nil)
  if valid_594450 != nil:
    section.add "api-version", valid_594450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594451: Call_DeployedReplicasGet_594444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get deployed replicas
  ## 
  let valid = call_594451.validator(path, query, header, formData, body)
  let scheme = call_594451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594451.url(scheme.get, call_594451.host, call_594451.base,
                         call_594451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594451, url, valid)

proc call*(call_594452: Call_DeployedReplicasGet_594444; applicationName: string;
          apiVersion: string; nodeName: string; timeout: int = 0): Recallable =
  ## deployedReplicasGet
  ## Get deployed replicas
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_594453 = newJObject()
  var query_594454 = newJObject()
  add(query_594454, "timeout", newJInt(timeout))
  add(path_594453, "applicationName", newJString(applicationName))
  add(query_594454, "api-version", newJString(apiVersion))
  add(path_594453, "nodeName", newJString(nodeName))
  result = call_594452.call(path_594453, query_594454, nil, nil, nil)

var deployedReplicasGet* = Call_DeployedReplicasGet_594444(
    name: "deployedReplicasGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}/$/GetReplicas",
    validator: validate_DeployedReplicasGet_594445, base: "",
    url: url_DeployedReplicasGet_594446, schemes: {Scheme.Https})
type
  Call_DeployedServicePackagesGet_594455 = ref object of OpenApiRestCall_593421
proc url_DeployedServicePackagesGet_594457(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetApplications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/$/GetServicePackages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeployedServicePackagesGet_594456(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get deployed service packages
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  ##   nodeName: JString (required)
  ##           : The name of the node
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594458 = path.getOrDefault("applicationName")
  valid_594458 = validateParameter(valid_594458, JString, required = true,
                                 default = nil)
  if valid_594458 != nil:
    section.add "applicationName", valid_594458
  var valid_594459 = path.getOrDefault("nodeName")
  valid_594459 = validateParameter(valid_594459, JString, required = true,
                                 default = nil)
  if valid_594459 != nil:
    section.add "nodeName", valid_594459
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594460 = query.getOrDefault("timeout")
  valid_594460 = validateParameter(valid_594460, JInt, required = false, default = nil)
  if valid_594460 != nil:
    section.add "timeout", valid_594460
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594461 = query.getOrDefault("api-version")
  valid_594461 = validateParameter(valid_594461, JString, required = true,
                                 default = nil)
  if valid_594461 != nil:
    section.add "api-version", valid_594461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594462: Call_DeployedServicePackagesGet_594455; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get deployed service packages
  ## 
  let valid = call_594462.validator(path, query, header, formData, body)
  let scheme = call_594462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594462.url(scheme.get, call_594462.host, call_594462.base,
                         call_594462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594462, url, valid)

proc call*(call_594463: Call_DeployedServicePackagesGet_594455;
          applicationName: string; apiVersion: string; nodeName: string;
          timeout: int = 0): Recallable =
  ## deployedServicePackagesGet
  ## Get deployed service packages
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_594464 = newJObject()
  var query_594465 = newJObject()
  add(query_594465, "timeout", newJInt(timeout))
  add(path_594464, "applicationName", newJString(applicationName))
  add(query_594465, "api-version", newJString(apiVersion))
  add(path_594464, "nodeName", newJString(nodeName))
  result = call_594463.call(path_594464, query_594465, nil, nil, nil)

var deployedServicePackagesGet* = Call_DeployedServicePackagesGet_594455(
    name: "deployedServicePackagesGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}/$/GetServicePackages",
    validator: validate_DeployedServicePackagesGet_594456, base: "",
    url: url_DeployedServicePackagesGet_594457, schemes: {Scheme.Https})
type
  Call_DeployedServicePackageHealthsSend_594466 = ref object of OpenApiRestCall_593421
proc url_DeployedServicePackageHealthsSend_594468(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "serviceManifestName" in path,
        "`serviceManifestName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetApplications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/$/GetServicePackages/"),
               (kind: VariableSegment, value: "serviceManifestName"),
               (kind: ConstantSegment, value: "/$/ReportHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeployedServicePackageHealthsSend_594467(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Send deployed service package health
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  ##   nodeName: JString (required)
  ##           : The name of the node
  ##   serviceManifestName: JString (required)
  ##                      : The name of the service manifest
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594469 = path.getOrDefault("applicationName")
  valid_594469 = validateParameter(valid_594469, JString, required = true,
                                 default = nil)
  if valid_594469 != nil:
    section.add "applicationName", valid_594469
  var valid_594470 = path.getOrDefault("nodeName")
  valid_594470 = validateParameter(valid_594470, JString, required = true,
                                 default = nil)
  if valid_594470 != nil:
    section.add "nodeName", valid_594470
  var valid_594471 = path.getOrDefault("serviceManifestName")
  valid_594471 = validateParameter(valid_594471, JString, required = true,
                                 default = nil)
  if valid_594471 != nil:
    section.add "serviceManifestName", valid_594471
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594472 = query.getOrDefault("timeout")
  valid_594472 = validateParameter(valid_594472, JInt, required = false, default = nil)
  if valid_594472 != nil:
    section.add "timeout", valid_594472
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594473 = query.getOrDefault("api-version")
  valid_594473 = validateParameter(valid_594473, JString, required = true,
                                 default = nil)
  if valid_594473 != nil:
    section.add "api-version", valid_594473
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   deployedServicePackageHealthReport: JObject (required)
  ##                                     : The report of the deployed service package health
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594475: Call_DeployedServicePackageHealthsSend_594466;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Send deployed service package health
  ## 
  let valid = call_594475.validator(path, query, header, formData, body)
  let scheme = call_594475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594475.url(scheme.get, call_594475.host, call_594475.base,
                         call_594475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594475, url, valid)

proc call*(call_594476: Call_DeployedServicePackageHealthsSend_594466;
          applicationName: string; apiVersion: string; nodeName: string;
          serviceManifestName: string;
          deployedServicePackageHealthReport: JsonNode; timeout: int = 0): Recallable =
  ## deployedServicePackageHealthsSend
  ## Send deployed service package health
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   nodeName: string (required)
  ##           : The name of the node
  ##   serviceManifestName: string (required)
  ##                      : The name of the service manifest
  ##   deployedServicePackageHealthReport: JObject (required)
  ##                                     : The report of the deployed service package health
  var path_594477 = newJObject()
  var query_594478 = newJObject()
  var body_594479 = newJObject()
  add(query_594478, "timeout", newJInt(timeout))
  add(path_594477, "applicationName", newJString(applicationName))
  add(query_594478, "api-version", newJString(apiVersion))
  add(path_594477, "nodeName", newJString(nodeName))
  add(path_594477, "serviceManifestName", newJString(serviceManifestName))
  if deployedServicePackageHealthReport != nil:
    body_594479 = deployedServicePackageHealthReport
  result = call_594476.call(path_594477, query_594478, nil, nil, body_594479)

var deployedServicePackageHealthsSend* = Call_DeployedServicePackageHealthsSend_594466(
    name: "deployedServicePackageHealthsSend", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}/$/GetServicePackages/{serviceManifestName}/$/ReportHealth",
    validator: validate_DeployedServicePackageHealthsSend_594467, base: "",
    url: url_DeployedServicePackageHealthsSend_594468, schemes: {Scheme.Https})
type
  Call_DeployedServicePackageHealthsGet_594480 = ref object of OpenApiRestCall_593421
proc url_DeployedServicePackageHealthsGet_594482(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "servicePackageName" in path,
        "`servicePackageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetApplications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/$/GetServicePackages/"),
               (kind: VariableSegment, value: "servicePackageName"),
               (kind: ConstantSegment, value: "/$/GetHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeployedServicePackageHealthsGet_594481(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get deployed service package healths
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  ##   nodeName: JString (required)
  ##           : The name of the node
  ##   servicePackageName: JString (required)
  ##                     : The name of the service package
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594483 = path.getOrDefault("applicationName")
  valid_594483 = validateParameter(valid_594483, JString, required = true,
                                 default = nil)
  if valid_594483 != nil:
    section.add "applicationName", valid_594483
  var valid_594484 = path.getOrDefault("nodeName")
  valid_594484 = validateParameter(valid_594484, JString, required = true,
                                 default = nil)
  if valid_594484 != nil:
    section.add "nodeName", valid_594484
  var valid_594485 = path.getOrDefault("servicePackageName")
  valid_594485 = validateParameter(valid_594485, JString, required = true,
                                 default = nil)
  if valid_594485 != nil:
    section.add "servicePackageName", valid_594485
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   EventsHealthStateFilter: JString
  ##                          : The filter of the events health state
  section = newJObject()
  var valid_594486 = query.getOrDefault("timeout")
  valid_594486 = validateParameter(valid_594486, JInt, required = false, default = nil)
  if valid_594486 != nil:
    section.add "timeout", valid_594486
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594487 = query.getOrDefault("api-version")
  valid_594487 = validateParameter(valid_594487, JString, required = true,
                                 default = nil)
  if valid_594487 != nil:
    section.add "api-version", valid_594487
  var valid_594488 = query.getOrDefault("EventsHealthStateFilter")
  valid_594488 = validateParameter(valid_594488, JString, required = false,
                                 default = nil)
  if valid_594488 != nil:
    section.add "EventsHealthStateFilter", valid_594488
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594489: Call_DeployedServicePackageHealthsGet_594480;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get deployed service package healths
  ## 
  let valid = call_594489.validator(path, query, header, formData, body)
  let scheme = call_594489.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594489.url(scheme.get, call_594489.host, call_594489.base,
                         call_594489.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594489, url, valid)

proc call*(call_594490: Call_DeployedServicePackageHealthsGet_594480;
          applicationName: string; apiVersion: string; nodeName: string;
          servicePackageName: string; timeout: int = 0;
          EventsHealthStateFilter: string = ""): Recallable =
  ## deployedServicePackageHealthsGet
  ## Get deployed service package healths
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   nodeName: string (required)
  ##           : The name of the node
  ##   EventsHealthStateFilter: string
  ##                          : The filter of the events health state
  ##   servicePackageName: string (required)
  ##                     : The name of the service package
  var path_594491 = newJObject()
  var query_594492 = newJObject()
  add(query_594492, "timeout", newJInt(timeout))
  add(path_594491, "applicationName", newJString(applicationName))
  add(query_594492, "api-version", newJString(apiVersion))
  add(path_594491, "nodeName", newJString(nodeName))
  add(query_594492, "EventsHealthStateFilter", newJString(EventsHealthStateFilter))
  add(path_594491, "servicePackageName", newJString(servicePackageName))
  result = call_594490.call(path_594491, query_594492, nil, nil, nil)

var deployedServicePackageHealthsGet* = Call_DeployedServicePackageHealthsGet_594480(
    name: "deployedServicePackageHealthsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}/$/GetServicePackages/{servicePackageName}/$/GetHealth",
    validator: validate_DeployedServicePackageHealthsGet_594481, base: "",
    url: url_DeployedServicePackageHealthsGet_594482, schemes: {Scheme.Https})
type
  Call_DeployedServiceTypesGet_594493 = ref object of OpenApiRestCall_593421
proc url_DeployedServiceTypesGet_594495(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetApplications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/$/GetServiceTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeployedServiceTypesGet_594494(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get deployed service types
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  ##   nodeName: JString (required)
  ##           : The name of the node
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594496 = path.getOrDefault("applicationName")
  valid_594496 = validateParameter(valid_594496, JString, required = true,
                                 default = nil)
  if valid_594496 != nil:
    section.add "applicationName", valid_594496
  var valid_594497 = path.getOrDefault("nodeName")
  valid_594497 = validateParameter(valid_594497, JString, required = true,
                                 default = nil)
  if valid_594497 != nil:
    section.add "nodeName", valid_594497
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594498 = query.getOrDefault("timeout")
  valid_594498 = validateParameter(valid_594498, JInt, required = false, default = nil)
  if valid_594498 != nil:
    section.add "timeout", valid_594498
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594499 = query.getOrDefault("api-version")
  valid_594499 = validateParameter(valid_594499, JString, required = true,
                                 default = nil)
  if valid_594499 != nil:
    section.add "api-version", valid_594499
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594500: Call_DeployedServiceTypesGet_594493; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get deployed service types
  ## 
  let valid = call_594500.validator(path, query, header, formData, body)
  let scheme = call_594500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594500.url(scheme.get, call_594500.host, call_594500.base,
                         call_594500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594500, url, valid)

proc call*(call_594501: Call_DeployedServiceTypesGet_594493;
          applicationName: string; apiVersion: string; nodeName: string;
          timeout: int = 0): Recallable =
  ## deployedServiceTypesGet
  ## Get deployed service types
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_594502 = newJObject()
  var query_594503 = newJObject()
  add(query_594503, "timeout", newJInt(timeout))
  add(path_594502, "applicationName", newJString(applicationName))
  add(query_594503, "api-version", newJString(apiVersion))
  add(path_594502, "nodeName", newJString(nodeName))
  result = call_594501.call(path_594502, query_594503, nil, nil, nil)

var deployedServiceTypesGet* = Call_DeployedServiceTypesGet_594493(
    name: "deployedServiceTypesGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}/$/GetServiceTypes",
    validator: validate_DeployedServiceTypesGet_594494, base: "",
    url: url_DeployedServiceTypesGet_594495, schemes: {Scheme.Https})
type
  Call_DeployedApplicationHealthsSend_594504 = ref object of OpenApiRestCall_593421
proc url_DeployedApplicationHealthsSend_594506(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetApplications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/$/ReportHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeployedApplicationHealthsSend_594505(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Send deployed application health
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The name of the application
  ##   nodeName: JString (required)
  ##           : The name of the node
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_594507 = path.getOrDefault("applicationName")
  valid_594507 = validateParameter(valid_594507, JString, required = true,
                                 default = nil)
  if valid_594507 != nil:
    section.add "applicationName", valid_594507
  var valid_594508 = path.getOrDefault("nodeName")
  valid_594508 = validateParameter(valid_594508, JString, required = true,
                                 default = nil)
  if valid_594508 != nil:
    section.add "nodeName", valid_594508
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594509 = query.getOrDefault("timeout")
  valid_594509 = validateParameter(valid_594509, JInt, required = false, default = nil)
  if valid_594509 != nil:
    section.add "timeout", valid_594509
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594510 = query.getOrDefault("api-version")
  valid_594510 = validateParameter(valid_594510, JString, required = true,
                                 default = nil)
  if valid_594510 != nil:
    section.add "api-version", valid_594510
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   deployedApplicationHealthReport: JObject (required)
  ##                                  : The report of the deployed application health
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594512: Call_DeployedApplicationHealthsSend_594504; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send deployed application health
  ## 
  let valid = call_594512.validator(path, query, header, formData, body)
  let scheme = call_594512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594512.url(scheme.get, call_594512.host, call_594512.base,
                         call_594512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594512, url, valid)

proc call*(call_594513: Call_DeployedApplicationHealthsSend_594504;
          applicationName: string; apiVersion: string; nodeName: string;
          deployedApplicationHealthReport: JsonNode; timeout: int = 0): Recallable =
  ## deployedApplicationHealthsSend
  ## Send deployed application health
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   nodeName: string (required)
  ##           : The name of the node
  ##   deployedApplicationHealthReport: JObject (required)
  ##                                  : The report of the deployed application health
  var path_594514 = newJObject()
  var query_594515 = newJObject()
  var body_594516 = newJObject()
  add(query_594515, "timeout", newJInt(timeout))
  add(path_594514, "applicationName", newJString(applicationName))
  add(query_594515, "api-version", newJString(apiVersion))
  add(path_594514, "nodeName", newJString(nodeName))
  if deployedApplicationHealthReport != nil:
    body_594516 = deployedApplicationHealthReport
  result = call_594513.call(path_594514, query_594515, nil, nil, body_594516)

var deployedApplicationHealthsSend* = Call_DeployedApplicationHealthsSend_594504(
    name: "deployedApplicationHealthsSend", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}/$/ReportHealth",
    validator: validate_DeployedApplicationHealthsSend_594505, base: "",
    url: url_DeployedApplicationHealthsSend_594506, schemes: {Scheme.Https})
type
  Call_NodeHealthsGet_594517 = ref object of OpenApiRestCall_593421
proc url_NodeHealthsGet_594519(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NodeHealthsGet_594518(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get node healths
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_594520 = path.getOrDefault("nodeName")
  valid_594520 = validateParameter(valid_594520, JString, required = true,
                                 default = nil)
  if valid_594520 != nil:
    section.add "nodeName", valid_594520
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   EventsHealthStateFilter: JString
  ##                          : The filter of the events health state
  section = newJObject()
  var valid_594521 = query.getOrDefault("timeout")
  valid_594521 = validateParameter(valid_594521, JInt, required = false, default = nil)
  if valid_594521 != nil:
    section.add "timeout", valid_594521
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594522 = query.getOrDefault("api-version")
  valid_594522 = validateParameter(valid_594522, JString, required = true,
                                 default = nil)
  if valid_594522 != nil:
    section.add "api-version", valid_594522
  var valid_594523 = query.getOrDefault("EventsHealthStateFilter")
  valid_594523 = validateParameter(valid_594523, JString, required = false,
                                 default = nil)
  if valid_594523 != nil:
    section.add "EventsHealthStateFilter", valid_594523
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594524: Call_NodeHealthsGet_594517; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get node healths
  ## 
  let valid = call_594524.validator(path, query, header, formData, body)
  let scheme = call_594524.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594524.url(scheme.get, call_594524.host, call_594524.base,
                         call_594524.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594524, url, valid)

proc call*(call_594525: Call_NodeHealthsGet_594517; apiVersion: string;
          nodeName: string; timeout: int = 0; EventsHealthStateFilter: string = ""): Recallable =
  ## nodeHealthsGet
  ## Get node healths
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   nodeName: string (required)
  ##           : The name of the node
  ##   EventsHealthStateFilter: string
  ##                          : The filter of the events health state
  var path_594526 = newJObject()
  var query_594527 = newJObject()
  add(query_594527, "timeout", newJInt(timeout))
  add(query_594527, "api-version", newJString(apiVersion))
  add(path_594526, "nodeName", newJString(nodeName))
  add(query_594527, "EventsHealthStateFilter", newJString(EventsHealthStateFilter))
  result = call_594525.call(path_594526, query_594527, nil, nil, nil)

var nodeHealthsGet* = Call_NodeHealthsGet_594517(name: "nodeHealthsGet",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetHealth", validator: validate_NodeHealthsGet_594518,
    base: "", url: url_NodeHealthsGet_594519, schemes: {Scheme.Https})
type
  Call_NodeLoadInformationsGet_594528 = ref object of OpenApiRestCall_593421
proc url_NodeLoadInformationsGet_594530(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetLoadInformation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NodeLoadInformationsGet_594529(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get node load informations
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_594531 = path.getOrDefault("nodeName")
  valid_594531 = validateParameter(valid_594531, JString, required = true,
                                 default = nil)
  if valid_594531 != nil:
    section.add "nodeName", valid_594531
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594532 = query.getOrDefault("timeout")
  valid_594532 = validateParameter(valid_594532, JInt, required = false, default = nil)
  if valid_594532 != nil:
    section.add "timeout", valid_594532
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594533 = query.getOrDefault("api-version")
  valid_594533 = validateParameter(valid_594533, JString, required = true,
                                 default = nil)
  if valid_594533 != nil:
    section.add "api-version", valid_594533
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594534: Call_NodeLoadInformationsGet_594528; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get node load informations
  ## 
  let valid = call_594534.validator(path, query, header, formData, body)
  let scheme = call_594534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594534.url(scheme.get, call_594534.host, call_594534.base,
                         call_594534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594534, url, valid)

proc call*(call_594535: Call_NodeLoadInformationsGet_594528; apiVersion: string;
          nodeName: string; timeout: int = 0): Recallable =
  ## nodeLoadInformationsGet
  ## Get node load informations
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_594536 = newJObject()
  var query_594537 = newJObject()
  add(query_594537, "timeout", newJInt(timeout))
  add(query_594537, "api-version", newJString(apiVersion))
  add(path_594536, "nodeName", newJString(nodeName))
  result = call_594535.call(path_594536, query_594537, nil, nil, nil)

var nodeLoadInformationsGet* = Call_NodeLoadInformationsGet_594528(
    name: "nodeLoadInformationsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetLoadInformation",
    validator: validate_NodeLoadInformationsGet_594529, base: "",
    url: url_NodeLoadInformationsGet_594530, schemes: {Scheme.Https})
type
  Call_DeployedReplicaDetailsGet_594538 = ref object of OpenApiRestCall_593421
proc url_DeployedReplicaDetailsGet_594540(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "partitionName" in path, "`partitionName` is a required path parameter"
  assert "replicaId" in path, "`replicaId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetPartitions/"),
               (kind: VariableSegment, value: "partitionName"),
               (kind: ConstantSegment, value: "/$/GetReplicas/"),
               (kind: VariableSegment, value: "replicaId"),
               (kind: ConstantSegment, value: "/$/GetDetail")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeployedReplicaDetailsGet_594539(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get deployed replica details
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   replicaId: JString (required)
  ##            : The id of the replica
  ##   nodeName: JString (required)
  ##           : The name of the node
  ##   partitionName: JString (required)
  ##                : The name of the partition
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `replicaId` field"
  var valid_594541 = path.getOrDefault("replicaId")
  valid_594541 = validateParameter(valid_594541, JString, required = true,
                                 default = nil)
  if valid_594541 != nil:
    section.add "replicaId", valid_594541
  var valid_594542 = path.getOrDefault("nodeName")
  valid_594542 = validateParameter(valid_594542, JString, required = true,
                                 default = nil)
  if valid_594542 != nil:
    section.add "nodeName", valid_594542
  var valid_594543 = path.getOrDefault("partitionName")
  valid_594543 = validateParameter(valid_594543, JString, required = true,
                                 default = nil)
  if valid_594543 != nil:
    section.add "partitionName", valid_594543
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594544 = query.getOrDefault("timeout")
  valid_594544 = validateParameter(valid_594544, JInt, required = false, default = nil)
  if valid_594544 != nil:
    section.add "timeout", valid_594544
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594545 = query.getOrDefault("api-version")
  valid_594545 = validateParameter(valid_594545, JString, required = true,
                                 default = nil)
  if valid_594545 != nil:
    section.add "api-version", valid_594545
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594546: Call_DeployedReplicaDetailsGet_594538; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get deployed replica details
  ## 
  let valid = call_594546.validator(path, query, header, formData, body)
  let scheme = call_594546.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594546.url(scheme.get, call_594546.host, call_594546.base,
                         call_594546.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594546, url, valid)

proc call*(call_594547: Call_DeployedReplicaDetailsGet_594538; replicaId: string;
          apiVersion: string; nodeName: string; partitionName: string;
          timeout: int = 0): Recallable =
  ## deployedReplicaDetailsGet
  ## Get deployed replica details
  ##   replicaId: string (required)
  ##            : The id of the replica
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   nodeName: string (required)
  ##           : The name of the node
  ##   partitionName: string (required)
  ##                : The name of the partition
  var path_594548 = newJObject()
  var query_594549 = newJObject()
  add(path_594548, "replicaId", newJString(replicaId))
  add(query_594549, "timeout", newJInt(timeout))
  add(query_594549, "api-version", newJString(apiVersion))
  add(path_594548, "nodeName", newJString(nodeName))
  add(path_594548, "partitionName", newJString(partitionName))
  result = call_594547.call(path_594548, query_594549, nil, nil, nil)

var deployedReplicaDetailsGet* = Call_DeployedReplicaDetailsGet_594538(
    name: "deployedReplicaDetailsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetPartitions/{partitionName}/$/GetReplicas/{replicaId}/$/GetDetail",
    validator: validate_DeployedReplicaDetailsGet_594539, base: "",
    url: url_DeployedReplicaDetailsGet_594540, schemes: {Scheme.Https})
type
  Call_NodeStatesRemove_594550 = ref object of OpenApiRestCall_593421
proc url_NodeStatesRemove_594552(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/RemoveNodeState")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NodeStatesRemove_594551(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Remove node states
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_594553 = path.getOrDefault("nodeName")
  valid_594553 = validateParameter(valid_594553, JString, required = true,
                                 default = nil)
  if valid_594553 != nil:
    section.add "nodeName", valid_594553
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594554 = query.getOrDefault("timeout")
  valid_594554 = validateParameter(valid_594554, JInt, required = false, default = nil)
  if valid_594554 != nil:
    section.add "timeout", valid_594554
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594555 = query.getOrDefault("api-version")
  valid_594555 = validateParameter(valid_594555, JString, required = true,
                                 default = nil)
  if valid_594555 != nil:
    section.add "api-version", valid_594555
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594556: Call_NodeStatesRemove_594550; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove node states
  ## 
  let valid = call_594556.validator(path, query, header, formData, body)
  let scheme = call_594556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594556.url(scheme.get, call_594556.host, call_594556.base,
                         call_594556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594556, url, valid)

proc call*(call_594557: Call_NodeStatesRemove_594550; apiVersion: string;
          nodeName: string; timeout: int = 0): Recallable =
  ## nodeStatesRemove
  ## Remove node states
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_594558 = newJObject()
  var query_594559 = newJObject()
  add(query_594559, "timeout", newJInt(timeout))
  add(query_594559, "api-version", newJString(apiVersion))
  add(path_594558, "nodeName", newJString(nodeName))
  result = call_594557.call(path_594558, query_594559, nil, nil, nil)

var nodeStatesRemove* = Call_NodeStatesRemove_594550(name: "nodeStatesRemove",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/RemoveNodeState",
    validator: validate_NodeStatesRemove_594551, base: "",
    url: url_NodeStatesRemove_594552, schemes: {Scheme.Https})
type
  Call_NodeHealthsSend_594560 = ref object of OpenApiRestCall_593421
proc url_NodeHealthsSend_594562(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/ReportHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NodeHealthsSend_594561(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Send node health
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_594563 = path.getOrDefault("nodeName")
  valid_594563 = validateParameter(valid_594563, JString, required = true,
                                 default = nil)
  if valid_594563 != nil:
    section.add "nodeName", valid_594563
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594564 = query.getOrDefault("timeout")
  valid_594564 = validateParameter(valid_594564, JInt, required = false, default = nil)
  if valid_594564 != nil:
    section.add "timeout", valid_594564
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594565 = query.getOrDefault("api-version")
  valid_594565 = validateParameter(valid_594565, JString, required = true,
                                 default = nil)
  if valid_594565 != nil:
    section.add "api-version", valid_594565
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   nodeHealthReport: JObject (required)
  ##                   : The report of the node health
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594567: Call_NodeHealthsSend_594560; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send node health
  ## 
  let valid = call_594567.validator(path, query, header, formData, body)
  let scheme = call_594567.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594567.url(scheme.get, call_594567.host, call_594567.base,
                         call_594567.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594567, url, valid)

proc call*(call_594568: Call_NodeHealthsSend_594560; nodeHealthReport: JsonNode;
          apiVersion: string; nodeName: string; timeout: int = 0): Recallable =
  ## nodeHealthsSend
  ## Send node health
  ##   timeout: int
  ##          : The timeout in seconds
  ##   nodeHealthReport: JObject (required)
  ##                   : The report of the node health
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_594569 = newJObject()
  var query_594570 = newJObject()
  var body_594571 = newJObject()
  add(query_594570, "timeout", newJInt(timeout))
  if nodeHealthReport != nil:
    body_594571 = nodeHealthReport
  add(query_594570, "api-version", newJString(apiVersion))
  add(path_594569, "nodeName", newJString(nodeName))
  result = call_594568.call(path_594569, query_594570, nil, nil, body_594571)

var nodeHealthsSend* = Call_NodeHealthsSend_594560(name: "nodeHealthsSend",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/ReportHealth",
    validator: validate_NodeHealthsSend_594561, base: "", url: url_NodeHealthsSend_594562,
    schemes: {Scheme.Https})
type
  Call_PartitionHealthsGet_594572 = ref object of OpenApiRestCall_593421
proc url_PartitionHealthsGet_594574(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Partitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/GetHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartitionHealthsGet_594573(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get partition healths
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partitionId: JString (required)
  ##              : The id of the partition
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `partitionId` field"
  var valid_594575 = path.getOrDefault("partitionId")
  valid_594575 = validateParameter(valid_594575, JString, required = true,
                                 default = nil)
  if valid_594575 != nil:
    section.add "partitionId", valid_594575
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   ReplicasHealthStateFilter: JString
  ##                            : The filter of the replicas health state
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   EventsHealthStateFilter: JString
  ##                          : The filter of the events health state
  section = newJObject()
  var valid_594576 = query.getOrDefault("timeout")
  valid_594576 = validateParameter(valid_594576, JInt, required = false, default = nil)
  if valid_594576 != nil:
    section.add "timeout", valid_594576
  var valid_594577 = query.getOrDefault("ReplicasHealthStateFilter")
  valid_594577 = validateParameter(valid_594577, JString, required = false,
                                 default = nil)
  if valid_594577 != nil:
    section.add "ReplicasHealthStateFilter", valid_594577
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594578 = query.getOrDefault("api-version")
  valid_594578 = validateParameter(valid_594578, JString, required = true,
                                 default = nil)
  if valid_594578 != nil:
    section.add "api-version", valid_594578
  var valid_594579 = query.getOrDefault("EventsHealthStateFilter")
  valid_594579 = validateParameter(valid_594579, JString, required = false,
                                 default = nil)
  if valid_594579 != nil:
    section.add "EventsHealthStateFilter", valid_594579
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594580: Call_PartitionHealthsGet_594572; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get partition healths
  ## 
  let valid = call_594580.validator(path, query, header, formData, body)
  let scheme = call_594580.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594580.url(scheme.get, call_594580.host, call_594580.base,
                         call_594580.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594580, url, valid)

proc call*(call_594581: Call_PartitionHealthsGet_594572; apiVersion: string;
          partitionId: string; timeout: int = 0;
          ReplicasHealthStateFilter: string = "";
          EventsHealthStateFilter: string = ""): Recallable =
  ## partitionHealthsGet
  ## Get partition healths
  ##   timeout: int
  ##          : The timeout in seconds
  ##   ReplicasHealthStateFilter: string
  ##                            : The filter of the replicas health state
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   EventsHealthStateFilter: string
  ##                          : The filter of the events health state
  ##   partitionId: string (required)
  ##              : The id of the partition
  var path_594582 = newJObject()
  var query_594583 = newJObject()
  add(query_594583, "timeout", newJInt(timeout))
  add(query_594583, "ReplicasHealthStateFilter",
      newJString(ReplicasHealthStateFilter))
  add(query_594583, "api-version", newJString(apiVersion))
  add(query_594583, "EventsHealthStateFilter", newJString(EventsHealthStateFilter))
  add(path_594582, "partitionId", newJString(partitionId))
  result = call_594581.call(path_594582, query_594583, nil, nil, nil)

var partitionHealthsGet* = Call_PartitionHealthsGet_594572(
    name: "partitionHealthsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/GetHealth",
    validator: validate_PartitionHealthsGet_594573, base: "",
    url: url_PartitionHealthsGet_594574, schemes: {Scheme.Https})
type
  Call_PartitionLoadInformationsGet_594584 = ref object of OpenApiRestCall_593421
proc url_PartitionLoadInformationsGet_594586(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Partitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/GetLoadInformation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartitionLoadInformationsGet_594585(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get partition load informations
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partitionId: JString (required)
  ##              : The id of the partition
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `partitionId` field"
  var valid_594587 = path.getOrDefault("partitionId")
  valid_594587 = validateParameter(valid_594587, JString, required = true,
                                 default = nil)
  if valid_594587 != nil:
    section.add "partitionId", valid_594587
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594588 = query.getOrDefault("timeout")
  valid_594588 = validateParameter(valid_594588, JInt, required = false, default = nil)
  if valid_594588 != nil:
    section.add "timeout", valid_594588
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594589 = query.getOrDefault("api-version")
  valid_594589 = validateParameter(valid_594589, JString, required = true,
                                 default = nil)
  if valid_594589 != nil:
    section.add "api-version", valid_594589
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594590: Call_PartitionLoadInformationsGet_594584; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get partition load informations
  ## 
  let valid = call_594590.validator(path, query, header, formData, body)
  let scheme = call_594590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594590.url(scheme.get, call_594590.host, call_594590.base,
                         call_594590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594590, url, valid)

proc call*(call_594591: Call_PartitionLoadInformationsGet_594584;
          apiVersion: string; partitionId: string; timeout: int = 0): Recallable =
  ## partitionLoadInformationsGet
  ## Get partition load informations
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   partitionId: string (required)
  ##              : The id of the partition
  var path_594592 = newJObject()
  var query_594593 = newJObject()
  add(query_594593, "timeout", newJInt(timeout))
  add(query_594593, "api-version", newJString(apiVersion))
  add(path_594592, "partitionId", newJString(partitionId))
  result = call_594591.call(path_594592, query_594593, nil, nil, nil)

var partitionLoadInformationsGet* = Call_PartitionLoadInformationsGet_594584(
    name: "partitionLoadInformationsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetLoadInformation",
    validator: validate_PartitionLoadInformationsGet_594585, base: "",
    url: url_PartitionLoadInformationsGet_594586, schemes: {Scheme.Https})
type
  Call_ReplicasList_594594 = ref object of OpenApiRestCall_593421
proc url_ReplicasList_594596(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Partitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/GetReplicas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicasList_594595(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List replicas
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partitionId: JString (required)
  ##              : The id of the partition
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `partitionId` field"
  var valid_594597 = path.getOrDefault("partitionId")
  valid_594597 = validateParameter(valid_594597, JString, required = true,
                                 default = nil)
  if valid_594597 != nil:
    section.add "partitionId", valid_594597
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594598 = query.getOrDefault("timeout")
  valid_594598 = validateParameter(valid_594598, JInt, required = false, default = nil)
  if valid_594598 != nil:
    section.add "timeout", valid_594598
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594599 = query.getOrDefault("api-version")
  valid_594599 = validateParameter(valid_594599, JString, required = true,
                                 default = nil)
  if valid_594599 != nil:
    section.add "api-version", valid_594599
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594600: Call_ReplicasList_594594; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List replicas
  ## 
  let valid = call_594600.validator(path, query, header, formData, body)
  let scheme = call_594600.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594600.url(scheme.get, call_594600.host, call_594600.base,
                         call_594600.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594600, url, valid)

proc call*(call_594601: Call_ReplicasList_594594; apiVersion: string;
          partitionId: string; timeout: int = 0): Recallable =
  ## replicasList
  ## List replicas
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   partitionId: string (required)
  ##              : The id of the partition
  var path_594602 = newJObject()
  var query_594603 = newJObject()
  add(query_594603, "timeout", newJInt(timeout))
  add(query_594603, "api-version", newJString(apiVersion))
  add(path_594602, "partitionId", newJString(partitionId))
  result = call_594601.call(path_594602, query_594603, nil, nil, nil)

var replicasList* = Call_ReplicasList_594594(name: "replicasList",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetReplicas",
    validator: validate_ReplicasList_594595, base: "", url: url_ReplicasList_594596,
    schemes: {Scheme.Https})
type
  Call_ReplicasGet_594604 = ref object of OpenApiRestCall_593421
proc url_ReplicasGet_594606(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  assert "replicaId" in path, "`replicaId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Partitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/GetReplicas/"),
               (kind: VariableSegment, value: "replicaId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicasGet_594605(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get replicas
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   replicaId: JString (required)
  ##            : The id of the replica
  ##   partitionId: JString (required)
  ##              : The id of the partition
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `replicaId` field"
  var valid_594607 = path.getOrDefault("replicaId")
  valid_594607 = validateParameter(valid_594607, JString, required = true,
                                 default = nil)
  if valid_594607 != nil:
    section.add "replicaId", valid_594607
  var valid_594608 = path.getOrDefault("partitionId")
  valid_594608 = validateParameter(valid_594608, JString, required = true,
                                 default = nil)
  if valid_594608 != nil:
    section.add "partitionId", valid_594608
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594609 = query.getOrDefault("timeout")
  valid_594609 = validateParameter(valid_594609, JInt, required = false, default = nil)
  if valid_594609 != nil:
    section.add "timeout", valid_594609
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594610 = query.getOrDefault("api-version")
  valid_594610 = validateParameter(valid_594610, JString, required = true,
                                 default = nil)
  if valid_594610 != nil:
    section.add "api-version", valid_594610
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594611: Call_ReplicasGet_594604; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get replicas
  ## 
  let valid = call_594611.validator(path, query, header, formData, body)
  let scheme = call_594611.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594611.url(scheme.get, call_594611.host, call_594611.base,
                         call_594611.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594611, url, valid)

proc call*(call_594612: Call_ReplicasGet_594604; replicaId: string;
          apiVersion: string; partitionId: string; timeout: int = 0): Recallable =
  ## replicasGet
  ## Get replicas
  ##   replicaId: string (required)
  ##            : The id of the replica
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   partitionId: string (required)
  ##              : The id of the partition
  var path_594613 = newJObject()
  var query_594614 = newJObject()
  add(path_594613, "replicaId", newJString(replicaId))
  add(query_594614, "timeout", newJInt(timeout))
  add(query_594614, "api-version", newJString(apiVersion))
  add(path_594613, "partitionId", newJString(partitionId))
  result = call_594612.call(path_594613, query_594614, nil, nil, nil)

var replicasGet* = Call_ReplicasGet_594604(name: "replicasGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local:19080", route: "/Partitions/{partitionId}/$/GetReplicas/{replicaId}",
                                        validator: validate_ReplicasGet_594605,
                                        base: "", url: url_ReplicasGet_594606,
                                        schemes: {Scheme.Https})
type
  Call_ReplicaHealthsGet_594615 = ref object of OpenApiRestCall_593421
proc url_ReplicaHealthsGet_594617(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  assert "replicaId" in path, "`replicaId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Partitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/GetReplicas/"),
               (kind: VariableSegment, value: "replicaId"),
               (kind: ConstantSegment, value: "/$/GetHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicaHealthsGet_594616(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get replica healths
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   replicaId: JString (required)
  ##            : The id of the replica
  ##   partitionId: JString (required)
  ##              : The id of the partition
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `replicaId` field"
  var valid_594618 = path.getOrDefault("replicaId")
  valid_594618 = validateParameter(valid_594618, JString, required = true,
                                 default = nil)
  if valid_594618 != nil:
    section.add "replicaId", valid_594618
  var valid_594619 = path.getOrDefault("partitionId")
  valid_594619 = validateParameter(valid_594619, JString, required = true,
                                 default = nil)
  if valid_594619 != nil:
    section.add "partitionId", valid_594619
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   EventsHealthStateFilter: JString
  ##                          : The filter of the events health state
  section = newJObject()
  var valid_594620 = query.getOrDefault("timeout")
  valid_594620 = validateParameter(valid_594620, JInt, required = false, default = nil)
  if valid_594620 != nil:
    section.add "timeout", valid_594620
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594621 = query.getOrDefault("api-version")
  valid_594621 = validateParameter(valid_594621, JString, required = true,
                                 default = nil)
  if valid_594621 != nil:
    section.add "api-version", valid_594621
  var valid_594622 = query.getOrDefault("EventsHealthStateFilter")
  valid_594622 = validateParameter(valid_594622, JString, required = false,
                                 default = nil)
  if valid_594622 != nil:
    section.add "EventsHealthStateFilter", valid_594622
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594623: Call_ReplicaHealthsGet_594615; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get replica healths
  ## 
  let valid = call_594623.validator(path, query, header, formData, body)
  let scheme = call_594623.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594623.url(scheme.get, call_594623.host, call_594623.base,
                         call_594623.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594623, url, valid)

proc call*(call_594624: Call_ReplicaHealthsGet_594615; replicaId: string;
          apiVersion: string; partitionId: string; timeout: int = 0;
          EventsHealthStateFilter: string = ""): Recallable =
  ## replicaHealthsGet
  ## Get replica healths
  ##   replicaId: string (required)
  ##            : The id of the replica
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   EventsHealthStateFilter: string
  ##                          : The filter of the events health state
  ##   partitionId: string (required)
  ##              : The id of the partition
  var path_594625 = newJObject()
  var query_594626 = newJObject()
  add(path_594625, "replicaId", newJString(replicaId))
  add(query_594626, "timeout", newJInt(timeout))
  add(query_594626, "api-version", newJString(apiVersion))
  add(query_594626, "EventsHealthStateFilter", newJString(EventsHealthStateFilter))
  add(path_594625, "partitionId", newJString(partitionId))
  result = call_594624.call(path_594625, query_594626, nil, nil, nil)

var replicaHealthsGet* = Call_ReplicaHealthsGet_594615(name: "replicaHealthsGet",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetReplicas/{replicaId}/$/GetHealth",
    validator: validate_ReplicaHealthsGet_594616, base: "",
    url: url_ReplicaHealthsGet_594617, schemes: {Scheme.Https})
type
  Call_ReplicaLoadInformationsGet_594627 = ref object of OpenApiRestCall_593421
proc url_ReplicaLoadInformationsGet_594629(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  assert "replicaId" in path, "`replicaId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Partitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/GetReplicas/"),
               (kind: VariableSegment, value: "replicaId"),
               (kind: ConstantSegment, value: "/$/GetLoadInformation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicaLoadInformationsGet_594628(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get replica load informations
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   replicaId: JString (required)
  ##            : The id of the replica
  ##   partitionId: JString (required)
  ##              : The id of the partition
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `replicaId` field"
  var valid_594630 = path.getOrDefault("replicaId")
  valid_594630 = validateParameter(valid_594630, JString, required = true,
                                 default = nil)
  if valid_594630 != nil:
    section.add "replicaId", valid_594630
  var valid_594631 = path.getOrDefault("partitionId")
  valid_594631 = validateParameter(valid_594631, JString, required = true,
                                 default = nil)
  if valid_594631 != nil:
    section.add "partitionId", valid_594631
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594632 = query.getOrDefault("timeout")
  valid_594632 = validateParameter(valid_594632, JInt, required = false, default = nil)
  if valid_594632 != nil:
    section.add "timeout", valid_594632
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594633 = query.getOrDefault("api-version")
  valid_594633 = validateParameter(valid_594633, JString, required = true,
                                 default = nil)
  if valid_594633 != nil:
    section.add "api-version", valid_594633
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594634: Call_ReplicaLoadInformationsGet_594627; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get replica load informations
  ## 
  let valid = call_594634.validator(path, query, header, formData, body)
  let scheme = call_594634.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594634.url(scheme.get, call_594634.host, call_594634.base,
                         call_594634.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594634, url, valid)

proc call*(call_594635: Call_ReplicaLoadInformationsGet_594627; replicaId: string;
          apiVersion: string; partitionId: string; timeout: int = 0): Recallable =
  ## replicaLoadInformationsGet
  ## Get replica load informations
  ##   replicaId: string (required)
  ##            : The id of the replica
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   partitionId: string (required)
  ##              : The id of the partition
  var path_594636 = newJObject()
  var query_594637 = newJObject()
  add(path_594636, "replicaId", newJString(replicaId))
  add(query_594637, "timeout", newJInt(timeout))
  add(query_594637, "api-version", newJString(apiVersion))
  add(path_594636, "partitionId", newJString(partitionId))
  result = call_594635.call(path_594636, query_594637, nil, nil, nil)

var replicaLoadInformationsGet* = Call_ReplicaLoadInformationsGet_594627(
    name: "replicaLoadInformationsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/GetReplicas/{replicaId}/$/GetLoadInformation",
    validator: validate_ReplicaLoadInformationsGet_594628, base: "",
    url: url_ReplicaLoadInformationsGet_594629, schemes: {Scheme.Https})
type
  Call_ReplicaHealthsSend_594638 = ref object of OpenApiRestCall_593421
proc url_ReplicaHealthsSend_594640(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  assert "replicaId" in path, "`replicaId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Partitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/GetReplicas/"),
               (kind: VariableSegment, value: "replicaId"),
               (kind: ConstantSegment, value: "/$/ReportHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicaHealthsSend_594639(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Send replica healths
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   replicaId: JString (required)
  ##            : The id of the replica
  ##   partitionId: JString (required)
  ##              : The id of the partition
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `replicaId` field"
  var valid_594641 = path.getOrDefault("replicaId")
  valid_594641 = validateParameter(valid_594641, JString, required = true,
                                 default = nil)
  if valid_594641 != nil:
    section.add "replicaId", valid_594641
  var valid_594642 = path.getOrDefault("partitionId")
  valid_594642 = validateParameter(valid_594642, JString, required = true,
                                 default = nil)
  if valid_594642 != nil:
    section.add "partitionId", valid_594642
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594643 = query.getOrDefault("timeout")
  valid_594643 = validateParameter(valid_594643, JInt, required = false, default = nil)
  if valid_594643 != nil:
    section.add "timeout", valid_594643
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594644 = query.getOrDefault("api-version")
  valid_594644 = validateParameter(valid_594644, JString, required = true,
                                 default = nil)
  if valid_594644 != nil:
    section.add "api-version", valid_594644
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   replicaHealthReport: JObject (required)
  ##                      : The report of the replica health
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594646: Call_ReplicaHealthsSend_594638; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send replica healths
  ## 
  let valid = call_594646.validator(path, query, header, formData, body)
  let scheme = call_594646.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594646.url(scheme.get, call_594646.host, call_594646.base,
                         call_594646.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594646, url, valid)

proc call*(call_594647: Call_ReplicaHealthsSend_594638; replicaId: string;
          apiVersion: string; partitionId: string; replicaHealthReport: JsonNode;
          timeout: int = 0): Recallable =
  ## replicaHealthsSend
  ## Send replica healths
  ##   replicaId: string (required)
  ##            : The id of the replica
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   partitionId: string (required)
  ##              : The id of the partition
  ##   replicaHealthReport: JObject (required)
  ##                      : The report of the replica health
  var path_594648 = newJObject()
  var query_594649 = newJObject()
  var body_594650 = newJObject()
  add(path_594648, "replicaId", newJString(replicaId))
  add(query_594649, "timeout", newJInt(timeout))
  add(query_594649, "api-version", newJString(apiVersion))
  add(path_594648, "partitionId", newJString(partitionId))
  if replicaHealthReport != nil:
    body_594650 = replicaHealthReport
  result = call_594647.call(path_594648, query_594649, nil, nil, body_594650)

var replicaHealthsSend* = Call_ReplicaHealthsSend_594638(
    name: "replicaHealthsSend", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/GetReplicas/{replicaId}/$/ReportHealth",
    validator: validate_ReplicaHealthsSend_594639, base: "",
    url: url_ReplicaHealthsSend_594640, schemes: {Scheme.Https})
type
  Call_PartitionsRepair_594651 = ref object of OpenApiRestCall_593421
proc url_PartitionsRepair_594653(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Partitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/Recover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartitionsRepair_594652(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Repair partitions
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partitionId: JString (required)
  ##              : The id of the partition
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `partitionId` field"
  var valid_594654 = path.getOrDefault("partitionId")
  valid_594654 = validateParameter(valid_594654, JString, required = true,
                                 default = nil)
  if valid_594654 != nil:
    section.add "partitionId", valid_594654
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594655 = query.getOrDefault("timeout")
  valid_594655 = validateParameter(valid_594655, JInt, required = false, default = nil)
  if valid_594655 != nil:
    section.add "timeout", valid_594655
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594656 = query.getOrDefault("api-version")
  valid_594656 = validateParameter(valid_594656, JString, required = true,
                                 default = nil)
  if valid_594656 != nil:
    section.add "api-version", valid_594656
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594657: Call_PartitionsRepair_594651; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Repair partitions
  ## 
  let valid = call_594657.validator(path, query, header, formData, body)
  let scheme = call_594657.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594657.url(scheme.get, call_594657.host, call_594657.base,
                         call_594657.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594657, url, valid)

proc call*(call_594658: Call_PartitionsRepair_594651; apiVersion: string;
          partitionId: string; timeout: int = 0): Recallable =
  ## partitionsRepair
  ## Repair partitions
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   partitionId: string (required)
  ##              : The id of the partition
  var path_594659 = newJObject()
  var query_594660 = newJObject()
  add(query_594660, "timeout", newJInt(timeout))
  add(query_594660, "api-version", newJString(apiVersion))
  add(path_594659, "partitionId", newJString(partitionId))
  result = call_594658.call(path_594659, query_594660, nil, nil, nil)

var partitionsRepair* = Call_PartitionsRepair_594651(name: "partitionsRepair",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/Recover",
    validator: validate_PartitionsRepair_594652, base: "",
    url: url_PartitionsRepair_594653, schemes: {Scheme.Https})
type
  Call_PartitionHealthsSend_594661 = ref object of OpenApiRestCall_593421
proc url_PartitionHealthsSend_594663(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Partitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/ReportHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartitionHealthsSend_594662(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Send partition health
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partitionId: JString (required)
  ##              : The id of the partition
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `partitionId` field"
  var valid_594664 = path.getOrDefault("partitionId")
  valid_594664 = validateParameter(valid_594664, JString, required = true,
                                 default = nil)
  if valid_594664 != nil:
    section.add "partitionId", valid_594664
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594665 = query.getOrDefault("timeout")
  valid_594665 = validateParameter(valid_594665, JInt, required = false, default = nil)
  if valid_594665 != nil:
    section.add "timeout", valid_594665
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594666 = query.getOrDefault("api-version")
  valid_594666 = validateParameter(valid_594666, JString, required = true,
                                 default = nil)
  if valid_594666 != nil:
    section.add "api-version", valid_594666
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   partitionHealthReport: JObject (required)
  ##                        : The report of the partition health
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594668: Call_PartitionHealthsSend_594661; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send partition health
  ## 
  let valid = call_594668.validator(path, query, header, formData, body)
  let scheme = call_594668.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594668.url(scheme.get, call_594668.host, call_594668.base,
                         call_594668.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594668, url, valid)

proc call*(call_594669: Call_PartitionHealthsSend_594661; apiVersion: string;
          partitionHealthReport: JsonNode; partitionId: string; timeout: int = 0): Recallable =
  ## partitionHealthsSend
  ## Send partition health
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   partitionHealthReport: JObject (required)
  ##                        : The report of the partition health
  ##   partitionId: string (required)
  ##              : The id of the partition
  var path_594670 = newJObject()
  var query_594671 = newJObject()
  var body_594672 = newJObject()
  add(query_594671, "timeout", newJInt(timeout))
  add(query_594671, "api-version", newJString(apiVersion))
  if partitionHealthReport != nil:
    body_594672 = partitionHealthReport
  add(path_594670, "partitionId", newJString(partitionId))
  result = call_594669.call(path_594670, query_594671, nil, nil, body_594672)

var partitionHealthsSend* = Call_PartitionHealthsSend_594661(
    name: "partitionHealthsSend", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/ReportHealth",
    validator: validate_PartitionHealthsSend_594662, base: "",
    url: url_PartitionHealthsSend_594663, schemes: {Scheme.Https})
type
  Call_PartitionLoadsReset_594673 = ref object of OpenApiRestCall_593421
proc url_PartitionLoadsReset_594675(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Partitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/ResetLoad")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartitionLoadsReset_594674(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Reset partition loads
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partitionId: JString (required)
  ##              : The id of the partition
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `partitionId` field"
  var valid_594676 = path.getOrDefault("partitionId")
  valid_594676 = validateParameter(valid_594676, JString, required = true,
                                 default = nil)
  if valid_594676 != nil:
    section.add "partitionId", valid_594676
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594677 = query.getOrDefault("timeout")
  valid_594677 = validateParameter(valid_594677, JInt, required = false, default = nil)
  if valid_594677 != nil:
    section.add "timeout", valid_594677
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594678 = query.getOrDefault("api-version")
  valid_594678 = validateParameter(valid_594678, JString, required = true,
                                 default = nil)
  if valid_594678 != nil:
    section.add "api-version", valid_594678
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594679: Call_PartitionLoadsReset_594673; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reset partition loads
  ## 
  let valid = call_594679.validator(path, query, header, formData, body)
  let scheme = call_594679.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594679.url(scheme.get, call_594679.host, call_594679.base,
                         call_594679.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594679, url, valid)

proc call*(call_594680: Call_PartitionLoadsReset_594673; apiVersion: string;
          partitionId: string; timeout: int = 0): Recallable =
  ## partitionLoadsReset
  ## Reset partition loads
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   partitionId: string (required)
  ##              : The id of the partition
  var path_594681 = newJObject()
  var query_594682 = newJObject()
  add(query_594682, "timeout", newJInt(timeout))
  add(query_594682, "api-version", newJString(apiVersion))
  add(path_594681, "partitionId", newJString(partitionId))
  result = call_594680.call(path_594681, query_594682, nil, nil, nil)

var partitionLoadsReset* = Call_PartitionLoadsReset_594673(
    name: "partitionLoadsReset", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/ResetLoad",
    validator: validate_PartitionLoadsReset_594674, base: "",
    url: url_PartitionLoadsReset_594675, schemes: {Scheme.Https})
type
  Call_ServicesRemove_594683 = ref object of OpenApiRestCall_593421
proc url_ServicesRemove_594685(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/$/Delete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesRemove_594684(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Remove services
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594686 = path.getOrDefault("serviceName")
  valid_594686 = validateParameter(valid_594686, JString, required = true,
                                 default = nil)
  if valid_594686 != nil:
    section.add "serviceName", valid_594686
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594687 = query.getOrDefault("timeout")
  valid_594687 = validateParameter(valid_594687, JInt, required = false, default = nil)
  if valid_594687 != nil:
    section.add "timeout", valid_594687
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594688 = query.getOrDefault("api-version")
  valid_594688 = validateParameter(valid_594688, JString, required = true,
                                 default = nil)
  if valid_594688 != nil:
    section.add "api-version", valid_594688
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594689: Call_ServicesRemove_594683; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove services
  ## 
  let valid = call_594689.validator(path, query, header, formData, body)
  let scheme = call_594689.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594689.url(scheme.get, call_594689.host, call_594689.base,
                         call_594689.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594689, url, valid)

proc call*(call_594690: Call_ServicesRemove_594683; apiVersion: string;
          serviceName: string; timeout: int = 0): Recallable =
  ## servicesRemove
  ## Remove services
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   serviceName: string (required)
  ##              : The name of the service
  var path_594691 = newJObject()
  var query_594692 = newJObject()
  add(query_594692, "timeout", newJInt(timeout))
  add(query_594692, "api-version", newJString(apiVersion))
  add(path_594691, "serviceName", newJString(serviceName))
  result = call_594690.call(path_594691, query_594692, nil, nil, nil)

var servicesRemove* = Call_ServicesRemove_594683(name: "servicesRemove",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Services/{serviceName}/$/Delete", validator: validate_ServicesRemove_594684,
    base: "", url: url_ServicesRemove_594685, schemes: {Scheme.Https})
type
  Call_ServiceDescriptionsGet_594693 = ref object of OpenApiRestCall_593421
proc url_ServiceDescriptionsGet_594695(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/$/GetDescription")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceDescriptionsGet_594694(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get service descriptions
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594696 = path.getOrDefault("serviceName")
  valid_594696 = validateParameter(valid_594696, JString, required = true,
                                 default = nil)
  if valid_594696 != nil:
    section.add "serviceName", valid_594696
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594697 = query.getOrDefault("timeout")
  valid_594697 = validateParameter(valid_594697, JInt, required = false, default = nil)
  if valid_594697 != nil:
    section.add "timeout", valid_594697
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594698 = query.getOrDefault("api-version")
  valid_594698 = validateParameter(valid_594698, JString, required = true,
                                 default = nil)
  if valid_594698 != nil:
    section.add "api-version", valid_594698
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594699: Call_ServiceDescriptionsGet_594693; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service descriptions
  ## 
  let valid = call_594699.validator(path, query, header, formData, body)
  let scheme = call_594699.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594699.url(scheme.get, call_594699.host, call_594699.base,
                         call_594699.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594699, url, valid)

proc call*(call_594700: Call_ServiceDescriptionsGet_594693; apiVersion: string;
          serviceName: string; timeout: int = 0): Recallable =
  ## serviceDescriptionsGet
  ## Get service descriptions
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   serviceName: string (required)
  ##              : The name of the service
  var path_594701 = newJObject()
  var query_594702 = newJObject()
  add(query_594702, "timeout", newJInt(timeout))
  add(query_594702, "api-version", newJString(apiVersion))
  add(path_594701, "serviceName", newJString(serviceName))
  result = call_594700.call(path_594701, query_594702, nil, nil, nil)

var serviceDescriptionsGet* = Call_ServiceDescriptionsGet_594693(
    name: "serviceDescriptionsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Services/{serviceName}/$/GetDescription",
    validator: validate_ServiceDescriptionsGet_594694, base: "",
    url: url_ServiceDescriptionsGet_594695, schemes: {Scheme.Https})
type
  Call_ServiceHealthsGet_594703 = ref object of OpenApiRestCall_593421
proc url_ServiceHealthsGet_594705(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/$/GetHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceHealthsGet_594704(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get service healths
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594706 = path.getOrDefault("serviceName")
  valid_594706 = validateParameter(valid_594706, JString, required = true,
                                 default = nil)
  if valid_594706 != nil:
    section.add "serviceName", valid_594706
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594707 = query.getOrDefault("timeout")
  valid_594707 = validateParameter(valid_594707, JInt, required = false, default = nil)
  if valid_594707 != nil:
    section.add "timeout", valid_594707
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594708 = query.getOrDefault("api-version")
  valid_594708 = validateParameter(valid_594708, JString, required = true,
                                 default = nil)
  if valid_594708 != nil:
    section.add "api-version", valid_594708
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594709: Call_ServiceHealthsGet_594703; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service healths
  ## 
  let valid = call_594709.validator(path, query, header, formData, body)
  let scheme = call_594709.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594709.url(scheme.get, call_594709.host, call_594709.base,
                         call_594709.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594709, url, valid)

proc call*(call_594710: Call_ServiceHealthsGet_594703; apiVersion: string;
          serviceName: string; timeout: int = 0): Recallable =
  ## serviceHealthsGet
  ## Get service healths
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   serviceName: string (required)
  ##              : The name of the service
  var path_594711 = newJObject()
  var query_594712 = newJObject()
  add(query_594712, "timeout", newJInt(timeout))
  add(query_594712, "api-version", newJString(apiVersion))
  add(path_594711, "serviceName", newJString(serviceName))
  result = call_594710.call(path_594711, query_594712, nil, nil, nil)

var serviceHealthsGet* = Call_ServiceHealthsGet_594703(name: "serviceHealthsGet",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Services/{serviceName}/$/GetHealth",
    validator: validate_ServiceHealthsGet_594704, base: "",
    url: url_ServiceHealthsGet_594705, schemes: {Scheme.Https})
type
  Call_PartitionsList_594713 = ref object of OpenApiRestCall_593421
proc url_PartitionsList_594715(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/$/GetPartitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartitionsList_594714(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## List partitions
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594716 = path.getOrDefault("serviceName")
  valid_594716 = validateParameter(valid_594716, JString, required = true,
                                 default = nil)
  if valid_594716 != nil:
    section.add "serviceName", valid_594716
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594717 = query.getOrDefault("timeout")
  valid_594717 = validateParameter(valid_594717, JInt, required = false, default = nil)
  if valid_594717 != nil:
    section.add "timeout", valid_594717
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594718 = query.getOrDefault("api-version")
  valid_594718 = validateParameter(valid_594718, JString, required = true,
                                 default = nil)
  if valid_594718 != nil:
    section.add "api-version", valid_594718
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594719: Call_PartitionsList_594713; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List partitions
  ## 
  let valid = call_594719.validator(path, query, header, formData, body)
  let scheme = call_594719.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594719.url(scheme.get, call_594719.host, call_594719.base,
                         call_594719.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594719, url, valid)

proc call*(call_594720: Call_PartitionsList_594713; apiVersion: string;
          serviceName: string; timeout: int = 0): Recallable =
  ## partitionsList
  ## List partitions
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   serviceName: string (required)
  ##              : The name of the service
  var path_594721 = newJObject()
  var query_594722 = newJObject()
  add(query_594722, "timeout", newJInt(timeout))
  add(query_594722, "api-version", newJString(apiVersion))
  add(path_594721, "serviceName", newJString(serviceName))
  result = call_594720.call(path_594721, query_594722, nil, nil, nil)

var partitionsList* = Call_PartitionsList_594713(name: "partitionsList",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Services/{serviceName}/$/GetPartitions",
    validator: validate_PartitionsList_594714, base: "", url: url_PartitionsList_594715,
    schemes: {Scheme.Https})
type
  Call_PartitionListsRepair_594723 = ref object of OpenApiRestCall_593421
proc url_PartitionListsRepair_594725(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/$/GetPartitions/$/Recover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartitionListsRepair_594724(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Repair partition lists
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594726 = path.getOrDefault("serviceName")
  valid_594726 = validateParameter(valid_594726, JString, required = true,
                                 default = nil)
  if valid_594726 != nil:
    section.add "serviceName", valid_594726
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594727 = query.getOrDefault("timeout")
  valid_594727 = validateParameter(valid_594727, JInt, required = false, default = nil)
  if valid_594727 != nil:
    section.add "timeout", valid_594727
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594728 = query.getOrDefault("api-version")
  valid_594728 = validateParameter(valid_594728, JString, required = true,
                                 default = nil)
  if valid_594728 != nil:
    section.add "api-version", valid_594728
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594729: Call_PartitionListsRepair_594723; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Repair partition lists
  ## 
  let valid = call_594729.validator(path, query, header, formData, body)
  let scheme = call_594729.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594729.url(scheme.get, call_594729.host, call_594729.base,
                         call_594729.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594729, url, valid)

proc call*(call_594730: Call_PartitionListsRepair_594723; apiVersion: string;
          serviceName: string; timeout: int = 0): Recallable =
  ## partitionListsRepair
  ## Repair partition lists
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   serviceName: string (required)
  ##              : The name of the service
  var path_594731 = newJObject()
  var query_594732 = newJObject()
  add(query_594732, "timeout", newJInt(timeout))
  add(query_594732, "api-version", newJString(apiVersion))
  add(path_594731, "serviceName", newJString(serviceName))
  result = call_594730.call(path_594731, query_594732, nil, nil, nil)

var partitionListsRepair* = Call_PartitionListsRepair_594723(
    name: "partitionListsRepair", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Services/{serviceName}/$/GetPartitions/$/Recover",
    validator: validate_PartitionListsRepair_594724, base: "",
    url: url_PartitionListsRepair_594725, schemes: {Scheme.Https})
type
  Call_PartitionsGet_594733 = ref object of OpenApiRestCall_593421
proc url_PartitionsGet_594735(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/$/GetPartitions/"),
               (kind: VariableSegment, value: "partitionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartitionsGet_594734(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get partitions
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partitionId: JString (required)
  ##              : The id of the partition
  ##   serviceName: JString (required)
  ##              : The name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `partitionId` field"
  var valid_594736 = path.getOrDefault("partitionId")
  valid_594736 = validateParameter(valid_594736, JString, required = true,
                                 default = nil)
  if valid_594736 != nil:
    section.add "partitionId", valid_594736
  var valid_594737 = path.getOrDefault("serviceName")
  valid_594737 = validateParameter(valid_594737, JString, required = true,
                                 default = nil)
  if valid_594737 != nil:
    section.add "serviceName", valid_594737
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594738 = query.getOrDefault("timeout")
  valid_594738 = validateParameter(valid_594738, JInt, required = false, default = nil)
  if valid_594738 != nil:
    section.add "timeout", valid_594738
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594739 = query.getOrDefault("api-version")
  valid_594739 = validateParameter(valid_594739, JString, required = true,
                                 default = nil)
  if valid_594739 != nil:
    section.add "api-version", valid_594739
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594740: Call_PartitionsGet_594733; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get partitions
  ## 
  let valid = call_594740.validator(path, query, header, formData, body)
  let scheme = call_594740.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594740.url(scheme.get, call_594740.host, call_594740.base,
                         call_594740.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594740, url, valid)

proc call*(call_594741: Call_PartitionsGet_594733; apiVersion: string;
          partitionId: string; serviceName: string; timeout: int = 0): Recallable =
  ## partitionsGet
  ## Get partitions
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   partitionId: string (required)
  ##              : The id of the partition
  ##   serviceName: string (required)
  ##              : The name of the service
  var path_594742 = newJObject()
  var query_594743 = newJObject()
  add(query_594743, "timeout", newJInt(timeout))
  add(query_594743, "api-version", newJString(apiVersion))
  add(path_594742, "partitionId", newJString(partitionId))
  add(path_594742, "serviceName", newJString(serviceName))
  result = call_594741.call(path_594742, query_594743, nil, nil, nil)

var partitionsGet* = Call_PartitionsGet_594733(name: "partitionsGet",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Services/{serviceName}/$/GetPartitions/{partitionId}",
    validator: validate_PartitionsGet_594734, base: "", url: url_PartitionsGet_594735,
    schemes: {Scheme.Https})
type
  Call_ServiceHealthsSend_594744 = ref object of OpenApiRestCall_593421
proc url_ServiceHealthsSend_594746(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/$/ReportHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceHealthsSend_594745(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Send service healths
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594747 = path.getOrDefault("serviceName")
  valid_594747 = validateParameter(valid_594747, JString, required = true,
                                 default = nil)
  if valid_594747 != nil:
    section.add "serviceName", valid_594747
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594748 = query.getOrDefault("timeout")
  valid_594748 = validateParameter(valid_594748, JInt, required = false, default = nil)
  if valid_594748 != nil:
    section.add "timeout", valid_594748
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594749 = query.getOrDefault("api-version")
  valid_594749 = validateParameter(valid_594749, JString, required = true,
                                 default = nil)
  if valid_594749 != nil:
    section.add "api-version", valid_594749
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   serviceHealthReport: JObject (required)
  ##                      : The report of the service health
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594751: Call_ServiceHealthsSend_594744; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send service healths
  ## 
  let valid = call_594751.validator(path, query, header, formData, body)
  let scheme = call_594751.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594751.url(scheme.get, call_594751.host, call_594751.base,
                         call_594751.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594751, url, valid)

proc call*(call_594752: Call_ServiceHealthsSend_594744; apiVersion: string;
          serviceName: string; serviceHealthReport: JsonNode; timeout: int = 0): Recallable =
  ## serviceHealthsSend
  ## Send service healths
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   serviceName: string (required)
  ##              : The name of the service
  ##   serviceHealthReport: JObject (required)
  ##                      : The report of the service health
  var path_594753 = newJObject()
  var query_594754 = newJObject()
  var body_594755 = newJObject()
  add(query_594754, "timeout", newJInt(timeout))
  add(query_594754, "api-version", newJString(apiVersion))
  add(path_594753, "serviceName", newJString(serviceName))
  if serviceHealthReport != nil:
    body_594755 = serviceHealthReport
  result = call_594752.call(path_594753, query_594754, nil, nil, body_594755)

var serviceHealthsSend* = Call_ServiceHealthsSend_594744(
    name: "serviceHealthsSend", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Services/{serviceName}/$/ReportHealth",
    validator: validate_ServiceHealthsSend_594745, base: "",
    url: url_ServiceHealthsSend_594746, schemes: {Scheme.Https})
type
  Call_ServicesResolve_594756 = ref object of OpenApiRestCall_593421
proc url_ServicesResolve_594758(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/$/ResolvePartition")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesResolve_594757(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Resolve services
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594759 = path.getOrDefault("serviceName")
  valid_594759 = validateParameter(valid_594759, JString, required = true,
                                 default = nil)
  if valid_594759 != nil:
    section.add "serviceName", valid_594759
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   PartitionKeyValue: JString
  ##                    : The value of the partition key
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   PartitionKeyType: JInt
  ##                   : The type of the partition key
  ##   PreviousRspVersion: JString
  ##                     : The version of the previous rsp
  section = newJObject()
  var valid_594760 = query.getOrDefault("timeout")
  valid_594760 = validateParameter(valid_594760, JInt, required = false, default = nil)
  if valid_594760 != nil:
    section.add "timeout", valid_594760
  var valid_594761 = query.getOrDefault("PartitionKeyValue")
  valid_594761 = validateParameter(valid_594761, JString, required = false,
                                 default = nil)
  if valid_594761 != nil:
    section.add "PartitionKeyValue", valid_594761
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594762 = query.getOrDefault("api-version")
  valid_594762 = validateParameter(valid_594762, JString, required = true,
                                 default = nil)
  if valid_594762 != nil:
    section.add "api-version", valid_594762
  var valid_594763 = query.getOrDefault("PartitionKeyType")
  valid_594763 = validateParameter(valid_594763, JInt, required = false, default = nil)
  if valid_594763 != nil:
    section.add "PartitionKeyType", valid_594763
  var valid_594764 = query.getOrDefault("PreviousRspVersion")
  valid_594764 = validateParameter(valid_594764, JString, required = false,
                                 default = nil)
  if valid_594764 != nil:
    section.add "PreviousRspVersion", valid_594764
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594765: Call_ServicesResolve_594756; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resolve services
  ## 
  let valid = call_594765.validator(path, query, header, formData, body)
  let scheme = call_594765.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594765.url(scheme.get, call_594765.host, call_594765.base,
                         call_594765.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594765, url, valid)

proc call*(call_594766: Call_ServicesResolve_594756; apiVersion: string;
          serviceName: string; timeout: int = 0; PartitionKeyValue: string = "";
          PartitionKeyType: int = 0; PreviousRspVersion: string = ""): Recallable =
  ## servicesResolve
  ## Resolve services
  ##   timeout: int
  ##          : The timeout in seconds
  ##   PartitionKeyValue: string
  ##                    : The value of the partition key
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   PartitionKeyType: int
  ##                   : The type of the partition key
  ##   PreviousRspVersion: string
  ##                     : The version of the previous rsp
  ##   serviceName: string (required)
  ##              : The name of the service
  var path_594767 = newJObject()
  var query_594768 = newJObject()
  add(query_594768, "timeout", newJInt(timeout))
  add(query_594768, "PartitionKeyValue", newJString(PartitionKeyValue))
  add(query_594768, "api-version", newJString(apiVersion))
  add(query_594768, "PartitionKeyType", newJInt(PartitionKeyType))
  add(query_594768, "PreviousRspVersion", newJString(PreviousRspVersion))
  add(path_594767, "serviceName", newJString(serviceName))
  result = call_594766.call(path_594767, query_594768, nil, nil, nil)

var servicesResolve* = Call_ServicesResolve_594756(name: "servicesResolve",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Services/{serviceName}/$/ResolvePartition",
    validator: validate_ServicesResolve_594757, base: "", url: url_ServicesResolve_594758,
    schemes: {Scheme.Https})
type
  Call_ServicesUpdate_594769 = ref object of OpenApiRestCall_593421
proc url_ServicesUpdate_594771(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/$/Update")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesUpdate_594770(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Update services
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_594772 = path.getOrDefault("serviceName")
  valid_594772 = validateParameter(valid_594772, JString, required = true,
                                 default = nil)
  if valid_594772 != nil:
    section.add "serviceName", valid_594772
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_594773 = query.getOrDefault("timeout")
  valid_594773 = validateParameter(valid_594773, JInt, required = false, default = nil)
  if valid_594773 != nil:
    section.add "timeout", valid_594773
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594774 = query.getOrDefault("api-version")
  valid_594774 = validateParameter(valid_594774, JString, required = true,
                                 default = nil)
  if valid_594774 != nil:
    section.add "api-version", valid_594774
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateServiceDescription: JObject (required)
  ##                           : The description of the service update
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594776: Call_ServicesUpdate_594769; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update services
  ## 
  let valid = call_594776.validator(path, query, header, formData, body)
  let scheme = call_594776.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594776.url(scheme.get, call_594776.host, call_594776.base,
                         call_594776.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594776, url, valid)

proc call*(call_594777: Call_ServicesUpdate_594769; apiVersion: string;
          updateServiceDescription: JsonNode; serviceName: string; timeout: int = 0): Recallable =
  ## servicesUpdate
  ## Update services
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   updateServiceDescription: JObject (required)
  ##                           : The description of the service update
  ##   serviceName: string (required)
  ##              : The name of the service
  var path_594778 = newJObject()
  var query_594779 = newJObject()
  var body_594780 = newJObject()
  add(query_594779, "timeout", newJInt(timeout))
  add(query_594779, "api-version", newJString(apiVersion))
  if updateServiceDescription != nil:
    body_594780 = updateServiceDescription
  add(path_594778, "serviceName", newJString(serviceName))
  result = call_594777.call(path_594778, query_594779, nil, nil, body_594780)

var servicesUpdate* = Call_ServicesUpdate_594769(name: "servicesUpdate",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Services/{serviceName}/$/Update", validator: validate_ServicesUpdate_594770,
    base: "", url: url_ServicesUpdate_594771, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
