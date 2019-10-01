
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567650 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567650](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567650): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
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
  Call_ClusterHealthsGet_567872 = ref object of OpenApiRestCall_567650
proc url_ClusterHealthsGet_567874(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterHealthsGet_567873(path: JsonNode; query: JsonNode;
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
  var valid_568033 = query.getOrDefault("timeout")
  valid_568033 = validateParameter(valid_568033, JInt, required = false, default = nil)
  if valid_568033 != nil:
    section.add "timeout", valid_568033
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568034 = query.getOrDefault("api-version")
  valid_568034 = validateParameter(valid_568034, JString, required = true,
                                 default = nil)
  if valid_568034 != nil:
    section.add "api-version", valid_568034
  var valid_568035 = query.getOrDefault("ApplicationsHealthStateFilter")
  valid_568035 = validateParameter(valid_568035, JString, required = false,
                                 default = nil)
  if valid_568035 != nil:
    section.add "ApplicationsHealthStateFilter", valid_568035
  var valid_568036 = query.getOrDefault("EventsHealthStateFilter")
  valid_568036 = validateParameter(valid_568036, JString, required = false,
                                 default = nil)
  if valid_568036 != nil:
    section.add "EventsHealthStateFilter", valid_568036
  var valid_568037 = query.getOrDefault("NodesHealthStateFilter")
  valid_568037 = validateParameter(valid_568037, JString, required = false,
                                 default = nil)
  if valid_568037 != nil:
    section.add "NodesHealthStateFilter", valid_568037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568060: Call_ClusterHealthsGet_567872; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get cluster healths
  ## 
  let valid = call_568060.validator(path, query, header, formData, body)
  let scheme = call_568060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568060.url(scheme.get, call_568060.host, call_568060.base,
                         call_568060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568060, url, valid)

proc call*(call_568131: Call_ClusterHealthsGet_567872; apiVersion: string;
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
  var query_568132 = newJObject()
  add(query_568132, "timeout", newJInt(timeout))
  add(query_568132, "api-version", newJString(apiVersion))
  add(query_568132, "ApplicationsHealthStateFilter",
      newJString(ApplicationsHealthStateFilter))
  add(query_568132, "EventsHealthStateFilter", newJString(EventsHealthStateFilter))
  add(query_568132, "NodesHealthStateFilter", newJString(NodesHealthStateFilter))
  result = call_568131.call(nil, query_568132, nil, nil, nil)

var clusterHealthsGet* = Call_ClusterHealthsGet_567872(name: "clusterHealthsGet",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/$/GetClusterHealth", validator: validate_ClusterHealthsGet_567873,
    base: "", url: url_ClusterHealthsGet_567874, schemes: {Scheme.Https})
type
  Call_ClusterManifestsGet_568172 = ref object of OpenApiRestCall_567650
proc url_ClusterManifestsGet_568174(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterManifestsGet_568173(path: JsonNode; query: JsonNode;
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
  var valid_568175 = query.getOrDefault("timeout")
  valid_568175 = validateParameter(valid_568175, JInt, required = false, default = nil)
  if valid_568175 != nil:
    section.add "timeout", valid_568175
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568176 = query.getOrDefault("api-version")
  valid_568176 = validateParameter(valid_568176, JString, required = true,
                                 default = nil)
  if valid_568176 != nil:
    section.add "api-version", valid_568176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568177: Call_ClusterManifestsGet_568172; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get cluster manifests
  ## 
  let valid = call_568177.validator(path, query, header, formData, body)
  let scheme = call_568177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568177.url(scheme.get, call_568177.host, call_568177.base,
                         call_568177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568177, url, valid)

proc call*(call_568178: Call_ClusterManifestsGet_568172; apiVersion: string;
          timeout: int = 0): Recallable =
  ## clusterManifestsGet
  ## Get cluster manifests
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  var query_568179 = newJObject()
  add(query_568179, "timeout", newJInt(timeout))
  add(query_568179, "api-version", newJString(apiVersion))
  result = call_568178.call(nil, query_568179, nil, nil, nil)

var clusterManifestsGet* = Call_ClusterManifestsGet_568172(
    name: "clusterManifestsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/$/GetClusterManifest",
    validator: validate_ClusterManifestsGet_568173, base: "",
    url: url_ClusterManifestsGet_568174, schemes: {Scheme.Https})
type
  Call_ClusterLoadInformationsGet_568180 = ref object of OpenApiRestCall_567650
proc url_ClusterLoadInformationsGet_568182(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterLoadInformationsGet_568181(path: JsonNode; query: JsonNode;
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
  var valid_568183 = query.getOrDefault("timeout")
  valid_568183 = validateParameter(valid_568183, JInt, required = false, default = nil)
  if valid_568183 != nil:
    section.add "timeout", valid_568183
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568184 = query.getOrDefault("api-version")
  valid_568184 = validateParameter(valid_568184, JString, required = true,
                                 default = nil)
  if valid_568184 != nil:
    section.add "api-version", valid_568184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568185: Call_ClusterLoadInformationsGet_568180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get cluster load informations
  ## 
  let valid = call_568185.validator(path, query, header, formData, body)
  let scheme = call_568185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568185.url(scheme.get, call_568185.host, call_568185.base,
                         call_568185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568185, url, valid)

proc call*(call_568186: Call_ClusterLoadInformationsGet_568180; apiVersion: string;
          timeout: int = 0): Recallable =
  ## clusterLoadInformationsGet
  ## Get cluster load informations
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  var query_568187 = newJObject()
  add(query_568187, "timeout", newJInt(timeout))
  add(query_568187, "api-version", newJString(apiVersion))
  result = call_568186.call(nil, query_568187, nil, nil, nil)

var clusterLoadInformationsGet* = Call_ClusterLoadInformationsGet_568180(
    name: "clusterLoadInformationsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/$/GetLoadInformation",
    validator: validate_ClusterLoadInformationsGet_568181, base: "",
    url: url_ClusterLoadInformationsGet_568182, schemes: {Scheme.Https})
type
  Call_UpgradeProgressesGet_568188 = ref object of OpenApiRestCall_567650
proc url_UpgradeProgressesGet_568190(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_UpgradeProgressesGet_568189(path: JsonNode; query: JsonNode;
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
  var valid_568191 = query.getOrDefault("timeout")
  valid_568191 = validateParameter(valid_568191, JInt, required = false, default = nil)
  if valid_568191 != nil:
    section.add "timeout", valid_568191
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568192 = query.getOrDefault("api-version")
  valid_568192 = validateParameter(valid_568192, JString, required = true,
                                 default = nil)
  if valid_568192 != nil:
    section.add "api-version", valid_568192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568193: Call_UpgradeProgressesGet_568188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get upgrade progresses
  ## 
  let valid = call_568193.validator(path, query, header, formData, body)
  let scheme = call_568193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568193.url(scheme.get, call_568193.host, call_568193.base,
                         call_568193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568193, url, valid)

proc call*(call_568194: Call_UpgradeProgressesGet_568188; apiVersion: string;
          timeout: int = 0): Recallable =
  ## upgradeProgressesGet
  ## Get upgrade progresses
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  var query_568195 = newJObject()
  add(query_568195, "timeout", newJInt(timeout))
  add(query_568195, "api-version", newJString(apiVersion))
  result = call_568194.call(nil, query_568195, nil, nil, nil)

var upgradeProgressesGet* = Call_UpgradeProgressesGet_568188(
    name: "upgradeProgressesGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/$/GetUpgradeProgress",
    validator: validate_UpgradeProgressesGet_568189, base: "",
    url: url_UpgradeProgressesGet_568190, schemes: {Scheme.Https})
type
  Call_ClusterUpgradesResume_568196 = ref object of OpenApiRestCall_567650
proc url_ClusterUpgradesResume_568198(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterUpgradesResume_568197(path: JsonNode; query: JsonNode;
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
  var valid_568199 = query.getOrDefault("timeout")
  valid_568199 = validateParameter(valid_568199, JInt, required = false, default = nil)
  if valid_568199 != nil:
    section.add "timeout", valid_568199
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568200 = query.getOrDefault("api-version")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "api-version", valid_568200
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

proc call*(call_568202: Call_ClusterUpgradesResume_568196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resume cluster upgrades
  ## 
  let valid = call_568202.validator(path, query, header, formData, body)
  let scheme = call_568202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568202.url(scheme.get, call_568202.host, call_568202.base,
                         call_568202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568202, url, valid)

proc call*(call_568203: Call_ClusterUpgradesResume_568196; apiVersion: string;
          resumeClusterUpgrade: JsonNode; timeout: int = 0): Recallable =
  ## clusterUpgradesResume
  ## Resume cluster upgrades
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   resumeClusterUpgrade: JObject (required)
  ##                       : The upgrade of the cluster
  var query_568204 = newJObject()
  var body_568205 = newJObject()
  add(query_568204, "timeout", newJInt(timeout))
  add(query_568204, "api-version", newJString(apiVersion))
  if resumeClusterUpgrade != nil:
    body_568205 = resumeClusterUpgrade
  result = call_568203.call(nil, query_568204, nil, nil, body_568205)

var clusterUpgradesResume* = Call_ClusterUpgradesResume_568196(
    name: "clusterUpgradesResume", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/MoveToNextUpgradeDomain",
    validator: validate_ClusterUpgradesResume_568197, base: "",
    url: url_ClusterUpgradesResume_568198, schemes: {Scheme.Https})
type
  Call_ClusterPackagesRegister_568206 = ref object of OpenApiRestCall_567650
proc url_ClusterPackagesRegister_568208(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterPackagesRegister_568207(path: JsonNode; query: JsonNode;
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
  var valid_568209 = query.getOrDefault("timeout")
  valid_568209 = validateParameter(valid_568209, JInt, required = false, default = nil)
  if valid_568209 != nil:
    section.add "timeout", valid_568209
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568210 = query.getOrDefault("api-version")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "api-version", valid_568210
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

proc call*(call_568212: Call_ClusterPackagesRegister_568206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Register cluster packages
  ## 
  let valid = call_568212.validator(path, query, header, formData, body)
  let scheme = call_568212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568212.url(scheme.get, call_568212.host, call_568212.base,
                         call_568212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568212, url, valid)

proc call*(call_568213: Call_ClusterPackagesRegister_568206;
          registerClusterPackage: JsonNode; apiVersion: string; timeout: int = 0): Recallable =
  ## clusterPackagesRegister
  ## Register cluster packages
  ##   timeout: int
  ##          : The timeout in seconds
  ##   registerClusterPackage: JObject (required)
  ##                         : The package of the register cluster
  ##   apiVersion: string (required)
  ##             : The version of the api
  var query_568214 = newJObject()
  var body_568215 = newJObject()
  add(query_568214, "timeout", newJInt(timeout))
  if registerClusterPackage != nil:
    body_568215 = registerClusterPackage
  add(query_568214, "api-version", newJString(apiVersion))
  result = call_568213.call(nil, query_568214, nil, nil, body_568215)

var clusterPackagesRegister* = Call_ClusterPackagesRegister_568206(
    name: "clusterPackagesRegister", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/Provision",
    validator: validate_ClusterPackagesRegister_568207, base: "",
    url: url_ClusterPackagesRegister_568208, schemes: {Scheme.Https})
type
  Call_ClusterHealthsSend_568216 = ref object of OpenApiRestCall_567650
proc url_ClusterHealthsSend_568218(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterHealthsSend_568217(path: JsonNode; query: JsonNode;
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
  var valid_568219 = query.getOrDefault("timeout")
  valid_568219 = validateParameter(valid_568219, JInt, required = false, default = nil)
  if valid_568219 != nil:
    section.add "timeout", valid_568219
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568220 = query.getOrDefault("api-version")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "api-version", valid_568220
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

proc call*(call_568222: Call_ClusterHealthsSend_568216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Report cluster healths
  ## 
  let valid = call_568222.validator(path, query, header, formData, body)
  let scheme = call_568222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568222.url(scheme.get, call_568222.host, call_568222.base,
                         call_568222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568222, url, valid)

proc call*(call_568223: Call_ClusterHealthsSend_568216;
          clusterHealthReport: JsonNode; apiVersion: string; timeout: int = 0): Recallable =
  ## clusterHealthsSend
  ## Report cluster healths
  ##   timeout: int
  ##          : The timeout in seconds
  ##   clusterHealthReport: JObject (required)
  ##                      : The report of the cluster health
  ##   apiVersion: string (required)
  ##             : The version of the api
  var query_568224 = newJObject()
  var body_568225 = newJObject()
  add(query_568224, "timeout", newJInt(timeout))
  if clusterHealthReport != nil:
    body_568225 = clusterHealthReport
  add(query_568224, "api-version", newJString(apiVersion))
  result = call_568223.call(nil, query_568224, nil, nil, body_568225)

var clusterHealthsSend* = Call_ClusterHealthsSend_568216(
    name: "clusterHealthsSend", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/ReportClusterHealth",
    validator: validate_ClusterHealthsSend_568217, base: "",
    url: url_ClusterHealthsSend_568218, schemes: {Scheme.Https})
type
  Call_ClusterUpgradesRollback_568226 = ref object of OpenApiRestCall_567650
proc url_ClusterUpgradesRollback_568228(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterUpgradesRollback_568227(path: JsonNode; query: JsonNode;
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
  var valid_568229 = query.getOrDefault("timeout")
  valid_568229 = validateParameter(valid_568229, JInt, required = false, default = nil)
  if valid_568229 != nil:
    section.add "timeout", valid_568229
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568230 = query.getOrDefault("api-version")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "api-version", valid_568230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568231: Call_ClusterUpgradesRollback_568226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rollback cluster upgrades
  ## 
  let valid = call_568231.validator(path, query, header, formData, body)
  let scheme = call_568231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568231.url(scheme.get, call_568231.host, call_568231.base,
                         call_568231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568231, url, valid)

proc call*(call_568232: Call_ClusterUpgradesRollback_568226; apiVersion: string;
          timeout: int = 0): Recallable =
  ## clusterUpgradesRollback
  ## Rollback cluster upgrades
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  var query_568233 = newJObject()
  add(query_568233, "timeout", newJInt(timeout))
  add(query_568233, "api-version", newJString(apiVersion))
  result = call_568232.call(nil, query_568233, nil, nil, nil)

var clusterUpgradesRollback* = Call_ClusterUpgradesRollback_568226(
    name: "clusterUpgradesRollback", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/RollbackUpgrade",
    validator: validate_ClusterUpgradesRollback_568227, base: "",
    url: url_ClusterUpgradesRollback_568228, schemes: {Scheme.Https})
type
  Call_ClusterPackagesUnregister_568234 = ref object of OpenApiRestCall_567650
proc url_ClusterPackagesUnregister_568236(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterPackagesUnregister_568235(path: JsonNode; query: JsonNode;
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
  var valid_568237 = query.getOrDefault("timeout")
  valid_568237 = validateParameter(valid_568237, JInt, required = false, default = nil)
  if valid_568237 != nil:
    section.add "timeout", valid_568237
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568238 = query.getOrDefault("api-version")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "api-version", valid_568238
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

proc call*(call_568240: Call_ClusterPackagesUnregister_568234; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unregister cluster packages
  ## 
  let valid = call_568240.validator(path, query, header, formData, body)
  let scheme = call_568240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568240.url(scheme.get, call_568240.host, call_568240.base,
                         call_568240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568240, url, valid)

proc call*(call_568241: Call_ClusterPackagesUnregister_568234; apiVersion: string;
          unregisterClusterPackage: JsonNode; timeout: int = 0): Recallable =
  ## clusterPackagesUnregister
  ## Unregister cluster packages
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   unregisterClusterPackage: JObject (required)
  ##                           : The package of the unregister cluster
  var query_568242 = newJObject()
  var body_568243 = newJObject()
  add(query_568242, "timeout", newJInt(timeout))
  add(query_568242, "api-version", newJString(apiVersion))
  if unregisterClusterPackage != nil:
    body_568243 = unregisterClusterPackage
  result = call_568241.call(nil, query_568242, nil, nil, body_568243)

var clusterPackagesUnregister* = Call_ClusterPackagesUnregister_568234(
    name: "clusterPackagesUnregister", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/Unprovision",
    validator: validate_ClusterPackagesUnregister_568235, base: "",
    url: url_ClusterPackagesUnregister_568236, schemes: {Scheme.Https})
type
  Call_ClusterUpgradesUpdate_568244 = ref object of OpenApiRestCall_567650
proc url_ClusterUpgradesUpdate_568246(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterUpgradesUpdate_568245(path: JsonNode; query: JsonNode;
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
  var valid_568247 = query.getOrDefault("timeout")
  valid_568247 = validateParameter(valid_568247, JInt, required = false, default = nil)
  if valid_568247 != nil:
    section.add "timeout", valid_568247
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568248 = query.getOrDefault("api-version")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "api-version", valid_568248
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

proc call*(call_568250: Call_ClusterUpgradesUpdate_568244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update cluster upgrades
  ## 
  let valid = call_568250.validator(path, query, header, formData, body)
  let scheme = call_568250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568250.url(scheme.get, call_568250.host, call_568250.base,
                         call_568250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568250, url, valid)

proc call*(call_568251: Call_ClusterUpgradesUpdate_568244; apiVersion: string;
          updateClusterUpgrade: JsonNode; timeout: int = 0): Recallable =
  ## clusterUpgradesUpdate
  ## Update cluster upgrades
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   updateClusterUpgrade: JObject (required)
  ##                       : The description of the update cluster upgrade
  var query_568252 = newJObject()
  var body_568253 = newJObject()
  add(query_568252, "timeout", newJInt(timeout))
  add(query_568252, "api-version", newJString(apiVersion))
  if updateClusterUpgrade != nil:
    body_568253 = updateClusterUpgrade
  result = call_568251.call(nil, query_568252, nil, nil, body_568253)

var clusterUpgradesUpdate* = Call_ClusterUpgradesUpdate_568244(
    name: "clusterUpgradesUpdate", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/UpdateUpgrade",
    validator: validate_ClusterUpgradesUpdate_568245, base: "",
    url: url_ClusterUpgradesUpdate_568246, schemes: {Scheme.Https})
type
  Call_ClusterUpgradesStart_568254 = ref object of OpenApiRestCall_567650
proc url_ClusterUpgradesStart_568256(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterUpgradesStart_568255(path: JsonNode; query: JsonNode;
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
  var valid_568257 = query.getOrDefault("timeout")
  valid_568257 = validateParameter(valid_568257, JInt, required = false, default = nil)
  if valid_568257 != nil:
    section.add "timeout", valid_568257
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568258 = query.getOrDefault("api-version")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "api-version", valid_568258
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

proc call*(call_568260: Call_ClusterUpgradesStart_568254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Start cluster upgrades
  ## 
  let valid = call_568260.validator(path, query, header, formData, body)
  let scheme = call_568260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568260.url(scheme.get, call_568260.host, call_568260.base,
                         call_568260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568260, url, valid)

proc call*(call_568261: Call_ClusterUpgradesStart_568254; apiVersion: string;
          startClusterUpgrade: JsonNode; timeout: int = 0): Recallable =
  ## clusterUpgradesStart
  ## Start cluster upgrades
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   startClusterUpgrade: JObject (required)
  ##                      : The description of the start cluster upgrade
  var query_568262 = newJObject()
  var body_568263 = newJObject()
  add(query_568262, "timeout", newJInt(timeout))
  add(query_568262, "api-version", newJString(apiVersion))
  if startClusterUpgrade != nil:
    body_568263 = startClusterUpgrade
  result = call_568261.call(nil, query_568262, nil, nil, body_568263)

var clusterUpgradesStart* = Call_ClusterUpgradesStart_568254(
    name: "clusterUpgradesStart", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/Upgrade",
    validator: validate_ClusterUpgradesStart_568255, base: "",
    url: url_ClusterUpgradesStart_568256, schemes: {Scheme.Https})
type
  Call_ApplicationTypesList_568264 = ref object of OpenApiRestCall_567650
proc url_ApplicationTypesList_568266(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ApplicationTypesList_568265(path: JsonNode; query: JsonNode;
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
  var valid_568267 = query.getOrDefault("timeout")
  valid_568267 = validateParameter(valid_568267, JInt, required = false, default = nil)
  if valid_568267 != nil:
    section.add "timeout", valid_568267
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568268 = query.getOrDefault("api-version")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "api-version", valid_568268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568269: Call_ApplicationTypesList_568264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List application types
  ## 
  let valid = call_568269.validator(path, query, header, formData, body)
  let scheme = call_568269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568269.url(scheme.get, call_568269.host, call_568269.base,
                         call_568269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568269, url, valid)

proc call*(call_568270: Call_ApplicationTypesList_568264; apiVersion: string;
          timeout: int = 0): Recallable =
  ## applicationTypesList
  ## List application types
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  var query_568271 = newJObject()
  add(query_568271, "timeout", newJInt(timeout))
  add(query_568271, "api-version", newJString(apiVersion))
  result = call_568270.call(nil, query_568271, nil, nil, nil)

var applicationTypesList* = Call_ApplicationTypesList_568264(
    name: "applicationTypesList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/ApplicationTypes",
    validator: validate_ApplicationTypesList_568265, base: "",
    url: url_ApplicationTypesList_568266, schemes: {Scheme.Https})
type
  Call_ApplicationTypesRegister_568272 = ref object of OpenApiRestCall_567650
proc url_ApplicationTypesRegister_568274(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ApplicationTypesRegister_568273(path: JsonNode; query: JsonNode;
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
  var valid_568275 = query.getOrDefault("timeout")
  valid_568275 = validateParameter(valid_568275, JInt, required = false, default = nil)
  if valid_568275 != nil:
    section.add "timeout", valid_568275
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568276 = query.getOrDefault("api-version")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "api-version", valid_568276
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

proc call*(call_568278: Call_ApplicationTypesRegister_568272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Register application types
  ## 
  let valid = call_568278.validator(path, query, header, formData, body)
  let scheme = call_568278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568278.url(scheme.get, call_568278.host, call_568278.base,
                         call_568278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568278, url, valid)

proc call*(call_568279: Call_ApplicationTypesRegister_568272; apiVersion: string;
          registerApplicationType: JsonNode; timeout: int = 0): Recallable =
  ## applicationTypesRegister
  ## Register application types
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   registerApplicationType: JObject (required)
  ##                          : The type of the register application
  var query_568280 = newJObject()
  var body_568281 = newJObject()
  add(query_568280, "timeout", newJInt(timeout))
  add(query_568280, "api-version", newJString(apiVersion))
  if registerApplicationType != nil:
    body_568281 = registerApplicationType
  result = call_568279.call(nil, query_568280, nil, nil, body_568281)

var applicationTypesRegister* = Call_ApplicationTypesRegister_568272(
    name: "applicationTypesRegister", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/ApplicationTypes/$/Provision",
    validator: validate_ApplicationTypesRegister_568273, base: "",
    url: url_ApplicationTypesRegister_568274, schemes: {Scheme.Https})
type
  Call_ApplicationTypesGet_568282 = ref object of OpenApiRestCall_567650
proc url_ApplicationTypesGet_568284(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationTypesGet_568283(path: JsonNode; query: JsonNode;
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
  var valid_568299 = path.getOrDefault("applicationTypeName")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "applicationTypeName", valid_568299
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568300 = query.getOrDefault("timeout")
  valid_568300 = validateParameter(valid_568300, JInt, required = false, default = nil)
  if valid_568300 != nil:
    section.add "timeout", valid_568300
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568301 = query.getOrDefault("api-version")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "api-version", valid_568301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568302: Call_ApplicationTypesGet_568282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get application types
  ## 
  let valid = call_568302.validator(path, query, header, formData, body)
  let scheme = call_568302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568302.url(scheme.get, call_568302.host, call_568302.base,
                         call_568302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568302, url, valid)

proc call*(call_568303: Call_ApplicationTypesGet_568282; apiVersion: string;
          applicationTypeName: string; timeout: int = 0): Recallable =
  ## applicationTypesGet
  ## Get application types
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type
  var path_568304 = newJObject()
  var query_568305 = newJObject()
  add(query_568305, "timeout", newJInt(timeout))
  add(query_568305, "api-version", newJString(apiVersion))
  add(path_568304, "applicationTypeName", newJString(applicationTypeName))
  result = call_568303.call(path_568304, query_568305, nil, nil, nil)

var applicationTypesGet* = Call_ApplicationTypesGet_568282(
    name: "applicationTypesGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/ApplicationTypes/{applicationTypeName}",
    validator: validate_ApplicationTypesGet_568283, base: "",
    url: url_ApplicationTypesGet_568284, schemes: {Scheme.Https})
type
  Call_ApplicationManifestsGet_568306 = ref object of OpenApiRestCall_567650
proc url_ApplicationManifestsGet_568308(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationManifestsGet_568307(path: JsonNode; query: JsonNode;
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
  var valid_568309 = path.getOrDefault("applicationTypeName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "applicationTypeName", valid_568309
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   ApplicationTypeVersion: JString (required)
  ##                         : The version of the application type
  section = newJObject()
  var valid_568310 = query.getOrDefault("timeout")
  valid_568310 = validateParameter(valid_568310, JInt, required = false, default = nil)
  if valid_568310 != nil:
    section.add "timeout", valid_568310
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568311 = query.getOrDefault("api-version")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "api-version", valid_568311
  var valid_568312 = query.getOrDefault("ApplicationTypeVersion")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "ApplicationTypeVersion", valid_568312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568313: Call_ApplicationManifestsGet_568306; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get application manifests
  ## 
  let valid = call_568313.validator(path, query, header, formData, body)
  let scheme = call_568313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568313.url(scheme.get, call_568313.host, call_568313.base,
                         call_568313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568313, url, valid)

proc call*(call_568314: Call_ApplicationManifestsGet_568306; apiVersion: string;
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
  var path_568315 = newJObject()
  var query_568316 = newJObject()
  add(query_568316, "timeout", newJInt(timeout))
  add(query_568316, "api-version", newJString(apiVersion))
  add(path_568315, "applicationTypeName", newJString(applicationTypeName))
  add(query_568316, "ApplicationTypeVersion", newJString(ApplicationTypeVersion))
  result = call_568314.call(path_568315, query_568316, nil, nil, nil)

var applicationManifestsGet* = Call_ApplicationManifestsGet_568306(
    name: "applicationManifestsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/ApplicationTypes/{applicationTypeName}/$/GetApplicationManifest",
    validator: validate_ApplicationManifestsGet_568307, base: "",
    url: url_ApplicationManifestsGet_568308, schemes: {Scheme.Https})
type
  Call_ServiceManifestsGet_568317 = ref object of OpenApiRestCall_567650
proc url_ServiceManifestsGet_568319(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceManifestsGet_568318(path: JsonNode; query: JsonNode;
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
  var valid_568320 = path.getOrDefault("applicationTypeName")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "applicationTypeName", valid_568320
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
  var valid_568321 = query.getOrDefault("timeout")
  valid_568321 = validateParameter(valid_568321, JInt, required = false, default = nil)
  if valid_568321 != nil:
    section.add "timeout", valid_568321
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568322 = query.getOrDefault("api-version")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "api-version", valid_568322
  var valid_568323 = query.getOrDefault("ApplicationTypeVersion")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "ApplicationTypeVersion", valid_568323
  var valid_568324 = query.getOrDefault("ServiceManifestName")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "ServiceManifestName", valid_568324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568325: Call_ServiceManifestsGet_568317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service manifests
  ## 
  let valid = call_568325.validator(path, query, header, formData, body)
  let scheme = call_568325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568325.url(scheme.get, call_568325.host, call_568325.base,
                         call_568325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568325, url, valid)

proc call*(call_568326: Call_ServiceManifestsGet_568317; apiVersion: string;
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
  var path_568327 = newJObject()
  var query_568328 = newJObject()
  add(query_568328, "timeout", newJInt(timeout))
  add(query_568328, "api-version", newJString(apiVersion))
  add(path_568327, "applicationTypeName", newJString(applicationTypeName))
  add(query_568328, "ApplicationTypeVersion", newJString(ApplicationTypeVersion))
  add(query_568328, "ServiceManifestName", newJString(ServiceManifestName))
  result = call_568326.call(path_568327, query_568328, nil, nil, nil)

var serviceManifestsGet* = Call_ServiceManifestsGet_568317(
    name: "serviceManifestsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/ApplicationTypes/{applicationTypeName}/$/GetServiceManifest",
    validator: validate_ServiceManifestsGet_568318, base: "",
    url: url_ServiceManifestsGet_568319, schemes: {Scheme.Https})
type
  Call_ServiceTypesGet_568329 = ref object of OpenApiRestCall_567650
proc url_ServiceTypesGet_568331(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceTypesGet_568330(path: JsonNode; query: JsonNode;
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
  var valid_568332 = path.getOrDefault("applicationTypeName")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "applicationTypeName", valid_568332
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   ApplicationTypeVersion: JString (required)
  ##                         : The version of the application type
  section = newJObject()
  var valid_568333 = query.getOrDefault("timeout")
  valid_568333 = validateParameter(valid_568333, JInt, required = false, default = nil)
  if valid_568333 != nil:
    section.add "timeout", valid_568333
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568334 = query.getOrDefault("api-version")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "api-version", valid_568334
  var valid_568335 = query.getOrDefault("ApplicationTypeVersion")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "ApplicationTypeVersion", valid_568335
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568336: Call_ServiceTypesGet_568329; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service types
  ## 
  let valid = call_568336.validator(path, query, header, formData, body)
  let scheme = call_568336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568336.url(scheme.get, call_568336.host, call_568336.base,
                         call_568336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568336, url, valid)

proc call*(call_568337: Call_ServiceTypesGet_568329; apiVersion: string;
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
  var path_568338 = newJObject()
  var query_568339 = newJObject()
  add(query_568339, "timeout", newJInt(timeout))
  add(query_568339, "api-version", newJString(apiVersion))
  add(path_568338, "applicationTypeName", newJString(applicationTypeName))
  add(query_568339, "ApplicationTypeVersion", newJString(ApplicationTypeVersion))
  result = call_568337.call(path_568338, query_568339, nil, nil, nil)

var serviceTypesGet* = Call_ServiceTypesGet_568329(name: "serviceTypesGet",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/ApplicationTypes/{applicationTypeName}/$/GetServiceTypes",
    validator: validate_ServiceTypesGet_568330, base: "", url: url_ServiceTypesGet_568331,
    schemes: {Scheme.Https})
type
  Call_ApplicationTypesUnregister_568340 = ref object of OpenApiRestCall_567650
proc url_ApplicationTypesUnregister_568342(protocol: Scheme; host: string;
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

proc validate_ApplicationTypesUnregister_568341(path: JsonNode; query: JsonNode;
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
  var valid_568343 = path.getOrDefault("applicationTypeName")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "applicationTypeName", valid_568343
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568344 = query.getOrDefault("timeout")
  valid_568344 = validateParameter(valid_568344, JInt, required = false, default = nil)
  if valid_568344 != nil:
    section.add "timeout", valid_568344
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568345 = query.getOrDefault("api-version")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "api-version", valid_568345
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

proc call*(call_568347: Call_ApplicationTypesUnregister_568340; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unregister application types
  ## 
  let valid = call_568347.validator(path, query, header, formData, body)
  let scheme = call_568347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568347.url(scheme.get, call_568347.host, call_568347.base,
                         call_568347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568347, url, valid)

proc call*(call_568348: Call_ApplicationTypesUnregister_568340;
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
  var path_568349 = newJObject()
  var query_568350 = newJObject()
  var body_568351 = newJObject()
  add(query_568350, "timeout", newJInt(timeout))
  if unregisterApplicationType != nil:
    body_568351 = unregisterApplicationType
  add(query_568350, "api-version", newJString(apiVersion))
  add(path_568349, "applicationTypeName", newJString(applicationTypeName))
  result = call_568348.call(path_568349, query_568350, nil, nil, body_568351)

var applicationTypesUnregister* = Call_ApplicationTypesUnregister_568340(
    name: "applicationTypesUnregister", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/ApplicationTypes/{applicationTypeName}/$/Unprovision",
    validator: validate_ApplicationTypesUnregister_568341, base: "",
    url: url_ApplicationTypesUnregister_568342, schemes: {Scheme.Https})
type
  Call_ApplicationsList_568352 = ref object of OpenApiRestCall_567650
proc url_ApplicationsList_568354(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ApplicationsList_568353(path: JsonNode; query: JsonNode;
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
  var valid_568355 = query.getOrDefault("timeout")
  valid_568355 = validateParameter(valid_568355, JInt, required = false, default = nil)
  if valid_568355 != nil:
    section.add "timeout", valid_568355
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568356 = query.getOrDefault("api-version")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "api-version", valid_568356
  var valid_568357 = query.getOrDefault("continuation-token")
  valid_568357 = validateParameter(valid_568357, JString, required = false,
                                 default = nil)
  if valid_568357 != nil:
    section.add "continuation-token", valid_568357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568358: Call_ApplicationsList_568352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List applications
  ## 
  let valid = call_568358.validator(path, query, header, formData, body)
  let scheme = call_568358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568358.url(scheme.get, call_568358.host, call_568358.base,
                         call_568358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568358, url, valid)

proc call*(call_568359: Call_ApplicationsList_568352; apiVersion: string;
          timeout: int = 0; continuationToken: string = ""): Recallable =
  ## applicationsList
  ## List applications
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   continuationToken: string
  ##                    : The token of the continuation
  var query_568360 = newJObject()
  add(query_568360, "timeout", newJInt(timeout))
  add(query_568360, "api-version", newJString(apiVersion))
  add(query_568360, "continuation-token", newJString(continuationToken))
  result = call_568359.call(nil, query_568360, nil, nil, nil)

var applicationsList* = Call_ApplicationsList_568352(name: "applicationsList",
    meth: HttpMethod.HttpGet, host: "azure.local:19080", route: "/Applications",
    validator: validate_ApplicationsList_568353, base: "",
    url: url_ApplicationsList_568354, schemes: {Scheme.Https})
type
  Call_ApplicationsCreate_568361 = ref object of OpenApiRestCall_567650
proc url_ApplicationsCreate_568363(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ApplicationsCreate_568362(path: JsonNode; query: JsonNode;
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
  var valid_568364 = query.getOrDefault("timeout")
  valid_568364 = validateParameter(valid_568364, JInt, required = false, default = nil)
  if valid_568364 != nil:
    section.add "timeout", valid_568364
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568365 = query.getOrDefault("api-version")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "api-version", valid_568365
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

proc call*(call_568367: Call_ApplicationsCreate_568361; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create applications
  ## 
  let valid = call_568367.validator(path, query, header, formData, body)
  let scheme = call_568367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568367.url(scheme.get, call_568367.host, call_568367.base,
                         call_568367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568367, url, valid)

proc call*(call_568368: Call_ApplicationsCreate_568361; apiVersion: string;
          applicationDescription: JsonNode; timeout: int = 0): Recallable =
  ## applicationsCreate
  ## Create applications
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationDescription: JObject (required)
  ##                         : The description of the application
  var query_568369 = newJObject()
  var body_568370 = newJObject()
  add(query_568369, "timeout", newJInt(timeout))
  add(query_568369, "api-version", newJString(apiVersion))
  if applicationDescription != nil:
    body_568370 = applicationDescription
  result = call_568368.call(nil, query_568369, nil, nil, body_568370)

var applicationsCreate* = Call_ApplicationsCreate_568361(
    name: "applicationsCreate", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/$/Create",
    validator: validate_ApplicationsCreate_568362, base: "",
    url: url_ApplicationsCreate_568363, schemes: {Scheme.Https})
type
  Call_ApplicationsGet_568371 = ref object of OpenApiRestCall_567650
proc url_ApplicationsGet_568373(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationsGet_568372(path: JsonNode; query: JsonNode;
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
  var valid_568374 = path.getOrDefault("applicationName")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "applicationName", valid_568374
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568375 = query.getOrDefault("timeout")
  valid_568375 = validateParameter(valid_568375, JInt, required = false, default = nil)
  if valid_568375 != nil:
    section.add "timeout", valid_568375
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568376 = query.getOrDefault("api-version")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "api-version", valid_568376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568377: Call_ApplicationsGet_568371; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get applications
  ## 
  let valid = call_568377.validator(path, query, header, formData, body)
  let scheme = call_568377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568377.url(scheme.get, call_568377.host, call_568377.base,
                         call_568377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568377, url, valid)

proc call*(call_568378: Call_ApplicationsGet_568371; applicationName: string;
          apiVersion: string; timeout: int = 0): Recallable =
  ## applicationsGet
  ## Get applications
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  var path_568379 = newJObject()
  var query_568380 = newJObject()
  add(query_568380, "timeout", newJInt(timeout))
  add(path_568379, "applicationName", newJString(applicationName))
  add(query_568380, "api-version", newJString(apiVersion))
  result = call_568378.call(path_568379, query_568380, nil, nil, nil)

var applicationsGet* = Call_ApplicationsGet_568371(name: "applicationsGet",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Applications/{applicationName}", validator: validate_ApplicationsGet_568372,
    base: "", url: url_ApplicationsGet_568373, schemes: {Scheme.Https})
type
  Call_ApplicationsRemove_568381 = ref object of OpenApiRestCall_567650
proc url_ApplicationsRemove_568383(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationsRemove_568382(path: JsonNode; query: JsonNode;
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
  var valid_568384 = path.getOrDefault("applicationName")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "applicationName", valid_568384
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   ForceRemove: JBool
  ##              : The force remove flag to skip services check
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568385 = query.getOrDefault("timeout")
  valid_568385 = validateParameter(valid_568385, JInt, required = false, default = nil)
  if valid_568385 != nil:
    section.add "timeout", valid_568385
  var valid_568386 = query.getOrDefault("ForceRemove")
  valid_568386 = validateParameter(valid_568386, JBool, required = false, default = nil)
  if valid_568386 != nil:
    section.add "ForceRemove", valid_568386
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568387 = query.getOrDefault("api-version")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "api-version", valid_568387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568388: Call_ApplicationsRemove_568381; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove applications
  ## 
  let valid = call_568388.validator(path, query, header, formData, body)
  let scheme = call_568388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568388.url(scheme.get, call_568388.host, call_568388.base,
                         call_568388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568388, url, valid)

proc call*(call_568389: Call_ApplicationsRemove_568381; applicationName: string;
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
  var path_568390 = newJObject()
  var query_568391 = newJObject()
  add(query_568391, "timeout", newJInt(timeout))
  add(path_568390, "applicationName", newJString(applicationName))
  add(query_568391, "ForceRemove", newJBool(ForceRemove))
  add(query_568391, "api-version", newJString(apiVersion))
  result = call_568389.call(path_568390, query_568391, nil, nil, nil)

var applicationsRemove* = Call_ApplicationsRemove_568381(
    name: "applicationsRemove", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/Delete",
    validator: validate_ApplicationsRemove_568382, base: "",
    url: url_ApplicationsRemove_568383, schemes: {Scheme.Https})
type
  Call_ApplicationHealthsGet_568392 = ref object of OpenApiRestCall_567650
proc url_ApplicationHealthsGet_568394(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationHealthsGet_568393(path: JsonNode; query: JsonNode;
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
  var valid_568395 = path.getOrDefault("applicationName")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "applicationName", valid_568395
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
  var valid_568396 = query.getOrDefault("timeout")
  valid_568396 = validateParameter(valid_568396, JInt, required = false, default = nil)
  if valid_568396 != nil:
    section.add "timeout", valid_568396
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568397 = query.getOrDefault("api-version")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "api-version", valid_568397
  var valid_568398 = query.getOrDefault("EventsHealthStateFilter")
  valid_568398 = validateParameter(valid_568398, JString, required = false,
                                 default = nil)
  if valid_568398 != nil:
    section.add "EventsHealthStateFilter", valid_568398
  var valid_568399 = query.getOrDefault("DeployedApplicationsHealthStateFilter")
  valid_568399 = validateParameter(valid_568399, JString, required = false,
                                 default = nil)
  if valid_568399 != nil:
    section.add "DeployedApplicationsHealthStateFilter", valid_568399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568400: Call_ApplicationHealthsGet_568392; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get application healths
  ## 
  let valid = call_568400.validator(path, query, header, formData, body)
  let scheme = call_568400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568400.url(scheme.get, call_568400.host, call_568400.base,
                         call_568400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568400, url, valid)

proc call*(call_568401: Call_ApplicationHealthsGet_568392; applicationName: string;
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
  var path_568402 = newJObject()
  var query_568403 = newJObject()
  add(query_568403, "timeout", newJInt(timeout))
  add(path_568402, "applicationName", newJString(applicationName))
  add(query_568403, "api-version", newJString(apiVersion))
  add(query_568403, "EventsHealthStateFilter", newJString(EventsHealthStateFilter))
  add(query_568403, "DeployedApplicationsHealthStateFilter",
      newJString(DeployedApplicationsHealthStateFilter))
  result = call_568401.call(path_568402, query_568403, nil, nil, nil)

var applicationHealthsGet* = Call_ApplicationHealthsGet_568392(
    name: "applicationHealthsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Applications/{applicationName}/$/GetHealth",
    validator: validate_ApplicationHealthsGet_568393, base: "",
    url: url_ApplicationHealthsGet_568394, schemes: {Scheme.Https})
type
  Call_ServiceGroupFromTemplatesCreate_568404 = ref object of OpenApiRestCall_567650
proc url_ServiceGroupFromTemplatesCreate_568406(protocol: Scheme; host: string;
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

proc validate_ServiceGroupFromTemplatesCreate_568405(path: JsonNode;
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
  var valid_568407 = path.getOrDefault("applicationName")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "applicationName", valid_568407
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568408 = query.getOrDefault("timeout")
  valid_568408 = validateParameter(valid_568408, JInt, required = false, default = nil)
  if valid_568408 != nil:
    section.add "timeout", valid_568408
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568409 = query.getOrDefault("api-version")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "api-version", valid_568409
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

proc call*(call_568411: Call_ServiceGroupFromTemplatesCreate_568404;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create service group from templates
  ## 
  let valid = call_568411.validator(path, query, header, formData, body)
  let scheme = call_568411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568411.url(scheme.get, call_568411.host, call_568411.base,
                         call_568411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568411, url, valid)

proc call*(call_568412: Call_ServiceGroupFromTemplatesCreate_568404;
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
  var path_568413 = newJObject()
  var query_568414 = newJObject()
  var body_568415 = newJObject()
  add(query_568414, "timeout", newJInt(timeout))
  add(path_568413, "applicationName", newJString(applicationName))
  add(query_568414, "api-version", newJString(apiVersion))
  if serviceDescriptionTemplate != nil:
    body_568415 = serviceDescriptionTemplate
  result = call_568412.call(path_568413, query_568414, nil, nil, body_568415)

var serviceGroupFromTemplatesCreate* = Call_ServiceGroupFromTemplatesCreate_568404(
    name: "serviceGroupFromTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/GetServiceGroups/$/CreateServiceGroupFromTemplate",
    validator: validate_ServiceGroupFromTemplatesCreate_568405, base: "",
    url: url_ServiceGroupFromTemplatesCreate_568406, schemes: {Scheme.Https})
type
  Call_ServiceGroupsRemove_568416 = ref object of OpenApiRestCall_567650
proc url_ServiceGroupsRemove_568418(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceGroupsRemove_568417(path: JsonNode; query: JsonNode;
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
  var valid_568419 = path.getOrDefault("applicationName")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "applicationName", valid_568419
  var valid_568420 = path.getOrDefault("serviceName")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "serviceName", valid_568420
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568421 = query.getOrDefault("timeout")
  valid_568421 = validateParameter(valid_568421, JInt, required = false, default = nil)
  if valid_568421 != nil:
    section.add "timeout", valid_568421
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568422 = query.getOrDefault("api-version")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "api-version", valid_568422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568423: Call_ServiceGroupsRemove_568416; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove service groups
  ## 
  let valid = call_568423.validator(path, query, header, formData, body)
  let scheme = call_568423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568423.url(scheme.get, call_568423.host, call_568423.base,
                         call_568423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568423, url, valid)

proc call*(call_568424: Call_ServiceGroupsRemove_568416; applicationName: string;
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
  var path_568425 = newJObject()
  var query_568426 = newJObject()
  add(query_568426, "timeout", newJInt(timeout))
  add(path_568425, "applicationName", newJString(applicationName))
  add(query_568426, "api-version", newJString(apiVersion))
  add(path_568425, "serviceName", newJString(serviceName))
  result = call_568424.call(path_568425, query_568426, nil, nil, nil)

var serviceGroupsRemove* = Call_ServiceGroupsRemove_568416(
    name: "serviceGroupsRemove", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/GetServiceGroups/{serviceName}/$/Delete",
    validator: validate_ServiceGroupsRemove_568417, base: "",
    url: url_ServiceGroupsRemove_568418, schemes: {Scheme.Https})
type
  Call_ServicesList_568427 = ref object of OpenApiRestCall_567650
proc url_ServicesList_568429(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesList_568428(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568430 = path.getOrDefault("applicationName")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "applicationName", valid_568430
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568431 = query.getOrDefault("timeout")
  valid_568431 = validateParameter(valid_568431, JInt, required = false, default = nil)
  if valid_568431 != nil:
    section.add "timeout", valid_568431
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568432 = query.getOrDefault("api-version")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "api-version", valid_568432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568433: Call_ServicesList_568427; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List services
  ## 
  let valid = call_568433.validator(path, query, header, formData, body)
  let scheme = call_568433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568433.url(scheme.get, call_568433.host, call_568433.base,
                         call_568433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568433, url, valid)

proc call*(call_568434: Call_ServicesList_568427; applicationName: string;
          apiVersion: string; timeout: int = 0): Recallable =
  ## servicesList
  ## List services
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  var path_568435 = newJObject()
  var query_568436 = newJObject()
  add(query_568436, "timeout", newJInt(timeout))
  add(path_568435, "applicationName", newJString(applicationName))
  add(query_568436, "api-version", newJString(apiVersion))
  result = call_568434.call(path_568435, query_568436, nil, nil, nil)

var servicesList* = Call_ServicesList_568427(name: "servicesList",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Applications/{applicationName}/$/GetServices",
    validator: validate_ServicesList_568428, base: "", url: url_ServicesList_568429,
    schemes: {Scheme.Https})
type
  Call_ServicesCreate_568437 = ref object of OpenApiRestCall_567650
proc url_ServicesCreate_568439(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesCreate_568438(path: JsonNode; query: JsonNode;
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
  var valid_568440 = path.getOrDefault("applicationName")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "applicationName", valid_568440
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568441 = query.getOrDefault("timeout")
  valid_568441 = validateParameter(valid_568441, JInt, required = false, default = nil)
  if valid_568441 != nil:
    section.add "timeout", valid_568441
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568442 = query.getOrDefault("api-version")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "api-version", valid_568442
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

proc call*(call_568444: Call_ServicesCreate_568437; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create services
  ## 
  let valid = call_568444.validator(path, query, header, formData, body)
  let scheme = call_568444.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568444.url(scheme.get, call_568444.host, call_568444.base,
                         call_568444.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568444, url, valid)

proc call*(call_568445: Call_ServicesCreate_568437;
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
  var path_568446 = newJObject()
  var query_568447 = newJObject()
  var body_568448 = newJObject()
  if createServiceDescription != nil:
    body_568448 = createServiceDescription
  add(query_568447, "timeout", newJInt(timeout))
  add(path_568446, "applicationName", newJString(applicationName))
  add(query_568447, "api-version", newJString(apiVersion))
  result = call_568445.call(path_568446, query_568447, nil, nil, body_568448)

var servicesCreate* = Call_ServicesCreate_568437(name: "servicesCreate",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Applications/{applicationName}/$/GetServices/$/Create",
    validator: validate_ServicesCreate_568438, base: "", url: url_ServicesCreate_568439,
    schemes: {Scheme.Https})
type
  Call_ServiceFromTemplatesCreate_568449 = ref object of OpenApiRestCall_567650
proc url_ServiceFromTemplatesCreate_568451(protocol: Scheme; host: string;
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

proc validate_ServiceFromTemplatesCreate_568450(path: JsonNode; query: JsonNode;
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
  var valid_568452 = path.getOrDefault("applicationName")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "applicationName", valid_568452
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568453 = query.getOrDefault("timeout")
  valid_568453 = validateParameter(valid_568453, JInt, required = false, default = nil)
  if valid_568453 != nil:
    section.add "timeout", valid_568453
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568454 = query.getOrDefault("api-version")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "api-version", valid_568454
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

proc call*(call_568456: Call_ServiceFromTemplatesCreate_568449; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create service from templates
  ## 
  let valid = call_568456.validator(path, query, header, formData, body)
  let scheme = call_568456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568456.url(scheme.get, call_568456.host, call_568456.base,
                         call_568456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568456, url, valid)

proc call*(call_568457: Call_ServiceFromTemplatesCreate_568449;
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
  var path_568458 = newJObject()
  var query_568459 = newJObject()
  var body_568460 = newJObject()
  add(query_568459, "timeout", newJInt(timeout))
  add(path_568458, "applicationName", newJString(applicationName))
  add(query_568459, "api-version", newJString(apiVersion))
  if serviceDescriptionTemplate != nil:
    body_568460 = serviceDescriptionTemplate
  result = call_568457.call(path_568458, query_568459, nil, nil, body_568460)

var serviceFromTemplatesCreate* = Call_ServiceFromTemplatesCreate_568449(
    name: "serviceFromTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/GetServices/$/CreateFromTemplate",
    validator: validate_ServiceFromTemplatesCreate_568450, base: "",
    url: url_ServiceFromTemplatesCreate_568451, schemes: {Scheme.Https})
type
  Call_ServiceGroupsCreate_568461 = ref object of OpenApiRestCall_567650
proc url_ServiceGroupsCreate_568463(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceGroupsCreate_568462(path: JsonNode; query: JsonNode;
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
  var valid_568464 = path.getOrDefault("applicationName")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "applicationName", valid_568464
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568465 = query.getOrDefault("timeout")
  valid_568465 = validateParameter(valid_568465, JInt, required = false, default = nil)
  if valid_568465 != nil:
    section.add "timeout", valid_568465
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568466 = query.getOrDefault("api-version")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "api-version", valid_568466
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

proc call*(call_568468: Call_ServiceGroupsCreate_568461; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create service groups
  ## 
  let valid = call_568468.validator(path, query, header, formData, body)
  let scheme = call_568468.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568468.url(scheme.get, call_568468.host, call_568468.base,
                         call_568468.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568468, url, valid)

proc call*(call_568469: Call_ServiceGroupsCreate_568461;
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
  var path_568470 = newJObject()
  var query_568471 = newJObject()
  var body_568472 = newJObject()
  add(query_568471, "timeout", newJInt(timeout))
  if createServiceGroupDescription != nil:
    body_568472 = createServiceGroupDescription
  add(path_568470, "applicationName", newJString(applicationName))
  add(query_568471, "api-version", newJString(apiVersion))
  result = call_568469.call(path_568470, query_568471, nil, nil, body_568472)

var serviceGroupsCreate* = Call_ServiceGroupsCreate_568461(
    name: "serviceGroupsCreate", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/GetServices/$/CreateServiceGroup",
    validator: validate_ServiceGroupsCreate_568462, base: "",
    url: url_ServiceGroupsCreate_568463, schemes: {Scheme.Https})
type
  Call_ServicesGet_568473 = ref object of OpenApiRestCall_567650
proc url_ServicesGet_568475(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesGet_568474(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568476 = path.getOrDefault("applicationName")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "applicationName", valid_568476
  var valid_568477 = path.getOrDefault("serviceName")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "serviceName", valid_568477
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568478 = query.getOrDefault("timeout")
  valid_568478 = validateParameter(valid_568478, JInt, required = false, default = nil)
  if valid_568478 != nil:
    section.add "timeout", valid_568478
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568479 = query.getOrDefault("api-version")
  valid_568479 = validateParameter(valid_568479, JString, required = true,
                                 default = nil)
  if valid_568479 != nil:
    section.add "api-version", valid_568479
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568480: Call_ServicesGet_568473; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get services
  ## 
  let valid = call_568480.validator(path, query, header, formData, body)
  let scheme = call_568480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568480.url(scheme.get, call_568480.host, call_568480.base,
                         call_568480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568480, url, valid)

proc call*(call_568481: Call_ServicesGet_568473; applicationName: string;
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
  var path_568482 = newJObject()
  var query_568483 = newJObject()
  add(query_568483, "timeout", newJInt(timeout))
  add(path_568482, "applicationName", newJString(applicationName))
  add(query_568483, "api-version", newJString(apiVersion))
  add(path_568482, "serviceName", newJString(serviceName))
  result = call_568481.call(path_568482, query_568483, nil, nil, nil)

var servicesGet* = Call_ServicesGet_568473(name: "servicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local:19080", route: "/Applications/{applicationName}/$/GetServices/{serviceName}",
                                        validator: validate_ServicesGet_568474,
                                        base: "", url: url_ServicesGet_568475,
                                        schemes: {Scheme.Https})
type
  Call_ServiceGroupDescriptionsGet_568484 = ref object of OpenApiRestCall_567650
proc url_ServiceGroupDescriptionsGet_568486(protocol: Scheme; host: string;
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

proc validate_ServiceGroupDescriptionsGet_568485(path: JsonNode; query: JsonNode;
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
  var valid_568487 = path.getOrDefault("applicationName")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "applicationName", valid_568487
  var valid_568488 = path.getOrDefault("serviceName")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "serviceName", valid_568488
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568489 = query.getOrDefault("timeout")
  valid_568489 = validateParameter(valid_568489, JInt, required = false, default = nil)
  if valid_568489 != nil:
    section.add "timeout", valid_568489
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568490 = query.getOrDefault("api-version")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "api-version", valid_568490
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568491: Call_ServiceGroupDescriptionsGet_568484; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service group descriptions
  ## 
  let valid = call_568491.validator(path, query, header, formData, body)
  let scheme = call_568491.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568491.url(scheme.get, call_568491.host, call_568491.base,
                         call_568491.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568491, url, valid)

proc call*(call_568492: Call_ServiceGroupDescriptionsGet_568484;
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
  var path_568493 = newJObject()
  var query_568494 = newJObject()
  add(query_568494, "timeout", newJInt(timeout))
  add(path_568493, "applicationName", newJString(applicationName))
  add(query_568494, "api-version", newJString(apiVersion))
  add(path_568493, "serviceName", newJString(serviceName))
  result = call_568492.call(path_568493, query_568494, nil, nil, nil)

var serviceGroupDescriptionsGet* = Call_ServiceGroupDescriptionsGet_568484(
    name: "serviceGroupDescriptionsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/GetServices/{serviceName}/$/GetServiceGroupDescription",
    validator: validate_ServiceGroupDescriptionsGet_568485, base: "",
    url: url_ServiceGroupDescriptionsGet_568486, schemes: {Scheme.Https})
type
  Call_ServiceGroupMembersGet_568495 = ref object of OpenApiRestCall_567650
proc url_ServiceGroupMembersGet_568497(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceGroupMembersGet_568496(path: JsonNode; query: JsonNode;
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
  var valid_568498 = path.getOrDefault("applicationName")
  valid_568498 = validateParameter(valid_568498, JString, required = true,
                                 default = nil)
  if valid_568498 != nil:
    section.add "applicationName", valid_568498
  var valid_568499 = path.getOrDefault("serviceName")
  valid_568499 = validateParameter(valid_568499, JString, required = true,
                                 default = nil)
  if valid_568499 != nil:
    section.add "serviceName", valid_568499
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568500 = query.getOrDefault("timeout")
  valid_568500 = validateParameter(valid_568500, JInt, required = false, default = nil)
  if valid_568500 != nil:
    section.add "timeout", valid_568500
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568501 = query.getOrDefault("api-version")
  valid_568501 = validateParameter(valid_568501, JString, required = true,
                                 default = nil)
  if valid_568501 != nil:
    section.add "api-version", valid_568501
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568502: Call_ServiceGroupMembersGet_568495; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service group members
  ## 
  let valid = call_568502.validator(path, query, header, formData, body)
  let scheme = call_568502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568502.url(scheme.get, call_568502.host, call_568502.base,
                         call_568502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568502, url, valid)

proc call*(call_568503: Call_ServiceGroupMembersGet_568495;
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
  var path_568504 = newJObject()
  var query_568505 = newJObject()
  add(query_568505, "timeout", newJInt(timeout))
  add(path_568504, "applicationName", newJString(applicationName))
  add(query_568505, "api-version", newJString(apiVersion))
  add(path_568504, "serviceName", newJString(serviceName))
  result = call_568503.call(path_568504, query_568505, nil, nil, nil)

var serviceGroupMembersGet* = Call_ServiceGroupMembersGet_568495(
    name: "serviceGroupMembersGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/GetServices/{serviceName}/$/GetServiceGroupMembers",
    validator: validate_ServiceGroupMembersGet_568496, base: "",
    url: url_ServiceGroupMembersGet_568497, schemes: {Scheme.Https})
type
  Call_ServiceGroupsUpdate_568506 = ref object of OpenApiRestCall_567650
proc url_ServiceGroupsUpdate_568508(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceGroupsUpdate_568507(path: JsonNode; query: JsonNode;
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
  var valid_568509 = path.getOrDefault("applicationName")
  valid_568509 = validateParameter(valid_568509, JString, required = true,
                                 default = nil)
  if valid_568509 != nil:
    section.add "applicationName", valid_568509
  var valid_568510 = path.getOrDefault("serviceName")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "serviceName", valid_568510
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568511 = query.getOrDefault("timeout")
  valid_568511 = validateParameter(valid_568511, JInt, required = false, default = nil)
  if valid_568511 != nil:
    section.add "timeout", valid_568511
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568512 = query.getOrDefault("api-version")
  valid_568512 = validateParameter(valid_568512, JString, required = true,
                                 default = nil)
  if valid_568512 != nil:
    section.add "api-version", valid_568512
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

proc call*(call_568514: Call_ServiceGroupsUpdate_568506; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update service groups
  ## 
  let valid = call_568514.validator(path, query, header, formData, body)
  let scheme = call_568514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568514.url(scheme.get, call_568514.host, call_568514.base,
                         call_568514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568514, url, valid)

proc call*(call_568515: Call_ServiceGroupsUpdate_568506; applicationName: string;
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
  var path_568516 = newJObject()
  var query_568517 = newJObject()
  var body_568518 = newJObject()
  add(query_568517, "timeout", newJInt(timeout))
  add(path_568516, "applicationName", newJString(applicationName))
  add(query_568517, "api-version", newJString(apiVersion))
  add(path_568516, "serviceName", newJString(serviceName))
  if updateServiceGroupDescription != nil:
    body_568518 = updateServiceGroupDescription
  result = call_568515.call(path_568516, query_568517, nil, nil, body_568518)

var serviceGroupsUpdate* = Call_ServiceGroupsUpdate_568506(
    name: "serviceGroupsUpdate", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/GetServices/{serviceName}/$/UpdateServiceGroup",
    validator: validate_ServiceGroupsUpdate_568507, base: "",
    url: url_ServiceGroupsUpdate_568508, schemes: {Scheme.Https})
type
  Call_ApplicationUpgradesGet_568519 = ref object of OpenApiRestCall_567650
proc url_ApplicationUpgradesGet_568521(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationUpgradesGet_568520(path: JsonNode; query: JsonNode;
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
  var valid_568522 = path.getOrDefault("applicationName")
  valid_568522 = validateParameter(valid_568522, JString, required = true,
                                 default = nil)
  if valid_568522 != nil:
    section.add "applicationName", valid_568522
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568523 = query.getOrDefault("timeout")
  valid_568523 = validateParameter(valid_568523, JInt, required = false, default = nil)
  if valid_568523 != nil:
    section.add "timeout", valid_568523
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568524 = query.getOrDefault("api-version")
  valid_568524 = validateParameter(valid_568524, JString, required = true,
                                 default = nil)
  if valid_568524 != nil:
    section.add "api-version", valid_568524
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568525: Call_ApplicationUpgradesGet_568519; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get application upgrades
  ## 
  let valid = call_568525.validator(path, query, header, formData, body)
  let scheme = call_568525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568525.url(scheme.get, call_568525.host, call_568525.base,
                         call_568525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568525, url, valid)

proc call*(call_568526: Call_ApplicationUpgradesGet_568519;
          applicationName: string; apiVersion: string; timeout: int = 0): Recallable =
  ## applicationUpgradesGet
  ## Get application upgrades
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  var path_568527 = newJObject()
  var query_568528 = newJObject()
  add(query_568528, "timeout", newJInt(timeout))
  add(path_568527, "applicationName", newJString(applicationName))
  add(query_568528, "api-version", newJString(apiVersion))
  result = call_568526.call(path_568527, query_568528, nil, nil, nil)

var applicationUpgradesGet* = Call_ApplicationUpgradesGet_568519(
    name: "applicationUpgradesGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Applications/{applicationName}/$/GetUpgradeProgress",
    validator: validate_ApplicationUpgradesGet_568520, base: "",
    url: url_ApplicationUpgradesGet_568521, schemes: {Scheme.Https})
type
  Call_ApplicationUpgradesResume_568529 = ref object of OpenApiRestCall_567650
proc url_ApplicationUpgradesResume_568531(protocol: Scheme; host: string;
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

proc validate_ApplicationUpgradesResume_568530(path: JsonNode; query: JsonNode;
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
  var valid_568532 = path.getOrDefault("applicationName")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "applicationName", valid_568532
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568533 = query.getOrDefault("timeout")
  valid_568533 = validateParameter(valid_568533, JInt, required = false, default = nil)
  if valid_568533 != nil:
    section.add "timeout", valid_568533
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568534 = query.getOrDefault("api-version")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "api-version", valid_568534
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

proc call*(call_568536: Call_ApplicationUpgradesResume_568529; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resume application upgrades
  ## 
  let valid = call_568536.validator(path, query, header, formData, body)
  let scheme = call_568536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568536.url(scheme.get, call_568536.host, call_568536.base,
                         call_568536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568536, url, valid)

proc call*(call_568537: Call_ApplicationUpgradesResume_568529;
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
  var path_568538 = newJObject()
  var query_568539 = newJObject()
  var body_568540 = newJObject()
  add(query_568539, "timeout", newJInt(timeout))
  if resumeApplicationUpgrade != nil:
    body_568540 = resumeApplicationUpgrade
  add(path_568538, "applicationName", newJString(applicationName))
  add(query_568539, "api-version", newJString(apiVersion))
  result = call_568537.call(path_568538, query_568539, nil, nil, body_568540)

var applicationUpgradesResume* = Call_ApplicationUpgradesResume_568529(
    name: "applicationUpgradesResume", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationName}/$/MoveNextUpgradeDomain",
    validator: validate_ApplicationUpgradesResume_568530, base: "",
    url: url_ApplicationUpgradesResume_568531, schemes: {Scheme.Https})
type
  Call_ApplicationHealthsSend_568541 = ref object of OpenApiRestCall_567650
proc url_ApplicationHealthsSend_568543(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationHealthsSend_568542(path: JsonNode; query: JsonNode;
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
  var valid_568544 = path.getOrDefault("applicationName")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "applicationName", valid_568544
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568545 = query.getOrDefault("timeout")
  valid_568545 = validateParameter(valid_568545, JInt, required = false, default = nil)
  if valid_568545 != nil:
    section.add "timeout", valid_568545
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568546 = query.getOrDefault("api-version")
  valid_568546 = validateParameter(valid_568546, JString, required = true,
                                 default = nil)
  if valid_568546 != nil:
    section.add "api-version", valid_568546
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

proc call*(call_568548: Call_ApplicationHealthsSend_568541; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send application health
  ## 
  let valid = call_568548.validator(path, query, header, formData, body)
  let scheme = call_568548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568548.url(scheme.get, call_568548.host, call_568548.base,
                         call_568548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568548, url, valid)

proc call*(call_568549: Call_ApplicationHealthsSend_568541;
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
  var path_568550 = newJObject()
  var query_568551 = newJObject()
  var body_568552 = newJObject()
  add(query_568551, "timeout", newJInt(timeout))
  add(path_568550, "applicationName", newJString(applicationName))
  add(query_568551, "api-version", newJString(apiVersion))
  if applicationHealthReport != nil:
    body_568552 = applicationHealthReport
  result = call_568549.call(path_568550, query_568551, nil, nil, body_568552)

var applicationHealthsSend* = Call_ApplicationHealthsSend_568541(
    name: "applicationHealthsSend", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationName}/$/ReportHealth",
    validator: validate_ApplicationHealthsSend_568542, base: "",
    url: url_ApplicationHealthsSend_568543, schemes: {Scheme.Https})
type
  Call_ApplicationUpgradeRollbacksStart_568553 = ref object of OpenApiRestCall_567650
proc url_ApplicationUpgradeRollbacksStart_568555(protocol: Scheme; host: string;
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

proc validate_ApplicationUpgradeRollbacksStart_568554(path: JsonNode;
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
  var valid_568556 = path.getOrDefault("applicationName")
  valid_568556 = validateParameter(valid_568556, JString, required = true,
                                 default = nil)
  if valid_568556 != nil:
    section.add "applicationName", valid_568556
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568557 = query.getOrDefault("timeout")
  valid_568557 = validateParameter(valid_568557, JInt, required = false, default = nil)
  if valid_568557 != nil:
    section.add "timeout", valid_568557
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568558 = query.getOrDefault("api-version")
  valid_568558 = validateParameter(valid_568558, JString, required = true,
                                 default = nil)
  if valid_568558 != nil:
    section.add "api-version", valid_568558
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568559: Call_ApplicationUpgradeRollbacksStart_568553;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Start application upgrade rollbacks
  ## 
  let valid = call_568559.validator(path, query, header, formData, body)
  let scheme = call_568559.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568559.url(scheme.get, call_568559.host, call_568559.base,
                         call_568559.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568559, url, valid)

proc call*(call_568560: Call_ApplicationUpgradeRollbacksStart_568553;
          applicationName: string; apiVersion: string; timeout: int = 0): Recallable =
  ## applicationUpgradeRollbacksStart
  ## Start application upgrade rollbacks
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   apiVersion: string (required)
  ##             : The version of the api
  var path_568561 = newJObject()
  var query_568562 = newJObject()
  add(query_568562, "timeout", newJInt(timeout))
  add(path_568561, "applicationName", newJString(applicationName))
  add(query_568562, "api-version", newJString(apiVersion))
  result = call_568560.call(path_568561, query_568562, nil, nil, nil)

var applicationUpgradeRollbacksStart* = Call_ApplicationUpgradeRollbacksStart_568553(
    name: "applicationUpgradeRollbacksStart", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationName}/$/RollbackUpgrade",
    validator: validate_ApplicationUpgradeRollbacksStart_568554, base: "",
    url: url_ApplicationUpgradeRollbacksStart_568555, schemes: {Scheme.Https})
type
  Call_ApplicationUpgradesUpdate_568563 = ref object of OpenApiRestCall_567650
proc url_ApplicationUpgradesUpdate_568565(protocol: Scheme; host: string;
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

proc validate_ApplicationUpgradesUpdate_568564(path: JsonNode; query: JsonNode;
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
  var valid_568566 = path.getOrDefault("applicationName")
  valid_568566 = validateParameter(valid_568566, JString, required = true,
                                 default = nil)
  if valid_568566 != nil:
    section.add "applicationName", valid_568566
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568567 = query.getOrDefault("timeout")
  valid_568567 = validateParameter(valid_568567, JInt, required = false, default = nil)
  if valid_568567 != nil:
    section.add "timeout", valid_568567
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568568 = query.getOrDefault("api-version")
  valid_568568 = validateParameter(valid_568568, JString, required = true,
                                 default = nil)
  if valid_568568 != nil:
    section.add "api-version", valid_568568
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

proc call*(call_568570: Call_ApplicationUpgradesUpdate_568563; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update application upgrades
  ## 
  let valid = call_568570.validator(path, query, header, formData, body)
  let scheme = call_568570.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568570.url(scheme.get, call_568570.host, call_568570.base,
                         call_568570.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568570, url, valid)

proc call*(call_568571: Call_ApplicationUpgradesUpdate_568563;
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
  var path_568572 = newJObject()
  var query_568573 = newJObject()
  var body_568574 = newJObject()
  add(query_568573, "timeout", newJInt(timeout))
  add(path_568572, "applicationName", newJString(applicationName))
  add(query_568573, "api-version", newJString(apiVersion))
  if updateApplicationUpgrade != nil:
    body_568574 = updateApplicationUpgrade
  result = call_568571.call(path_568572, query_568573, nil, nil, body_568574)

var applicationUpgradesUpdate* = Call_ApplicationUpgradesUpdate_568563(
    name: "applicationUpgradesUpdate", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationName}/$/UpdateUpgrade",
    validator: validate_ApplicationUpgradesUpdate_568564, base: "",
    url: url_ApplicationUpgradesUpdate_568565, schemes: {Scheme.Https})
type
  Call_ApplicationUpgradesStart_568575 = ref object of OpenApiRestCall_567650
proc url_ApplicationUpgradesStart_568577(protocol: Scheme; host: string;
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

proc validate_ApplicationUpgradesStart_568576(path: JsonNode; query: JsonNode;
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
  var valid_568578 = path.getOrDefault("applicationName")
  valid_568578 = validateParameter(valid_568578, JString, required = true,
                                 default = nil)
  if valid_568578 != nil:
    section.add "applicationName", valid_568578
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568579 = query.getOrDefault("timeout")
  valid_568579 = validateParameter(valid_568579, JInt, required = false, default = nil)
  if valid_568579 != nil:
    section.add "timeout", valid_568579
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568580 = query.getOrDefault("api-version")
  valid_568580 = validateParameter(valid_568580, JString, required = true,
                                 default = nil)
  if valid_568580 != nil:
    section.add "api-version", valid_568580
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

proc call*(call_568582: Call_ApplicationUpgradesStart_568575; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Start application upgrades
  ## 
  let valid = call_568582.validator(path, query, header, formData, body)
  let scheme = call_568582.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568582.url(scheme.get, call_568582.host, call_568582.base,
                         call_568582.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568582, url, valid)

proc call*(call_568583: Call_ApplicationUpgradesStart_568575;
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
  var path_568584 = newJObject()
  var query_568585 = newJObject()
  var body_568586 = newJObject()
  add(query_568585, "timeout", newJInt(timeout))
  add(path_568584, "applicationName", newJString(applicationName))
  add(query_568585, "api-version", newJString(apiVersion))
  if startApplicationUpgrade != nil:
    body_568586 = startApplicationUpgrade
  result = call_568583.call(path_568584, query_568585, nil, nil, body_568586)

var applicationUpgradesStart* = Call_ApplicationUpgradesStart_568575(
    name: "applicationUpgradesStart", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/Upgrade",
    validator: validate_ApplicationUpgradesStart_568576, base: "",
    url: url_ApplicationUpgradesStart_568577, schemes: {Scheme.Https})
type
  Call_NodesList_568587 = ref object of OpenApiRestCall_567650
proc url_NodesList_568589(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_NodesList_568588(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568590 = query.getOrDefault("timeout")
  valid_568590 = validateParameter(valid_568590, JInt, required = false, default = nil)
  if valid_568590 != nil:
    section.add "timeout", valid_568590
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568591 = query.getOrDefault("api-version")
  valid_568591 = validateParameter(valid_568591, JString, required = true,
                                 default = nil)
  if valid_568591 != nil:
    section.add "api-version", valid_568591
  var valid_568592 = query.getOrDefault("continuation-token")
  valid_568592 = validateParameter(valid_568592, JString, required = false,
                                 default = nil)
  if valid_568592 != nil:
    section.add "continuation-token", valid_568592
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568593: Call_NodesList_568587; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List nodes
  ## 
  let valid = call_568593.validator(path, query, header, formData, body)
  let scheme = call_568593.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568593.url(scheme.get, call_568593.host, call_568593.base,
                         call_568593.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568593, url, valid)

proc call*(call_568594: Call_NodesList_568587; apiVersion: string; timeout: int = 0;
          continuationToken: string = ""): Recallable =
  ## nodesList
  ## List nodes
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   continuationToken: string
  ##                    : The token of the continuation
  var query_568595 = newJObject()
  add(query_568595, "timeout", newJInt(timeout))
  add(query_568595, "api-version", newJString(apiVersion))
  add(query_568595, "continuation-token", newJString(continuationToken))
  result = call_568594.call(nil, query_568595, nil, nil, nil)

var nodesList* = Call_NodesList_568587(name: "nodesList", meth: HttpMethod.HttpGet,
                                    host: "azure.local:19080", route: "/Nodes",
                                    validator: validate_NodesList_568588,
                                    base: "", url: url_NodesList_568589,
                                    schemes: {Scheme.Https})
type
  Call_NodesGet_568596 = ref object of OpenApiRestCall_567650
proc url_NodesGet_568598(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_NodesGet_568597(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568599 = path.getOrDefault("nodeName")
  valid_568599 = validateParameter(valid_568599, JString, required = true,
                                 default = nil)
  if valid_568599 != nil:
    section.add "nodeName", valid_568599
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568600 = query.getOrDefault("timeout")
  valid_568600 = validateParameter(valid_568600, JInt, required = false, default = nil)
  if valid_568600 != nil:
    section.add "timeout", valid_568600
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568601 = query.getOrDefault("api-version")
  valid_568601 = validateParameter(valid_568601, JString, required = true,
                                 default = nil)
  if valid_568601 != nil:
    section.add "api-version", valid_568601
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568602: Call_NodesGet_568596; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get nodes
  ## 
  let valid = call_568602.validator(path, query, header, formData, body)
  let scheme = call_568602.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568602.url(scheme.get, call_568602.host, call_568602.base,
                         call_568602.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568602, url, valid)

proc call*(call_568603: Call_NodesGet_568596; apiVersion: string; nodeName: string;
          timeout: int = 0): Recallable =
  ## nodesGet
  ## Get nodes
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_568604 = newJObject()
  var query_568605 = newJObject()
  add(query_568605, "timeout", newJInt(timeout))
  add(query_568605, "api-version", newJString(apiVersion))
  add(path_568604, "nodeName", newJString(nodeName))
  result = call_568603.call(path_568604, query_568605, nil, nil, nil)

var nodesGet* = Call_NodesGet_568596(name: "nodesGet", meth: HttpMethod.HttpGet,
                                  host: "azure.local:19080",
                                  route: "/Nodes/{nodeName}",
                                  validator: validate_NodesGet_568597, base: "",
                                  url: url_NodesGet_568598,
                                  schemes: {Scheme.Https})
type
  Call_NodesEnable_568606 = ref object of OpenApiRestCall_567650
proc url_NodesEnable_568608(protocol: Scheme; host: string; base: string;
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

proc validate_NodesEnable_568607(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568609 = path.getOrDefault("nodeName")
  valid_568609 = validateParameter(valid_568609, JString, required = true,
                                 default = nil)
  if valid_568609 != nil:
    section.add "nodeName", valid_568609
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568610 = query.getOrDefault("timeout")
  valid_568610 = validateParameter(valid_568610, JInt, required = false, default = nil)
  if valid_568610 != nil:
    section.add "timeout", valid_568610
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568611 = query.getOrDefault("api-version")
  valid_568611 = validateParameter(valid_568611, JString, required = true,
                                 default = nil)
  if valid_568611 != nil:
    section.add "api-version", valid_568611
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568612: Call_NodesEnable_568606; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enable nodes
  ## 
  let valid = call_568612.validator(path, query, header, formData, body)
  let scheme = call_568612.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568612.url(scheme.get, call_568612.host, call_568612.base,
                         call_568612.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568612, url, valid)

proc call*(call_568613: Call_NodesEnable_568606; apiVersion: string;
          nodeName: string; timeout: int = 0): Recallable =
  ## nodesEnable
  ## Enable nodes
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_568614 = newJObject()
  var query_568615 = newJObject()
  add(query_568615, "timeout", newJInt(timeout))
  add(query_568615, "api-version", newJString(apiVersion))
  add(path_568614, "nodeName", newJString(nodeName))
  result = call_568613.call(path_568614, query_568615, nil, nil, nil)

var nodesEnable* = Call_NodesEnable_568606(name: "nodesEnable",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local:19080",
                                        route: "/Nodes/{nodeName}/$/Activate",
                                        validator: validate_NodesEnable_568607,
                                        base: "", url: url_NodesEnable_568608,
                                        schemes: {Scheme.Https})
type
  Call_NodesDisable_568616 = ref object of OpenApiRestCall_567650
proc url_NodesDisable_568618(protocol: Scheme; host: string; base: string;
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

proc validate_NodesDisable_568617(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568619 = path.getOrDefault("nodeName")
  valid_568619 = validateParameter(valid_568619, JString, required = true,
                                 default = nil)
  if valid_568619 != nil:
    section.add "nodeName", valid_568619
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568620 = query.getOrDefault("timeout")
  valid_568620 = validateParameter(valid_568620, JInt, required = false, default = nil)
  if valid_568620 != nil:
    section.add "timeout", valid_568620
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568621 = query.getOrDefault("api-version")
  valid_568621 = validateParameter(valid_568621, JString, required = true,
                                 default = nil)
  if valid_568621 != nil:
    section.add "api-version", valid_568621
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

proc call*(call_568623: Call_NodesDisable_568616; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Disable nodes
  ## 
  let valid = call_568623.validator(path, query, header, formData, body)
  let scheme = call_568623.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568623.url(scheme.get, call_568623.host, call_568623.base,
                         call_568623.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568623, url, valid)

proc call*(call_568624: Call_NodesDisable_568616; apiVersion: string;
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
  var path_568625 = newJObject()
  var query_568626 = newJObject()
  var body_568627 = newJObject()
  add(query_568626, "timeout", newJInt(timeout))
  add(query_568626, "api-version", newJString(apiVersion))
  add(path_568625, "nodeName", newJString(nodeName))
  if disableNode != nil:
    body_568627 = disableNode
  result = call_568624.call(path_568625, query_568626, nil, nil, body_568627)

var nodesDisable* = Call_NodesDisable_568616(name: "nodesDisable",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/Deactivate", validator: validate_NodesDisable_568617,
    base: "", url: url_NodesDisable_568618, schemes: {Scheme.Https})
type
  Call_DeployedApplicationsList_568628 = ref object of OpenApiRestCall_567650
proc url_DeployedApplicationsList_568630(protocol: Scheme; host: string;
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

proc validate_DeployedApplicationsList_568629(path: JsonNode; query: JsonNode;
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
  var valid_568631 = path.getOrDefault("nodeName")
  valid_568631 = validateParameter(valid_568631, JString, required = true,
                                 default = nil)
  if valid_568631 != nil:
    section.add "nodeName", valid_568631
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568632 = query.getOrDefault("timeout")
  valid_568632 = validateParameter(valid_568632, JInt, required = false, default = nil)
  if valid_568632 != nil:
    section.add "timeout", valid_568632
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568633 = query.getOrDefault("api-version")
  valid_568633 = validateParameter(valid_568633, JString, required = true,
                                 default = nil)
  if valid_568633 != nil:
    section.add "api-version", valid_568633
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568634: Call_DeployedApplicationsList_568628; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List deployed applications
  ## 
  let valid = call_568634.validator(path, query, header, formData, body)
  let scheme = call_568634.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568634.url(scheme.get, call_568634.host, call_568634.base,
                         call_568634.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568634, url, valid)

proc call*(call_568635: Call_DeployedApplicationsList_568628; apiVersion: string;
          nodeName: string; timeout: int = 0): Recallable =
  ## deployedApplicationsList
  ## List deployed applications
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_568636 = newJObject()
  var query_568637 = newJObject()
  add(query_568637, "timeout", newJInt(timeout))
  add(query_568637, "api-version", newJString(apiVersion))
  add(path_568636, "nodeName", newJString(nodeName))
  result = call_568635.call(path_568636, query_568637, nil, nil, nil)

var deployedApplicationsList* = Call_DeployedApplicationsList_568628(
    name: "deployedApplicationsList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications",
    validator: validate_DeployedApplicationsList_568629, base: "",
    url: url_DeployedApplicationsList_568630, schemes: {Scheme.Https})
type
  Call_DeployedApplicationsGet_568638 = ref object of OpenApiRestCall_567650
proc url_DeployedApplicationsGet_568640(protocol: Scheme; host: string; base: string;
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

proc validate_DeployedApplicationsGet_568639(path: JsonNode; query: JsonNode;
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
  var valid_568641 = path.getOrDefault("applicationName")
  valid_568641 = validateParameter(valid_568641, JString, required = true,
                                 default = nil)
  if valid_568641 != nil:
    section.add "applicationName", valid_568641
  var valid_568642 = path.getOrDefault("nodeName")
  valid_568642 = validateParameter(valid_568642, JString, required = true,
                                 default = nil)
  if valid_568642 != nil:
    section.add "nodeName", valid_568642
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568643 = query.getOrDefault("timeout")
  valid_568643 = validateParameter(valid_568643, JInt, required = false, default = nil)
  if valid_568643 != nil:
    section.add "timeout", valid_568643
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568644 = query.getOrDefault("api-version")
  valid_568644 = validateParameter(valid_568644, JString, required = true,
                                 default = nil)
  if valid_568644 != nil:
    section.add "api-version", valid_568644
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568645: Call_DeployedApplicationsGet_568638; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get deployed applications
  ## 
  let valid = call_568645.validator(path, query, header, formData, body)
  let scheme = call_568645.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568645.url(scheme.get, call_568645.host, call_568645.base,
                         call_568645.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568645, url, valid)

proc call*(call_568646: Call_DeployedApplicationsGet_568638;
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
  var path_568647 = newJObject()
  var query_568648 = newJObject()
  add(query_568648, "timeout", newJInt(timeout))
  add(path_568647, "applicationName", newJString(applicationName))
  add(query_568648, "api-version", newJString(apiVersion))
  add(path_568647, "nodeName", newJString(nodeName))
  result = call_568646.call(path_568647, query_568648, nil, nil, nil)

var deployedApplicationsGet* = Call_DeployedApplicationsGet_568638(
    name: "deployedApplicationsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}",
    validator: validate_DeployedApplicationsGet_568639, base: "",
    url: url_DeployedApplicationsGet_568640, schemes: {Scheme.Https})
type
  Call_DeployedCodePackagesGet_568649 = ref object of OpenApiRestCall_567650
proc url_DeployedCodePackagesGet_568651(protocol: Scheme; host: string; base: string;
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

proc validate_DeployedCodePackagesGet_568650(path: JsonNode; query: JsonNode;
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
  var valid_568652 = path.getOrDefault("applicationName")
  valid_568652 = validateParameter(valid_568652, JString, required = true,
                                 default = nil)
  if valid_568652 != nil:
    section.add "applicationName", valid_568652
  var valid_568653 = path.getOrDefault("nodeName")
  valid_568653 = validateParameter(valid_568653, JString, required = true,
                                 default = nil)
  if valid_568653 != nil:
    section.add "nodeName", valid_568653
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568654 = query.getOrDefault("timeout")
  valid_568654 = validateParameter(valid_568654, JInt, required = false, default = nil)
  if valid_568654 != nil:
    section.add "timeout", valid_568654
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568655 = query.getOrDefault("api-version")
  valid_568655 = validateParameter(valid_568655, JString, required = true,
                                 default = nil)
  if valid_568655 != nil:
    section.add "api-version", valid_568655
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568656: Call_DeployedCodePackagesGet_568649; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get deployed code packages
  ## 
  let valid = call_568656.validator(path, query, header, formData, body)
  let scheme = call_568656.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568656.url(scheme.get, call_568656.host, call_568656.base,
                         call_568656.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568656, url, valid)

proc call*(call_568657: Call_DeployedCodePackagesGet_568649;
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
  var path_568658 = newJObject()
  var query_568659 = newJObject()
  add(query_568659, "timeout", newJInt(timeout))
  add(path_568658, "applicationName", newJString(applicationName))
  add(query_568659, "api-version", newJString(apiVersion))
  add(path_568658, "nodeName", newJString(nodeName))
  result = call_568657.call(path_568658, query_568659, nil, nil, nil)

var deployedCodePackagesGet* = Call_DeployedCodePackagesGet_568649(
    name: "deployedCodePackagesGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}/$/GetCodePackages",
    validator: validate_DeployedCodePackagesGet_568650, base: "",
    url: url_DeployedCodePackagesGet_568651, schemes: {Scheme.Https})
type
  Call_DeployedApplicationHealthsGet_568660 = ref object of OpenApiRestCall_567650
proc url_DeployedApplicationHealthsGet_568662(protocol: Scheme; host: string;
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

proc validate_DeployedApplicationHealthsGet_568661(path: JsonNode; query: JsonNode;
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
  var valid_568663 = path.getOrDefault("applicationName")
  valid_568663 = validateParameter(valid_568663, JString, required = true,
                                 default = nil)
  if valid_568663 != nil:
    section.add "applicationName", valid_568663
  var valid_568664 = path.getOrDefault("nodeName")
  valid_568664 = validateParameter(valid_568664, JString, required = true,
                                 default = nil)
  if valid_568664 != nil:
    section.add "nodeName", valid_568664
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
  var valid_568665 = query.getOrDefault("timeout")
  valid_568665 = validateParameter(valid_568665, JInt, required = false, default = nil)
  if valid_568665 != nil:
    section.add "timeout", valid_568665
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568666 = query.getOrDefault("api-version")
  valid_568666 = validateParameter(valid_568666, JString, required = true,
                                 default = nil)
  if valid_568666 != nil:
    section.add "api-version", valid_568666
  var valid_568667 = query.getOrDefault("DeployedServicePackagesHealthStateFilter")
  valid_568667 = validateParameter(valid_568667, JString, required = false,
                                 default = nil)
  if valid_568667 != nil:
    section.add "DeployedServicePackagesHealthStateFilter", valid_568667
  var valid_568668 = query.getOrDefault("EventsHealthStateFilter")
  valid_568668 = validateParameter(valid_568668, JString, required = false,
                                 default = nil)
  if valid_568668 != nil:
    section.add "EventsHealthStateFilter", valid_568668
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568669: Call_DeployedApplicationHealthsGet_568660; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get deployed application healths
  ## 
  let valid = call_568669.validator(path, query, header, formData, body)
  let scheme = call_568669.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568669.url(scheme.get, call_568669.host, call_568669.base,
                         call_568669.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568669, url, valid)

proc call*(call_568670: Call_DeployedApplicationHealthsGet_568660;
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
  var path_568671 = newJObject()
  var query_568672 = newJObject()
  add(query_568672, "timeout", newJInt(timeout))
  add(path_568671, "applicationName", newJString(applicationName))
  add(query_568672, "api-version", newJString(apiVersion))
  add(path_568671, "nodeName", newJString(nodeName))
  add(query_568672, "DeployedServicePackagesHealthStateFilter",
      newJString(DeployedServicePackagesHealthStateFilter))
  add(query_568672, "EventsHealthStateFilter", newJString(EventsHealthStateFilter))
  result = call_568670.call(path_568671, query_568672, nil, nil, nil)

var deployedApplicationHealthsGet* = Call_DeployedApplicationHealthsGet_568660(
    name: "deployedApplicationHealthsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}/$/GetHealth",
    validator: validate_DeployedApplicationHealthsGet_568661, base: "",
    url: url_DeployedApplicationHealthsGet_568662, schemes: {Scheme.Https})
type
  Call_DeployedReplicasGet_568673 = ref object of OpenApiRestCall_567650
proc url_DeployedReplicasGet_568675(protocol: Scheme; host: string; base: string;
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

proc validate_DeployedReplicasGet_568674(path: JsonNode; query: JsonNode;
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
  var valid_568676 = path.getOrDefault("applicationName")
  valid_568676 = validateParameter(valid_568676, JString, required = true,
                                 default = nil)
  if valid_568676 != nil:
    section.add "applicationName", valid_568676
  var valid_568677 = path.getOrDefault("nodeName")
  valid_568677 = validateParameter(valid_568677, JString, required = true,
                                 default = nil)
  if valid_568677 != nil:
    section.add "nodeName", valid_568677
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568678 = query.getOrDefault("timeout")
  valid_568678 = validateParameter(valid_568678, JInt, required = false, default = nil)
  if valid_568678 != nil:
    section.add "timeout", valid_568678
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568679 = query.getOrDefault("api-version")
  valid_568679 = validateParameter(valid_568679, JString, required = true,
                                 default = nil)
  if valid_568679 != nil:
    section.add "api-version", valid_568679
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568680: Call_DeployedReplicasGet_568673; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get deployed replicas
  ## 
  let valid = call_568680.validator(path, query, header, formData, body)
  let scheme = call_568680.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568680.url(scheme.get, call_568680.host, call_568680.base,
                         call_568680.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568680, url, valid)

proc call*(call_568681: Call_DeployedReplicasGet_568673; applicationName: string;
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
  var path_568682 = newJObject()
  var query_568683 = newJObject()
  add(query_568683, "timeout", newJInt(timeout))
  add(path_568682, "applicationName", newJString(applicationName))
  add(query_568683, "api-version", newJString(apiVersion))
  add(path_568682, "nodeName", newJString(nodeName))
  result = call_568681.call(path_568682, query_568683, nil, nil, nil)

var deployedReplicasGet* = Call_DeployedReplicasGet_568673(
    name: "deployedReplicasGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}/$/GetReplicas",
    validator: validate_DeployedReplicasGet_568674, base: "",
    url: url_DeployedReplicasGet_568675, schemes: {Scheme.Https})
type
  Call_DeployedServicePackagesGet_568684 = ref object of OpenApiRestCall_567650
proc url_DeployedServicePackagesGet_568686(protocol: Scheme; host: string;
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

proc validate_DeployedServicePackagesGet_568685(path: JsonNode; query: JsonNode;
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
  var valid_568687 = path.getOrDefault("applicationName")
  valid_568687 = validateParameter(valid_568687, JString, required = true,
                                 default = nil)
  if valid_568687 != nil:
    section.add "applicationName", valid_568687
  var valid_568688 = path.getOrDefault("nodeName")
  valid_568688 = validateParameter(valid_568688, JString, required = true,
                                 default = nil)
  if valid_568688 != nil:
    section.add "nodeName", valid_568688
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568689 = query.getOrDefault("timeout")
  valid_568689 = validateParameter(valid_568689, JInt, required = false, default = nil)
  if valid_568689 != nil:
    section.add "timeout", valid_568689
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568690 = query.getOrDefault("api-version")
  valid_568690 = validateParameter(valid_568690, JString, required = true,
                                 default = nil)
  if valid_568690 != nil:
    section.add "api-version", valid_568690
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568691: Call_DeployedServicePackagesGet_568684; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get deployed service packages
  ## 
  let valid = call_568691.validator(path, query, header, formData, body)
  let scheme = call_568691.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568691.url(scheme.get, call_568691.host, call_568691.base,
                         call_568691.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568691, url, valid)

proc call*(call_568692: Call_DeployedServicePackagesGet_568684;
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
  var path_568693 = newJObject()
  var query_568694 = newJObject()
  add(query_568694, "timeout", newJInt(timeout))
  add(path_568693, "applicationName", newJString(applicationName))
  add(query_568694, "api-version", newJString(apiVersion))
  add(path_568693, "nodeName", newJString(nodeName))
  result = call_568692.call(path_568693, query_568694, nil, nil, nil)

var deployedServicePackagesGet* = Call_DeployedServicePackagesGet_568684(
    name: "deployedServicePackagesGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}/$/GetServicePackages",
    validator: validate_DeployedServicePackagesGet_568685, base: "",
    url: url_DeployedServicePackagesGet_568686, schemes: {Scheme.Https})
type
  Call_DeployedServicePackageHealthsSend_568695 = ref object of OpenApiRestCall_567650
proc url_DeployedServicePackageHealthsSend_568697(protocol: Scheme; host: string;
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

proc validate_DeployedServicePackageHealthsSend_568696(path: JsonNode;
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
  var valid_568698 = path.getOrDefault("applicationName")
  valid_568698 = validateParameter(valid_568698, JString, required = true,
                                 default = nil)
  if valid_568698 != nil:
    section.add "applicationName", valid_568698
  var valid_568699 = path.getOrDefault("nodeName")
  valid_568699 = validateParameter(valid_568699, JString, required = true,
                                 default = nil)
  if valid_568699 != nil:
    section.add "nodeName", valid_568699
  var valid_568700 = path.getOrDefault("serviceManifestName")
  valid_568700 = validateParameter(valid_568700, JString, required = true,
                                 default = nil)
  if valid_568700 != nil:
    section.add "serviceManifestName", valid_568700
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568701 = query.getOrDefault("timeout")
  valid_568701 = validateParameter(valid_568701, JInt, required = false, default = nil)
  if valid_568701 != nil:
    section.add "timeout", valid_568701
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568702 = query.getOrDefault("api-version")
  valid_568702 = validateParameter(valid_568702, JString, required = true,
                                 default = nil)
  if valid_568702 != nil:
    section.add "api-version", valid_568702
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

proc call*(call_568704: Call_DeployedServicePackageHealthsSend_568695;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Send deployed service package health
  ## 
  let valid = call_568704.validator(path, query, header, formData, body)
  let scheme = call_568704.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568704.url(scheme.get, call_568704.host, call_568704.base,
                         call_568704.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568704, url, valid)

proc call*(call_568705: Call_DeployedServicePackageHealthsSend_568695;
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
  var path_568706 = newJObject()
  var query_568707 = newJObject()
  var body_568708 = newJObject()
  add(query_568707, "timeout", newJInt(timeout))
  add(path_568706, "applicationName", newJString(applicationName))
  add(query_568707, "api-version", newJString(apiVersion))
  add(path_568706, "nodeName", newJString(nodeName))
  add(path_568706, "serviceManifestName", newJString(serviceManifestName))
  if deployedServicePackageHealthReport != nil:
    body_568708 = deployedServicePackageHealthReport
  result = call_568705.call(path_568706, query_568707, nil, nil, body_568708)

var deployedServicePackageHealthsSend* = Call_DeployedServicePackageHealthsSend_568695(
    name: "deployedServicePackageHealthsSend", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}/$/GetServicePackages/{serviceManifestName}/$/ReportHealth",
    validator: validate_DeployedServicePackageHealthsSend_568696, base: "",
    url: url_DeployedServicePackageHealthsSend_568697, schemes: {Scheme.Https})
type
  Call_DeployedServicePackageHealthsGet_568709 = ref object of OpenApiRestCall_567650
proc url_DeployedServicePackageHealthsGet_568711(protocol: Scheme; host: string;
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

proc validate_DeployedServicePackageHealthsGet_568710(path: JsonNode;
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
  var valid_568712 = path.getOrDefault("applicationName")
  valid_568712 = validateParameter(valid_568712, JString, required = true,
                                 default = nil)
  if valid_568712 != nil:
    section.add "applicationName", valid_568712
  var valid_568713 = path.getOrDefault("nodeName")
  valid_568713 = validateParameter(valid_568713, JString, required = true,
                                 default = nil)
  if valid_568713 != nil:
    section.add "nodeName", valid_568713
  var valid_568714 = path.getOrDefault("servicePackageName")
  valid_568714 = validateParameter(valid_568714, JString, required = true,
                                 default = nil)
  if valid_568714 != nil:
    section.add "servicePackageName", valid_568714
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   EventsHealthStateFilter: JString
  ##                          : The filter of the events health state
  section = newJObject()
  var valid_568715 = query.getOrDefault("timeout")
  valid_568715 = validateParameter(valid_568715, JInt, required = false, default = nil)
  if valid_568715 != nil:
    section.add "timeout", valid_568715
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568716 = query.getOrDefault("api-version")
  valid_568716 = validateParameter(valid_568716, JString, required = true,
                                 default = nil)
  if valid_568716 != nil:
    section.add "api-version", valid_568716
  var valid_568717 = query.getOrDefault("EventsHealthStateFilter")
  valid_568717 = validateParameter(valid_568717, JString, required = false,
                                 default = nil)
  if valid_568717 != nil:
    section.add "EventsHealthStateFilter", valid_568717
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568718: Call_DeployedServicePackageHealthsGet_568709;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get deployed service package healths
  ## 
  let valid = call_568718.validator(path, query, header, formData, body)
  let scheme = call_568718.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568718.url(scheme.get, call_568718.host, call_568718.base,
                         call_568718.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568718, url, valid)

proc call*(call_568719: Call_DeployedServicePackageHealthsGet_568709;
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
  var path_568720 = newJObject()
  var query_568721 = newJObject()
  add(query_568721, "timeout", newJInt(timeout))
  add(path_568720, "applicationName", newJString(applicationName))
  add(query_568721, "api-version", newJString(apiVersion))
  add(path_568720, "nodeName", newJString(nodeName))
  add(query_568721, "EventsHealthStateFilter", newJString(EventsHealthStateFilter))
  add(path_568720, "servicePackageName", newJString(servicePackageName))
  result = call_568719.call(path_568720, query_568721, nil, nil, nil)

var deployedServicePackageHealthsGet* = Call_DeployedServicePackageHealthsGet_568709(
    name: "deployedServicePackageHealthsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}/$/GetServicePackages/{servicePackageName}/$/GetHealth",
    validator: validate_DeployedServicePackageHealthsGet_568710, base: "",
    url: url_DeployedServicePackageHealthsGet_568711, schemes: {Scheme.Https})
type
  Call_DeployedServiceTypesGet_568722 = ref object of OpenApiRestCall_567650
proc url_DeployedServiceTypesGet_568724(protocol: Scheme; host: string; base: string;
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

proc validate_DeployedServiceTypesGet_568723(path: JsonNode; query: JsonNode;
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
  var valid_568725 = path.getOrDefault("applicationName")
  valid_568725 = validateParameter(valid_568725, JString, required = true,
                                 default = nil)
  if valid_568725 != nil:
    section.add "applicationName", valid_568725
  var valid_568726 = path.getOrDefault("nodeName")
  valid_568726 = validateParameter(valid_568726, JString, required = true,
                                 default = nil)
  if valid_568726 != nil:
    section.add "nodeName", valid_568726
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568727 = query.getOrDefault("timeout")
  valid_568727 = validateParameter(valid_568727, JInt, required = false, default = nil)
  if valid_568727 != nil:
    section.add "timeout", valid_568727
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568728 = query.getOrDefault("api-version")
  valid_568728 = validateParameter(valid_568728, JString, required = true,
                                 default = nil)
  if valid_568728 != nil:
    section.add "api-version", valid_568728
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568729: Call_DeployedServiceTypesGet_568722; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get deployed service types
  ## 
  let valid = call_568729.validator(path, query, header, formData, body)
  let scheme = call_568729.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568729.url(scheme.get, call_568729.host, call_568729.base,
                         call_568729.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568729, url, valid)

proc call*(call_568730: Call_DeployedServiceTypesGet_568722;
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
  var path_568731 = newJObject()
  var query_568732 = newJObject()
  add(query_568732, "timeout", newJInt(timeout))
  add(path_568731, "applicationName", newJString(applicationName))
  add(query_568732, "api-version", newJString(apiVersion))
  add(path_568731, "nodeName", newJString(nodeName))
  result = call_568730.call(path_568731, query_568732, nil, nil, nil)

var deployedServiceTypesGet* = Call_DeployedServiceTypesGet_568722(
    name: "deployedServiceTypesGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}/$/GetServiceTypes",
    validator: validate_DeployedServiceTypesGet_568723, base: "",
    url: url_DeployedServiceTypesGet_568724, schemes: {Scheme.Https})
type
  Call_DeployedApplicationHealthsSend_568733 = ref object of OpenApiRestCall_567650
proc url_DeployedApplicationHealthsSend_568735(protocol: Scheme; host: string;
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

proc validate_DeployedApplicationHealthsSend_568734(path: JsonNode;
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
  var valid_568736 = path.getOrDefault("applicationName")
  valid_568736 = validateParameter(valid_568736, JString, required = true,
                                 default = nil)
  if valid_568736 != nil:
    section.add "applicationName", valid_568736
  var valid_568737 = path.getOrDefault("nodeName")
  valid_568737 = validateParameter(valid_568737, JString, required = true,
                                 default = nil)
  if valid_568737 != nil:
    section.add "nodeName", valid_568737
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568738 = query.getOrDefault("timeout")
  valid_568738 = validateParameter(valid_568738, JInt, required = false, default = nil)
  if valid_568738 != nil:
    section.add "timeout", valid_568738
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568739 = query.getOrDefault("api-version")
  valid_568739 = validateParameter(valid_568739, JString, required = true,
                                 default = nil)
  if valid_568739 != nil:
    section.add "api-version", valid_568739
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

proc call*(call_568741: Call_DeployedApplicationHealthsSend_568733; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send deployed application health
  ## 
  let valid = call_568741.validator(path, query, header, formData, body)
  let scheme = call_568741.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568741.url(scheme.get, call_568741.host, call_568741.base,
                         call_568741.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568741, url, valid)

proc call*(call_568742: Call_DeployedApplicationHealthsSend_568733;
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
  var path_568743 = newJObject()
  var query_568744 = newJObject()
  var body_568745 = newJObject()
  add(query_568744, "timeout", newJInt(timeout))
  add(path_568743, "applicationName", newJString(applicationName))
  add(query_568744, "api-version", newJString(apiVersion))
  add(path_568743, "nodeName", newJString(nodeName))
  if deployedApplicationHealthReport != nil:
    body_568745 = deployedApplicationHealthReport
  result = call_568742.call(path_568743, query_568744, nil, nil, body_568745)

var deployedApplicationHealthsSend* = Call_DeployedApplicationHealthsSend_568733(
    name: "deployedApplicationHealthsSend", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}/$/ReportHealth",
    validator: validate_DeployedApplicationHealthsSend_568734, base: "",
    url: url_DeployedApplicationHealthsSend_568735, schemes: {Scheme.Https})
type
  Call_NodeHealthsGet_568746 = ref object of OpenApiRestCall_567650
proc url_NodeHealthsGet_568748(protocol: Scheme; host: string; base: string;
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

proc validate_NodeHealthsGet_568747(path: JsonNode; query: JsonNode;
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
  var valid_568749 = path.getOrDefault("nodeName")
  valid_568749 = validateParameter(valid_568749, JString, required = true,
                                 default = nil)
  if valid_568749 != nil:
    section.add "nodeName", valid_568749
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   EventsHealthStateFilter: JString
  ##                          : The filter of the events health state
  section = newJObject()
  var valid_568750 = query.getOrDefault("timeout")
  valid_568750 = validateParameter(valid_568750, JInt, required = false, default = nil)
  if valid_568750 != nil:
    section.add "timeout", valid_568750
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568751 = query.getOrDefault("api-version")
  valid_568751 = validateParameter(valid_568751, JString, required = true,
                                 default = nil)
  if valid_568751 != nil:
    section.add "api-version", valid_568751
  var valid_568752 = query.getOrDefault("EventsHealthStateFilter")
  valid_568752 = validateParameter(valid_568752, JString, required = false,
                                 default = nil)
  if valid_568752 != nil:
    section.add "EventsHealthStateFilter", valid_568752
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568753: Call_NodeHealthsGet_568746; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get node healths
  ## 
  let valid = call_568753.validator(path, query, header, formData, body)
  let scheme = call_568753.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568753.url(scheme.get, call_568753.host, call_568753.base,
                         call_568753.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568753, url, valid)

proc call*(call_568754: Call_NodeHealthsGet_568746; apiVersion: string;
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
  var path_568755 = newJObject()
  var query_568756 = newJObject()
  add(query_568756, "timeout", newJInt(timeout))
  add(query_568756, "api-version", newJString(apiVersion))
  add(path_568755, "nodeName", newJString(nodeName))
  add(query_568756, "EventsHealthStateFilter", newJString(EventsHealthStateFilter))
  result = call_568754.call(path_568755, query_568756, nil, nil, nil)

var nodeHealthsGet* = Call_NodeHealthsGet_568746(name: "nodeHealthsGet",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetHealth", validator: validate_NodeHealthsGet_568747,
    base: "", url: url_NodeHealthsGet_568748, schemes: {Scheme.Https})
type
  Call_NodeLoadInformationsGet_568757 = ref object of OpenApiRestCall_567650
proc url_NodeLoadInformationsGet_568759(protocol: Scheme; host: string; base: string;
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

proc validate_NodeLoadInformationsGet_568758(path: JsonNode; query: JsonNode;
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
  var valid_568760 = path.getOrDefault("nodeName")
  valid_568760 = validateParameter(valid_568760, JString, required = true,
                                 default = nil)
  if valid_568760 != nil:
    section.add "nodeName", valid_568760
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568761 = query.getOrDefault("timeout")
  valid_568761 = validateParameter(valid_568761, JInt, required = false, default = nil)
  if valid_568761 != nil:
    section.add "timeout", valid_568761
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568762 = query.getOrDefault("api-version")
  valid_568762 = validateParameter(valid_568762, JString, required = true,
                                 default = nil)
  if valid_568762 != nil:
    section.add "api-version", valid_568762
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568763: Call_NodeLoadInformationsGet_568757; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get node load informations
  ## 
  let valid = call_568763.validator(path, query, header, formData, body)
  let scheme = call_568763.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568763.url(scheme.get, call_568763.host, call_568763.base,
                         call_568763.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568763, url, valid)

proc call*(call_568764: Call_NodeLoadInformationsGet_568757; apiVersion: string;
          nodeName: string; timeout: int = 0): Recallable =
  ## nodeLoadInformationsGet
  ## Get node load informations
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_568765 = newJObject()
  var query_568766 = newJObject()
  add(query_568766, "timeout", newJInt(timeout))
  add(query_568766, "api-version", newJString(apiVersion))
  add(path_568765, "nodeName", newJString(nodeName))
  result = call_568764.call(path_568765, query_568766, nil, nil, nil)

var nodeLoadInformationsGet* = Call_NodeLoadInformationsGet_568757(
    name: "nodeLoadInformationsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetLoadInformation",
    validator: validate_NodeLoadInformationsGet_568758, base: "",
    url: url_NodeLoadInformationsGet_568759, schemes: {Scheme.Https})
type
  Call_DeployedReplicaDetailsGet_568767 = ref object of OpenApiRestCall_567650
proc url_DeployedReplicaDetailsGet_568769(protocol: Scheme; host: string;
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

proc validate_DeployedReplicaDetailsGet_568768(path: JsonNode; query: JsonNode;
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
  var valid_568770 = path.getOrDefault("replicaId")
  valid_568770 = validateParameter(valid_568770, JString, required = true,
                                 default = nil)
  if valid_568770 != nil:
    section.add "replicaId", valid_568770
  var valid_568771 = path.getOrDefault("nodeName")
  valid_568771 = validateParameter(valid_568771, JString, required = true,
                                 default = nil)
  if valid_568771 != nil:
    section.add "nodeName", valid_568771
  var valid_568772 = path.getOrDefault("partitionName")
  valid_568772 = validateParameter(valid_568772, JString, required = true,
                                 default = nil)
  if valid_568772 != nil:
    section.add "partitionName", valid_568772
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568773 = query.getOrDefault("timeout")
  valid_568773 = validateParameter(valid_568773, JInt, required = false, default = nil)
  if valid_568773 != nil:
    section.add "timeout", valid_568773
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568774 = query.getOrDefault("api-version")
  valid_568774 = validateParameter(valid_568774, JString, required = true,
                                 default = nil)
  if valid_568774 != nil:
    section.add "api-version", valid_568774
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568775: Call_DeployedReplicaDetailsGet_568767; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get deployed replica details
  ## 
  let valid = call_568775.validator(path, query, header, formData, body)
  let scheme = call_568775.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568775.url(scheme.get, call_568775.host, call_568775.base,
                         call_568775.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568775, url, valid)

proc call*(call_568776: Call_DeployedReplicaDetailsGet_568767; replicaId: string;
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
  var path_568777 = newJObject()
  var query_568778 = newJObject()
  add(path_568777, "replicaId", newJString(replicaId))
  add(query_568778, "timeout", newJInt(timeout))
  add(query_568778, "api-version", newJString(apiVersion))
  add(path_568777, "nodeName", newJString(nodeName))
  add(path_568777, "partitionName", newJString(partitionName))
  result = call_568776.call(path_568777, query_568778, nil, nil, nil)

var deployedReplicaDetailsGet* = Call_DeployedReplicaDetailsGet_568767(
    name: "deployedReplicaDetailsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetPartitions/{partitionName}/$/GetReplicas/{replicaId}/$/GetDetail",
    validator: validate_DeployedReplicaDetailsGet_568768, base: "",
    url: url_DeployedReplicaDetailsGet_568769, schemes: {Scheme.Https})
type
  Call_NodeStatesRemove_568779 = ref object of OpenApiRestCall_567650
proc url_NodeStatesRemove_568781(protocol: Scheme; host: string; base: string;
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

proc validate_NodeStatesRemove_568780(path: JsonNode; query: JsonNode;
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
  var valid_568782 = path.getOrDefault("nodeName")
  valid_568782 = validateParameter(valid_568782, JString, required = true,
                                 default = nil)
  if valid_568782 != nil:
    section.add "nodeName", valid_568782
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568783 = query.getOrDefault("timeout")
  valid_568783 = validateParameter(valid_568783, JInt, required = false, default = nil)
  if valid_568783 != nil:
    section.add "timeout", valid_568783
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568784 = query.getOrDefault("api-version")
  valid_568784 = validateParameter(valid_568784, JString, required = true,
                                 default = nil)
  if valid_568784 != nil:
    section.add "api-version", valid_568784
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568785: Call_NodeStatesRemove_568779; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove node states
  ## 
  let valid = call_568785.validator(path, query, header, formData, body)
  let scheme = call_568785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568785.url(scheme.get, call_568785.host, call_568785.base,
                         call_568785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568785, url, valid)

proc call*(call_568786: Call_NodeStatesRemove_568779; apiVersion: string;
          nodeName: string; timeout: int = 0): Recallable =
  ## nodeStatesRemove
  ## Remove node states
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_568787 = newJObject()
  var query_568788 = newJObject()
  add(query_568788, "timeout", newJInt(timeout))
  add(query_568788, "api-version", newJString(apiVersion))
  add(path_568787, "nodeName", newJString(nodeName))
  result = call_568786.call(path_568787, query_568788, nil, nil, nil)

var nodeStatesRemove* = Call_NodeStatesRemove_568779(name: "nodeStatesRemove",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/RemoveNodeState",
    validator: validate_NodeStatesRemove_568780, base: "",
    url: url_NodeStatesRemove_568781, schemes: {Scheme.Https})
type
  Call_NodeHealthsSend_568789 = ref object of OpenApiRestCall_567650
proc url_NodeHealthsSend_568791(protocol: Scheme; host: string; base: string;
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

proc validate_NodeHealthsSend_568790(path: JsonNode; query: JsonNode;
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
  var valid_568792 = path.getOrDefault("nodeName")
  valid_568792 = validateParameter(valid_568792, JString, required = true,
                                 default = nil)
  if valid_568792 != nil:
    section.add "nodeName", valid_568792
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568793 = query.getOrDefault("timeout")
  valid_568793 = validateParameter(valid_568793, JInt, required = false, default = nil)
  if valid_568793 != nil:
    section.add "timeout", valid_568793
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568794 = query.getOrDefault("api-version")
  valid_568794 = validateParameter(valid_568794, JString, required = true,
                                 default = nil)
  if valid_568794 != nil:
    section.add "api-version", valid_568794
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

proc call*(call_568796: Call_NodeHealthsSend_568789; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send node health
  ## 
  let valid = call_568796.validator(path, query, header, formData, body)
  let scheme = call_568796.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568796.url(scheme.get, call_568796.host, call_568796.base,
                         call_568796.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568796, url, valid)

proc call*(call_568797: Call_NodeHealthsSend_568789; nodeHealthReport: JsonNode;
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
  var path_568798 = newJObject()
  var query_568799 = newJObject()
  var body_568800 = newJObject()
  add(query_568799, "timeout", newJInt(timeout))
  if nodeHealthReport != nil:
    body_568800 = nodeHealthReport
  add(query_568799, "api-version", newJString(apiVersion))
  add(path_568798, "nodeName", newJString(nodeName))
  result = call_568797.call(path_568798, query_568799, nil, nil, body_568800)

var nodeHealthsSend* = Call_NodeHealthsSend_568789(name: "nodeHealthsSend",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/ReportHealth",
    validator: validate_NodeHealthsSend_568790, base: "", url: url_NodeHealthsSend_568791,
    schemes: {Scheme.Https})
type
  Call_PartitionHealthsGet_568801 = ref object of OpenApiRestCall_567650
proc url_PartitionHealthsGet_568803(protocol: Scheme; host: string; base: string;
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

proc validate_PartitionHealthsGet_568802(path: JsonNode; query: JsonNode;
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
  var valid_568804 = path.getOrDefault("partitionId")
  valid_568804 = validateParameter(valid_568804, JString, required = true,
                                 default = nil)
  if valid_568804 != nil:
    section.add "partitionId", valid_568804
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
  var valid_568805 = query.getOrDefault("timeout")
  valid_568805 = validateParameter(valid_568805, JInt, required = false, default = nil)
  if valid_568805 != nil:
    section.add "timeout", valid_568805
  var valid_568806 = query.getOrDefault("ReplicasHealthStateFilter")
  valid_568806 = validateParameter(valid_568806, JString, required = false,
                                 default = nil)
  if valid_568806 != nil:
    section.add "ReplicasHealthStateFilter", valid_568806
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568807 = query.getOrDefault("api-version")
  valid_568807 = validateParameter(valid_568807, JString, required = true,
                                 default = nil)
  if valid_568807 != nil:
    section.add "api-version", valid_568807
  var valid_568808 = query.getOrDefault("EventsHealthStateFilter")
  valid_568808 = validateParameter(valid_568808, JString, required = false,
                                 default = nil)
  if valid_568808 != nil:
    section.add "EventsHealthStateFilter", valid_568808
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568809: Call_PartitionHealthsGet_568801; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get partition healths
  ## 
  let valid = call_568809.validator(path, query, header, formData, body)
  let scheme = call_568809.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568809.url(scheme.get, call_568809.host, call_568809.base,
                         call_568809.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568809, url, valid)

proc call*(call_568810: Call_PartitionHealthsGet_568801; apiVersion: string;
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
  var path_568811 = newJObject()
  var query_568812 = newJObject()
  add(query_568812, "timeout", newJInt(timeout))
  add(query_568812, "ReplicasHealthStateFilter",
      newJString(ReplicasHealthStateFilter))
  add(query_568812, "api-version", newJString(apiVersion))
  add(query_568812, "EventsHealthStateFilter", newJString(EventsHealthStateFilter))
  add(path_568811, "partitionId", newJString(partitionId))
  result = call_568810.call(path_568811, query_568812, nil, nil, nil)

var partitionHealthsGet* = Call_PartitionHealthsGet_568801(
    name: "partitionHealthsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/GetHealth",
    validator: validate_PartitionHealthsGet_568802, base: "",
    url: url_PartitionHealthsGet_568803, schemes: {Scheme.Https})
type
  Call_PartitionLoadInformationsGet_568813 = ref object of OpenApiRestCall_567650
proc url_PartitionLoadInformationsGet_568815(protocol: Scheme; host: string;
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

proc validate_PartitionLoadInformationsGet_568814(path: JsonNode; query: JsonNode;
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
  var valid_568816 = path.getOrDefault("partitionId")
  valid_568816 = validateParameter(valid_568816, JString, required = true,
                                 default = nil)
  if valid_568816 != nil:
    section.add "partitionId", valid_568816
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568817 = query.getOrDefault("timeout")
  valid_568817 = validateParameter(valid_568817, JInt, required = false, default = nil)
  if valid_568817 != nil:
    section.add "timeout", valid_568817
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568818 = query.getOrDefault("api-version")
  valid_568818 = validateParameter(valid_568818, JString, required = true,
                                 default = nil)
  if valid_568818 != nil:
    section.add "api-version", valid_568818
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568819: Call_PartitionLoadInformationsGet_568813; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get partition load informations
  ## 
  let valid = call_568819.validator(path, query, header, formData, body)
  let scheme = call_568819.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568819.url(scheme.get, call_568819.host, call_568819.base,
                         call_568819.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568819, url, valid)

proc call*(call_568820: Call_PartitionLoadInformationsGet_568813;
          apiVersion: string; partitionId: string; timeout: int = 0): Recallable =
  ## partitionLoadInformationsGet
  ## Get partition load informations
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   partitionId: string (required)
  ##              : The id of the partition
  var path_568821 = newJObject()
  var query_568822 = newJObject()
  add(query_568822, "timeout", newJInt(timeout))
  add(query_568822, "api-version", newJString(apiVersion))
  add(path_568821, "partitionId", newJString(partitionId))
  result = call_568820.call(path_568821, query_568822, nil, nil, nil)

var partitionLoadInformationsGet* = Call_PartitionLoadInformationsGet_568813(
    name: "partitionLoadInformationsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetLoadInformation",
    validator: validate_PartitionLoadInformationsGet_568814, base: "",
    url: url_PartitionLoadInformationsGet_568815, schemes: {Scheme.Https})
type
  Call_ReplicasList_568823 = ref object of OpenApiRestCall_567650
proc url_ReplicasList_568825(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicasList_568824(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568826 = path.getOrDefault("partitionId")
  valid_568826 = validateParameter(valid_568826, JString, required = true,
                                 default = nil)
  if valid_568826 != nil:
    section.add "partitionId", valid_568826
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568827 = query.getOrDefault("timeout")
  valid_568827 = validateParameter(valid_568827, JInt, required = false, default = nil)
  if valid_568827 != nil:
    section.add "timeout", valid_568827
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568828 = query.getOrDefault("api-version")
  valid_568828 = validateParameter(valid_568828, JString, required = true,
                                 default = nil)
  if valid_568828 != nil:
    section.add "api-version", valid_568828
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568829: Call_ReplicasList_568823; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List replicas
  ## 
  let valid = call_568829.validator(path, query, header, formData, body)
  let scheme = call_568829.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568829.url(scheme.get, call_568829.host, call_568829.base,
                         call_568829.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568829, url, valid)

proc call*(call_568830: Call_ReplicasList_568823; apiVersion: string;
          partitionId: string; timeout: int = 0): Recallable =
  ## replicasList
  ## List replicas
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   partitionId: string (required)
  ##              : The id of the partition
  var path_568831 = newJObject()
  var query_568832 = newJObject()
  add(query_568832, "timeout", newJInt(timeout))
  add(query_568832, "api-version", newJString(apiVersion))
  add(path_568831, "partitionId", newJString(partitionId))
  result = call_568830.call(path_568831, query_568832, nil, nil, nil)

var replicasList* = Call_ReplicasList_568823(name: "replicasList",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetReplicas",
    validator: validate_ReplicasList_568824, base: "", url: url_ReplicasList_568825,
    schemes: {Scheme.Https})
type
  Call_ReplicasGet_568833 = ref object of OpenApiRestCall_567650
proc url_ReplicasGet_568835(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicasGet_568834(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568836 = path.getOrDefault("replicaId")
  valid_568836 = validateParameter(valid_568836, JString, required = true,
                                 default = nil)
  if valid_568836 != nil:
    section.add "replicaId", valid_568836
  var valid_568837 = path.getOrDefault("partitionId")
  valid_568837 = validateParameter(valid_568837, JString, required = true,
                                 default = nil)
  if valid_568837 != nil:
    section.add "partitionId", valid_568837
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568838 = query.getOrDefault("timeout")
  valid_568838 = validateParameter(valid_568838, JInt, required = false, default = nil)
  if valid_568838 != nil:
    section.add "timeout", valid_568838
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568839 = query.getOrDefault("api-version")
  valid_568839 = validateParameter(valid_568839, JString, required = true,
                                 default = nil)
  if valid_568839 != nil:
    section.add "api-version", valid_568839
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568840: Call_ReplicasGet_568833; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get replicas
  ## 
  let valid = call_568840.validator(path, query, header, formData, body)
  let scheme = call_568840.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568840.url(scheme.get, call_568840.host, call_568840.base,
                         call_568840.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568840, url, valid)

proc call*(call_568841: Call_ReplicasGet_568833; replicaId: string;
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
  var path_568842 = newJObject()
  var query_568843 = newJObject()
  add(path_568842, "replicaId", newJString(replicaId))
  add(query_568843, "timeout", newJInt(timeout))
  add(query_568843, "api-version", newJString(apiVersion))
  add(path_568842, "partitionId", newJString(partitionId))
  result = call_568841.call(path_568842, query_568843, nil, nil, nil)

var replicasGet* = Call_ReplicasGet_568833(name: "replicasGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local:19080", route: "/Partitions/{partitionId}/$/GetReplicas/{replicaId}",
                                        validator: validate_ReplicasGet_568834,
                                        base: "", url: url_ReplicasGet_568835,
                                        schemes: {Scheme.Https})
type
  Call_ReplicaHealthsGet_568844 = ref object of OpenApiRestCall_567650
proc url_ReplicaHealthsGet_568846(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicaHealthsGet_568845(path: JsonNode; query: JsonNode;
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
  var valid_568847 = path.getOrDefault("replicaId")
  valid_568847 = validateParameter(valid_568847, JString, required = true,
                                 default = nil)
  if valid_568847 != nil:
    section.add "replicaId", valid_568847
  var valid_568848 = path.getOrDefault("partitionId")
  valid_568848 = validateParameter(valid_568848, JString, required = true,
                                 default = nil)
  if valid_568848 != nil:
    section.add "partitionId", valid_568848
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   EventsHealthStateFilter: JString
  ##                          : The filter of the events health state
  section = newJObject()
  var valid_568849 = query.getOrDefault("timeout")
  valid_568849 = validateParameter(valid_568849, JInt, required = false, default = nil)
  if valid_568849 != nil:
    section.add "timeout", valid_568849
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568850 = query.getOrDefault("api-version")
  valid_568850 = validateParameter(valid_568850, JString, required = true,
                                 default = nil)
  if valid_568850 != nil:
    section.add "api-version", valid_568850
  var valid_568851 = query.getOrDefault("EventsHealthStateFilter")
  valid_568851 = validateParameter(valid_568851, JString, required = false,
                                 default = nil)
  if valid_568851 != nil:
    section.add "EventsHealthStateFilter", valid_568851
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568852: Call_ReplicaHealthsGet_568844; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get replica healths
  ## 
  let valid = call_568852.validator(path, query, header, formData, body)
  let scheme = call_568852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568852.url(scheme.get, call_568852.host, call_568852.base,
                         call_568852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568852, url, valid)

proc call*(call_568853: Call_ReplicaHealthsGet_568844; replicaId: string;
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
  var path_568854 = newJObject()
  var query_568855 = newJObject()
  add(path_568854, "replicaId", newJString(replicaId))
  add(query_568855, "timeout", newJInt(timeout))
  add(query_568855, "api-version", newJString(apiVersion))
  add(query_568855, "EventsHealthStateFilter", newJString(EventsHealthStateFilter))
  add(path_568854, "partitionId", newJString(partitionId))
  result = call_568853.call(path_568854, query_568855, nil, nil, nil)

var replicaHealthsGet* = Call_ReplicaHealthsGet_568844(name: "replicaHealthsGet",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetReplicas/{replicaId}/$/GetHealth",
    validator: validate_ReplicaHealthsGet_568845, base: "",
    url: url_ReplicaHealthsGet_568846, schemes: {Scheme.Https})
type
  Call_ReplicaLoadInformationsGet_568856 = ref object of OpenApiRestCall_567650
proc url_ReplicaLoadInformationsGet_568858(protocol: Scheme; host: string;
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

proc validate_ReplicaLoadInformationsGet_568857(path: JsonNode; query: JsonNode;
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
  var valid_568859 = path.getOrDefault("replicaId")
  valid_568859 = validateParameter(valid_568859, JString, required = true,
                                 default = nil)
  if valid_568859 != nil:
    section.add "replicaId", valid_568859
  var valid_568860 = path.getOrDefault("partitionId")
  valid_568860 = validateParameter(valid_568860, JString, required = true,
                                 default = nil)
  if valid_568860 != nil:
    section.add "partitionId", valid_568860
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568861 = query.getOrDefault("timeout")
  valid_568861 = validateParameter(valid_568861, JInt, required = false, default = nil)
  if valid_568861 != nil:
    section.add "timeout", valid_568861
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568862 = query.getOrDefault("api-version")
  valid_568862 = validateParameter(valid_568862, JString, required = true,
                                 default = nil)
  if valid_568862 != nil:
    section.add "api-version", valid_568862
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568863: Call_ReplicaLoadInformationsGet_568856; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get replica load informations
  ## 
  let valid = call_568863.validator(path, query, header, formData, body)
  let scheme = call_568863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568863.url(scheme.get, call_568863.host, call_568863.base,
                         call_568863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568863, url, valid)

proc call*(call_568864: Call_ReplicaLoadInformationsGet_568856; replicaId: string;
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
  var path_568865 = newJObject()
  var query_568866 = newJObject()
  add(path_568865, "replicaId", newJString(replicaId))
  add(query_568866, "timeout", newJInt(timeout))
  add(query_568866, "api-version", newJString(apiVersion))
  add(path_568865, "partitionId", newJString(partitionId))
  result = call_568864.call(path_568865, query_568866, nil, nil, nil)

var replicaLoadInformationsGet* = Call_ReplicaLoadInformationsGet_568856(
    name: "replicaLoadInformationsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/GetReplicas/{replicaId}/$/GetLoadInformation",
    validator: validate_ReplicaLoadInformationsGet_568857, base: "",
    url: url_ReplicaLoadInformationsGet_568858, schemes: {Scheme.Https})
type
  Call_ReplicaHealthsSend_568867 = ref object of OpenApiRestCall_567650
proc url_ReplicaHealthsSend_568869(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicaHealthsSend_568868(path: JsonNode; query: JsonNode;
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
  var valid_568870 = path.getOrDefault("replicaId")
  valid_568870 = validateParameter(valid_568870, JString, required = true,
                                 default = nil)
  if valid_568870 != nil:
    section.add "replicaId", valid_568870
  var valid_568871 = path.getOrDefault("partitionId")
  valid_568871 = validateParameter(valid_568871, JString, required = true,
                                 default = nil)
  if valid_568871 != nil:
    section.add "partitionId", valid_568871
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568872 = query.getOrDefault("timeout")
  valid_568872 = validateParameter(valid_568872, JInt, required = false, default = nil)
  if valid_568872 != nil:
    section.add "timeout", valid_568872
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568873 = query.getOrDefault("api-version")
  valid_568873 = validateParameter(valid_568873, JString, required = true,
                                 default = nil)
  if valid_568873 != nil:
    section.add "api-version", valid_568873
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

proc call*(call_568875: Call_ReplicaHealthsSend_568867; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send replica healths
  ## 
  let valid = call_568875.validator(path, query, header, formData, body)
  let scheme = call_568875.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568875.url(scheme.get, call_568875.host, call_568875.base,
                         call_568875.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568875, url, valid)

proc call*(call_568876: Call_ReplicaHealthsSend_568867; replicaId: string;
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
  var path_568877 = newJObject()
  var query_568878 = newJObject()
  var body_568879 = newJObject()
  add(path_568877, "replicaId", newJString(replicaId))
  add(query_568878, "timeout", newJInt(timeout))
  add(query_568878, "api-version", newJString(apiVersion))
  add(path_568877, "partitionId", newJString(partitionId))
  if replicaHealthReport != nil:
    body_568879 = replicaHealthReport
  result = call_568876.call(path_568877, query_568878, nil, nil, body_568879)

var replicaHealthsSend* = Call_ReplicaHealthsSend_568867(
    name: "replicaHealthsSend", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/GetReplicas/{replicaId}/$/ReportHealth",
    validator: validate_ReplicaHealthsSend_568868, base: "",
    url: url_ReplicaHealthsSend_568869, schemes: {Scheme.Https})
type
  Call_PartitionsRepair_568880 = ref object of OpenApiRestCall_567650
proc url_PartitionsRepair_568882(protocol: Scheme; host: string; base: string;
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

proc validate_PartitionsRepair_568881(path: JsonNode; query: JsonNode;
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
  var valid_568883 = path.getOrDefault("partitionId")
  valid_568883 = validateParameter(valid_568883, JString, required = true,
                                 default = nil)
  if valid_568883 != nil:
    section.add "partitionId", valid_568883
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568884 = query.getOrDefault("timeout")
  valid_568884 = validateParameter(valid_568884, JInt, required = false, default = nil)
  if valid_568884 != nil:
    section.add "timeout", valid_568884
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568885 = query.getOrDefault("api-version")
  valid_568885 = validateParameter(valid_568885, JString, required = true,
                                 default = nil)
  if valid_568885 != nil:
    section.add "api-version", valid_568885
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568886: Call_PartitionsRepair_568880; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Repair partitions
  ## 
  let valid = call_568886.validator(path, query, header, formData, body)
  let scheme = call_568886.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568886.url(scheme.get, call_568886.host, call_568886.base,
                         call_568886.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568886, url, valid)

proc call*(call_568887: Call_PartitionsRepair_568880; apiVersion: string;
          partitionId: string; timeout: int = 0): Recallable =
  ## partitionsRepair
  ## Repair partitions
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   partitionId: string (required)
  ##              : The id of the partition
  var path_568888 = newJObject()
  var query_568889 = newJObject()
  add(query_568889, "timeout", newJInt(timeout))
  add(query_568889, "api-version", newJString(apiVersion))
  add(path_568888, "partitionId", newJString(partitionId))
  result = call_568887.call(path_568888, query_568889, nil, nil, nil)

var partitionsRepair* = Call_PartitionsRepair_568880(name: "partitionsRepair",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/Recover",
    validator: validate_PartitionsRepair_568881, base: "",
    url: url_PartitionsRepair_568882, schemes: {Scheme.Https})
type
  Call_PartitionHealthsSend_568890 = ref object of OpenApiRestCall_567650
proc url_PartitionHealthsSend_568892(protocol: Scheme; host: string; base: string;
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

proc validate_PartitionHealthsSend_568891(path: JsonNode; query: JsonNode;
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
  var valid_568893 = path.getOrDefault("partitionId")
  valid_568893 = validateParameter(valid_568893, JString, required = true,
                                 default = nil)
  if valid_568893 != nil:
    section.add "partitionId", valid_568893
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568894 = query.getOrDefault("timeout")
  valid_568894 = validateParameter(valid_568894, JInt, required = false, default = nil)
  if valid_568894 != nil:
    section.add "timeout", valid_568894
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568895 = query.getOrDefault("api-version")
  valid_568895 = validateParameter(valid_568895, JString, required = true,
                                 default = nil)
  if valid_568895 != nil:
    section.add "api-version", valid_568895
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

proc call*(call_568897: Call_PartitionHealthsSend_568890; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send partition health
  ## 
  let valid = call_568897.validator(path, query, header, formData, body)
  let scheme = call_568897.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568897.url(scheme.get, call_568897.host, call_568897.base,
                         call_568897.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568897, url, valid)

proc call*(call_568898: Call_PartitionHealthsSend_568890; apiVersion: string;
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
  var path_568899 = newJObject()
  var query_568900 = newJObject()
  var body_568901 = newJObject()
  add(query_568900, "timeout", newJInt(timeout))
  add(query_568900, "api-version", newJString(apiVersion))
  if partitionHealthReport != nil:
    body_568901 = partitionHealthReport
  add(path_568899, "partitionId", newJString(partitionId))
  result = call_568898.call(path_568899, query_568900, nil, nil, body_568901)

var partitionHealthsSend* = Call_PartitionHealthsSend_568890(
    name: "partitionHealthsSend", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/ReportHealth",
    validator: validate_PartitionHealthsSend_568891, base: "",
    url: url_PartitionHealthsSend_568892, schemes: {Scheme.Https})
type
  Call_PartitionLoadsReset_568902 = ref object of OpenApiRestCall_567650
proc url_PartitionLoadsReset_568904(protocol: Scheme; host: string; base: string;
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

proc validate_PartitionLoadsReset_568903(path: JsonNode; query: JsonNode;
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
  var valid_568905 = path.getOrDefault("partitionId")
  valid_568905 = validateParameter(valid_568905, JString, required = true,
                                 default = nil)
  if valid_568905 != nil:
    section.add "partitionId", valid_568905
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568906 = query.getOrDefault("timeout")
  valid_568906 = validateParameter(valid_568906, JInt, required = false, default = nil)
  if valid_568906 != nil:
    section.add "timeout", valid_568906
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568907 = query.getOrDefault("api-version")
  valid_568907 = validateParameter(valid_568907, JString, required = true,
                                 default = nil)
  if valid_568907 != nil:
    section.add "api-version", valid_568907
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568908: Call_PartitionLoadsReset_568902; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reset partition loads
  ## 
  let valid = call_568908.validator(path, query, header, formData, body)
  let scheme = call_568908.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568908.url(scheme.get, call_568908.host, call_568908.base,
                         call_568908.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568908, url, valid)

proc call*(call_568909: Call_PartitionLoadsReset_568902; apiVersion: string;
          partitionId: string; timeout: int = 0): Recallable =
  ## partitionLoadsReset
  ## Reset partition loads
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   partitionId: string (required)
  ##              : The id of the partition
  var path_568910 = newJObject()
  var query_568911 = newJObject()
  add(query_568911, "timeout", newJInt(timeout))
  add(query_568911, "api-version", newJString(apiVersion))
  add(path_568910, "partitionId", newJString(partitionId))
  result = call_568909.call(path_568910, query_568911, nil, nil, nil)

var partitionLoadsReset* = Call_PartitionLoadsReset_568902(
    name: "partitionLoadsReset", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/ResetLoad",
    validator: validate_PartitionLoadsReset_568903, base: "",
    url: url_PartitionLoadsReset_568904, schemes: {Scheme.Https})
type
  Call_ServicesRemove_568912 = ref object of OpenApiRestCall_567650
proc url_ServicesRemove_568914(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesRemove_568913(path: JsonNode; query: JsonNode;
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
  var valid_568915 = path.getOrDefault("serviceName")
  valid_568915 = validateParameter(valid_568915, JString, required = true,
                                 default = nil)
  if valid_568915 != nil:
    section.add "serviceName", valid_568915
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568916 = query.getOrDefault("timeout")
  valid_568916 = validateParameter(valid_568916, JInt, required = false, default = nil)
  if valid_568916 != nil:
    section.add "timeout", valid_568916
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568917 = query.getOrDefault("api-version")
  valid_568917 = validateParameter(valid_568917, JString, required = true,
                                 default = nil)
  if valid_568917 != nil:
    section.add "api-version", valid_568917
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568918: Call_ServicesRemove_568912; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove services
  ## 
  let valid = call_568918.validator(path, query, header, formData, body)
  let scheme = call_568918.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568918.url(scheme.get, call_568918.host, call_568918.base,
                         call_568918.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568918, url, valid)

proc call*(call_568919: Call_ServicesRemove_568912; apiVersion: string;
          serviceName: string; timeout: int = 0): Recallable =
  ## servicesRemove
  ## Remove services
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   serviceName: string (required)
  ##              : The name of the service
  var path_568920 = newJObject()
  var query_568921 = newJObject()
  add(query_568921, "timeout", newJInt(timeout))
  add(query_568921, "api-version", newJString(apiVersion))
  add(path_568920, "serviceName", newJString(serviceName))
  result = call_568919.call(path_568920, query_568921, nil, nil, nil)

var servicesRemove* = Call_ServicesRemove_568912(name: "servicesRemove",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Services/{serviceName}/$/Delete", validator: validate_ServicesRemove_568913,
    base: "", url: url_ServicesRemove_568914, schemes: {Scheme.Https})
type
  Call_ServiceDescriptionsGet_568922 = ref object of OpenApiRestCall_567650
proc url_ServiceDescriptionsGet_568924(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceDescriptionsGet_568923(path: JsonNode; query: JsonNode;
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
  var valid_568925 = path.getOrDefault("serviceName")
  valid_568925 = validateParameter(valid_568925, JString, required = true,
                                 default = nil)
  if valid_568925 != nil:
    section.add "serviceName", valid_568925
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568926 = query.getOrDefault("timeout")
  valid_568926 = validateParameter(valid_568926, JInt, required = false, default = nil)
  if valid_568926 != nil:
    section.add "timeout", valid_568926
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568927 = query.getOrDefault("api-version")
  valid_568927 = validateParameter(valid_568927, JString, required = true,
                                 default = nil)
  if valid_568927 != nil:
    section.add "api-version", valid_568927
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568928: Call_ServiceDescriptionsGet_568922; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service descriptions
  ## 
  let valid = call_568928.validator(path, query, header, formData, body)
  let scheme = call_568928.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568928.url(scheme.get, call_568928.host, call_568928.base,
                         call_568928.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568928, url, valid)

proc call*(call_568929: Call_ServiceDescriptionsGet_568922; apiVersion: string;
          serviceName: string; timeout: int = 0): Recallable =
  ## serviceDescriptionsGet
  ## Get service descriptions
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   serviceName: string (required)
  ##              : The name of the service
  var path_568930 = newJObject()
  var query_568931 = newJObject()
  add(query_568931, "timeout", newJInt(timeout))
  add(query_568931, "api-version", newJString(apiVersion))
  add(path_568930, "serviceName", newJString(serviceName))
  result = call_568929.call(path_568930, query_568931, nil, nil, nil)

var serviceDescriptionsGet* = Call_ServiceDescriptionsGet_568922(
    name: "serviceDescriptionsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Services/{serviceName}/$/GetDescription",
    validator: validate_ServiceDescriptionsGet_568923, base: "",
    url: url_ServiceDescriptionsGet_568924, schemes: {Scheme.Https})
type
  Call_ServiceHealthsGet_568932 = ref object of OpenApiRestCall_567650
proc url_ServiceHealthsGet_568934(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceHealthsGet_568933(path: JsonNode; query: JsonNode;
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
  var valid_568935 = path.getOrDefault("serviceName")
  valid_568935 = validateParameter(valid_568935, JString, required = true,
                                 default = nil)
  if valid_568935 != nil:
    section.add "serviceName", valid_568935
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568936 = query.getOrDefault("timeout")
  valid_568936 = validateParameter(valid_568936, JInt, required = false, default = nil)
  if valid_568936 != nil:
    section.add "timeout", valid_568936
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568937 = query.getOrDefault("api-version")
  valid_568937 = validateParameter(valid_568937, JString, required = true,
                                 default = nil)
  if valid_568937 != nil:
    section.add "api-version", valid_568937
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568938: Call_ServiceHealthsGet_568932; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service healths
  ## 
  let valid = call_568938.validator(path, query, header, formData, body)
  let scheme = call_568938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568938.url(scheme.get, call_568938.host, call_568938.base,
                         call_568938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568938, url, valid)

proc call*(call_568939: Call_ServiceHealthsGet_568932; apiVersion: string;
          serviceName: string; timeout: int = 0): Recallable =
  ## serviceHealthsGet
  ## Get service healths
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   serviceName: string (required)
  ##              : The name of the service
  var path_568940 = newJObject()
  var query_568941 = newJObject()
  add(query_568941, "timeout", newJInt(timeout))
  add(query_568941, "api-version", newJString(apiVersion))
  add(path_568940, "serviceName", newJString(serviceName))
  result = call_568939.call(path_568940, query_568941, nil, nil, nil)

var serviceHealthsGet* = Call_ServiceHealthsGet_568932(name: "serviceHealthsGet",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Services/{serviceName}/$/GetHealth",
    validator: validate_ServiceHealthsGet_568933, base: "",
    url: url_ServiceHealthsGet_568934, schemes: {Scheme.Https})
type
  Call_PartitionsList_568942 = ref object of OpenApiRestCall_567650
proc url_PartitionsList_568944(protocol: Scheme; host: string; base: string;
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

proc validate_PartitionsList_568943(path: JsonNode; query: JsonNode;
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
  var valid_568945 = path.getOrDefault("serviceName")
  valid_568945 = validateParameter(valid_568945, JString, required = true,
                                 default = nil)
  if valid_568945 != nil:
    section.add "serviceName", valid_568945
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568946 = query.getOrDefault("timeout")
  valid_568946 = validateParameter(valid_568946, JInt, required = false, default = nil)
  if valid_568946 != nil:
    section.add "timeout", valid_568946
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568947 = query.getOrDefault("api-version")
  valid_568947 = validateParameter(valid_568947, JString, required = true,
                                 default = nil)
  if valid_568947 != nil:
    section.add "api-version", valid_568947
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568948: Call_PartitionsList_568942; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List partitions
  ## 
  let valid = call_568948.validator(path, query, header, formData, body)
  let scheme = call_568948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568948.url(scheme.get, call_568948.host, call_568948.base,
                         call_568948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568948, url, valid)

proc call*(call_568949: Call_PartitionsList_568942; apiVersion: string;
          serviceName: string; timeout: int = 0): Recallable =
  ## partitionsList
  ## List partitions
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   serviceName: string (required)
  ##              : The name of the service
  var path_568950 = newJObject()
  var query_568951 = newJObject()
  add(query_568951, "timeout", newJInt(timeout))
  add(query_568951, "api-version", newJString(apiVersion))
  add(path_568950, "serviceName", newJString(serviceName))
  result = call_568949.call(path_568950, query_568951, nil, nil, nil)

var partitionsList* = Call_PartitionsList_568942(name: "partitionsList",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Services/{serviceName}/$/GetPartitions",
    validator: validate_PartitionsList_568943, base: "", url: url_PartitionsList_568944,
    schemes: {Scheme.Https})
type
  Call_PartitionListsRepair_568952 = ref object of OpenApiRestCall_567650
proc url_PartitionListsRepair_568954(protocol: Scheme; host: string; base: string;
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

proc validate_PartitionListsRepair_568953(path: JsonNode; query: JsonNode;
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
  var valid_568955 = path.getOrDefault("serviceName")
  valid_568955 = validateParameter(valid_568955, JString, required = true,
                                 default = nil)
  if valid_568955 != nil:
    section.add "serviceName", valid_568955
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568956 = query.getOrDefault("timeout")
  valid_568956 = validateParameter(valid_568956, JInt, required = false, default = nil)
  if valid_568956 != nil:
    section.add "timeout", valid_568956
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568957 = query.getOrDefault("api-version")
  valid_568957 = validateParameter(valid_568957, JString, required = true,
                                 default = nil)
  if valid_568957 != nil:
    section.add "api-version", valid_568957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568958: Call_PartitionListsRepair_568952; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Repair partition lists
  ## 
  let valid = call_568958.validator(path, query, header, formData, body)
  let scheme = call_568958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568958.url(scheme.get, call_568958.host, call_568958.base,
                         call_568958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568958, url, valid)

proc call*(call_568959: Call_PartitionListsRepair_568952; apiVersion: string;
          serviceName: string; timeout: int = 0): Recallable =
  ## partitionListsRepair
  ## Repair partition lists
  ##   timeout: int
  ##          : The timeout in seconds
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   serviceName: string (required)
  ##              : The name of the service
  var path_568960 = newJObject()
  var query_568961 = newJObject()
  add(query_568961, "timeout", newJInt(timeout))
  add(query_568961, "api-version", newJString(apiVersion))
  add(path_568960, "serviceName", newJString(serviceName))
  result = call_568959.call(path_568960, query_568961, nil, nil, nil)

var partitionListsRepair* = Call_PartitionListsRepair_568952(
    name: "partitionListsRepair", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Services/{serviceName}/$/GetPartitions/$/Recover",
    validator: validate_PartitionListsRepair_568953, base: "",
    url: url_PartitionListsRepair_568954, schemes: {Scheme.Https})
type
  Call_PartitionsGet_568962 = ref object of OpenApiRestCall_567650
proc url_PartitionsGet_568964(protocol: Scheme; host: string; base: string;
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

proc validate_PartitionsGet_568963(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568965 = path.getOrDefault("partitionId")
  valid_568965 = validateParameter(valid_568965, JString, required = true,
                                 default = nil)
  if valid_568965 != nil:
    section.add "partitionId", valid_568965
  var valid_568966 = path.getOrDefault("serviceName")
  valid_568966 = validateParameter(valid_568966, JString, required = true,
                                 default = nil)
  if valid_568966 != nil:
    section.add "serviceName", valid_568966
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568967 = query.getOrDefault("timeout")
  valid_568967 = validateParameter(valid_568967, JInt, required = false, default = nil)
  if valid_568967 != nil:
    section.add "timeout", valid_568967
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568968 = query.getOrDefault("api-version")
  valid_568968 = validateParameter(valid_568968, JString, required = true,
                                 default = nil)
  if valid_568968 != nil:
    section.add "api-version", valid_568968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568969: Call_PartitionsGet_568962; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get partitions
  ## 
  let valid = call_568969.validator(path, query, header, formData, body)
  let scheme = call_568969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568969.url(scheme.get, call_568969.host, call_568969.base,
                         call_568969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568969, url, valid)

proc call*(call_568970: Call_PartitionsGet_568962; apiVersion: string;
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
  var path_568971 = newJObject()
  var query_568972 = newJObject()
  add(query_568972, "timeout", newJInt(timeout))
  add(query_568972, "api-version", newJString(apiVersion))
  add(path_568971, "partitionId", newJString(partitionId))
  add(path_568971, "serviceName", newJString(serviceName))
  result = call_568970.call(path_568971, query_568972, nil, nil, nil)

var partitionsGet* = Call_PartitionsGet_568962(name: "partitionsGet",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Services/{serviceName}/$/GetPartitions/{partitionId}",
    validator: validate_PartitionsGet_568963, base: "", url: url_PartitionsGet_568964,
    schemes: {Scheme.Https})
type
  Call_ServiceHealthsSend_568973 = ref object of OpenApiRestCall_567650
proc url_ServiceHealthsSend_568975(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceHealthsSend_568974(path: JsonNode; query: JsonNode;
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
  var valid_568976 = path.getOrDefault("serviceName")
  valid_568976 = validateParameter(valid_568976, JString, required = true,
                                 default = nil)
  if valid_568976 != nil:
    section.add "serviceName", valid_568976
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_568977 = query.getOrDefault("timeout")
  valid_568977 = validateParameter(valid_568977, JInt, required = false, default = nil)
  if valid_568977 != nil:
    section.add "timeout", valid_568977
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568978 = query.getOrDefault("api-version")
  valid_568978 = validateParameter(valid_568978, JString, required = true,
                                 default = nil)
  if valid_568978 != nil:
    section.add "api-version", valid_568978
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

proc call*(call_568980: Call_ServiceHealthsSend_568973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send service healths
  ## 
  let valid = call_568980.validator(path, query, header, formData, body)
  let scheme = call_568980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568980.url(scheme.get, call_568980.host, call_568980.base,
                         call_568980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568980, url, valid)

proc call*(call_568981: Call_ServiceHealthsSend_568973; apiVersion: string;
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
  var path_568982 = newJObject()
  var query_568983 = newJObject()
  var body_568984 = newJObject()
  add(query_568983, "timeout", newJInt(timeout))
  add(query_568983, "api-version", newJString(apiVersion))
  add(path_568982, "serviceName", newJString(serviceName))
  if serviceHealthReport != nil:
    body_568984 = serviceHealthReport
  result = call_568981.call(path_568982, query_568983, nil, nil, body_568984)

var serviceHealthsSend* = Call_ServiceHealthsSend_568973(
    name: "serviceHealthsSend", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Services/{serviceName}/$/ReportHealth",
    validator: validate_ServiceHealthsSend_568974, base: "",
    url: url_ServiceHealthsSend_568975, schemes: {Scheme.Https})
type
  Call_ServicesResolve_568985 = ref object of OpenApiRestCall_567650
proc url_ServicesResolve_568987(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesResolve_568986(path: JsonNode; query: JsonNode;
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
  var valid_568988 = path.getOrDefault("serviceName")
  valid_568988 = validateParameter(valid_568988, JString, required = true,
                                 default = nil)
  if valid_568988 != nil:
    section.add "serviceName", valid_568988
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
  var valid_568989 = query.getOrDefault("timeout")
  valid_568989 = validateParameter(valid_568989, JInt, required = false, default = nil)
  if valid_568989 != nil:
    section.add "timeout", valid_568989
  var valid_568990 = query.getOrDefault("PartitionKeyValue")
  valid_568990 = validateParameter(valid_568990, JString, required = false,
                                 default = nil)
  if valid_568990 != nil:
    section.add "PartitionKeyValue", valid_568990
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568991 = query.getOrDefault("api-version")
  valid_568991 = validateParameter(valid_568991, JString, required = true,
                                 default = nil)
  if valid_568991 != nil:
    section.add "api-version", valid_568991
  var valid_568992 = query.getOrDefault("PartitionKeyType")
  valid_568992 = validateParameter(valid_568992, JInt, required = false, default = nil)
  if valid_568992 != nil:
    section.add "PartitionKeyType", valid_568992
  var valid_568993 = query.getOrDefault("PreviousRspVersion")
  valid_568993 = validateParameter(valid_568993, JString, required = false,
                                 default = nil)
  if valid_568993 != nil:
    section.add "PreviousRspVersion", valid_568993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568994: Call_ServicesResolve_568985; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resolve services
  ## 
  let valid = call_568994.validator(path, query, header, formData, body)
  let scheme = call_568994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568994.url(scheme.get, call_568994.host, call_568994.base,
                         call_568994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568994, url, valid)

proc call*(call_568995: Call_ServicesResolve_568985; apiVersion: string;
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
  var path_568996 = newJObject()
  var query_568997 = newJObject()
  add(query_568997, "timeout", newJInt(timeout))
  add(query_568997, "PartitionKeyValue", newJString(PartitionKeyValue))
  add(query_568997, "api-version", newJString(apiVersion))
  add(query_568997, "PartitionKeyType", newJInt(PartitionKeyType))
  add(query_568997, "PreviousRspVersion", newJString(PreviousRspVersion))
  add(path_568996, "serviceName", newJString(serviceName))
  result = call_568995.call(path_568996, query_568997, nil, nil, nil)

var servicesResolve* = Call_ServicesResolve_568985(name: "servicesResolve",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Services/{serviceName}/$/ResolvePartition",
    validator: validate_ServicesResolve_568986, base: "", url: url_ServicesResolve_568987,
    schemes: {Scheme.Https})
type
  Call_ServicesUpdate_568998 = ref object of OpenApiRestCall_567650
proc url_ServicesUpdate_569000(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesUpdate_568999(path: JsonNode; query: JsonNode;
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
  var valid_569001 = path.getOrDefault("serviceName")
  valid_569001 = validateParameter(valid_569001, JString, required = true,
                                 default = nil)
  if valid_569001 != nil:
    section.add "serviceName", valid_569001
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   api-version: JString (required)
  ##              : The version of the api
  section = newJObject()
  var valid_569002 = query.getOrDefault("timeout")
  valid_569002 = validateParameter(valid_569002, JInt, required = false, default = nil)
  if valid_569002 != nil:
    section.add "timeout", valid_569002
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569003 = query.getOrDefault("api-version")
  valid_569003 = validateParameter(valid_569003, JString, required = true,
                                 default = nil)
  if valid_569003 != nil:
    section.add "api-version", valid_569003
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

proc call*(call_569005: Call_ServicesUpdate_568998; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update services
  ## 
  let valid = call_569005.validator(path, query, header, formData, body)
  let scheme = call_569005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569005.url(scheme.get, call_569005.host, call_569005.base,
                         call_569005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569005, url, valid)

proc call*(call_569006: Call_ServicesUpdate_568998; apiVersion: string;
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
  var path_569007 = newJObject()
  var query_569008 = newJObject()
  var body_569009 = newJObject()
  add(query_569008, "timeout", newJInt(timeout))
  add(query_569008, "api-version", newJString(apiVersion))
  if updateServiceDescription != nil:
    body_569009 = updateServiceDescription
  add(path_569007, "serviceName", newJString(serviceName))
  result = call_569006.call(path_569007, query_569008, nil, nil, body_569009)

var servicesUpdate* = Call_ServicesUpdate_568998(name: "servicesUpdate",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Services/{serviceName}/$/Update", validator: validate_ServicesUpdate_568999,
    base: "", url: url_ServicesUpdate_569000, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
