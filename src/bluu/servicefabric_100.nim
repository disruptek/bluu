
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563548 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563548](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563548): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "servicefabric"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ClusterHealthsGet_563770 = ref object of OpenApiRestCall_563548
proc url_ClusterHealthsGet_563772(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterHealthsGet_563771(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get cluster healths
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   ApplicationsHealthStateFilter: JString
  ##                                : The filter of the applications health state
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   EventsHealthStateFilter: JString
  ##                          : The filter of the events health state
  ##   NodesHealthStateFilter: JString
  ##                         : The filter of the nodes health state
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563933 = query.getOrDefault("api-version")
  valid_563933 = validateParameter(valid_563933, JString, required = true,
                                 default = nil)
  if valid_563933 != nil:
    section.add "api-version", valid_563933
  var valid_563934 = query.getOrDefault("ApplicationsHealthStateFilter")
  valid_563934 = validateParameter(valid_563934, JString, required = false,
                                 default = nil)
  if valid_563934 != nil:
    section.add "ApplicationsHealthStateFilter", valid_563934
  var valid_563935 = query.getOrDefault("timeout")
  valid_563935 = validateParameter(valid_563935, JInt, required = false, default = nil)
  if valid_563935 != nil:
    section.add "timeout", valid_563935
  var valid_563936 = query.getOrDefault("EventsHealthStateFilter")
  valid_563936 = validateParameter(valid_563936, JString, required = false,
                                 default = nil)
  if valid_563936 != nil:
    section.add "EventsHealthStateFilter", valid_563936
  var valid_563937 = query.getOrDefault("NodesHealthStateFilter")
  valid_563937 = validateParameter(valid_563937, JString, required = false,
                                 default = nil)
  if valid_563937 != nil:
    section.add "NodesHealthStateFilter", valid_563937
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563960: Call_ClusterHealthsGet_563770; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get cluster healths
  ## 
  let valid = call_563960.validator(path, query, header, formData, body)
  let scheme = call_563960.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563960.url(scheme.get, call_563960.host, call_563960.base,
                         call_563960.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563960, url, valid)

proc call*(call_564031: Call_ClusterHealthsGet_563770; apiVersion: string;
          ApplicationsHealthStateFilter: string = ""; timeout: int = 0;
          EventsHealthStateFilter: string = ""; NodesHealthStateFilter: string = ""): Recallable =
  ## clusterHealthsGet
  ## Get cluster healths
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   ApplicationsHealthStateFilter: string
  ##                                : The filter of the applications health state
  ##   timeout: int
  ##          : The timeout in seconds
  ##   EventsHealthStateFilter: string
  ##                          : The filter of the events health state
  ##   NodesHealthStateFilter: string
  ##                         : The filter of the nodes health state
  var query_564032 = newJObject()
  add(query_564032, "api-version", newJString(apiVersion))
  add(query_564032, "ApplicationsHealthStateFilter",
      newJString(ApplicationsHealthStateFilter))
  add(query_564032, "timeout", newJInt(timeout))
  add(query_564032, "EventsHealthStateFilter", newJString(EventsHealthStateFilter))
  add(query_564032, "NodesHealthStateFilter", newJString(NodesHealthStateFilter))
  result = call_564031.call(nil, query_564032, nil, nil, nil)

var clusterHealthsGet* = Call_ClusterHealthsGet_563770(name: "clusterHealthsGet",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/$/GetClusterHealth", validator: validate_ClusterHealthsGet_563771,
    base: "", url: url_ClusterHealthsGet_563772, schemes: {Scheme.Https})
type
  Call_ClusterManifestsGet_564072 = ref object of OpenApiRestCall_563548
proc url_ClusterManifestsGet_564074(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterManifestsGet_564073(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get cluster manifests
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564075 = query.getOrDefault("api-version")
  valid_564075 = validateParameter(valid_564075, JString, required = true,
                                 default = nil)
  if valid_564075 != nil:
    section.add "api-version", valid_564075
  var valid_564076 = query.getOrDefault("timeout")
  valid_564076 = validateParameter(valid_564076, JInt, required = false, default = nil)
  if valid_564076 != nil:
    section.add "timeout", valid_564076
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564077: Call_ClusterManifestsGet_564072; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get cluster manifests
  ## 
  let valid = call_564077.validator(path, query, header, formData, body)
  let scheme = call_564077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564077.url(scheme.get, call_564077.host, call_564077.base,
                         call_564077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564077, url, valid)

proc call*(call_564078: Call_ClusterManifestsGet_564072; apiVersion: string;
          timeout: int = 0): Recallable =
  ## clusterManifestsGet
  ## Get cluster manifests
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  var query_564079 = newJObject()
  add(query_564079, "api-version", newJString(apiVersion))
  add(query_564079, "timeout", newJInt(timeout))
  result = call_564078.call(nil, query_564079, nil, nil, nil)

var clusterManifestsGet* = Call_ClusterManifestsGet_564072(
    name: "clusterManifestsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/$/GetClusterManifest",
    validator: validate_ClusterManifestsGet_564073, base: "",
    url: url_ClusterManifestsGet_564074, schemes: {Scheme.Https})
type
  Call_ClusterLoadInformationsGet_564080 = ref object of OpenApiRestCall_563548
proc url_ClusterLoadInformationsGet_564082(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterLoadInformationsGet_564081(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get cluster load informations
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564083 = query.getOrDefault("api-version")
  valid_564083 = validateParameter(valid_564083, JString, required = true,
                                 default = nil)
  if valid_564083 != nil:
    section.add "api-version", valid_564083
  var valid_564084 = query.getOrDefault("timeout")
  valid_564084 = validateParameter(valid_564084, JInt, required = false, default = nil)
  if valid_564084 != nil:
    section.add "timeout", valid_564084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564085: Call_ClusterLoadInformationsGet_564080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get cluster load informations
  ## 
  let valid = call_564085.validator(path, query, header, formData, body)
  let scheme = call_564085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564085.url(scheme.get, call_564085.host, call_564085.base,
                         call_564085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564085, url, valid)

proc call*(call_564086: Call_ClusterLoadInformationsGet_564080; apiVersion: string;
          timeout: int = 0): Recallable =
  ## clusterLoadInformationsGet
  ## Get cluster load informations
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  var query_564087 = newJObject()
  add(query_564087, "api-version", newJString(apiVersion))
  add(query_564087, "timeout", newJInt(timeout))
  result = call_564086.call(nil, query_564087, nil, nil, nil)

var clusterLoadInformationsGet* = Call_ClusterLoadInformationsGet_564080(
    name: "clusterLoadInformationsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/$/GetLoadInformation",
    validator: validate_ClusterLoadInformationsGet_564081, base: "",
    url: url_ClusterLoadInformationsGet_564082, schemes: {Scheme.Https})
type
  Call_UpgradeProgressesGet_564088 = ref object of OpenApiRestCall_563548
proc url_UpgradeProgressesGet_564090(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_UpgradeProgressesGet_564089(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get upgrade progresses
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564091 = query.getOrDefault("api-version")
  valid_564091 = validateParameter(valid_564091, JString, required = true,
                                 default = nil)
  if valid_564091 != nil:
    section.add "api-version", valid_564091
  var valid_564092 = query.getOrDefault("timeout")
  valid_564092 = validateParameter(valid_564092, JInt, required = false, default = nil)
  if valid_564092 != nil:
    section.add "timeout", valid_564092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564093: Call_UpgradeProgressesGet_564088; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get upgrade progresses
  ## 
  let valid = call_564093.validator(path, query, header, formData, body)
  let scheme = call_564093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564093.url(scheme.get, call_564093.host, call_564093.base,
                         call_564093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564093, url, valid)

proc call*(call_564094: Call_UpgradeProgressesGet_564088; apiVersion: string;
          timeout: int = 0): Recallable =
  ## upgradeProgressesGet
  ## Get upgrade progresses
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  var query_564095 = newJObject()
  add(query_564095, "api-version", newJString(apiVersion))
  add(query_564095, "timeout", newJInt(timeout))
  result = call_564094.call(nil, query_564095, nil, nil, nil)

var upgradeProgressesGet* = Call_UpgradeProgressesGet_564088(
    name: "upgradeProgressesGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/$/GetUpgradeProgress",
    validator: validate_UpgradeProgressesGet_564089, base: "",
    url: url_UpgradeProgressesGet_564090, schemes: {Scheme.Https})
type
  Call_ClusterUpgradesResume_564096 = ref object of OpenApiRestCall_563548
proc url_ClusterUpgradesResume_564098(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterUpgradesResume_564097(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resume cluster upgrades
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564099 = query.getOrDefault("api-version")
  valid_564099 = validateParameter(valid_564099, JString, required = true,
                                 default = nil)
  if valid_564099 != nil:
    section.add "api-version", valid_564099
  var valid_564100 = query.getOrDefault("timeout")
  valid_564100 = validateParameter(valid_564100, JInt, required = false, default = nil)
  if valid_564100 != nil:
    section.add "timeout", valid_564100
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

proc call*(call_564102: Call_ClusterUpgradesResume_564096; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resume cluster upgrades
  ## 
  let valid = call_564102.validator(path, query, header, formData, body)
  let scheme = call_564102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564102.url(scheme.get, call_564102.host, call_564102.base,
                         call_564102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564102, url, valid)

proc call*(call_564103: Call_ClusterUpgradesResume_564096; apiVersion: string;
          resumeClusterUpgrade: JsonNode; timeout: int = 0): Recallable =
  ## clusterUpgradesResume
  ## Resume cluster upgrades
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   resumeClusterUpgrade: JObject (required)
  ##                       : The upgrade of the cluster
  var query_564104 = newJObject()
  var body_564105 = newJObject()
  add(query_564104, "api-version", newJString(apiVersion))
  add(query_564104, "timeout", newJInt(timeout))
  if resumeClusterUpgrade != nil:
    body_564105 = resumeClusterUpgrade
  result = call_564103.call(nil, query_564104, nil, nil, body_564105)

var clusterUpgradesResume* = Call_ClusterUpgradesResume_564096(
    name: "clusterUpgradesResume", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/MoveToNextUpgradeDomain",
    validator: validate_ClusterUpgradesResume_564097, base: "",
    url: url_ClusterUpgradesResume_564098, schemes: {Scheme.Https})
type
  Call_ClusterPackagesRegister_564106 = ref object of OpenApiRestCall_563548
proc url_ClusterPackagesRegister_564108(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterPackagesRegister_564107(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Register cluster packages
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564109 = query.getOrDefault("api-version")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "api-version", valid_564109
  var valid_564110 = query.getOrDefault("timeout")
  valid_564110 = validateParameter(valid_564110, JInt, required = false, default = nil)
  if valid_564110 != nil:
    section.add "timeout", valid_564110
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

proc call*(call_564112: Call_ClusterPackagesRegister_564106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Register cluster packages
  ## 
  let valid = call_564112.validator(path, query, header, formData, body)
  let scheme = call_564112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564112.url(scheme.get, call_564112.host, call_564112.base,
                         call_564112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564112, url, valid)

proc call*(call_564113: Call_ClusterPackagesRegister_564106; apiVersion: string;
          registerClusterPackage: JsonNode; timeout: int = 0): Recallable =
  ## clusterPackagesRegister
  ## Register cluster packages
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   registerClusterPackage: JObject (required)
  ##                         : The package of the register cluster
  var query_564114 = newJObject()
  var body_564115 = newJObject()
  add(query_564114, "api-version", newJString(apiVersion))
  add(query_564114, "timeout", newJInt(timeout))
  if registerClusterPackage != nil:
    body_564115 = registerClusterPackage
  result = call_564113.call(nil, query_564114, nil, nil, body_564115)

var clusterPackagesRegister* = Call_ClusterPackagesRegister_564106(
    name: "clusterPackagesRegister", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/Provision",
    validator: validate_ClusterPackagesRegister_564107, base: "",
    url: url_ClusterPackagesRegister_564108, schemes: {Scheme.Https})
type
  Call_ClusterHealthsSend_564116 = ref object of OpenApiRestCall_563548
proc url_ClusterHealthsSend_564118(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterHealthsSend_564117(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Report cluster healths
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564119 = query.getOrDefault("api-version")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "api-version", valid_564119
  var valid_564120 = query.getOrDefault("timeout")
  valid_564120 = validateParameter(valid_564120, JInt, required = false, default = nil)
  if valid_564120 != nil:
    section.add "timeout", valid_564120
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

proc call*(call_564122: Call_ClusterHealthsSend_564116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Report cluster healths
  ## 
  let valid = call_564122.validator(path, query, header, formData, body)
  let scheme = call_564122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564122.url(scheme.get, call_564122.host, call_564122.base,
                         call_564122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564122, url, valid)

proc call*(call_564123: Call_ClusterHealthsSend_564116; apiVersion: string;
          clusterHealthReport: JsonNode; timeout: int = 0): Recallable =
  ## clusterHealthsSend
  ## Report cluster healths
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   clusterHealthReport: JObject (required)
  ##                      : The report of the cluster health
  var query_564124 = newJObject()
  var body_564125 = newJObject()
  add(query_564124, "api-version", newJString(apiVersion))
  add(query_564124, "timeout", newJInt(timeout))
  if clusterHealthReport != nil:
    body_564125 = clusterHealthReport
  result = call_564123.call(nil, query_564124, nil, nil, body_564125)

var clusterHealthsSend* = Call_ClusterHealthsSend_564116(
    name: "clusterHealthsSend", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/ReportClusterHealth",
    validator: validate_ClusterHealthsSend_564117, base: "",
    url: url_ClusterHealthsSend_564118, schemes: {Scheme.Https})
type
  Call_ClusterUpgradesRollback_564126 = ref object of OpenApiRestCall_563548
proc url_ClusterUpgradesRollback_564128(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterUpgradesRollback_564127(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rollback cluster upgrades
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564129 = query.getOrDefault("api-version")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "api-version", valid_564129
  var valid_564130 = query.getOrDefault("timeout")
  valid_564130 = validateParameter(valid_564130, JInt, required = false, default = nil)
  if valid_564130 != nil:
    section.add "timeout", valid_564130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564131: Call_ClusterUpgradesRollback_564126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rollback cluster upgrades
  ## 
  let valid = call_564131.validator(path, query, header, formData, body)
  let scheme = call_564131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564131.url(scheme.get, call_564131.host, call_564131.base,
                         call_564131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564131, url, valid)

proc call*(call_564132: Call_ClusterUpgradesRollback_564126; apiVersion: string;
          timeout: int = 0): Recallable =
  ## clusterUpgradesRollback
  ## Rollback cluster upgrades
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  var query_564133 = newJObject()
  add(query_564133, "api-version", newJString(apiVersion))
  add(query_564133, "timeout", newJInt(timeout))
  result = call_564132.call(nil, query_564133, nil, nil, nil)

var clusterUpgradesRollback* = Call_ClusterUpgradesRollback_564126(
    name: "clusterUpgradesRollback", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/RollbackUpgrade",
    validator: validate_ClusterUpgradesRollback_564127, base: "",
    url: url_ClusterUpgradesRollback_564128, schemes: {Scheme.Https})
type
  Call_ClusterPackagesUnregister_564134 = ref object of OpenApiRestCall_563548
proc url_ClusterPackagesUnregister_564136(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterPackagesUnregister_564135(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unregister cluster packages
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564137 = query.getOrDefault("api-version")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "api-version", valid_564137
  var valid_564138 = query.getOrDefault("timeout")
  valid_564138 = validateParameter(valid_564138, JInt, required = false, default = nil)
  if valid_564138 != nil:
    section.add "timeout", valid_564138
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

proc call*(call_564140: Call_ClusterPackagesUnregister_564134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unregister cluster packages
  ## 
  let valid = call_564140.validator(path, query, header, formData, body)
  let scheme = call_564140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564140.url(scheme.get, call_564140.host, call_564140.base,
                         call_564140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564140, url, valid)

proc call*(call_564141: Call_ClusterPackagesUnregister_564134; apiVersion: string;
          unregisterClusterPackage: JsonNode; timeout: int = 0): Recallable =
  ## clusterPackagesUnregister
  ## Unregister cluster packages
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   unregisterClusterPackage: JObject (required)
  ##                           : The package of the unregister cluster
  var query_564142 = newJObject()
  var body_564143 = newJObject()
  add(query_564142, "api-version", newJString(apiVersion))
  add(query_564142, "timeout", newJInt(timeout))
  if unregisterClusterPackage != nil:
    body_564143 = unregisterClusterPackage
  result = call_564141.call(nil, query_564142, nil, nil, body_564143)

var clusterPackagesUnregister* = Call_ClusterPackagesUnregister_564134(
    name: "clusterPackagesUnregister", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/Unprovision",
    validator: validate_ClusterPackagesUnregister_564135, base: "",
    url: url_ClusterPackagesUnregister_564136, schemes: {Scheme.Https})
type
  Call_ClusterUpgradesUpdate_564144 = ref object of OpenApiRestCall_563548
proc url_ClusterUpgradesUpdate_564146(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterUpgradesUpdate_564145(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update cluster upgrades
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564147 = query.getOrDefault("api-version")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "api-version", valid_564147
  var valid_564148 = query.getOrDefault("timeout")
  valid_564148 = validateParameter(valid_564148, JInt, required = false, default = nil)
  if valid_564148 != nil:
    section.add "timeout", valid_564148
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

proc call*(call_564150: Call_ClusterUpgradesUpdate_564144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update cluster upgrades
  ## 
  let valid = call_564150.validator(path, query, header, formData, body)
  let scheme = call_564150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564150.url(scheme.get, call_564150.host, call_564150.base,
                         call_564150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564150, url, valid)

proc call*(call_564151: Call_ClusterUpgradesUpdate_564144; apiVersion: string;
          updateClusterUpgrade: JsonNode; timeout: int = 0): Recallable =
  ## clusterUpgradesUpdate
  ## Update cluster upgrades
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   updateClusterUpgrade: JObject (required)
  ##                       : The description of the update cluster upgrade
  ##   timeout: int
  ##          : The timeout in seconds
  var query_564152 = newJObject()
  var body_564153 = newJObject()
  add(query_564152, "api-version", newJString(apiVersion))
  if updateClusterUpgrade != nil:
    body_564153 = updateClusterUpgrade
  add(query_564152, "timeout", newJInt(timeout))
  result = call_564151.call(nil, query_564152, nil, nil, body_564153)

var clusterUpgradesUpdate* = Call_ClusterUpgradesUpdate_564144(
    name: "clusterUpgradesUpdate", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/UpdateUpgrade",
    validator: validate_ClusterUpgradesUpdate_564145, base: "",
    url: url_ClusterUpgradesUpdate_564146, schemes: {Scheme.Https})
type
  Call_ClusterUpgradesStart_564154 = ref object of OpenApiRestCall_563548
proc url_ClusterUpgradesStart_564156(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ClusterUpgradesStart_564155(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Start cluster upgrades
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564157 = query.getOrDefault("api-version")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "api-version", valid_564157
  var valid_564158 = query.getOrDefault("timeout")
  valid_564158 = validateParameter(valid_564158, JInt, required = false, default = nil)
  if valid_564158 != nil:
    section.add "timeout", valid_564158
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

proc call*(call_564160: Call_ClusterUpgradesStart_564154; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Start cluster upgrades
  ## 
  let valid = call_564160.validator(path, query, header, formData, body)
  let scheme = call_564160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564160.url(scheme.get, call_564160.host, call_564160.base,
                         call_564160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564160, url, valid)

proc call*(call_564161: Call_ClusterUpgradesStart_564154; apiVersion: string;
          startClusterUpgrade: JsonNode; timeout: int = 0): Recallable =
  ## clusterUpgradesStart
  ## Start cluster upgrades
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   startClusterUpgrade: JObject (required)
  ##                      : The description of the start cluster upgrade
  var query_564162 = newJObject()
  var body_564163 = newJObject()
  add(query_564162, "api-version", newJString(apiVersion))
  add(query_564162, "timeout", newJInt(timeout))
  if startClusterUpgrade != nil:
    body_564163 = startClusterUpgrade
  result = call_564161.call(nil, query_564162, nil, nil, body_564163)

var clusterUpgradesStart* = Call_ClusterUpgradesStart_564154(
    name: "clusterUpgradesStart", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/Upgrade",
    validator: validate_ClusterUpgradesStart_564155, base: "",
    url: url_ClusterUpgradesStart_564156, schemes: {Scheme.Https})
type
  Call_ApplicationTypesList_564164 = ref object of OpenApiRestCall_563548
proc url_ApplicationTypesList_564166(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ApplicationTypesList_564165(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List application types
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564167 = query.getOrDefault("api-version")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "api-version", valid_564167
  var valid_564168 = query.getOrDefault("timeout")
  valid_564168 = validateParameter(valid_564168, JInt, required = false, default = nil)
  if valid_564168 != nil:
    section.add "timeout", valid_564168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564169: Call_ApplicationTypesList_564164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List application types
  ## 
  let valid = call_564169.validator(path, query, header, formData, body)
  let scheme = call_564169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564169.url(scheme.get, call_564169.host, call_564169.base,
                         call_564169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564169, url, valid)

proc call*(call_564170: Call_ApplicationTypesList_564164; apiVersion: string;
          timeout: int = 0): Recallable =
  ## applicationTypesList
  ## List application types
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  var query_564171 = newJObject()
  add(query_564171, "api-version", newJString(apiVersion))
  add(query_564171, "timeout", newJInt(timeout))
  result = call_564170.call(nil, query_564171, nil, nil, nil)

var applicationTypesList* = Call_ApplicationTypesList_564164(
    name: "applicationTypesList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/ApplicationTypes",
    validator: validate_ApplicationTypesList_564165, base: "",
    url: url_ApplicationTypesList_564166, schemes: {Scheme.Https})
type
  Call_ApplicationTypesRegister_564172 = ref object of OpenApiRestCall_563548
proc url_ApplicationTypesRegister_564174(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ApplicationTypesRegister_564173(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Register application types
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564175 = query.getOrDefault("api-version")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "api-version", valid_564175
  var valid_564176 = query.getOrDefault("timeout")
  valid_564176 = validateParameter(valid_564176, JInt, required = false, default = nil)
  if valid_564176 != nil:
    section.add "timeout", valid_564176
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

proc call*(call_564178: Call_ApplicationTypesRegister_564172; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Register application types
  ## 
  let valid = call_564178.validator(path, query, header, formData, body)
  let scheme = call_564178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564178.url(scheme.get, call_564178.host, call_564178.base,
                         call_564178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564178, url, valid)

proc call*(call_564179: Call_ApplicationTypesRegister_564172; apiVersion: string;
          registerApplicationType: JsonNode; timeout: int = 0): Recallable =
  ## applicationTypesRegister
  ## Register application types
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   registerApplicationType: JObject (required)
  ##                          : The type of the register application
  ##   timeout: int
  ##          : The timeout in seconds
  var query_564180 = newJObject()
  var body_564181 = newJObject()
  add(query_564180, "api-version", newJString(apiVersion))
  if registerApplicationType != nil:
    body_564181 = registerApplicationType
  add(query_564180, "timeout", newJInt(timeout))
  result = call_564179.call(nil, query_564180, nil, nil, body_564181)

var applicationTypesRegister* = Call_ApplicationTypesRegister_564172(
    name: "applicationTypesRegister", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/ApplicationTypes/$/Provision",
    validator: validate_ApplicationTypesRegister_564173, base: "",
    url: url_ApplicationTypesRegister_564174, schemes: {Scheme.Https})
type
  Call_ApplicationTypesGet_564182 = ref object of OpenApiRestCall_563548
proc url_ApplicationTypesGet_564184(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationTypesGet_564183(path: JsonNode; query: JsonNode;
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
  var valid_564199 = path.getOrDefault("applicationTypeName")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "applicationTypeName", valid_564199
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564200 = query.getOrDefault("api-version")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "api-version", valid_564200
  var valid_564201 = query.getOrDefault("timeout")
  valid_564201 = validateParameter(valid_564201, JInt, required = false, default = nil)
  if valid_564201 != nil:
    section.add "timeout", valid_564201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564202: Call_ApplicationTypesGet_564182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get application types
  ## 
  let valid = call_564202.validator(path, query, header, formData, body)
  let scheme = call_564202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564202.url(scheme.get, call_564202.host, call_564202.base,
                         call_564202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564202, url, valid)

proc call*(call_564203: Call_ApplicationTypesGet_564182; apiVersion: string;
          applicationTypeName: string; timeout: int = 0): Recallable =
  ## applicationTypesGet
  ## Get application types
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type
  var path_564204 = newJObject()
  var query_564205 = newJObject()
  add(query_564205, "api-version", newJString(apiVersion))
  add(query_564205, "timeout", newJInt(timeout))
  add(path_564204, "applicationTypeName", newJString(applicationTypeName))
  result = call_564203.call(path_564204, query_564205, nil, nil, nil)

var applicationTypesGet* = Call_ApplicationTypesGet_564182(
    name: "applicationTypesGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/ApplicationTypes/{applicationTypeName}",
    validator: validate_ApplicationTypesGet_564183, base: "",
    url: url_ApplicationTypesGet_564184, schemes: {Scheme.Https})
type
  Call_ApplicationManifestsGet_564206 = ref object of OpenApiRestCall_563548
proc url_ApplicationManifestsGet_564208(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationManifestsGet_564207(path: JsonNode; query: JsonNode;
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
  var valid_564209 = path.getOrDefault("applicationTypeName")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "applicationTypeName", valid_564209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   ApplicationTypeVersion: JString (required)
  ##                         : The version of the application type
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564210 = query.getOrDefault("api-version")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "api-version", valid_564210
  var valid_564211 = query.getOrDefault("ApplicationTypeVersion")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "ApplicationTypeVersion", valid_564211
  var valid_564212 = query.getOrDefault("timeout")
  valid_564212 = validateParameter(valid_564212, JInt, required = false, default = nil)
  if valid_564212 != nil:
    section.add "timeout", valid_564212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564213: Call_ApplicationManifestsGet_564206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get application manifests
  ## 
  let valid = call_564213.validator(path, query, header, formData, body)
  let scheme = call_564213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564213.url(scheme.get, call_564213.host, call_564213.base,
                         call_564213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564213, url, valid)

proc call*(call_564214: Call_ApplicationManifestsGet_564206; apiVersion: string;
          ApplicationTypeVersion: string; applicationTypeName: string;
          timeout: int = 0): Recallable =
  ## applicationManifestsGet
  ## Get application manifests
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   ApplicationTypeVersion: string (required)
  ##                         : The version of the application type
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type
  var path_564215 = newJObject()
  var query_564216 = newJObject()
  add(query_564216, "api-version", newJString(apiVersion))
  add(query_564216, "ApplicationTypeVersion", newJString(ApplicationTypeVersion))
  add(query_564216, "timeout", newJInt(timeout))
  add(path_564215, "applicationTypeName", newJString(applicationTypeName))
  result = call_564214.call(path_564215, query_564216, nil, nil, nil)

var applicationManifestsGet* = Call_ApplicationManifestsGet_564206(
    name: "applicationManifestsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/ApplicationTypes/{applicationTypeName}/$/GetApplicationManifest",
    validator: validate_ApplicationManifestsGet_564207, base: "",
    url: url_ApplicationManifestsGet_564208, schemes: {Scheme.Https})
type
  Call_ServiceManifestsGet_564217 = ref object of OpenApiRestCall_563548
proc url_ServiceManifestsGet_564219(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceManifestsGet_564218(path: JsonNode; query: JsonNode;
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
  var valid_564220 = path.getOrDefault("applicationTypeName")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "applicationTypeName", valid_564220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   ApplicationTypeVersion: JString (required)
  ##                         : The version of the application type
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   ServiceManifestName: JString (required)
  ##                      : The name of the service manifest
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564221 = query.getOrDefault("api-version")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "api-version", valid_564221
  var valid_564222 = query.getOrDefault("ApplicationTypeVersion")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "ApplicationTypeVersion", valid_564222
  var valid_564223 = query.getOrDefault("timeout")
  valid_564223 = validateParameter(valid_564223, JInt, required = false, default = nil)
  if valid_564223 != nil:
    section.add "timeout", valid_564223
  var valid_564224 = query.getOrDefault("ServiceManifestName")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "ServiceManifestName", valid_564224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564225: Call_ServiceManifestsGet_564217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service manifests
  ## 
  let valid = call_564225.validator(path, query, header, formData, body)
  let scheme = call_564225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564225.url(scheme.get, call_564225.host, call_564225.base,
                         call_564225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564225, url, valid)

proc call*(call_564226: Call_ServiceManifestsGet_564217; apiVersion: string;
          ApplicationTypeVersion: string; applicationTypeName: string;
          ServiceManifestName: string; timeout: int = 0): Recallable =
  ## serviceManifestsGet
  ## Get service manifests
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   ApplicationTypeVersion: string (required)
  ##                         : The version of the application type
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type
  ##   ServiceManifestName: string (required)
  ##                      : The name of the service manifest
  var path_564227 = newJObject()
  var query_564228 = newJObject()
  add(query_564228, "api-version", newJString(apiVersion))
  add(query_564228, "ApplicationTypeVersion", newJString(ApplicationTypeVersion))
  add(query_564228, "timeout", newJInt(timeout))
  add(path_564227, "applicationTypeName", newJString(applicationTypeName))
  add(query_564228, "ServiceManifestName", newJString(ServiceManifestName))
  result = call_564226.call(path_564227, query_564228, nil, nil, nil)

var serviceManifestsGet* = Call_ServiceManifestsGet_564217(
    name: "serviceManifestsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/ApplicationTypes/{applicationTypeName}/$/GetServiceManifest",
    validator: validate_ServiceManifestsGet_564218, base: "",
    url: url_ServiceManifestsGet_564219, schemes: {Scheme.Https})
type
  Call_ServiceTypesGet_564229 = ref object of OpenApiRestCall_563548
proc url_ServiceTypesGet_564231(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceTypesGet_564230(path: JsonNode; query: JsonNode;
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
  var valid_564232 = path.getOrDefault("applicationTypeName")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "applicationTypeName", valid_564232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   ApplicationTypeVersion: JString (required)
  ##                         : The version of the application type
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564233 = query.getOrDefault("api-version")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "api-version", valid_564233
  var valid_564234 = query.getOrDefault("ApplicationTypeVersion")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "ApplicationTypeVersion", valid_564234
  var valid_564235 = query.getOrDefault("timeout")
  valid_564235 = validateParameter(valid_564235, JInt, required = false, default = nil)
  if valid_564235 != nil:
    section.add "timeout", valid_564235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564236: Call_ServiceTypesGet_564229; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service types
  ## 
  let valid = call_564236.validator(path, query, header, formData, body)
  let scheme = call_564236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564236.url(scheme.get, call_564236.host, call_564236.base,
                         call_564236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564236, url, valid)

proc call*(call_564237: Call_ServiceTypesGet_564229; apiVersion: string;
          ApplicationTypeVersion: string; applicationTypeName: string;
          timeout: int = 0): Recallable =
  ## serviceTypesGet
  ## Get service types
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   ApplicationTypeVersion: string (required)
  ##                         : The version of the application type
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type
  var path_564238 = newJObject()
  var query_564239 = newJObject()
  add(query_564239, "api-version", newJString(apiVersion))
  add(query_564239, "ApplicationTypeVersion", newJString(ApplicationTypeVersion))
  add(query_564239, "timeout", newJInt(timeout))
  add(path_564238, "applicationTypeName", newJString(applicationTypeName))
  result = call_564237.call(path_564238, query_564239, nil, nil, nil)

var serviceTypesGet* = Call_ServiceTypesGet_564229(name: "serviceTypesGet",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/ApplicationTypes/{applicationTypeName}/$/GetServiceTypes",
    validator: validate_ServiceTypesGet_564230, base: "", url: url_ServiceTypesGet_564231,
    schemes: {Scheme.Https})
type
  Call_ApplicationTypesUnregister_564240 = ref object of OpenApiRestCall_563548
proc url_ApplicationTypesUnregister_564242(protocol: Scheme; host: string;
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

proc validate_ApplicationTypesUnregister_564241(path: JsonNode; query: JsonNode;
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
  var valid_564243 = path.getOrDefault("applicationTypeName")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "applicationTypeName", valid_564243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564244 = query.getOrDefault("api-version")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "api-version", valid_564244
  var valid_564245 = query.getOrDefault("timeout")
  valid_564245 = validateParameter(valid_564245, JInt, required = false, default = nil)
  if valid_564245 != nil:
    section.add "timeout", valid_564245
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

proc call*(call_564247: Call_ApplicationTypesUnregister_564240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unregister application types
  ## 
  let valid = call_564247.validator(path, query, header, formData, body)
  let scheme = call_564247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564247.url(scheme.get, call_564247.host, call_564247.base,
                         call_564247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564247, url, valid)

proc call*(call_564248: Call_ApplicationTypesUnregister_564240; apiVersion: string;
          unregisterApplicationType: JsonNode; applicationTypeName: string;
          timeout: int = 0): Recallable =
  ## applicationTypesUnregister
  ## Unregister application types
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   unregisterApplicationType: JObject (required)
  ##                            : The type of the unregister application
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type
  var path_564249 = newJObject()
  var query_564250 = newJObject()
  var body_564251 = newJObject()
  add(query_564250, "api-version", newJString(apiVersion))
  add(query_564250, "timeout", newJInt(timeout))
  if unregisterApplicationType != nil:
    body_564251 = unregisterApplicationType
  add(path_564249, "applicationTypeName", newJString(applicationTypeName))
  result = call_564248.call(path_564249, query_564250, nil, nil, body_564251)

var applicationTypesUnregister* = Call_ApplicationTypesUnregister_564240(
    name: "applicationTypesUnregister", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/ApplicationTypes/{applicationTypeName}/$/Unprovision",
    validator: validate_ApplicationTypesUnregister_564241, base: "",
    url: url_ApplicationTypesUnregister_564242, schemes: {Scheme.Https})
type
  Call_ApplicationsList_564252 = ref object of OpenApiRestCall_563548
proc url_ApplicationsList_564254(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ApplicationsList_564253(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## List applications
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   continuation-token: JString
  ##                     : The token of the continuation
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  var valid_564255 = query.getOrDefault("continuation-token")
  valid_564255 = validateParameter(valid_564255, JString, required = false,
                                 default = nil)
  if valid_564255 != nil:
    section.add "continuation-token", valid_564255
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564256 = query.getOrDefault("api-version")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "api-version", valid_564256
  var valid_564257 = query.getOrDefault("timeout")
  valid_564257 = validateParameter(valid_564257, JInt, required = false, default = nil)
  if valid_564257 != nil:
    section.add "timeout", valid_564257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564258: Call_ApplicationsList_564252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List applications
  ## 
  let valid = call_564258.validator(path, query, header, formData, body)
  let scheme = call_564258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564258.url(scheme.get, call_564258.host, call_564258.base,
                         call_564258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564258, url, valid)

proc call*(call_564259: Call_ApplicationsList_564252; apiVersion: string;
          continuationToken: string = ""; timeout: int = 0): Recallable =
  ## applicationsList
  ## List applications
  ##   continuationToken: string
  ##                    : The token of the continuation
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  var query_564260 = newJObject()
  add(query_564260, "continuation-token", newJString(continuationToken))
  add(query_564260, "api-version", newJString(apiVersion))
  add(query_564260, "timeout", newJInt(timeout))
  result = call_564259.call(nil, query_564260, nil, nil, nil)

var applicationsList* = Call_ApplicationsList_564252(name: "applicationsList",
    meth: HttpMethod.HttpGet, host: "azure.local:19080", route: "/Applications",
    validator: validate_ApplicationsList_564253, base: "",
    url: url_ApplicationsList_564254, schemes: {Scheme.Https})
type
  Call_ApplicationsCreate_564261 = ref object of OpenApiRestCall_563548
proc url_ApplicationsCreate_564263(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ApplicationsCreate_564262(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Create applications
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564264 = query.getOrDefault("api-version")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "api-version", valid_564264
  var valid_564265 = query.getOrDefault("timeout")
  valid_564265 = validateParameter(valid_564265, JInt, required = false, default = nil)
  if valid_564265 != nil:
    section.add "timeout", valid_564265
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

proc call*(call_564267: Call_ApplicationsCreate_564261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create applications
  ## 
  let valid = call_564267.validator(path, query, header, formData, body)
  let scheme = call_564267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564267.url(scheme.get, call_564267.host, call_564267.base,
                         call_564267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564267, url, valid)

proc call*(call_564268: Call_ApplicationsCreate_564261; apiVersion: string;
          applicationDescription: JsonNode; timeout: int = 0): Recallable =
  ## applicationsCreate
  ## Create applications
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationDescription: JObject (required)
  ##                         : The description of the application
  ##   timeout: int
  ##          : The timeout in seconds
  var query_564269 = newJObject()
  var body_564270 = newJObject()
  add(query_564269, "api-version", newJString(apiVersion))
  if applicationDescription != nil:
    body_564270 = applicationDescription
  add(query_564269, "timeout", newJInt(timeout))
  result = call_564268.call(nil, query_564269, nil, nil, body_564270)

var applicationsCreate* = Call_ApplicationsCreate_564261(
    name: "applicationsCreate", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/$/Create",
    validator: validate_ApplicationsCreate_564262, base: "",
    url: url_ApplicationsCreate_564263, schemes: {Scheme.Https})
type
  Call_ApplicationsGet_564271 = ref object of OpenApiRestCall_563548
proc url_ApplicationsGet_564273(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationsGet_564272(path: JsonNode; query: JsonNode;
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
  var valid_564274 = path.getOrDefault("applicationName")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "applicationName", valid_564274
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564275 = query.getOrDefault("api-version")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "api-version", valid_564275
  var valid_564276 = query.getOrDefault("timeout")
  valid_564276 = validateParameter(valid_564276, JInt, required = false, default = nil)
  if valid_564276 != nil:
    section.add "timeout", valid_564276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564277: Call_ApplicationsGet_564271; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get applications
  ## 
  let valid = call_564277.validator(path, query, header, formData, body)
  let scheme = call_564277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564277.url(scheme.get, call_564277.host, call_564277.base,
                         call_564277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564277, url, valid)

proc call*(call_564278: Call_ApplicationsGet_564271; apiVersion: string;
          applicationName: string; timeout: int = 0): Recallable =
  ## applicationsGet
  ## Get applications
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  var path_564279 = newJObject()
  var query_564280 = newJObject()
  add(query_564280, "api-version", newJString(apiVersion))
  add(path_564279, "applicationName", newJString(applicationName))
  add(query_564280, "timeout", newJInt(timeout))
  result = call_564278.call(path_564279, query_564280, nil, nil, nil)

var applicationsGet* = Call_ApplicationsGet_564271(name: "applicationsGet",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Applications/{applicationName}", validator: validate_ApplicationsGet_564272,
    base: "", url: url_ApplicationsGet_564273, schemes: {Scheme.Https})
type
  Call_ApplicationsRemove_564281 = ref object of OpenApiRestCall_563548
proc url_ApplicationsRemove_564283(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationsRemove_564282(path: JsonNode; query: JsonNode;
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
  var valid_564284 = path.getOrDefault("applicationName")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "applicationName", valid_564284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   ForceRemove: JBool
  ##              : The force remove flag to skip services check
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564285 = query.getOrDefault("api-version")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "api-version", valid_564285
  var valid_564286 = query.getOrDefault("timeout")
  valid_564286 = validateParameter(valid_564286, JInt, required = false, default = nil)
  if valid_564286 != nil:
    section.add "timeout", valid_564286
  var valid_564287 = query.getOrDefault("ForceRemove")
  valid_564287 = validateParameter(valid_564287, JBool, required = false, default = nil)
  if valid_564287 != nil:
    section.add "ForceRemove", valid_564287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564288: Call_ApplicationsRemove_564281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove applications
  ## 
  let valid = call_564288.validator(path, query, header, formData, body)
  let scheme = call_564288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564288.url(scheme.get, call_564288.host, call_564288.base,
                         call_564288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564288, url, valid)

proc call*(call_564289: Call_ApplicationsRemove_564281; apiVersion: string;
          applicationName: string; timeout: int = 0; ForceRemove: bool = false): Recallable =
  ## applicationsRemove
  ## Remove applications
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  ##   ForceRemove: bool
  ##              : The force remove flag to skip services check
  var path_564290 = newJObject()
  var query_564291 = newJObject()
  add(query_564291, "api-version", newJString(apiVersion))
  add(path_564290, "applicationName", newJString(applicationName))
  add(query_564291, "timeout", newJInt(timeout))
  add(query_564291, "ForceRemove", newJBool(ForceRemove))
  result = call_564289.call(path_564290, query_564291, nil, nil, nil)

var applicationsRemove* = Call_ApplicationsRemove_564281(
    name: "applicationsRemove", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/Delete",
    validator: validate_ApplicationsRemove_564282, base: "",
    url: url_ApplicationsRemove_564283, schemes: {Scheme.Https})
type
  Call_ApplicationHealthsGet_564292 = ref object of OpenApiRestCall_563548
proc url_ApplicationHealthsGet_564294(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationHealthsGet_564293(path: JsonNode; query: JsonNode;
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
  var valid_564295 = path.getOrDefault("applicationName")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "applicationName", valid_564295
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   EventsHealthStateFilter: JString
  ##                          : The filter of the events health state
  ##   DeployedApplicationsHealthStateFilter: JString
  ##                                        : The filter of the deployed application health state
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564296 = query.getOrDefault("api-version")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "api-version", valid_564296
  var valid_564297 = query.getOrDefault("timeout")
  valid_564297 = validateParameter(valid_564297, JInt, required = false, default = nil)
  if valid_564297 != nil:
    section.add "timeout", valid_564297
  var valid_564298 = query.getOrDefault("EventsHealthStateFilter")
  valid_564298 = validateParameter(valid_564298, JString, required = false,
                                 default = nil)
  if valid_564298 != nil:
    section.add "EventsHealthStateFilter", valid_564298
  var valid_564299 = query.getOrDefault("DeployedApplicationsHealthStateFilter")
  valid_564299 = validateParameter(valid_564299, JString, required = false,
                                 default = nil)
  if valid_564299 != nil:
    section.add "DeployedApplicationsHealthStateFilter", valid_564299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564300: Call_ApplicationHealthsGet_564292; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get application healths
  ## 
  let valid = call_564300.validator(path, query, header, formData, body)
  let scheme = call_564300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564300.url(scheme.get, call_564300.host, call_564300.base,
                         call_564300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564300, url, valid)

proc call*(call_564301: Call_ApplicationHealthsGet_564292; apiVersion: string;
          applicationName: string; timeout: int = 0;
          EventsHealthStateFilter: string = "";
          DeployedApplicationsHealthStateFilter: string = ""): Recallable =
  ## applicationHealthsGet
  ## Get application healths
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  ##   EventsHealthStateFilter: string
  ##                          : The filter of the events health state
  ##   DeployedApplicationsHealthStateFilter: string
  ##                                        : The filter of the deployed application health state
  var path_564302 = newJObject()
  var query_564303 = newJObject()
  add(query_564303, "api-version", newJString(apiVersion))
  add(path_564302, "applicationName", newJString(applicationName))
  add(query_564303, "timeout", newJInt(timeout))
  add(query_564303, "EventsHealthStateFilter", newJString(EventsHealthStateFilter))
  add(query_564303, "DeployedApplicationsHealthStateFilter",
      newJString(DeployedApplicationsHealthStateFilter))
  result = call_564301.call(path_564302, query_564303, nil, nil, nil)

var applicationHealthsGet* = Call_ApplicationHealthsGet_564292(
    name: "applicationHealthsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Applications/{applicationName}/$/GetHealth",
    validator: validate_ApplicationHealthsGet_564293, base: "",
    url: url_ApplicationHealthsGet_564294, schemes: {Scheme.Https})
type
  Call_ServiceGroupFromTemplatesCreate_564304 = ref object of OpenApiRestCall_563548
proc url_ServiceGroupFromTemplatesCreate_564306(protocol: Scheme; host: string;
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

proc validate_ServiceGroupFromTemplatesCreate_564305(path: JsonNode;
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
  var valid_564307 = path.getOrDefault("applicationName")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "applicationName", valid_564307
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564308 = query.getOrDefault("api-version")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "api-version", valid_564308
  var valid_564309 = query.getOrDefault("timeout")
  valid_564309 = validateParameter(valid_564309, JInt, required = false, default = nil)
  if valid_564309 != nil:
    section.add "timeout", valid_564309
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

proc call*(call_564311: Call_ServiceGroupFromTemplatesCreate_564304;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create service group from templates
  ## 
  let valid = call_564311.validator(path, query, header, formData, body)
  let scheme = call_564311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564311.url(scheme.get, call_564311.host, call_564311.base,
                         call_564311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564311, url, valid)

proc call*(call_564312: Call_ServiceGroupFromTemplatesCreate_564304;
          serviceDescriptionTemplate: JsonNode; apiVersion: string;
          applicationName: string; timeout: int = 0): Recallable =
  ## serviceGroupFromTemplatesCreate
  ## Create service group from templates
  ##   serviceDescriptionTemplate: JObject (required)
  ##                             : The template of the service description
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  var path_564313 = newJObject()
  var query_564314 = newJObject()
  var body_564315 = newJObject()
  if serviceDescriptionTemplate != nil:
    body_564315 = serviceDescriptionTemplate
  add(query_564314, "api-version", newJString(apiVersion))
  add(path_564313, "applicationName", newJString(applicationName))
  add(query_564314, "timeout", newJInt(timeout))
  result = call_564312.call(path_564313, query_564314, nil, nil, body_564315)

var serviceGroupFromTemplatesCreate* = Call_ServiceGroupFromTemplatesCreate_564304(
    name: "serviceGroupFromTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/GetServiceGroups/$/CreateServiceGroupFromTemplate",
    validator: validate_ServiceGroupFromTemplatesCreate_564305, base: "",
    url: url_ServiceGroupFromTemplatesCreate_564306, schemes: {Scheme.Https})
type
  Call_ServiceGroupsRemove_564316 = ref object of OpenApiRestCall_563548
proc url_ServiceGroupsRemove_564318(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceGroupsRemove_564317(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Remove service groups
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service
  ##   applicationName: JString (required)
  ##                  : The name of the application
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564319 = path.getOrDefault("serviceName")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "serviceName", valid_564319
  var valid_564320 = path.getOrDefault("applicationName")
  valid_564320 = validateParameter(valid_564320, JString, required = true,
                                 default = nil)
  if valid_564320 != nil:
    section.add "applicationName", valid_564320
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564321 = query.getOrDefault("api-version")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "api-version", valid_564321
  var valid_564322 = query.getOrDefault("timeout")
  valid_564322 = validateParameter(valid_564322, JInt, required = false, default = nil)
  if valid_564322 != nil:
    section.add "timeout", valid_564322
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564323: Call_ServiceGroupsRemove_564316; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove service groups
  ## 
  let valid = call_564323.validator(path, query, header, formData, body)
  let scheme = call_564323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564323.url(scheme.get, call_564323.host, call_564323.base,
                         call_564323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564323, url, valid)

proc call*(call_564324: Call_ServiceGroupsRemove_564316; serviceName: string;
          apiVersion: string; applicationName: string; timeout: int = 0): Recallable =
  ## serviceGroupsRemove
  ## Remove service groups
  ##   serviceName: string (required)
  ##              : The name of the service
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  var path_564325 = newJObject()
  var query_564326 = newJObject()
  add(path_564325, "serviceName", newJString(serviceName))
  add(query_564326, "api-version", newJString(apiVersion))
  add(path_564325, "applicationName", newJString(applicationName))
  add(query_564326, "timeout", newJInt(timeout))
  result = call_564324.call(path_564325, query_564326, nil, nil, nil)

var serviceGroupsRemove* = Call_ServiceGroupsRemove_564316(
    name: "serviceGroupsRemove", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/GetServiceGroups/{serviceName}/$/Delete",
    validator: validate_ServiceGroupsRemove_564317, base: "",
    url: url_ServiceGroupsRemove_564318, schemes: {Scheme.Https})
type
  Call_ServicesList_564327 = ref object of OpenApiRestCall_563548
proc url_ServicesList_564329(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesList_564328(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564330 = path.getOrDefault("applicationName")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "applicationName", valid_564330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564331 = query.getOrDefault("api-version")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "api-version", valid_564331
  var valid_564332 = query.getOrDefault("timeout")
  valid_564332 = validateParameter(valid_564332, JInt, required = false, default = nil)
  if valid_564332 != nil:
    section.add "timeout", valid_564332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564333: Call_ServicesList_564327; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List services
  ## 
  let valid = call_564333.validator(path, query, header, formData, body)
  let scheme = call_564333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564333.url(scheme.get, call_564333.host, call_564333.base,
                         call_564333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564333, url, valid)

proc call*(call_564334: Call_ServicesList_564327; apiVersion: string;
          applicationName: string; timeout: int = 0): Recallable =
  ## servicesList
  ## List services
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  var path_564335 = newJObject()
  var query_564336 = newJObject()
  add(query_564336, "api-version", newJString(apiVersion))
  add(path_564335, "applicationName", newJString(applicationName))
  add(query_564336, "timeout", newJInt(timeout))
  result = call_564334.call(path_564335, query_564336, nil, nil, nil)

var servicesList* = Call_ServicesList_564327(name: "servicesList",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Applications/{applicationName}/$/GetServices",
    validator: validate_ServicesList_564328, base: "", url: url_ServicesList_564329,
    schemes: {Scheme.Https})
type
  Call_ServicesCreate_564337 = ref object of OpenApiRestCall_563548
proc url_ServicesCreate_564339(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesCreate_564338(path: JsonNode; query: JsonNode;
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
  var valid_564340 = path.getOrDefault("applicationName")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "applicationName", valid_564340
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564341 = query.getOrDefault("api-version")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "api-version", valid_564341
  var valid_564342 = query.getOrDefault("timeout")
  valid_564342 = validateParameter(valid_564342, JInt, required = false, default = nil)
  if valid_564342 != nil:
    section.add "timeout", valid_564342
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

proc call*(call_564344: Call_ServicesCreate_564337; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create services
  ## 
  let valid = call_564344.validator(path, query, header, formData, body)
  let scheme = call_564344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564344.url(scheme.get, call_564344.host, call_564344.base,
                         call_564344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564344, url, valid)

proc call*(call_564345: Call_ServicesCreate_564337; apiVersion: string;
          applicationName: string; createServiceDescription: JsonNode;
          timeout: int = 0): Recallable =
  ## servicesCreate
  ## Create services
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  ##   createServiceDescription: JObject (required)
  ##                           : The description of the service
  var path_564346 = newJObject()
  var query_564347 = newJObject()
  var body_564348 = newJObject()
  add(query_564347, "api-version", newJString(apiVersion))
  add(path_564346, "applicationName", newJString(applicationName))
  add(query_564347, "timeout", newJInt(timeout))
  if createServiceDescription != nil:
    body_564348 = createServiceDescription
  result = call_564345.call(path_564346, query_564347, nil, nil, body_564348)

var servicesCreate* = Call_ServicesCreate_564337(name: "servicesCreate",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Applications/{applicationName}/$/GetServices/$/Create",
    validator: validate_ServicesCreate_564338, base: "", url: url_ServicesCreate_564339,
    schemes: {Scheme.Https})
type
  Call_ServiceFromTemplatesCreate_564349 = ref object of OpenApiRestCall_563548
proc url_ServiceFromTemplatesCreate_564351(protocol: Scheme; host: string;
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

proc validate_ServiceFromTemplatesCreate_564350(path: JsonNode; query: JsonNode;
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
  var valid_564352 = path.getOrDefault("applicationName")
  valid_564352 = validateParameter(valid_564352, JString, required = true,
                                 default = nil)
  if valid_564352 != nil:
    section.add "applicationName", valid_564352
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564353 = query.getOrDefault("api-version")
  valid_564353 = validateParameter(valid_564353, JString, required = true,
                                 default = nil)
  if valid_564353 != nil:
    section.add "api-version", valid_564353
  var valid_564354 = query.getOrDefault("timeout")
  valid_564354 = validateParameter(valid_564354, JInt, required = false, default = nil)
  if valid_564354 != nil:
    section.add "timeout", valid_564354
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

proc call*(call_564356: Call_ServiceFromTemplatesCreate_564349; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create service from templates
  ## 
  let valid = call_564356.validator(path, query, header, formData, body)
  let scheme = call_564356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564356.url(scheme.get, call_564356.host, call_564356.base,
                         call_564356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564356, url, valid)

proc call*(call_564357: Call_ServiceFromTemplatesCreate_564349;
          serviceDescriptionTemplate: JsonNode; apiVersion: string;
          applicationName: string; timeout: int = 0): Recallable =
  ## serviceFromTemplatesCreate
  ## Create service from templates
  ##   serviceDescriptionTemplate: JObject (required)
  ##                             : The template of the service description
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  var path_564358 = newJObject()
  var query_564359 = newJObject()
  var body_564360 = newJObject()
  if serviceDescriptionTemplate != nil:
    body_564360 = serviceDescriptionTemplate
  add(query_564359, "api-version", newJString(apiVersion))
  add(path_564358, "applicationName", newJString(applicationName))
  add(query_564359, "timeout", newJInt(timeout))
  result = call_564357.call(path_564358, query_564359, nil, nil, body_564360)

var serviceFromTemplatesCreate* = Call_ServiceFromTemplatesCreate_564349(
    name: "serviceFromTemplatesCreate", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/GetServices/$/CreateFromTemplate",
    validator: validate_ServiceFromTemplatesCreate_564350, base: "",
    url: url_ServiceFromTemplatesCreate_564351, schemes: {Scheme.Https})
type
  Call_ServiceGroupsCreate_564361 = ref object of OpenApiRestCall_563548
proc url_ServiceGroupsCreate_564363(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceGroupsCreate_564362(path: JsonNode; query: JsonNode;
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
  var valid_564364 = path.getOrDefault("applicationName")
  valid_564364 = validateParameter(valid_564364, JString, required = true,
                                 default = nil)
  if valid_564364 != nil:
    section.add "applicationName", valid_564364
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564365 = query.getOrDefault("api-version")
  valid_564365 = validateParameter(valid_564365, JString, required = true,
                                 default = nil)
  if valid_564365 != nil:
    section.add "api-version", valid_564365
  var valid_564366 = query.getOrDefault("timeout")
  valid_564366 = validateParameter(valid_564366, JInt, required = false, default = nil)
  if valid_564366 != nil:
    section.add "timeout", valid_564366
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

proc call*(call_564368: Call_ServiceGroupsCreate_564361; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create service groups
  ## 
  let valid = call_564368.validator(path, query, header, formData, body)
  let scheme = call_564368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564368.url(scheme.get, call_564368.host, call_564368.base,
                         call_564368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564368, url, valid)

proc call*(call_564369: Call_ServiceGroupsCreate_564361; apiVersion: string;
          applicationName: string; createServiceGroupDescription: JsonNode;
          timeout: int = 0): Recallable =
  ## serviceGroupsCreate
  ## Create service groups
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the service group
  ##   createServiceGroupDescription: JObject (required)
  ##                                : The description of the service group
  ##   timeout: int
  ##          : The timeout in seconds
  var path_564370 = newJObject()
  var query_564371 = newJObject()
  var body_564372 = newJObject()
  add(query_564371, "api-version", newJString(apiVersion))
  add(path_564370, "applicationName", newJString(applicationName))
  if createServiceGroupDescription != nil:
    body_564372 = createServiceGroupDescription
  add(query_564371, "timeout", newJInt(timeout))
  result = call_564369.call(path_564370, query_564371, nil, nil, body_564372)

var serviceGroupsCreate* = Call_ServiceGroupsCreate_564361(
    name: "serviceGroupsCreate", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/GetServices/$/CreateServiceGroup",
    validator: validate_ServiceGroupsCreate_564362, base: "",
    url: url_ServiceGroupsCreate_564363, schemes: {Scheme.Https})
type
  Call_ServicesGet_564373 = ref object of OpenApiRestCall_563548
proc url_ServicesGet_564375(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesGet_564374(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get services
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service
  ##   applicationName: JString (required)
  ##                  : The name of the application
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564376 = path.getOrDefault("serviceName")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "serviceName", valid_564376
  var valid_564377 = path.getOrDefault("applicationName")
  valid_564377 = validateParameter(valid_564377, JString, required = true,
                                 default = nil)
  if valid_564377 != nil:
    section.add "applicationName", valid_564377
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564378 = query.getOrDefault("api-version")
  valid_564378 = validateParameter(valid_564378, JString, required = true,
                                 default = nil)
  if valid_564378 != nil:
    section.add "api-version", valid_564378
  var valid_564379 = query.getOrDefault("timeout")
  valid_564379 = validateParameter(valid_564379, JInt, required = false, default = nil)
  if valid_564379 != nil:
    section.add "timeout", valid_564379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564380: Call_ServicesGet_564373; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get services
  ## 
  let valid = call_564380.validator(path, query, header, formData, body)
  let scheme = call_564380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564380.url(scheme.get, call_564380.host, call_564380.base,
                         call_564380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564380, url, valid)

proc call*(call_564381: Call_ServicesGet_564373; serviceName: string;
          apiVersion: string; applicationName: string; timeout: int = 0): Recallable =
  ## servicesGet
  ## Get services
  ##   serviceName: string (required)
  ##              : The name of the service
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  var path_564382 = newJObject()
  var query_564383 = newJObject()
  add(path_564382, "serviceName", newJString(serviceName))
  add(query_564383, "api-version", newJString(apiVersion))
  add(path_564382, "applicationName", newJString(applicationName))
  add(query_564383, "timeout", newJInt(timeout))
  result = call_564381.call(path_564382, query_564383, nil, nil, nil)

var servicesGet* = Call_ServicesGet_564373(name: "servicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local:19080", route: "/Applications/{applicationName}/$/GetServices/{serviceName}",
                                        validator: validate_ServicesGet_564374,
                                        base: "", url: url_ServicesGet_564375,
                                        schemes: {Scheme.Https})
type
  Call_ServiceGroupDescriptionsGet_564384 = ref object of OpenApiRestCall_563548
proc url_ServiceGroupDescriptionsGet_564386(protocol: Scheme; host: string;
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

proc validate_ServiceGroupDescriptionsGet_564385(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get service group descriptions
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service
  ##   applicationName: JString (required)
  ##                  : The name of the application
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564387 = path.getOrDefault("serviceName")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "serviceName", valid_564387
  var valid_564388 = path.getOrDefault("applicationName")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = nil)
  if valid_564388 != nil:
    section.add "applicationName", valid_564388
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564389 = query.getOrDefault("api-version")
  valid_564389 = validateParameter(valid_564389, JString, required = true,
                                 default = nil)
  if valid_564389 != nil:
    section.add "api-version", valid_564389
  var valid_564390 = query.getOrDefault("timeout")
  valid_564390 = validateParameter(valid_564390, JInt, required = false, default = nil)
  if valid_564390 != nil:
    section.add "timeout", valid_564390
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564391: Call_ServiceGroupDescriptionsGet_564384; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service group descriptions
  ## 
  let valid = call_564391.validator(path, query, header, formData, body)
  let scheme = call_564391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564391.url(scheme.get, call_564391.host, call_564391.base,
                         call_564391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564391, url, valid)

proc call*(call_564392: Call_ServiceGroupDescriptionsGet_564384;
          serviceName: string; apiVersion: string; applicationName: string;
          timeout: int = 0): Recallable =
  ## serviceGroupDescriptionsGet
  ## Get service group descriptions
  ##   serviceName: string (required)
  ##              : The name of the service
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  var path_564393 = newJObject()
  var query_564394 = newJObject()
  add(path_564393, "serviceName", newJString(serviceName))
  add(query_564394, "api-version", newJString(apiVersion))
  add(path_564393, "applicationName", newJString(applicationName))
  add(query_564394, "timeout", newJInt(timeout))
  result = call_564392.call(path_564393, query_564394, nil, nil, nil)

var serviceGroupDescriptionsGet* = Call_ServiceGroupDescriptionsGet_564384(
    name: "serviceGroupDescriptionsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/GetServices/{serviceName}/$/GetServiceGroupDescription",
    validator: validate_ServiceGroupDescriptionsGet_564385, base: "",
    url: url_ServiceGroupDescriptionsGet_564386, schemes: {Scheme.Https})
type
  Call_ServiceGroupMembersGet_564395 = ref object of OpenApiRestCall_563548
proc url_ServiceGroupMembersGet_564397(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceGroupMembersGet_564396(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get service group members
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service
  ##   applicationName: JString (required)
  ##                  : The name of the application
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564398 = path.getOrDefault("serviceName")
  valid_564398 = validateParameter(valid_564398, JString, required = true,
                                 default = nil)
  if valid_564398 != nil:
    section.add "serviceName", valid_564398
  var valid_564399 = path.getOrDefault("applicationName")
  valid_564399 = validateParameter(valid_564399, JString, required = true,
                                 default = nil)
  if valid_564399 != nil:
    section.add "applicationName", valid_564399
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564400 = query.getOrDefault("api-version")
  valid_564400 = validateParameter(valid_564400, JString, required = true,
                                 default = nil)
  if valid_564400 != nil:
    section.add "api-version", valid_564400
  var valid_564401 = query.getOrDefault("timeout")
  valid_564401 = validateParameter(valid_564401, JInt, required = false, default = nil)
  if valid_564401 != nil:
    section.add "timeout", valid_564401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564402: Call_ServiceGroupMembersGet_564395; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service group members
  ## 
  let valid = call_564402.validator(path, query, header, formData, body)
  let scheme = call_564402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564402.url(scheme.get, call_564402.host, call_564402.base,
                         call_564402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564402, url, valid)

proc call*(call_564403: Call_ServiceGroupMembersGet_564395; serviceName: string;
          apiVersion: string; applicationName: string; timeout: int = 0): Recallable =
  ## serviceGroupMembersGet
  ## Get service group members
  ##   serviceName: string (required)
  ##              : The name of the service
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  var path_564404 = newJObject()
  var query_564405 = newJObject()
  add(path_564404, "serviceName", newJString(serviceName))
  add(query_564405, "api-version", newJString(apiVersion))
  add(path_564404, "applicationName", newJString(applicationName))
  add(query_564405, "timeout", newJInt(timeout))
  result = call_564403.call(path_564404, query_564405, nil, nil, nil)

var serviceGroupMembersGet* = Call_ServiceGroupMembersGet_564395(
    name: "serviceGroupMembersGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/GetServices/{serviceName}/$/GetServiceGroupMembers",
    validator: validate_ServiceGroupMembersGet_564396, base: "",
    url: url_ServiceGroupMembersGet_564397, schemes: {Scheme.Https})
type
  Call_ServiceGroupsUpdate_564406 = ref object of OpenApiRestCall_563548
proc url_ServiceGroupsUpdate_564408(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceGroupsUpdate_564407(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Update service groups
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service
  ##   applicationName: JString (required)
  ##                  : The name of the application
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564409 = path.getOrDefault("serviceName")
  valid_564409 = validateParameter(valid_564409, JString, required = true,
                                 default = nil)
  if valid_564409 != nil:
    section.add "serviceName", valid_564409
  var valid_564410 = path.getOrDefault("applicationName")
  valid_564410 = validateParameter(valid_564410, JString, required = true,
                                 default = nil)
  if valid_564410 != nil:
    section.add "applicationName", valid_564410
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564411 = query.getOrDefault("api-version")
  valid_564411 = validateParameter(valid_564411, JString, required = true,
                                 default = nil)
  if valid_564411 != nil:
    section.add "api-version", valid_564411
  var valid_564412 = query.getOrDefault("timeout")
  valid_564412 = validateParameter(valid_564412, JInt, required = false, default = nil)
  if valid_564412 != nil:
    section.add "timeout", valid_564412
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

proc call*(call_564414: Call_ServiceGroupsUpdate_564406; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update service groups
  ## 
  let valid = call_564414.validator(path, query, header, formData, body)
  let scheme = call_564414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564414.url(scheme.get, call_564414.host, call_564414.base,
                         call_564414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564414, url, valid)

proc call*(call_564415: Call_ServiceGroupsUpdate_564406;
          updateServiceGroupDescription: JsonNode; serviceName: string;
          apiVersion: string; applicationName: string; timeout: int = 0): Recallable =
  ## serviceGroupsUpdate
  ## Update service groups
  ##   updateServiceGroupDescription: JObject (required)
  ##                                : The description of the service group update
  ##   serviceName: string (required)
  ##              : The name of the service
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  var path_564416 = newJObject()
  var query_564417 = newJObject()
  var body_564418 = newJObject()
  if updateServiceGroupDescription != nil:
    body_564418 = updateServiceGroupDescription
  add(path_564416, "serviceName", newJString(serviceName))
  add(query_564417, "api-version", newJString(apiVersion))
  add(path_564416, "applicationName", newJString(applicationName))
  add(query_564417, "timeout", newJInt(timeout))
  result = call_564415.call(path_564416, query_564417, nil, nil, body_564418)

var serviceGroupsUpdate* = Call_ServiceGroupsUpdate_564406(
    name: "serviceGroupsUpdate", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/GetServices/{serviceName}/$/UpdateServiceGroup",
    validator: validate_ServiceGroupsUpdate_564407, base: "",
    url: url_ServiceGroupsUpdate_564408, schemes: {Scheme.Https})
type
  Call_ApplicationUpgradesGet_564419 = ref object of OpenApiRestCall_563548
proc url_ApplicationUpgradesGet_564421(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationUpgradesGet_564420(path: JsonNode; query: JsonNode;
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
  var valid_564422 = path.getOrDefault("applicationName")
  valid_564422 = validateParameter(valid_564422, JString, required = true,
                                 default = nil)
  if valid_564422 != nil:
    section.add "applicationName", valid_564422
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564423 = query.getOrDefault("api-version")
  valid_564423 = validateParameter(valid_564423, JString, required = true,
                                 default = nil)
  if valid_564423 != nil:
    section.add "api-version", valid_564423
  var valid_564424 = query.getOrDefault("timeout")
  valid_564424 = validateParameter(valid_564424, JInt, required = false, default = nil)
  if valid_564424 != nil:
    section.add "timeout", valid_564424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564425: Call_ApplicationUpgradesGet_564419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get application upgrades
  ## 
  let valid = call_564425.validator(path, query, header, formData, body)
  let scheme = call_564425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564425.url(scheme.get, call_564425.host, call_564425.base,
                         call_564425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564425, url, valid)

proc call*(call_564426: Call_ApplicationUpgradesGet_564419; apiVersion: string;
          applicationName: string; timeout: int = 0): Recallable =
  ## applicationUpgradesGet
  ## Get application upgrades
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  var path_564427 = newJObject()
  var query_564428 = newJObject()
  add(query_564428, "api-version", newJString(apiVersion))
  add(path_564427, "applicationName", newJString(applicationName))
  add(query_564428, "timeout", newJInt(timeout))
  result = call_564426.call(path_564427, query_564428, nil, nil, nil)

var applicationUpgradesGet* = Call_ApplicationUpgradesGet_564419(
    name: "applicationUpgradesGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Applications/{applicationName}/$/GetUpgradeProgress",
    validator: validate_ApplicationUpgradesGet_564420, base: "",
    url: url_ApplicationUpgradesGet_564421, schemes: {Scheme.Https})
type
  Call_ApplicationUpgradesResume_564429 = ref object of OpenApiRestCall_563548
proc url_ApplicationUpgradesResume_564431(protocol: Scheme; host: string;
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

proc validate_ApplicationUpgradesResume_564430(path: JsonNode; query: JsonNode;
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
  var valid_564432 = path.getOrDefault("applicationName")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "applicationName", valid_564432
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564433 = query.getOrDefault("api-version")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "api-version", valid_564433
  var valid_564434 = query.getOrDefault("timeout")
  valid_564434 = validateParameter(valid_564434, JInt, required = false, default = nil)
  if valid_564434 != nil:
    section.add "timeout", valid_564434
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

proc call*(call_564436: Call_ApplicationUpgradesResume_564429; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resume application upgrades
  ## 
  let valid = call_564436.validator(path, query, header, formData, body)
  let scheme = call_564436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564436.url(scheme.get, call_564436.host, call_564436.base,
                         call_564436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564436, url, valid)

proc call*(call_564437: Call_ApplicationUpgradesResume_564429; apiVersion: string;
          applicationName: string; resumeApplicationUpgrade: JsonNode;
          timeout: int = 0): Recallable =
  ## applicationUpgradesResume
  ## Resume application upgrades
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  ##   resumeApplicationUpgrade: JObject (required)
  ##                           : The upgrade of the resume application
  var path_564438 = newJObject()
  var query_564439 = newJObject()
  var body_564440 = newJObject()
  add(query_564439, "api-version", newJString(apiVersion))
  add(path_564438, "applicationName", newJString(applicationName))
  add(query_564439, "timeout", newJInt(timeout))
  if resumeApplicationUpgrade != nil:
    body_564440 = resumeApplicationUpgrade
  result = call_564437.call(path_564438, query_564439, nil, nil, body_564440)

var applicationUpgradesResume* = Call_ApplicationUpgradesResume_564429(
    name: "applicationUpgradesResume", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationName}/$/MoveNextUpgradeDomain",
    validator: validate_ApplicationUpgradesResume_564430, base: "",
    url: url_ApplicationUpgradesResume_564431, schemes: {Scheme.Https})
type
  Call_ApplicationHealthsSend_564441 = ref object of OpenApiRestCall_563548
proc url_ApplicationHealthsSend_564443(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationHealthsSend_564442(path: JsonNode; query: JsonNode;
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
  var valid_564444 = path.getOrDefault("applicationName")
  valid_564444 = validateParameter(valid_564444, JString, required = true,
                                 default = nil)
  if valid_564444 != nil:
    section.add "applicationName", valid_564444
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564445 = query.getOrDefault("api-version")
  valid_564445 = validateParameter(valid_564445, JString, required = true,
                                 default = nil)
  if valid_564445 != nil:
    section.add "api-version", valid_564445
  var valid_564446 = query.getOrDefault("timeout")
  valid_564446 = validateParameter(valid_564446, JInt, required = false, default = nil)
  if valid_564446 != nil:
    section.add "timeout", valid_564446
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

proc call*(call_564448: Call_ApplicationHealthsSend_564441; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send application health
  ## 
  let valid = call_564448.validator(path, query, header, formData, body)
  let scheme = call_564448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564448.url(scheme.get, call_564448.host, call_564448.base,
                         call_564448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564448, url, valid)

proc call*(call_564449: Call_ApplicationHealthsSend_564441; apiVersion: string;
          applicationName: string; applicationHealthReport: JsonNode;
          timeout: int = 0): Recallable =
  ## applicationHealthsSend
  ## Send application health
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  ##   applicationHealthReport: JObject (required)
  ##                          : The report of the application health
  var path_564450 = newJObject()
  var query_564451 = newJObject()
  var body_564452 = newJObject()
  add(query_564451, "api-version", newJString(apiVersion))
  add(path_564450, "applicationName", newJString(applicationName))
  add(query_564451, "timeout", newJInt(timeout))
  if applicationHealthReport != nil:
    body_564452 = applicationHealthReport
  result = call_564449.call(path_564450, query_564451, nil, nil, body_564452)

var applicationHealthsSend* = Call_ApplicationHealthsSend_564441(
    name: "applicationHealthsSend", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationName}/$/ReportHealth",
    validator: validate_ApplicationHealthsSend_564442, base: "",
    url: url_ApplicationHealthsSend_564443, schemes: {Scheme.Https})
type
  Call_ApplicationUpgradeRollbacksStart_564453 = ref object of OpenApiRestCall_563548
proc url_ApplicationUpgradeRollbacksStart_564455(protocol: Scheme; host: string;
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

proc validate_ApplicationUpgradeRollbacksStart_564454(path: JsonNode;
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
  var valid_564456 = path.getOrDefault("applicationName")
  valid_564456 = validateParameter(valid_564456, JString, required = true,
                                 default = nil)
  if valid_564456 != nil:
    section.add "applicationName", valid_564456
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564457 = query.getOrDefault("api-version")
  valid_564457 = validateParameter(valid_564457, JString, required = true,
                                 default = nil)
  if valid_564457 != nil:
    section.add "api-version", valid_564457
  var valid_564458 = query.getOrDefault("timeout")
  valid_564458 = validateParameter(valid_564458, JInt, required = false, default = nil)
  if valid_564458 != nil:
    section.add "timeout", valid_564458
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564459: Call_ApplicationUpgradeRollbacksStart_564453;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Start application upgrade rollbacks
  ## 
  let valid = call_564459.validator(path, query, header, formData, body)
  let scheme = call_564459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564459.url(scheme.get, call_564459.host, call_564459.base,
                         call_564459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564459, url, valid)

proc call*(call_564460: Call_ApplicationUpgradeRollbacksStart_564453;
          apiVersion: string; applicationName: string; timeout: int = 0): Recallable =
  ## applicationUpgradeRollbacksStart
  ## Start application upgrade rollbacks
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  var path_564461 = newJObject()
  var query_564462 = newJObject()
  add(query_564462, "api-version", newJString(apiVersion))
  add(path_564461, "applicationName", newJString(applicationName))
  add(query_564462, "timeout", newJInt(timeout))
  result = call_564460.call(path_564461, query_564462, nil, nil, nil)

var applicationUpgradeRollbacksStart* = Call_ApplicationUpgradeRollbacksStart_564453(
    name: "applicationUpgradeRollbacksStart", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationName}/$/RollbackUpgrade",
    validator: validate_ApplicationUpgradeRollbacksStart_564454, base: "",
    url: url_ApplicationUpgradeRollbacksStart_564455, schemes: {Scheme.Https})
type
  Call_ApplicationUpgradesUpdate_564463 = ref object of OpenApiRestCall_563548
proc url_ApplicationUpgradesUpdate_564465(protocol: Scheme; host: string;
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

proc validate_ApplicationUpgradesUpdate_564464(path: JsonNode; query: JsonNode;
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
  var valid_564466 = path.getOrDefault("applicationName")
  valid_564466 = validateParameter(valid_564466, JString, required = true,
                                 default = nil)
  if valid_564466 != nil:
    section.add "applicationName", valid_564466
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564467 = query.getOrDefault("api-version")
  valid_564467 = validateParameter(valid_564467, JString, required = true,
                                 default = nil)
  if valid_564467 != nil:
    section.add "api-version", valid_564467
  var valid_564468 = query.getOrDefault("timeout")
  valid_564468 = validateParameter(valid_564468, JInt, required = false, default = nil)
  if valid_564468 != nil:
    section.add "timeout", valid_564468
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

proc call*(call_564470: Call_ApplicationUpgradesUpdate_564463; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update application upgrades
  ## 
  let valid = call_564470.validator(path, query, header, formData, body)
  let scheme = call_564470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564470.url(scheme.get, call_564470.host, call_564470.base,
                         call_564470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564470, url, valid)

proc call*(call_564471: Call_ApplicationUpgradesUpdate_564463; apiVersion: string;
          applicationName: string; updateApplicationUpgrade: JsonNode;
          timeout: int = 0): Recallable =
  ## applicationUpgradesUpdate
  ## Update application upgrades
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  ##   updateApplicationUpgrade: JObject (required)
  ##                           : The description of the update application upgrade
  var path_564472 = newJObject()
  var query_564473 = newJObject()
  var body_564474 = newJObject()
  add(query_564473, "api-version", newJString(apiVersion))
  add(path_564472, "applicationName", newJString(applicationName))
  add(query_564473, "timeout", newJInt(timeout))
  if updateApplicationUpgrade != nil:
    body_564474 = updateApplicationUpgrade
  result = call_564471.call(path_564472, query_564473, nil, nil, body_564474)

var applicationUpgradesUpdate* = Call_ApplicationUpgradesUpdate_564463(
    name: "applicationUpgradesUpdate", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationName}/$/UpdateUpgrade",
    validator: validate_ApplicationUpgradesUpdate_564464, base: "",
    url: url_ApplicationUpgradesUpdate_564465, schemes: {Scheme.Https})
type
  Call_ApplicationUpgradesStart_564475 = ref object of OpenApiRestCall_563548
proc url_ApplicationUpgradesStart_564477(protocol: Scheme; host: string;
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

proc validate_ApplicationUpgradesStart_564476(path: JsonNode; query: JsonNode;
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
  var valid_564478 = path.getOrDefault("applicationName")
  valid_564478 = validateParameter(valid_564478, JString, required = true,
                                 default = nil)
  if valid_564478 != nil:
    section.add "applicationName", valid_564478
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564479 = query.getOrDefault("api-version")
  valid_564479 = validateParameter(valid_564479, JString, required = true,
                                 default = nil)
  if valid_564479 != nil:
    section.add "api-version", valid_564479
  var valid_564480 = query.getOrDefault("timeout")
  valid_564480 = validateParameter(valid_564480, JInt, required = false, default = nil)
  if valid_564480 != nil:
    section.add "timeout", valid_564480
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

proc call*(call_564482: Call_ApplicationUpgradesStart_564475; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Start application upgrades
  ## 
  let valid = call_564482.validator(path, query, header, formData, body)
  let scheme = call_564482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564482.url(scheme.get, call_564482.host, call_564482.base,
                         call_564482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564482, url, valid)

proc call*(call_564483: Call_ApplicationUpgradesStart_564475; apiVersion: string;
          applicationName: string; startApplicationUpgrade: JsonNode;
          timeout: int = 0): Recallable =
  ## applicationUpgradesStart
  ## Start application upgrades
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  ##   startApplicationUpgrade: JObject (required)
  ##                          : The description of the start application upgrade
  var path_564484 = newJObject()
  var query_564485 = newJObject()
  var body_564486 = newJObject()
  add(query_564485, "api-version", newJString(apiVersion))
  add(path_564484, "applicationName", newJString(applicationName))
  add(query_564485, "timeout", newJInt(timeout))
  if startApplicationUpgrade != nil:
    body_564486 = startApplicationUpgrade
  result = call_564483.call(path_564484, query_564485, nil, nil, body_564486)

var applicationUpgradesStart* = Call_ApplicationUpgradesStart_564475(
    name: "applicationUpgradesStart", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationName}/$/Upgrade",
    validator: validate_ApplicationUpgradesStart_564476, base: "",
    url: url_ApplicationUpgradesStart_564477, schemes: {Scheme.Https})
type
  Call_NodesList_564487 = ref object of OpenApiRestCall_563548
proc url_NodesList_564489(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_NodesList_564488(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## List nodes
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   continuation-token: JString
  ##                     : The token of the continuation
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  var valid_564490 = query.getOrDefault("continuation-token")
  valid_564490 = validateParameter(valid_564490, JString, required = false,
                                 default = nil)
  if valid_564490 != nil:
    section.add "continuation-token", valid_564490
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564491 = query.getOrDefault("api-version")
  valid_564491 = validateParameter(valid_564491, JString, required = true,
                                 default = nil)
  if valid_564491 != nil:
    section.add "api-version", valid_564491
  var valid_564492 = query.getOrDefault("timeout")
  valid_564492 = validateParameter(valid_564492, JInt, required = false, default = nil)
  if valid_564492 != nil:
    section.add "timeout", valid_564492
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564493: Call_NodesList_564487; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List nodes
  ## 
  let valid = call_564493.validator(path, query, header, formData, body)
  let scheme = call_564493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564493.url(scheme.get, call_564493.host, call_564493.base,
                         call_564493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564493, url, valid)

proc call*(call_564494: Call_NodesList_564487; apiVersion: string;
          continuationToken: string = ""; timeout: int = 0): Recallable =
  ## nodesList
  ## List nodes
  ##   continuationToken: string
  ##                    : The token of the continuation
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  var query_564495 = newJObject()
  add(query_564495, "continuation-token", newJString(continuationToken))
  add(query_564495, "api-version", newJString(apiVersion))
  add(query_564495, "timeout", newJInt(timeout))
  result = call_564494.call(nil, query_564495, nil, nil, nil)

var nodesList* = Call_NodesList_564487(name: "nodesList", meth: HttpMethod.HttpGet,
                                    host: "azure.local:19080", route: "/Nodes",
                                    validator: validate_NodesList_564488,
                                    base: "", url: url_NodesList_564489,
                                    schemes: {Scheme.Https})
type
  Call_NodesGet_564496 = ref object of OpenApiRestCall_563548
proc url_NodesGet_564498(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_NodesGet_564497(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564499 = path.getOrDefault("nodeName")
  valid_564499 = validateParameter(valid_564499, JString, required = true,
                                 default = nil)
  if valid_564499 != nil:
    section.add "nodeName", valid_564499
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564500 = query.getOrDefault("api-version")
  valid_564500 = validateParameter(valid_564500, JString, required = true,
                                 default = nil)
  if valid_564500 != nil:
    section.add "api-version", valid_564500
  var valid_564501 = query.getOrDefault("timeout")
  valid_564501 = validateParameter(valid_564501, JInt, required = false, default = nil)
  if valid_564501 != nil:
    section.add "timeout", valid_564501
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564502: Call_NodesGet_564496; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get nodes
  ## 
  let valid = call_564502.validator(path, query, header, formData, body)
  let scheme = call_564502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564502.url(scheme.get, call_564502.host, call_564502.base,
                         call_564502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564502, url, valid)

proc call*(call_564503: Call_NodesGet_564496; apiVersion: string; nodeName: string;
          timeout: int = 0): Recallable =
  ## nodesGet
  ## Get nodes
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_564504 = newJObject()
  var query_564505 = newJObject()
  add(query_564505, "api-version", newJString(apiVersion))
  add(query_564505, "timeout", newJInt(timeout))
  add(path_564504, "nodeName", newJString(nodeName))
  result = call_564503.call(path_564504, query_564505, nil, nil, nil)

var nodesGet* = Call_NodesGet_564496(name: "nodesGet", meth: HttpMethod.HttpGet,
                                  host: "azure.local:19080",
                                  route: "/Nodes/{nodeName}",
                                  validator: validate_NodesGet_564497, base: "",
                                  url: url_NodesGet_564498,
                                  schemes: {Scheme.Https})
type
  Call_NodesEnable_564506 = ref object of OpenApiRestCall_563548
proc url_NodesEnable_564508(protocol: Scheme; host: string; base: string;
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

proc validate_NodesEnable_564507(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564509 = path.getOrDefault("nodeName")
  valid_564509 = validateParameter(valid_564509, JString, required = true,
                                 default = nil)
  if valid_564509 != nil:
    section.add "nodeName", valid_564509
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564510 = query.getOrDefault("api-version")
  valid_564510 = validateParameter(valid_564510, JString, required = true,
                                 default = nil)
  if valid_564510 != nil:
    section.add "api-version", valid_564510
  var valid_564511 = query.getOrDefault("timeout")
  valid_564511 = validateParameter(valid_564511, JInt, required = false, default = nil)
  if valid_564511 != nil:
    section.add "timeout", valid_564511
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564512: Call_NodesEnable_564506; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enable nodes
  ## 
  let valid = call_564512.validator(path, query, header, formData, body)
  let scheme = call_564512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564512.url(scheme.get, call_564512.host, call_564512.base,
                         call_564512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564512, url, valid)

proc call*(call_564513: Call_NodesEnable_564506; apiVersion: string;
          nodeName: string; timeout: int = 0): Recallable =
  ## nodesEnable
  ## Enable nodes
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_564514 = newJObject()
  var query_564515 = newJObject()
  add(query_564515, "api-version", newJString(apiVersion))
  add(query_564515, "timeout", newJInt(timeout))
  add(path_564514, "nodeName", newJString(nodeName))
  result = call_564513.call(path_564514, query_564515, nil, nil, nil)

var nodesEnable* = Call_NodesEnable_564506(name: "nodesEnable",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local:19080",
                                        route: "/Nodes/{nodeName}/$/Activate",
                                        validator: validate_NodesEnable_564507,
                                        base: "", url: url_NodesEnable_564508,
                                        schemes: {Scheme.Https})
type
  Call_NodesDisable_564516 = ref object of OpenApiRestCall_563548
proc url_NodesDisable_564518(protocol: Scheme; host: string; base: string;
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

proc validate_NodesDisable_564517(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564519 = path.getOrDefault("nodeName")
  valid_564519 = validateParameter(valid_564519, JString, required = true,
                                 default = nil)
  if valid_564519 != nil:
    section.add "nodeName", valid_564519
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564520 = query.getOrDefault("api-version")
  valid_564520 = validateParameter(valid_564520, JString, required = true,
                                 default = nil)
  if valid_564520 != nil:
    section.add "api-version", valid_564520
  var valid_564521 = query.getOrDefault("timeout")
  valid_564521 = validateParameter(valid_564521, JInt, required = false, default = nil)
  if valid_564521 != nil:
    section.add "timeout", valid_564521
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

proc call*(call_564523: Call_NodesDisable_564516; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Disable nodes
  ## 
  let valid = call_564523.validator(path, query, header, formData, body)
  let scheme = call_564523.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564523.url(scheme.get, call_564523.host, call_564523.base,
                         call_564523.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564523, url, valid)

proc call*(call_564524: Call_NodesDisable_564516; apiVersion: string;
          disableNode: JsonNode; nodeName: string; timeout: int = 0): Recallable =
  ## nodesDisable
  ## Disable nodes
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   disableNode: JObject (required)
  ##              : The node
  ##   timeout: int
  ##          : The timeout in seconds
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_564525 = newJObject()
  var query_564526 = newJObject()
  var body_564527 = newJObject()
  add(query_564526, "api-version", newJString(apiVersion))
  if disableNode != nil:
    body_564527 = disableNode
  add(query_564526, "timeout", newJInt(timeout))
  add(path_564525, "nodeName", newJString(nodeName))
  result = call_564524.call(path_564525, query_564526, nil, nil, body_564527)

var nodesDisable* = Call_NodesDisable_564516(name: "nodesDisable",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/Deactivate", validator: validate_NodesDisable_564517,
    base: "", url: url_NodesDisable_564518, schemes: {Scheme.Https})
type
  Call_DeployedApplicationsList_564528 = ref object of OpenApiRestCall_563548
proc url_DeployedApplicationsList_564530(protocol: Scheme; host: string;
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

proc validate_DeployedApplicationsList_564529(path: JsonNode; query: JsonNode;
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
  var valid_564531 = path.getOrDefault("nodeName")
  valid_564531 = validateParameter(valid_564531, JString, required = true,
                                 default = nil)
  if valid_564531 != nil:
    section.add "nodeName", valid_564531
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564532 = query.getOrDefault("api-version")
  valid_564532 = validateParameter(valid_564532, JString, required = true,
                                 default = nil)
  if valid_564532 != nil:
    section.add "api-version", valid_564532
  var valid_564533 = query.getOrDefault("timeout")
  valid_564533 = validateParameter(valid_564533, JInt, required = false, default = nil)
  if valid_564533 != nil:
    section.add "timeout", valid_564533
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564534: Call_DeployedApplicationsList_564528; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List deployed applications
  ## 
  let valid = call_564534.validator(path, query, header, formData, body)
  let scheme = call_564534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564534.url(scheme.get, call_564534.host, call_564534.base,
                         call_564534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564534, url, valid)

proc call*(call_564535: Call_DeployedApplicationsList_564528; apiVersion: string;
          nodeName: string; timeout: int = 0): Recallable =
  ## deployedApplicationsList
  ## List deployed applications
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_564536 = newJObject()
  var query_564537 = newJObject()
  add(query_564537, "api-version", newJString(apiVersion))
  add(query_564537, "timeout", newJInt(timeout))
  add(path_564536, "nodeName", newJString(nodeName))
  result = call_564535.call(path_564536, query_564537, nil, nil, nil)

var deployedApplicationsList* = Call_DeployedApplicationsList_564528(
    name: "deployedApplicationsList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications",
    validator: validate_DeployedApplicationsList_564529, base: "",
    url: url_DeployedApplicationsList_564530, schemes: {Scheme.Https})
type
  Call_DeployedApplicationsGet_564538 = ref object of OpenApiRestCall_563548
proc url_DeployedApplicationsGet_564540(protocol: Scheme; host: string; base: string;
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

proc validate_DeployedApplicationsGet_564539(path: JsonNode; query: JsonNode;
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
  var valid_564541 = path.getOrDefault("applicationName")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "applicationName", valid_564541
  var valid_564542 = path.getOrDefault("nodeName")
  valid_564542 = validateParameter(valid_564542, JString, required = true,
                                 default = nil)
  if valid_564542 != nil:
    section.add "nodeName", valid_564542
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564543 = query.getOrDefault("api-version")
  valid_564543 = validateParameter(valid_564543, JString, required = true,
                                 default = nil)
  if valid_564543 != nil:
    section.add "api-version", valid_564543
  var valid_564544 = query.getOrDefault("timeout")
  valid_564544 = validateParameter(valid_564544, JInt, required = false, default = nil)
  if valid_564544 != nil:
    section.add "timeout", valid_564544
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564545: Call_DeployedApplicationsGet_564538; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get deployed applications
  ## 
  let valid = call_564545.validator(path, query, header, formData, body)
  let scheme = call_564545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564545.url(scheme.get, call_564545.host, call_564545.base,
                         call_564545.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564545, url, valid)

proc call*(call_564546: Call_DeployedApplicationsGet_564538; apiVersion: string;
          applicationName: string; nodeName: string; timeout: int = 0): Recallable =
  ## deployedApplicationsGet
  ## Get deployed applications
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_564547 = newJObject()
  var query_564548 = newJObject()
  add(query_564548, "api-version", newJString(apiVersion))
  add(path_564547, "applicationName", newJString(applicationName))
  add(query_564548, "timeout", newJInt(timeout))
  add(path_564547, "nodeName", newJString(nodeName))
  result = call_564546.call(path_564547, query_564548, nil, nil, nil)

var deployedApplicationsGet* = Call_DeployedApplicationsGet_564538(
    name: "deployedApplicationsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}",
    validator: validate_DeployedApplicationsGet_564539, base: "",
    url: url_DeployedApplicationsGet_564540, schemes: {Scheme.Https})
type
  Call_DeployedCodePackagesGet_564549 = ref object of OpenApiRestCall_563548
proc url_DeployedCodePackagesGet_564551(protocol: Scheme; host: string; base: string;
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

proc validate_DeployedCodePackagesGet_564550(path: JsonNode; query: JsonNode;
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
  var valid_564552 = path.getOrDefault("applicationName")
  valid_564552 = validateParameter(valid_564552, JString, required = true,
                                 default = nil)
  if valid_564552 != nil:
    section.add "applicationName", valid_564552
  var valid_564553 = path.getOrDefault("nodeName")
  valid_564553 = validateParameter(valid_564553, JString, required = true,
                                 default = nil)
  if valid_564553 != nil:
    section.add "nodeName", valid_564553
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564554 = query.getOrDefault("api-version")
  valid_564554 = validateParameter(valid_564554, JString, required = true,
                                 default = nil)
  if valid_564554 != nil:
    section.add "api-version", valid_564554
  var valid_564555 = query.getOrDefault("timeout")
  valid_564555 = validateParameter(valid_564555, JInt, required = false, default = nil)
  if valid_564555 != nil:
    section.add "timeout", valid_564555
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564556: Call_DeployedCodePackagesGet_564549; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get deployed code packages
  ## 
  let valid = call_564556.validator(path, query, header, formData, body)
  let scheme = call_564556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564556.url(scheme.get, call_564556.host, call_564556.base,
                         call_564556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564556, url, valid)

proc call*(call_564557: Call_DeployedCodePackagesGet_564549; apiVersion: string;
          applicationName: string; nodeName: string; timeout: int = 0): Recallable =
  ## deployedCodePackagesGet
  ## Get deployed code packages
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_564558 = newJObject()
  var query_564559 = newJObject()
  add(query_564559, "api-version", newJString(apiVersion))
  add(path_564558, "applicationName", newJString(applicationName))
  add(query_564559, "timeout", newJInt(timeout))
  add(path_564558, "nodeName", newJString(nodeName))
  result = call_564557.call(path_564558, query_564559, nil, nil, nil)

var deployedCodePackagesGet* = Call_DeployedCodePackagesGet_564549(
    name: "deployedCodePackagesGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}/$/GetCodePackages",
    validator: validate_DeployedCodePackagesGet_564550, base: "",
    url: url_DeployedCodePackagesGet_564551, schemes: {Scheme.Https})
type
  Call_DeployedApplicationHealthsGet_564560 = ref object of OpenApiRestCall_563548
proc url_DeployedApplicationHealthsGet_564562(protocol: Scheme; host: string;
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

proc validate_DeployedApplicationHealthsGet_564561(path: JsonNode; query: JsonNode;
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
  var valid_564563 = path.getOrDefault("applicationName")
  valid_564563 = validateParameter(valid_564563, JString, required = true,
                                 default = nil)
  if valid_564563 != nil:
    section.add "applicationName", valid_564563
  var valid_564564 = path.getOrDefault("nodeName")
  valid_564564 = validateParameter(valid_564564, JString, required = true,
                                 default = nil)
  if valid_564564 != nil:
    section.add "nodeName", valid_564564
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   DeployedServicePackagesHealthStateFilter: JString
  ##                                           : The filter of the deployed service packages health state
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   EventsHealthStateFilter: JString
  ##                          : The filter of the events health state
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564565 = query.getOrDefault("api-version")
  valid_564565 = validateParameter(valid_564565, JString, required = true,
                                 default = nil)
  if valid_564565 != nil:
    section.add "api-version", valid_564565
  var valid_564566 = query.getOrDefault("DeployedServicePackagesHealthStateFilter")
  valid_564566 = validateParameter(valid_564566, JString, required = false,
                                 default = nil)
  if valid_564566 != nil:
    section.add "DeployedServicePackagesHealthStateFilter", valid_564566
  var valid_564567 = query.getOrDefault("timeout")
  valid_564567 = validateParameter(valid_564567, JInt, required = false, default = nil)
  if valid_564567 != nil:
    section.add "timeout", valid_564567
  var valid_564568 = query.getOrDefault("EventsHealthStateFilter")
  valid_564568 = validateParameter(valid_564568, JString, required = false,
                                 default = nil)
  if valid_564568 != nil:
    section.add "EventsHealthStateFilter", valid_564568
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564569: Call_DeployedApplicationHealthsGet_564560; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get deployed application healths
  ## 
  let valid = call_564569.validator(path, query, header, formData, body)
  let scheme = call_564569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564569.url(scheme.get, call_564569.host, call_564569.base,
                         call_564569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564569, url, valid)

proc call*(call_564570: Call_DeployedApplicationHealthsGet_564560;
          apiVersion: string; applicationName: string; nodeName: string;
          DeployedServicePackagesHealthStateFilter: string = ""; timeout: int = 0;
          EventsHealthStateFilter: string = ""): Recallable =
  ## deployedApplicationHealthsGet
  ## Get deployed application healths
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   DeployedServicePackagesHealthStateFilter: string
  ##                                           : The filter of the deployed service packages health state
  ##   timeout: int
  ##          : The timeout in seconds
  ##   nodeName: string (required)
  ##           : The name of the node
  ##   EventsHealthStateFilter: string
  ##                          : The filter of the events health state
  var path_564571 = newJObject()
  var query_564572 = newJObject()
  add(query_564572, "api-version", newJString(apiVersion))
  add(path_564571, "applicationName", newJString(applicationName))
  add(query_564572, "DeployedServicePackagesHealthStateFilter",
      newJString(DeployedServicePackagesHealthStateFilter))
  add(query_564572, "timeout", newJInt(timeout))
  add(path_564571, "nodeName", newJString(nodeName))
  add(query_564572, "EventsHealthStateFilter", newJString(EventsHealthStateFilter))
  result = call_564570.call(path_564571, query_564572, nil, nil, nil)

var deployedApplicationHealthsGet* = Call_DeployedApplicationHealthsGet_564560(
    name: "deployedApplicationHealthsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}/$/GetHealth",
    validator: validate_DeployedApplicationHealthsGet_564561, base: "",
    url: url_DeployedApplicationHealthsGet_564562, schemes: {Scheme.Https})
type
  Call_DeployedReplicasGet_564573 = ref object of OpenApiRestCall_563548
proc url_DeployedReplicasGet_564575(protocol: Scheme; host: string; base: string;
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

proc validate_DeployedReplicasGet_564574(path: JsonNode; query: JsonNode;
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
  var valid_564576 = path.getOrDefault("applicationName")
  valid_564576 = validateParameter(valid_564576, JString, required = true,
                                 default = nil)
  if valid_564576 != nil:
    section.add "applicationName", valid_564576
  var valid_564577 = path.getOrDefault("nodeName")
  valid_564577 = validateParameter(valid_564577, JString, required = true,
                                 default = nil)
  if valid_564577 != nil:
    section.add "nodeName", valid_564577
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564578 = query.getOrDefault("api-version")
  valid_564578 = validateParameter(valid_564578, JString, required = true,
                                 default = nil)
  if valid_564578 != nil:
    section.add "api-version", valid_564578
  var valid_564579 = query.getOrDefault("timeout")
  valid_564579 = validateParameter(valid_564579, JInt, required = false, default = nil)
  if valid_564579 != nil:
    section.add "timeout", valid_564579
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564580: Call_DeployedReplicasGet_564573; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get deployed replicas
  ## 
  let valid = call_564580.validator(path, query, header, formData, body)
  let scheme = call_564580.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564580.url(scheme.get, call_564580.host, call_564580.base,
                         call_564580.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564580, url, valid)

proc call*(call_564581: Call_DeployedReplicasGet_564573; apiVersion: string;
          applicationName: string; nodeName: string; timeout: int = 0): Recallable =
  ## deployedReplicasGet
  ## Get deployed replicas
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_564582 = newJObject()
  var query_564583 = newJObject()
  add(query_564583, "api-version", newJString(apiVersion))
  add(path_564582, "applicationName", newJString(applicationName))
  add(query_564583, "timeout", newJInt(timeout))
  add(path_564582, "nodeName", newJString(nodeName))
  result = call_564581.call(path_564582, query_564583, nil, nil, nil)

var deployedReplicasGet* = Call_DeployedReplicasGet_564573(
    name: "deployedReplicasGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}/$/GetReplicas",
    validator: validate_DeployedReplicasGet_564574, base: "",
    url: url_DeployedReplicasGet_564575, schemes: {Scheme.Https})
type
  Call_DeployedServicePackagesGet_564584 = ref object of OpenApiRestCall_563548
proc url_DeployedServicePackagesGet_564586(protocol: Scheme; host: string;
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

proc validate_DeployedServicePackagesGet_564585(path: JsonNode; query: JsonNode;
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
  var valid_564587 = path.getOrDefault("applicationName")
  valid_564587 = validateParameter(valid_564587, JString, required = true,
                                 default = nil)
  if valid_564587 != nil:
    section.add "applicationName", valid_564587
  var valid_564588 = path.getOrDefault("nodeName")
  valid_564588 = validateParameter(valid_564588, JString, required = true,
                                 default = nil)
  if valid_564588 != nil:
    section.add "nodeName", valid_564588
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564589 = query.getOrDefault("api-version")
  valid_564589 = validateParameter(valid_564589, JString, required = true,
                                 default = nil)
  if valid_564589 != nil:
    section.add "api-version", valid_564589
  var valid_564590 = query.getOrDefault("timeout")
  valid_564590 = validateParameter(valid_564590, JInt, required = false, default = nil)
  if valid_564590 != nil:
    section.add "timeout", valid_564590
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564591: Call_DeployedServicePackagesGet_564584; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get deployed service packages
  ## 
  let valid = call_564591.validator(path, query, header, formData, body)
  let scheme = call_564591.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564591.url(scheme.get, call_564591.host, call_564591.base,
                         call_564591.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564591, url, valid)

proc call*(call_564592: Call_DeployedServicePackagesGet_564584; apiVersion: string;
          applicationName: string; nodeName: string; timeout: int = 0): Recallable =
  ## deployedServicePackagesGet
  ## Get deployed service packages
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_564593 = newJObject()
  var query_564594 = newJObject()
  add(query_564594, "api-version", newJString(apiVersion))
  add(path_564593, "applicationName", newJString(applicationName))
  add(query_564594, "timeout", newJInt(timeout))
  add(path_564593, "nodeName", newJString(nodeName))
  result = call_564592.call(path_564593, query_564594, nil, nil, nil)

var deployedServicePackagesGet* = Call_DeployedServicePackagesGet_564584(
    name: "deployedServicePackagesGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}/$/GetServicePackages",
    validator: validate_DeployedServicePackagesGet_564585, base: "",
    url: url_DeployedServicePackagesGet_564586, schemes: {Scheme.Https})
type
  Call_DeployedServicePackageHealthsSend_564595 = ref object of OpenApiRestCall_563548
proc url_DeployedServicePackageHealthsSend_564597(protocol: Scheme; host: string;
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

proc validate_DeployedServicePackageHealthsSend_564596(path: JsonNode;
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
  var valid_564598 = path.getOrDefault("applicationName")
  valid_564598 = validateParameter(valid_564598, JString, required = true,
                                 default = nil)
  if valid_564598 != nil:
    section.add "applicationName", valid_564598
  var valid_564599 = path.getOrDefault("nodeName")
  valid_564599 = validateParameter(valid_564599, JString, required = true,
                                 default = nil)
  if valid_564599 != nil:
    section.add "nodeName", valid_564599
  var valid_564600 = path.getOrDefault("serviceManifestName")
  valid_564600 = validateParameter(valid_564600, JString, required = true,
                                 default = nil)
  if valid_564600 != nil:
    section.add "serviceManifestName", valid_564600
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564601 = query.getOrDefault("api-version")
  valid_564601 = validateParameter(valid_564601, JString, required = true,
                                 default = nil)
  if valid_564601 != nil:
    section.add "api-version", valid_564601
  var valid_564602 = query.getOrDefault("timeout")
  valid_564602 = validateParameter(valid_564602, JInt, required = false, default = nil)
  if valid_564602 != nil:
    section.add "timeout", valid_564602
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

proc call*(call_564604: Call_DeployedServicePackageHealthsSend_564595;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Send deployed service package health
  ## 
  let valid = call_564604.validator(path, query, header, formData, body)
  let scheme = call_564604.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564604.url(scheme.get, call_564604.host, call_564604.base,
                         call_564604.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564604, url, valid)

proc call*(call_564605: Call_DeployedServicePackageHealthsSend_564595;
          apiVersion: string; applicationName: string; nodeName: string;
          serviceManifestName: string;
          deployedServicePackageHealthReport: JsonNode; timeout: int = 0): Recallable =
  ## deployedServicePackageHealthsSend
  ## Send deployed service package health
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  ##   nodeName: string (required)
  ##           : The name of the node
  ##   serviceManifestName: string (required)
  ##                      : The name of the service manifest
  ##   deployedServicePackageHealthReport: JObject (required)
  ##                                     : The report of the deployed service package health
  var path_564606 = newJObject()
  var query_564607 = newJObject()
  var body_564608 = newJObject()
  add(query_564607, "api-version", newJString(apiVersion))
  add(path_564606, "applicationName", newJString(applicationName))
  add(query_564607, "timeout", newJInt(timeout))
  add(path_564606, "nodeName", newJString(nodeName))
  add(path_564606, "serviceManifestName", newJString(serviceManifestName))
  if deployedServicePackageHealthReport != nil:
    body_564608 = deployedServicePackageHealthReport
  result = call_564605.call(path_564606, query_564607, nil, nil, body_564608)

var deployedServicePackageHealthsSend* = Call_DeployedServicePackageHealthsSend_564595(
    name: "deployedServicePackageHealthsSend", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}/$/GetServicePackages/{serviceManifestName}/$/ReportHealth",
    validator: validate_DeployedServicePackageHealthsSend_564596, base: "",
    url: url_DeployedServicePackageHealthsSend_564597, schemes: {Scheme.Https})
type
  Call_DeployedServicePackageHealthsGet_564609 = ref object of OpenApiRestCall_563548
proc url_DeployedServicePackageHealthsGet_564611(protocol: Scheme; host: string;
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

proc validate_DeployedServicePackageHealthsGet_564610(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get deployed service package healths
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   servicePackageName: JString (required)
  ##                     : The name of the service package
  ##   applicationName: JString (required)
  ##                  : The name of the application
  ##   nodeName: JString (required)
  ##           : The name of the node
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `servicePackageName` field"
  var valid_564612 = path.getOrDefault("servicePackageName")
  valid_564612 = validateParameter(valid_564612, JString, required = true,
                                 default = nil)
  if valid_564612 != nil:
    section.add "servicePackageName", valid_564612
  var valid_564613 = path.getOrDefault("applicationName")
  valid_564613 = validateParameter(valid_564613, JString, required = true,
                                 default = nil)
  if valid_564613 != nil:
    section.add "applicationName", valid_564613
  var valid_564614 = path.getOrDefault("nodeName")
  valid_564614 = validateParameter(valid_564614, JString, required = true,
                                 default = nil)
  if valid_564614 != nil:
    section.add "nodeName", valid_564614
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   EventsHealthStateFilter: JString
  ##                          : The filter of the events health state
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564615 = query.getOrDefault("api-version")
  valid_564615 = validateParameter(valid_564615, JString, required = true,
                                 default = nil)
  if valid_564615 != nil:
    section.add "api-version", valid_564615
  var valid_564616 = query.getOrDefault("timeout")
  valid_564616 = validateParameter(valid_564616, JInt, required = false, default = nil)
  if valid_564616 != nil:
    section.add "timeout", valid_564616
  var valid_564617 = query.getOrDefault("EventsHealthStateFilter")
  valid_564617 = validateParameter(valid_564617, JString, required = false,
                                 default = nil)
  if valid_564617 != nil:
    section.add "EventsHealthStateFilter", valid_564617
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564618: Call_DeployedServicePackageHealthsGet_564609;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get deployed service package healths
  ## 
  let valid = call_564618.validator(path, query, header, formData, body)
  let scheme = call_564618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564618.url(scheme.get, call_564618.host, call_564618.base,
                         call_564618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564618, url, valid)

proc call*(call_564619: Call_DeployedServicePackageHealthsGet_564609;
          servicePackageName: string; apiVersion: string; applicationName: string;
          nodeName: string; timeout: int = 0; EventsHealthStateFilter: string = ""): Recallable =
  ## deployedServicePackageHealthsGet
  ## Get deployed service package healths
  ##   servicePackageName: string (required)
  ##                     : The name of the service package
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  ##   nodeName: string (required)
  ##           : The name of the node
  ##   EventsHealthStateFilter: string
  ##                          : The filter of the events health state
  var path_564620 = newJObject()
  var query_564621 = newJObject()
  add(path_564620, "servicePackageName", newJString(servicePackageName))
  add(query_564621, "api-version", newJString(apiVersion))
  add(path_564620, "applicationName", newJString(applicationName))
  add(query_564621, "timeout", newJInt(timeout))
  add(path_564620, "nodeName", newJString(nodeName))
  add(query_564621, "EventsHealthStateFilter", newJString(EventsHealthStateFilter))
  result = call_564619.call(path_564620, query_564621, nil, nil, nil)

var deployedServicePackageHealthsGet* = Call_DeployedServicePackageHealthsGet_564609(
    name: "deployedServicePackageHealthsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}/$/GetServicePackages/{servicePackageName}/$/GetHealth",
    validator: validate_DeployedServicePackageHealthsGet_564610, base: "",
    url: url_DeployedServicePackageHealthsGet_564611, schemes: {Scheme.Https})
type
  Call_DeployedServiceTypesGet_564622 = ref object of OpenApiRestCall_563548
proc url_DeployedServiceTypesGet_564624(protocol: Scheme; host: string; base: string;
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

proc validate_DeployedServiceTypesGet_564623(path: JsonNode; query: JsonNode;
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
  var valid_564625 = path.getOrDefault("applicationName")
  valid_564625 = validateParameter(valid_564625, JString, required = true,
                                 default = nil)
  if valid_564625 != nil:
    section.add "applicationName", valid_564625
  var valid_564626 = path.getOrDefault("nodeName")
  valid_564626 = validateParameter(valid_564626, JString, required = true,
                                 default = nil)
  if valid_564626 != nil:
    section.add "nodeName", valid_564626
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564627 = query.getOrDefault("api-version")
  valid_564627 = validateParameter(valid_564627, JString, required = true,
                                 default = nil)
  if valid_564627 != nil:
    section.add "api-version", valid_564627
  var valid_564628 = query.getOrDefault("timeout")
  valid_564628 = validateParameter(valid_564628, JInt, required = false, default = nil)
  if valid_564628 != nil:
    section.add "timeout", valid_564628
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564629: Call_DeployedServiceTypesGet_564622; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get deployed service types
  ## 
  let valid = call_564629.validator(path, query, header, formData, body)
  let scheme = call_564629.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564629.url(scheme.get, call_564629.host, call_564629.base,
                         call_564629.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564629, url, valid)

proc call*(call_564630: Call_DeployedServiceTypesGet_564622; apiVersion: string;
          applicationName: string; nodeName: string; timeout: int = 0): Recallable =
  ## deployedServiceTypesGet
  ## Get deployed service types
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_564631 = newJObject()
  var query_564632 = newJObject()
  add(query_564632, "api-version", newJString(apiVersion))
  add(path_564631, "applicationName", newJString(applicationName))
  add(query_564632, "timeout", newJInt(timeout))
  add(path_564631, "nodeName", newJString(nodeName))
  result = call_564630.call(path_564631, query_564632, nil, nil, nil)

var deployedServiceTypesGet* = Call_DeployedServiceTypesGet_564622(
    name: "deployedServiceTypesGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}/$/GetServiceTypes",
    validator: validate_DeployedServiceTypesGet_564623, base: "",
    url: url_DeployedServiceTypesGet_564624, schemes: {Scheme.Https})
type
  Call_DeployedApplicationHealthsSend_564633 = ref object of OpenApiRestCall_563548
proc url_DeployedApplicationHealthsSend_564635(protocol: Scheme; host: string;
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

proc validate_DeployedApplicationHealthsSend_564634(path: JsonNode;
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
  var valid_564636 = path.getOrDefault("applicationName")
  valid_564636 = validateParameter(valid_564636, JString, required = true,
                                 default = nil)
  if valid_564636 != nil:
    section.add "applicationName", valid_564636
  var valid_564637 = path.getOrDefault("nodeName")
  valid_564637 = validateParameter(valid_564637, JString, required = true,
                                 default = nil)
  if valid_564637 != nil:
    section.add "nodeName", valid_564637
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564638 = query.getOrDefault("api-version")
  valid_564638 = validateParameter(valid_564638, JString, required = true,
                                 default = nil)
  if valid_564638 != nil:
    section.add "api-version", valid_564638
  var valid_564639 = query.getOrDefault("timeout")
  valid_564639 = validateParameter(valid_564639, JInt, required = false, default = nil)
  if valid_564639 != nil:
    section.add "timeout", valid_564639
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

proc call*(call_564641: Call_DeployedApplicationHealthsSend_564633; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send deployed application health
  ## 
  let valid = call_564641.validator(path, query, header, formData, body)
  let scheme = call_564641.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564641.url(scheme.get, call_564641.host, call_564641.base,
                         call_564641.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564641, url, valid)

proc call*(call_564642: Call_DeployedApplicationHealthsSend_564633;
          apiVersion: string; applicationName: string; nodeName: string;
          deployedApplicationHealthReport: JsonNode; timeout: int = 0): Recallable =
  ## deployedApplicationHealthsSend
  ## Send deployed application health
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   applicationName: string (required)
  ##                  : The name of the application
  ##   timeout: int
  ##          : The timeout in seconds
  ##   nodeName: string (required)
  ##           : The name of the node
  ##   deployedApplicationHealthReport: JObject (required)
  ##                                  : The report of the deployed application health
  var path_564643 = newJObject()
  var query_564644 = newJObject()
  var body_564645 = newJObject()
  add(query_564644, "api-version", newJString(apiVersion))
  add(path_564643, "applicationName", newJString(applicationName))
  add(query_564644, "timeout", newJInt(timeout))
  add(path_564643, "nodeName", newJString(nodeName))
  if deployedApplicationHealthReport != nil:
    body_564645 = deployedApplicationHealthReport
  result = call_564642.call(path_564643, query_564644, nil, nil, body_564645)

var deployedApplicationHealthsSend* = Call_DeployedApplicationHealthsSend_564633(
    name: "deployedApplicationHealthsSend", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationName}/$/ReportHealth",
    validator: validate_DeployedApplicationHealthsSend_564634, base: "",
    url: url_DeployedApplicationHealthsSend_564635, schemes: {Scheme.Https})
type
  Call_NodeHealthsGet_564646 = ref object of OpenApiRestCall_563548
proc url_NodeHealthsGet_564648(protocol: Scheme; host: string; base: string;
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

proc validate_NodeHealthsGet_564647(path: JsonNode; query: JsonNode;
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
  var valid_564649 = path.getOrDefault("nodeName")
  valid_564649 = validateParameter(valid_564649, JString, required = true,
                                 default = nil)
  if valid_564649 != nil:
    section.add "nodeName", valid_564649
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   EventsHealthStateFilter: JString
  ##                          : The filter of the events health state
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564650 = query.getOrDefault("api-version")
  valid_564650 = validateParameter(valid_564650, JString, required = true,
                                 default = nil)
  if valid_564650 != nil:
    section.add "api-version", valid_564650
  var valid_564651 = query.getOrDefault("timeout")
  valid_564651 = validateParameter(valid_564651, JInt, required = false, default = nil)
  if valid_564651 != nil:
    section.add "timeout", valid_564651
  var valid_564652 = query.getOrDefault("EventsHealthStateFilter")
  valid_564652 = validateParameter(valid_564652, JString, required = false,
                                 default = nil)
  if valid_564652 != nil:
    section.add "EventsHealthStateFilter", valid_564652
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564653: Call_NodeHealthsGet_564646; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get node healths
  ## 
  let valid = call_564653.validator(path, query, header, formData, body)
  let scheme = call_564653.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564653.url(scheme.get, call_564653.host, call_564653.base,
                         call_564653.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564653, url, valid)

proc call*(call_564654: Call_NodeHealthsGet_564646; apiVersion: string;
          nodeName: string; timeout: int = 0; EventsHealthStateFilter: string = ""): Recallable =
  ## nodeHealthsGet
  ## Get node healths
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   nodeName: string (required)
  ##           : The name of the node
  ##   EventsHealthStateFilter: string
  ##                          : The filter of the events health state
  var path_564655 = newJObject()
  var query_564656 = newJObject()
  add(query_564656, "api-version", newJString(apiVersion))
  add(query_564656, "timeout", newJInt(timeout))
  add(path_564655, "nodeName", newJString(nodeName))
  add(query_564656, "EventsHealthStateFilter", newJString(EventsHealthStateFilter))
  result = call_564654.call(path_564655, query_564656, nil, nil, nil)

var nodeHealthsGet* = Call_NodeHealthsGet_564646(name: "nodeHealthsGet",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetHealth", validator: validate_NodeHealthsGet_564647,
    base: "", url: url_NodeHealthsGet_564648, schemes: {Scheme.Https})
type
  Call_NodeLoadInformationsGet_564657 = ref object of OpenApiRestCall_563548
proc url_NodeLoadInformationsGet_564659(protocol: Scheme; host: string; base: string;
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

proc validate_NodeLoadInformationsGet_564658(path: JsonNode; query: JsonNode;
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
  var valid_564660 = path.getOrDefault("nodeName")
  valid_564660 = validateParameter(valid_564660, JString, required = true,
                                 default = nil)
  if valid_564660 != nil:
    section.add "nodeName", valid_564660
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564661 = query.getOrDefault("api-version")
  valid_564661 = validateParameter(valid_564661, JString, required = true,
                                 default = nil)
  if valid_564661 != nil:
    section.add "api-version", valid_564661
  var valid_564662 = query.getOrDefault("timeout")
  valid_564662 = validateParameter(valid_564662, JInt, required = false, default = nil)
  if valid_564662 != nil:
    section.add "timeout", valid_564662
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564663: Call_NodeLoadInformationsGet_564657; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get node load informations
  ## 
  let valid = call_564663.validator(path, query, header, formData, body)
  let scheme = call_564663.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564663.url(scheme.get, call_564663.host, call_564663.base,
                         call_564663.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564663, url, valid)

proc call*(call_564664: Call_NodeLoadInformationsGet_564657; apiVersion: string;
          nodeName: string; timeout: int = 0): Recallable =
  ## nodeLoadInformationsGet
  ## Get node load informations
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_564665 = newJObject()
  var query_564666 = newJObject()
  add(query_564666, "api-version", newJString(apiVersion))
  add(query_564666, "timeout", newJInt(timeout))
  add(path_564665, "nodeName", newJString(nodeName))
  result = call_564664.call(path_564665, query_564666, nil, nil, nil)

var nodeLoadInformationsGet* = Call_NodeLoadInformationsGet_564657(
    name: "nodeLoadInformationsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetLoadInformation",
    validator: validate_NodeLoadInformationsGet_564658, base: "",
    url: url_NodeLoadInformationsGet_564659, schemes: {Scheme.Https})
type
  Call_DeployedReplicaDetailsGet_564667 = ref object of OpenApiRestCall_563548
proc url_DeployedReplicaDetailsGet_564669(protocol: Scheme; host: string;
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

proc validate_DeployedReplicaDetailsGet_564668(path: JsonNode; query: JsonNode;
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
  var valid_564670 = path.getOrDefault("replicaId")
  valid_564670 = validateParameter(valid_564670, JString, required = true,
                                 default = nil)
  if valid_564670 != nil:
    section.add "replicaId", valid_564670
  var valid_564671 = path.getOrDefault("nodeName")
  valid_564671 = validateParameter(valid_564671, JString, required = true,
                                 default = nil)
  if valid_564671 != nil:
    section.add "nodeName", valid_564671
  var valid_564672 = path.getOrDefault("partitionName")
  valid_564672 = validateParameter(valid_564672, JString, required = true,
                                 default = nil)
  if valid_564672 != nil:
    section.add "partitionName", valid_564672
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564673 = query.getOrDefault("api-version")
  valid_564673 = validateParameter(valid_564673, JString, required = true,
                                 default = nil)
  if valid_564673 != nil:
    section.add "api-version", valid_564673
  var valid_564674 = query.getOrDefault("timeout")
  valid_564674 = validateParameter(valid_564674, JInt, required = false, default = nil)
  if valid_564674 != nil:
    section.add "timeout", valid_564674
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564675: Call_DeployedReplicaDetailsGet_564667; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get deployed replica details
  ## 
  let valid = call_564675.validator(path, query, header, formData, body)
  let scheme = call_564675.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564675.url(scheme.get, call_564675.host, call_564675.base,
                         call_564675.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564675, url, valid)

proc call*(call_564676: Call_DeployedReplicaDetailsGet_564667; replicaId: string;
          apiVersion: string; nodeName: string; partitionName: string;
          timeout: int = 0): Recallable =
  ## deployedReplicaDetailsGet
  ## Get deployed replica details
  ##   replicaId: string (required)
  ##            : The id of the replica
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   nodeName: string (required)
  ##           : The name of the node
  ##   partitionName: string (required)
  ##                : The name of the partition
  var path_564677 = newJObject()
  var query_564678 = newJObject()
  add(path_564677, "replicaId", newJString(replicaId))
  add(query_564678, "api-version", newJString(apiVersion))
  add(query_564678, "timeout", newJInt(timeout))
  add(path_564677, "nodeName", newJString(nodeName))
  add(path_564677, "partitionName", newJString(partitionName))
  result = call_564676.call(path_564677, query_564678, nil, nil, nil)

var deployedReplicaDetailsGet* = Call_DeployedReplicaDetailsGet_564667(
    name: "deployedReplicaDetailsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetPartitions/{partitionName}/$/GetReplicas/{replicaId}/$/GetDetail",
    validator: validate_DeployedReplicaDetailsGet_564668, base: "",
    url: url_DeployedReplicaDetailsGet_564669, schemes: {Scheme.Https})
type
  Call_NodeStatesRemove_564679 = ref object of OpenApiRestCall_563548
proc url_NodeStatesRemove_564681(protocol: Scheme; host: string; base: string;
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

proc validate_NodeStatesRemove_564680(path: JsonNode; query: JsonNode;
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
  var valid_564682 = path.getOrDefault("nodeName")
  valid_564682 = validateParameter(valid_564682, JString, required = true,
                                 default = nil)
  if valid_564682 != nil:
    section.add "nodeName", valid_564682
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564683 = query.getOrDefault("api-version")
  valid_564683 = validateParameter(valid_564683, JString, required = true,
                                 default = nil)
  if valid_564683 != nil:
    section.add "api-version", valid_564683
  var valid_564684 = query.getOrDefault("timeout")
  valid_564684 = validateParameter(valid_564684, JInt, required = false, default = nil)
  if valid_564684 != nil:
    section.add "timeout", valid_564684
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564685: Call_NodeStatesRemove_564679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove node states
  ## 
  let valid = call_564685.validator(path, query, header, formData, body)
  let scheme = call_564685.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564685.url(scheme.get, call_564685.host, call_564685.base,
                         call_564685.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564685, url, valid)

proc call*(call_564686: Call_NodeStatesRemove_564679; apiVersion: string;
          nodeName: string; timeout: int = 0): Recallable =
  ## nodeStatesRemove
  ## Remove node states
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   nodeName: string (required)
  ##           : The name of the node
  var path_564687 = newJObject()
  var query_564688 = newJObject()
  add(query_564688, "api-version", newJString(apiVersion))
  add(query_564688, "timeout", newJInt(timeout))
  add(path_564687, "nodeName", newJString(nodeName))
  result = call_564686.call(path_564687, query_564688, nil, nil, nil)

var nodeStatesRemove* = Call_NodeStatesRemove_564679(name: "nodeStatesRemove",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/RemoveNodeState",
    validator: validate_NodeStatesRemove_564680, base: "",
    url: url_NodeStatesRemove_564681, schemes: {Scheme.Https})
type
  Call_NodeHealthsSend_564689 = ref object of OpenApiRestCall_563548
proc url_NodeHealthsSend_564691(protocol: Scheme; host: string; base: string;
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

proc validate_NodeHealthsSend_564690(path: JsonNode; query: JsonNode;
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
  var valid_564692 = path.getOrDefault("nodeName")
  valid_564692 = validateParameter(valid_564692, JString, required = true,
                                 default = nil)
  if valid_564692 != nil:
    section.add "nodeName", valid_564692
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564693 = query.getOrDefault("api-version")
  valid_564693 = validateParameter(valid_564693, JString, required = true,
                                 default = nil)
  if valid_564693 != nil:
    section.add "api-version", valid_564693
  var valid_564694 = query.getOrDefault("timeout")
  valid_564694 = validateParameter(valid_564694, JInt, required = false, default = nil)
  if valid_564694 != nil:
    section.add "timeout", valid_564694
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

proc call*(call_564696: Call_NodeHealthsSend_564689; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send node health
  ## 
  let valid = call_564696.validator(path, query, header, formData, body)
  let scheme = call_564696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564696.url(scheme.get, call_564696.host, call_564696.base,
                         call_564696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564696, url, valid)

proc call*(call_564697: Call_NodeHealthsSend_564689; apiVersion: string;
          nodeName: string; nodeHealthReport: JsonNode; timeout: int = 0): Recallable =
  ## nodeHealthsSend
  ## Send node health
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   nodeName: string (required)
  ##           : The name of the node
  ##   nodeHealthReport: JObject (required)
  ##                   : The report of the node health
  var path_564698 = newJObject()
  var query_564699 = newJObject()
  var body_564700 = newJObject()
  add(query_564699, "api-version", newJString(apiVersion))
  add(query_564699, "timeout", newJInt(timeout))
  add(path_564698, "nodeName", newJString(nodeName))
  if nodeHealthReport != nil:
    body_564700 = nodeHealthReport
  result = call_564697.call(path_564698, query_564699, nil, nil, body_564700)

var nodeHealthsSend* = Call_NodeHealthsSend_564689(name: "nodeHealthsSend",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/ReportHealth",
    validator: validate_NodeHealthsSend_564690, base: "", url: url_NodeHealthsSend_564691,
    schemes: {Scheme.Https})
type
  Call_PartitionHealthsGet_564701 = ref object of OpenApiRestCall_563548
proc url_PartitionHealthsGet_564703(protocol: Scheme; host: string; base: string;
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

proc validate_PartitionHealthsGet_564702(path: JsonNode; query: JsonNode;
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
  var valid_564704 = path.getOrDefault("partitionId")
  valid_564704 = validateParameter(valid_564704, JString, required = true,
                                 default = nil)
  if valid_564704 != nil:
    section.add "partitionId", valid_564704
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   EventsHealthStateFilter: JString
  ##                          : The filter of the events health state
  ##   ReplicasHealthStateFilter: JString
  ##                            : The filter of the replicas health state
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564705 = query.getOrDefault("api-version")
  valid_564705 = validateParameter(valid_564705, JString, required = true,
                                 default = nil)
  if valid_564705 != nil:
    section.add "api-version", valid_564705
  var valid_564706 = query.getOrDefault("timeout")
  valid_564706 = validateParameter(valid_564706, JInt, required = false, default = nil)
  if valid_564706 != nil:
    section.add "timeout", valid_564706
  var valid_564707 = query.getOrDefault("EventsHealthStateFilter")
  valid_564707 = validateParameter(valid_564707, JString, required = false,
                                 default = nil)
  if valid_564707 != nil:
    section.add "EventsHealthStateFilter", valid_564707
  var valid_564708 = query.getOrDefault("ReplicasHealthStateFilter")
  valid_564708 = validateParameter(valid_564708, JString, required = false,
                                 default = nil)
  if valid_564708 != nil:
    section.add "ReplicasHealthStateFilter", valid_564708
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564709: Call_PartitionHealthsGet_564701; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get partition healths
  ## 
  let valid = call_564709.validator(path, query, header, formData, body)
  let scheme = call_564709.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564709.url(scheme.get, call_564709.host, call_564709.base,
                         call_564709.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564709, url, valid)

proc call*(call_564710: Call_PartitionHealthsGet_564701; apiVersion: string;
          partitionId: string; timeout: int = 0; EventsHealthStateFilter: string = "";
          ReplicasHealthStateFilter: string = ""): Recallable =
  ## partitionHealthsGet
  ## Get partition healths
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   partitionId: string (required)
  ##              : The id of the partition
  ##   EventsHealthStateFilter: string
  ##                          : The filter of the events health state
  ##   ReplicasHealthStateFilter: string
  ##                            : The filter of the replicas health state
  var path_564711 = newJObject()
  var query_564712 = newJObject()
  add(query_564712, "api-version", newJString(apiVersion))
  add(query_564712, "timeout", newJInt(timeout))
  add(path_564711, "partitionId", newJString(partitionId))
  add(query_564712, "EventsHealthStateFilter", newJString(EventsHealthStateFilter))
  add(query_564712, "ReplicasHealthStateFilter",
      newJString(ReplicasHealthStateFilter))
  result = call_564710.call(path_564711, query_564712, nil, nil, nil)

var partitionHealthsGet* = Call_PartitionHealthsGet_564701(
    name: "partitionHealthsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/GetHealth",
    validator: validate_PartitionHealthsGet_564702, base: "",
    url: url_PartitionHealthsGet_564703, schemes: {Scheme.Https})
type
  Call_PartitionLoadInformationsGet_564713 = ref object of OpenApiRestCall_563548
proc url_PartitionLoadInformationsGet_564715(protocol: Scheme; host: string;
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

proc validate_PartitionLoadInformationsGet_564714(path: JsonNode; query: JsonNode;
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
  var valid_564716 = path.getOrDefault("partitionId")
  valid_564716 = validateParameter(valid_564716, JString, required = true,
                                 default = nil)
  if valid_564716 != nil:
    section.add "partitionId", valid_564716
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564717 = query.getOrDefault("api-version")
  valid_564717 = validateParameter(valid_564717, JString, required = true,
                                 default = nil)
  if valid_564717 != nil:
    section.add "api-version", valid_564717
  var valid_564718 = query.getOrDefault("timeout")
  valid_564718 = validateParameter(valid_564718, JInt, required = false, default = nil)
  if valid_564718 != nil:
    section.add "timeout", valid_564718
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564719: Call_PartitionLoadInformationsGet_564713; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get partition load informations
  ## 
  let valid = call_564719.validator(path, query, header, formData, body)
  let scheme = call_564719.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564719.url(scheme.get, call_564719.host, call_564719.base,
                         call_564719.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564719, url, valid)

proc call*(call_564720: Call_PartitionLoadInformationsGet_564713;
          apiVersion: string; partitionId: string; timeout: int = 0): Recallable =
  ## partitionLoadInformationsGet
  ## Get partition load informations
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   partitionId: string (required)
  ##              : The id of the partition
  var path_564721 = newJObject()
  var query_564722 = newJObject()
  add(query_564722, "api-version", newJString(apiVersion))
  add(query_564722, "timeout", newJInt(timeout))
  add(path_564721, "partitionId", newJString(partitionId))
  result = call_564720.call(path_564721, query_564722, nil, nil, nil)

var partitionLoadInformationsGet* = Call_PartitionLoadInformationsGet_564713(
    name: "partitionLoadInformationsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetLoadInformation",
    validator: validate_PartitionLoadInformationsGet_564714, base: "",
    url: url_PartitionLoadInformationsGet_564715, schemes: {Scheme.Https})
type
  Call_ReplicasList_564723 = ref object of OpenApiRestCall_563548
proc url_ReplicasList_564725(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicasList_564724(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564726 = path.getOrDefault("partitionId")
  valid_564726 = validateParameter(valid_564726, JString, required = true,
                                 default = nil)
  if valid_564726 != nil:
    section.add "partitionId", valid_564726
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564727 = query.getOrDefault("api-version")
  valid_564727 = validateParameter(valid_564727, JString, required = true,
                                 default = nil)
  if valid_564727 != nil:
    section.add "api-version", valid_564727
  var valid_564728 = query.getOrDefault("timeout")
  valid_564728 = validateParameter(valid_564728, JInt, required = false, default = nil)
  if valid_564728 != nil:
    section.add "timeout", valid_564728
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564729: Call_ReplicasList_564723; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List replicas
  ## 
  let valid = call_564729.validator(path, query, header, formData, body)
  let scheme = call_564729.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564729.url(scheme.get, call_564729.host, call_564729.base,
                         call_564729.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564729, url, valid)

proc call*(call_564730: Call_ReplicasList_564723; apiVersion: string;
          partitionId: string; timeout: int = 0): Recallable =
  ## replicasList
  ## List replicas
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   partitionId: string (required)
  ##              : The id of the partition
  var path_564731 = newJObject()
  var query_564732 = newJObject()
  add(query_564732, "api-version", newJString(apiVersion))
  add(query_564732, "timeout", newJInt(timeout))
  add(path_564731, "partitionId", newJString(partitionId))
  result = call_564730.call(path_564731, query_564732, nil, nil, nil)

var replicasList* = Call_ReplicasList_564723(name: "replicasList",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetReplicas",
    validator: validate_ReplicasList_564724, base: "", url: url_ReplicasList_564725,
    schemes: {Scheme.Https})
type
  Call_ReplicasGet_564733 = ref object of OpenApiRestCall_563548
proc url_ReplicasGet_564735(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicasGet_564734(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564736 = path.getOrDefault("replicaId")
  valid_564736 = validateParameter(valid_564736, JString, required = true,
                                 default = nil)
  if valid_564736 != nil:
    section.add "replicaId", valid_564736
  var valid_564737 = path.getOrDefault("partitionId")
  valid_564737 = validateParameter(valid_564737, JString, required = true,
                                 default = nil)
  if valid_564737 != nil:
    section.add "partitionId", valid_564737
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564738 = query.getOrDefault("api-version")
  valid_564738 = validateParameter(valid_564738, JString, required = true,
                                 default = nil)
  if valid_564738 != nil:
    section.add "api-version", valid_564738
  var valid_564739 = query.getOrDefault("timeout")
  valid_564739 = validateParameter(valid_564739, JInt, required = false, default = nil)
  if valid_564739 != nil:
    section.add "timeout", valid_564739
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564740: Call_ReplicasGet_564733; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get replicas
  ## 
  let valid = call_564740.validator(path, query, header, formData, body)
  let scheme = call_564740.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564740.url(scheme.get, call_564740.host, call_564740.base,
                         call_564740.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564740, url, valid)

proc call*(call_564741: Call_ReplicasGet_564733; replicaId: string;
          apiVersion: string; partitionId: string; timeout: int = 0): Recallable =
  ## replicasGet
  ## Get replicas
  ##   replicaId: string (required)
  ##            : The id of the replica
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   partitionId: string (required)
  ##              : The id of the partition
  var path_564742 = newJObject()
  var query_564743 = newJObject()
  add(path_564742, "replicaId", newJString(replicaId))
  add(query_564743, "api-version", newJString(apiVersion))
  add(query_564743, "timeout", newJInt(timeout))
  add(path_564742, "partitionId", newJString(partitionId))
  result = call_564741.call(path_564742, query_564743, nil, nil, nil)

var replicasGet* = Call_ReplicasGet_564733(name: "replicasGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local:19080", route: "/Partitions/{partitionId}/$/GetReplicas/{replicaId}",
                                        validator: validate_ReplicasGet_564734,
                                        base: "", url: url_ReplicasGet_564735,
                                        schemes: {Scheme.Https})
type
  Call_ReplicaHealthsGet_564744 = ref object of OpenApiRestCall_563548
proc url_ReplicaHealthsGet_564746(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicaHealthsGet_564745(path: JsonNode; query: JsonNode;
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
  var valid_564747 = path.getOrDefault("replicaId")
  valid_564747 = validateParameter(valid_564747, JString, required = true,
                                 default = nil)
  if valid_564747 != nil:
    section.add "replicaId", valid_564747
  var valid_564748 = path.getOrDefault("partitionId")
  valid_564748 = validateParameter(valid_564748, JString, required = true,
                                 default = nil)
  if valid_564748 != nil:
    section.add "partitionId", valid_564748
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   EventsHealthStateFilter: JString
  ##                          : The filter of the events health state
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564749 = query.getOrDefault("api-version")
  valid_564749 = validateParameter(valid_564749, JString, required = true,
                                 default = nil)
  if valid_564749 != nil:
    section.add "api-version", valid_564749
  var valid_564750 = query.getOrDefault("timeout")
  valid_564750 = validateParameter(valid_564750, JInt, required = false, default = nil)
  if valid_564750 != nil:
    section.add "timeout", valid_564750
  var valid_564751 = query.getOrDefault("EventsHealthStateFilter")
  valid_564751 = validateParameter(valid_564751, JString, required = false,
                                 default = nil)
  if valid_564751 != nil:
    section.add "EventsHealthStateFilter", valid_564751
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564752: Call_ReplicaHealthsGet_564744; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get replica healths
  ## 
  let valid = call_564752.validator(path, query, header, formData, body)
  let scheme = call_564752.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564752.url(scheme.get, call_564752.host, call_564752.base,
                         call_564752.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564752, url, valid)

proc call*(call_564753: Call_ReplicaHealthsGet_564744; replicaId: string;
          apiVersion: string; partitionId: string; timeout: int = 0;
          EventsHealthStateFilter: string = ""): Recallable =
  ## replicaHealthsGet
  ## Get replica healths
  ##   replicaId: string (required)
  ##            : The id of the replica
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   partitionId: string (required)
  ##              : The id of the partition
  ##   EventsHealthStateFilter: string
  ##                          : The filter of the events health state
  var path_564754 = newJObject()
  var query_564755 = newJObject()
  add(path_564754, "replicaId", newJString(replicaId))
  add(query_564755, "api-version", newJString(apiVersion))
  add(query_564755, "timeout", newJInt(timeout))
  add(path_564754, "partitionId", newJString(partitionId))
  add(query_564755, "EventsHealthStateFilter", newJString(EventsHealthStateFilter))
  result = call_564753.call(path_564754, query_564755, nil, nil, nil)

var replicaHealthsGet* = Call_ReplicaHealthsGet_564744(name: "replicaHealthsGet",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetReplicas/{replicaId}/$/GetHealth",
    validator: validate_ReplicaHealthsGet_564745, base: "",
    url: url_ReplicaHealthsGet_564746, schemes: {Scheme.Https})
type
  Call_ReplicaLoadInformationsGet_564756 = ref object of OpenApiRestCall_563548
proc url_ReplicaLoadInformationsGet_564758(protocol: Scheme; host: string;
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

proc validate_ReplicaLoadInformationsGet_564757(path: JsonNode; query: JsonNode;
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
  var valid_564759 = path.getOrDefault("replicaId")
  valid_564759 = validateParameter(valid_564759, JString, required = true,
                                 default = nil)
  if valid_564759 != nil:
    section.add "replicaId", valid_564759
  var valid_564760 = path.getOrDefault("partitionId")
  valid_564760 = validateParameter(valid_564760, JString, required = true,
                                 default = nil)
  if valid_564760 != nil:
    section.add "partitionId", valid_564760
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564761 = query.getOrDefault("api-version")
  valid_564761 = validateParameter(valid_564761, JString, required = true,
                                 default = nil)
  if valid_564761 != nil:
    section.add "api-version", valid_564761
  var valid_564762 = query.getOrDefault("timeout")
  valid_564762 = validateParameter(valid_564762, JInt, required = false, default = nil)
  if valid_564762 != nil:
    section.add "timeout", valid_564762
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564763: Call_ReplicaLoadInformationsGet_564756; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get replica load informations
  ## 
  let valid = call_564763.validator(path, query, header, formData, body)
  let scheme = call_564763.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564763.url(scheme.get, call_564763.host, call_564763.base,
                         call_564763.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564763, url, valid)

proc call*(call_564764: Call_ReplicaLoadInformationsGet_564756; replicaId: string;
          apiVersion: string; partitionId: string; timeout: int = 0): Recallable =
  ## replicaLoadInformationsGet
  ## Get replica load informations
  ##   replicaId: string (required)
  ##            : The id of the replica
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   partitionId: string (required)
  ##              : The id of the partition
  var path_564765 = newJObject()
  var query_564766 = newJObject()
  add(path_564765, "replicaId", newJString(replicaId))
  add(query_564766, "api-version", newJString(apiVersion))
  add(query_564766, "timeout", newJInt(timeout))
  add(path_564765, "partitionId", newJString(partitionId))
  result = call_564764.call(path_564765, query_564766, nil, nil, nil)

var replicaLoadInformationsGet* = Call_ReplicaLoadInformationsGet_564756(
    name: "replicaLoadInformationsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/GetReplicas/{replicaId}/$/GetLoadInformation",
    validator: validate_ReplicaLoadInformationsGet_564757, base: "",
    url: url_ReplicaLoadInformationsGet_564758, schemes: {Scheme.Https})
type
  Call_ReplicaHealthsSend_564767 = ref object of OpenApiRestCall_563548
proc url_ReplicaHealthsSend_564769(protocol: Scheme; host: string; base: string;
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

proc validate_ReplicaHealthsSend_564768(path: JsonNode; query: JsonNode;
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
  var valid_564770 = path.getOrDefault("replicaId")
  valid_564770 = validateParameter(valid_564770, JString, required = true,
                                 default = nil)
  if valid_564770 != nil:
    section.add "replicaId", valid_564770
  var valid_564771 = path.getOrDefault("partitionId")
  valid_564771 = validateParameter(valid_564771, JString, required = true,
                                 default = nil)
  if valid_564771 != nil:
    section.add "partitionId", valid_564771
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564772 = query.getOrDefault("api-version")
  valid_564772 = validateParameter(valid_564772, JString, required = true,
                                 default = nil)
  if valid_564772 != nil:
    section.add "api-version", valid_564772
  var valid_564773 = query.getOrDefault("timeout")
  valid_564773 = validateParameter(valid_564773, JInt, required = false, default = nil)
  if valid_564773 != nil:
    section.add "timeout", valid_564773
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

proc call*(call_564775: Call_ReplicaHealthsSend_564767; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send replica healths
  ## 
  let valid = call_564775.validator(path, query, header, formData, body)
  let scheme = call_564775.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564775.url(scheme.get, call_564775.host, call_564775.base,
                         call_564775.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564775, url, valid)

proc call*(call_564776: Call_ReplicaHealthsSend_564767; replicaId: string;
          replicaHealthReport: JsonNode; apiVersion: string; partitionId: string;
          timeout: int = 0): Recallable =
  ## replicaHealthsSend
  ## Send replica healths
  ##   replicaId: string (required)
  ##            : The id of the replica
  ##   replicaHealthReport: JObject (required)
  ##                      : The report of the replica health
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   partitionId: string (required)
  ##              : The id of the partition
  var path_564777 = newJObject()
  var query_564778 = newJObject()
  var body_564779 = newJObject()
  add(path_564777, "replicaId", newJString(replicaId))
  if replicaHealthReport != nil:
    body_564779 = replicaHealthReport
  add(query_564778, "api-version", newJString(apiVersion))
  add(query_564778, "timeout", newJInt(timeout))
  add(path_564777, "partitionId", newJString(partitionId))
  result = call_564776.call(path_564777, query_564778, nil, nil, body_564779)

var replicaHealthsSend* = Call_ReplicaHealthsSend_564767(
    name: "replicaHealthsSend", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/GetReplicas/{replicaId}/$/ReportHealth",
    validator: validate_ReplicaHealthsSend_564768, base: "",
    url: url_ReplicaHealthsSend_564769, schemes: {Scheme.Https})
type
  Call_PartitionsRepair_564780 = ref object of OpenApiRestCall_563548
proc url_PartitionsRepair_564782(protocol: Scheme; host: string; base: string;
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

proc validate_PartitionsRepair_564781(path: JsonNode; query: JsonNode;
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
  var valid_564783 = path.getOrDefault("partitionId")
  valid_564783 = validateParameter(valid_564783, JString, required = true,
                                 default = nil)
  if valid_564783 != nil:
    section.add "partitionId", valid_564783
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564784 = query.getOrDefault("api-version")
  valid_564784 = validateParameter(valid_564784, JString, required = true,
                                 default = nil)
  if valid_564784 != nil:
    section.add "api-version", valid_564784
  var valid_564785 = query.getOrDefault("timeout")
  valid_564785 = validateParameter(valid_564785, JInt, required = false, default = nil)
  if valid_564785 != nil:
    section.add "timeout", valid_564785
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564786: Call_PartitionsRepair_564780; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Repair partitions
  ## 
  let valid = call_564786.validator(path, query, header, formData, body)
  let scheme = call_564786.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564786.url(scheme.get, call_564786.host, call_564786.base,
                         call_564786.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564786, url, valid)

proc call*(call_564787: Call_PartitionsRepair_564780; apiVersion: string;
          partitionId: string; timeout: int = 0): Recallable =
  ## partitionsRepair
  ## Repair partitions
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   partitionId: string (required)
  ##              : The id of the partition
  var path_564788 = newJObject()
  var query_564789 = newJObject()
  add(query_564789, "api-version", newJString(apiVersion))
  add(query_564789, "timeout", newJInt(timeout))
  add(path_564788, "partitionId", newJString(partitionId))
  result = call_564787.call(path_564788, query_564789, nil, nil, nil)

var partitionsRepair* = Call_PartitionsRepair_564780(name: "partitionsRepair",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/Recover",
    validator: validate_PartitionsRepair_564781, base: "",
    url: url_PartitionsRepair_564782, schemes: {Scheme.Https})
type
  Call_PartitionHealthsSend_564790 = ref object of OpenApiRestCall_563548
proc url_PartitionHealthsSend_564792(protocol: Scheme; host: string; base: string;
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

proc validate_PartitionHealthsSend_564791(path: JsonNode; query: JsonNode;
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
  var valid_564793 = path.getOrDefault("partitionId")
  valid_564793 = validateParameter(valid_564793, JString, required = true,
                                 default = nil)
  if valid_564793 != nil:
    section.add "partitionId", valid_564793
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564794 = query.getOrDefault("api-version")
  valid_564794 = validateParameter(valid_564794, JString, required = true,
                                 default = nil)
  if valid_564794 != nil:
    section.add "api-version", valid_564794
  var valid_564795 = query.getOrDefault("timeout")
  valid_564795 = validateParameter(valid_564795, JInt, required = false, default = nil)
  if valid_564795 != nil:
    section.add "timeout", valid_564795
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

proc call*(call_564797: Call_PartitionHealthsSend_564790; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send partition health
  ## 
  let valid = call_564797.validator(path, query, header, formData, body)
  let scheme = call_564797.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564797.url(scheme.get, call_564797.host, call_564797.base,
                         call_564797.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564797, url, valid)

proc call*(call_564798: Call_PartitionHealthsSend_564790; apiVersion: string;
          partitionHealthReport: JsonNode; partitionId: string; timeout: int = 0): Recallable =
  ## partitionHealthsSend
  ## Send partition health
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   partitionHealthReport: JObject (required)
  ##                        : The report of the partition health
  ##   partitionId: string (required)
  ##              : The id of the partition
  var path_564799 = newJObject()
  var query_564800 = newJObject()
  var body_564801 = newJObject()
  add(query_564800, "api-version", newJString(apiVersion))
  add(query_564800, "timeout", newJInt(timeout))
  if partitionHealthReport != nil:
    body_564801 = partitionHealthReport
  add(path_564799, "partitionId", newJString(partitionId))
  result = call_564798.call(path_564799, query_564800, nil, nil, body_564801)

var partitionHealthsSend* = Call_PartitionHealthsSend_564790(
    name: "partitionHealthsSend", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/ReportHealth",
    validator: validate_PartitionHealthsSend_564791, base: "",
    url: url_PartitionHealthsSend_564792, schemes: {Scheme.Https})
type
  Call_PartitionLoadsReset_564802 = ref object of OpenApiRestCall_563548
proc url_PartitionLoadsReset_564804(protocol: Scheme; host: string; base: string;
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

proc validate_PartitionLoadsReset_564803(path: JsonNode; query: JsonNode;
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
  var valid_564805 = path.getOrDefault("partitionId")
  valid_564805 = validateParameter(valid_564805, JString, required = true,
                                 default = nil)
  if valid_564805 != nil:
    section.add "partitionId", valid_564805
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564806 = query.getOrDefault("api-version")
  valid_564806 = validateParameter(valid_564806, JString, required = true,
                                 default = nil)
  if valid_564806 != nil:
    section.add "api-version", valid_564806
  var valid_564807 = query.getOrDefault("timeout")
  valid_564807 = validateParameter(valid_564807, JInt, required = false, default = nil)
  if valid_564807 != nil:
    section.add "timeout", valid_564807
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564808: Call_PartitionLoadsReset_564802; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reset partition loads
  ## 
  let valid = call_564808.validator(path, query, header, formData, body)
  let scheme = call_564808.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564808.url(scheme.get, call_564808.host, call_564808.base,
                         call_564808.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564808, url, valid)

proc call*(call_564809: Call_PartitionLoadsReset_564802; apiVersion: string;
          partitionId: string; timeout: int = 0): Recallable =
  ## partitionLoadsReset
  ## Reset partition loads
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   partitionId: string (required)
  ##              : The id of the partition
  var path_564810 = newJObject()
  var query_564811 = newJObject()
  add(query_564811, "api-version", newJString(apiVersion))
  add(query_564811, "timeout", newJInt(timeout))
  add(path_564810, "partitionId", newJString(partitionId))
  result = call_564809.call(path_564810, query_564811, nil, nil, nil)

var partitionLoadsReset* = Call_PartitionLoadsReset_564802(
    name: "partitionLoadsReset", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/ResetLoad",
    validator: validate_PartitionLoadsReset_564803, base: "",
    url: url_PartitionLoadsReset_564804, schemes: {Scheme.Https})
type
  Call_ServicesRemove_564812 = ref object of OpenApiRestCall_563548
proc url_ServicesRemove_564814(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesRemove_564813(path: JsonNode; query: JsonNode;
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
  var valid_564815 = path.getOrDefault("serviceName")
  valid_564815 = validateParameter(valid_564815, JString, required = true,
                                 default = nil)
  if valid_564815 != nil:
    section.add "serviceName", valid_564815
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564816 = query.getOrDefault("api-version")
  valid_564816 = validateParameter(valid_564816, JString, required = true,
                                 default = nil)
  if valid_564816 != nil:
    section.add "api-version", valid_564816
  var valid_564817 = query.getOrDefault("timeout")
  valid_564817 = validateParameter(valid_564817, JInt, required = false, default = nil)
  if valid_564817 != nil:
    section.add "timeout", valid_564817
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564818: Call_ServicesRemove_564812; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove services
  ## 
  let valid = call_564818.validator(path, query, header, formData, body)
  let scheme = call_564818.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564818.url(scheme.get, call_564818.host, call_564818.base,
                         call_564818.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564818, url, valid)

proc call*(call_564819: Call_ServicesRemove_564812; serviceName: string;
          apiVersion: string; timeout: int = 0): Recallable =
  ## servicesRemove
  ## Remove services
  ##   serviceName: string (required)
  ##              : The name of the service
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  var path_564820 = newJObject()
  var query_564821 = newJObject()
  add(path_564820, "serviceName", newJString(serviceName))
  add(query_564821, "api-version", newJString(apiVersion))
  add(query_564821, "timeout", newJInt(timeout))
  result = call_564819.call(path_564820, query_564821, nil, nil, nil)

var servicesRemove* = Call_ServicesRemove_564812(name: "servicesRemove",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Services/{serviceName}/$/Delete", validator: validate_ServicesRemove_564813,
    base: "", url: url_ServicesRemove_564814, schemes: {Scheme.Https})
type
  Call_ServiceDescriptionsGet_564822 = ref object of OpenApiRestCall_563548
proc url_ServiceDescriptionsGet_564824(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceDescriptionsGet_564823(path: JsonNode; query: JsonNode;
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
  var valid_564825 = path.getOrDefault("serviceName")
  valid_564825 = validateParameter(valid_564825, JString, required = true,
                                 default = nil)
  if valid_564825 != nil:
    section.add "serviceName", valid_564825
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564826 = query.getOrDefault("api-version")
  valid_564826 = validateParameter(valid_564826, JString, required = true,
                                 default = nil)
  if valid_564826 != nil:
    section.add "api-version", valid_564826
  var valid_564827 = query.getOrDefault("timeout")
  valid_564827 = validateParameter(valid_564827, JInt, required = false, default = nil)
  if valid_564827 != nil:
    section.add "timeout", valid_564827
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564828: Call_ServiceDescriptionsGet_564822; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service descriptions
  ## 
  let valid = call_564828.validator(path, query, header, formData, body)
  let scheme = call_564828.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564828.url(scheme.get, call_564828.host, call_564828.base,
                         call_564828.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564828, url, valid)

proc call*(call_564829: Call_ServiceDescriptionsGet_564822; serviceName: string;
          apiVersion: string; timeout: int = 0): Recallable =
  ## serviceDescriptionsGet
  ## Get service descriptions
  ##   serviceName: string (required)
  ##              : The name of the service
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  var path_564830 = newJObject()
  var query_564831 = newJObject()
  add(path_564830, "serviceName", newJString(serviceName))
  add(query_564831, "api-version", newJString(apiVersion))
  add(query_564831, "timeout", newJInt(timeout))
  result = call_564829.call(path_564830, query_564831, nil, nil, nil)

var serviceDescriptionsGet* = Call_ServiceDescriptionsGet_564822(
    name: "serviceDescriptionsGet", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Services/{serviceName}/$/GetDescription",
    validator: validate_ServiceDescriptionsGet_564823, base: "",
    url: url_ServiceDescriptionsGet_564824, schemes: {Scheme.Https})
type
  Call_ServiceHealthsGet_564832 = ref object of OpenApiRestCall_563548
proc url_ServiceHealthsGet_564834(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceHealthsGet_564833(path: JsonNode; query: JsonNode;
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
  var valid_564835 = path.getOrDefault("serviceName")
  valid_564835 = validateParameter(valid_564835, JString, required = true,
                                 default = nil)
  if valid_564835 != nil:
    section.add "serviceName", valid_564835
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564836 = query.getOrDefault("api-version")
  valid_564836 = validateParameter(valid_564836, JString, required = true,
                                 default = nil)
  if valid_564836 != nil:
    section.add "api-version", valid_564836
  var valid_564837 = query.getOrDefault("timeout")
  valid_564837 = validateParameter(valid_564837, JInt, required = false, default = nil)
  if valid_564837 != nil:
    section.add "timeout", valid_564837
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564838: Call_ServiceHealthsGet_564832; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get service healths
  ## 
  let valid = call_564838.validator(path, query, header, formData, body)
  let scheme = call_564838.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564838.url(scheme.get, call_564838.host, call_564838.base,
                         call_564838.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564838, url, valid)

proc call*(call_564839: Call_ServiceHealthsGet_564832; serviceName: string;
          apiVersion: string; timeout: int = 0): Recallable =
  ## serviceHealthsGet
  ## Get service healths
  ##   serviceName: string (required)
  ##              : The name of the service
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  var path_564840 = newJObject()
  var query_564841 = newJObject()
  add(path_564840, "serviceName", newJString(serviceName))
  add(query_564841, "api-version", newJString(apiVersion))
  add(query_564841, "timeout", newJInt(timeout))
  result = call_564839.call(path_564840, query_564841, nil, nil, nil)

var serviceHealthsGet* = Call_ServiceHealthsGet_564832(name: "serviceHealthsGet",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Services/{serviceName}/$/GetHealth",
    validator: validate_ServiceHealthsGet_564833, base: "",
    url: url_ServiceHealthsGet_564834, schemes: {Scheme.Https})
type
  Call_PartitionsList_564842 = ref object of OpenApiRestCall_563548
proc url_PartitionsList_564844(protocol: Scheme; host: string; base: string;
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

proc validate_PartitionsList_564843(path: JsonNode; query: JsonNode;
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
  var valid_564845 = path.getOrDefault("serviceName")
  valid_564845 = validateParameter(valid_564845, JString, required = true,
                                 default = nil)
  if valid_564845 != nil:
    section.add "serviceName", valid_564845
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564846 = query.getOrDefault("api-version")
  valid_564846 = validateParameter(valid_564846, JString, required = true,
                                 default = nil)
  if valid_564846 != nil:
    section.add "api-version", valid_564846
  var valid_564847 = query.getOrDefault("timeout")
  valid_564847 = validateParameter(valid_564847, JInt, required = false, default = nil)
  if valid_564847 != nil:
    section.add "timeout", valid_564847
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564848: Call_PartitionsList_564842; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List partitions
  ## 
  let valid = call_564848.validator(path, query, header, formData, body)
  let scheme = call_564848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564848.url(scheme.get, call_564848.host, call_564848.base,
                         call_564848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564848, url, valid)

proc call*(call_564849: Call_PartitionsList_564842; serviceName: string;
          apiVersion: string; timeout: int = 0): Recallable =
  ## partitionsList
  ## List partitions
  ##   serviceName: string (required)
  ##              : The name of the service
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  var path_564850 = newJObject()
  var query_564851 = newJObject()
  add(path_564850, "serviceName", newJString(serviceName))
  add(query_564851, "api-version", newJString(apiVersion))
  add(query_564851, "timeout", newJInt(timeout))
  result = call_564849.call(path_564850, query_564851, nil, nil, nil)

var partitionsList* = Call_PartitionsList_564842(name: "partitionsList",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Services/{serviceName}/$/GetPartitions",
    validator: validate_PartitionsList_564843, base: "", url: url_PartitionsList_564844,
    schemes: {Scheme.Https})
type
  Call_PartitionListsRepair_564852 = ref object of OpenApiRestCall_563548
proc url_PartitionListsRepair_564854(protocol: Scheme; host: string; base: string;
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

proc validate_PartitionListsRepair_564853(path: JsonNode; query: JsonNode;
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
  var valid_564855 = path.getOrDefault("serviceName")
  valid_564855 = validateParameter(valid_564855, JString, required = true,
                                 default = nil)
  if valid_564855 != nil:
    section.add "serviceName", valid_564855
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564856 = query.getOrDefault("api-version")
  valid_564856 = validateParameter(valid_564856, JString, required = true,
                                 default = nil)
  if valid_564856 != nil:
    section.add "api-version", valid_564856
  var valid_564857 = query.getOrDefault("timeout")
  valid_564857 = validateParameter(valid_564857, JInt, required = false, default = nil)
  if valid_564857 != nil:
    section.add "timeout", valid_564857
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564858: Call_PartitionListsRepair_564852; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Repair partition lists
  ## 
  let valid = call_564858.validator(path, query, header, formData, body)
  let scheme = call_564858.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564858.url(scheme.get, call_564858.host, call_564858.base,
                         call_564858.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564858, url, valid)

proc call*(call_564859: Call_PartitionListsRepair_564852; serviceName: string;
          apiVersion: string; timeout: int = 0): Recallable =
  ## partitionListsRepair
  ## Repair partition lists
  ##   serviceName: string (required)
  ##              : The name of the service
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  var path_564860 = newJObject()
  var query_564861 = newJObject()
  add(path_564860, "serviceName", newJString(serviceName))
  add(query_564861, "api-version", newJString(apiVersion))
  add(query_564861, "timeout", newJInt(timeout))
  result = call_564859.call(path_564860, query_564861, nil, nil, nil)

var partitionListsRepair* = Call_PartitionListsRepair_564852(
    name: "partitionListsRepair", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Services/{serviceName}/$/GetPartitions/$/Recover",
    validator: validate_PartitionListsRepair_564853, base: "",
    url: url_PartitionListsRepair_564854, schemes: {Scheme.Https})
type
  Call_PartitionsGet_564862 = ref object of OpenApiRestCall_563548
proc url_PartitionsGet_564864(protocol: Scheme; host: string; base: string;
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

proc validate_PartitionsGet_564863(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get partitions
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service
  ##   partitionId: JString (required)
  ##              : The id of the partition
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564865 = path.getOrDefault("serviceName")
  valid_564865 = validateParameter(valid_564865, JString, required = true,
                                 default = nil)
  if valid_564865 != nil:
    section.add "serviceName", valid_564865
  var valid_564866 = path.getOrDefault("partitionId")
  valid_564866 = validateParameter(valid_564866, JString, required = true,
                                 default = nil)
  if valid_564866 != nil:
    section.add "partitionId", valid_564866
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564867 = query.getOrDefault("api-version")
  valid_564867 = validateParameter(valid_564867, JString, required = true,
                                 default = nil)
  if valid_564867 != nil:
    section.add "api-version", valid_564867
  var valid_564868 = query.getOrDefault("timeout")
  valid_564868 = validateParameter(valid_564868, JInt, required = false, default = nil)
  if valid_564868 != nil:
    section.add "timeout", valid_564868
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564869: Call_PartitionsGet_564862; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get partitions
  ## 
  let valid = call_564869.validator(path, query, header, formData, body)
  let scheme = call_564869.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564869.url(scheme.get, call_564869.host, call_564869.base,
                         call_564869.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564869, url, valid)

proc call*(call_564870: Call_PartitionsGet_564862; serviceName: string;
          apiVersion: string; partitionId: string; timeout: int = 0): Recallable =
  ## partitionsGet
  ## Get partitions
  ##   serviceName: string (required)
  ##              : The name of the service
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   partitionId: string (required)
  ##              : The id of the partition
  var path_564871 = newJObject()
  var query_564872 = newJObject()
  add(path_564871, "serviceName", newJString(serviceName))
  add(query_564872, "api-version", newJString(apiVersion))
  add(query_564872, "timeout", newJInt(timeout))
  add(path_564871, "partitionId", newJString(partitionId))
  result = call_564870.call(path_564871, query_564872, nil, nil, nil)

var partitionsGet* = Call_PartitionsGet_564862(name: "partitionsGet",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Services/{serviceName}/$/GetPartitions/{partitionId}",
    validator: validate_PartitionsGet_564863, base: "", url: url_PartitionsGet_564864,
    schemes: {Scheme.Https})
type
  Call_ServiceHealthsSend_564873 = ref object of OpenApiRestCall_563548
proc url_ServiceHealthsSend_564875(protocol: Scheme; host: string; base: string;
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

proc validate_ServiceHealthsSend_564874(path: JsonNode; query: JsonNode;
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
  var valid_564876 = path.getOrDefault("serviceName")
  valid_564876 = validateParameter(valid_564876, JString, required = true,
                                 default = nil)
  if valid_564876 != nil:
    section.add "serviceName", valid_564876
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564877 = query.getOrDefault("api-version")
  valid_564877 = validateParameter(valid_564877, JString, required = true,
                                 default = nil)
  if valid_564877 != nil:
    section.add "api-version", valid_564877
  var valid_564878 = query.getOrDefault("timeout")
  valid_564878 = validateParameter(valid_564878, JInt, required = false, default = nil)
  if valid_564878 != nil:
    section.add "timeout", valid_564878
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

proc call*(call_564880: Call_ServiceHealthsSend_564873; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Send service healths
  ## 
  let valid = call_564880.validator(path, query, header, formData, body)
  let scheme = call_564880.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564880.url(scheme.get, call_564880.host, call_564880.base,
                         call_564880.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564880, url, valid)

proc call*(call_564881: Call_ServiceHealthsSend_564873; serviceName: string;
          apiVersion: string; serviceHealthReport: JsonNode; timeout: int = 0): Recallable =
  ## serviceHealthsSend
  ## Send service healths
  ##   serviceName: string (required)
  ##              : The name of the service
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   serviceHealthReport: JObject (required)
  ##                      : The report of the service health
  ##   timeout: int
  ##          : The timeout in seconds
  var path_564882 = newJObject()
  var query_564883 = newJObject()
  var body_564884 = newJObject()
  add(path_564882, "serviceName", newJString(serviceName))
  add(query_564883, "api-version", newJString(apiVersion))
  if serviceHealthReport != nil:
    body_564884 = serviceHealthReport
  add(query_564883, "timeout", newJInt(timeout))
  result = call_564881.call(path_564882, query_564883, nil, nil, body_564884)

var serviceHealthsSend* = Call_ServiceHealthsSend_564873(
    name: "serviceHealthsSend", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Services/{serviceName}/$/ReportHealth",
    validator: validate_ServiceHealthsSend_564874, base: "",
    url: url_ServiceHealthsSend_564875, schemes: {Scheme.Https})
type
  Call_ServicesResolve_564885 = ref object of OpenApiRestCall_563548
proc url_ServicesResolve_564887(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesResolve_564886(path: JsonNode; query: JsonNode;
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
  var valid_564888 = path.getOrDefault("serviceName")
  valid_564888 = validateParameter(valid_564888, JString, required = true,
                                 default = nil)
  if valid_564888 != nil:
    section.add "serviceName", valid_564888
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   PartitionKeyValue: JString
  ##                    : The value of the partition key
  ##   timeout: JInt
  ##          : The timeout in seconds
  ##   PartitionKeyType: JInt
  ##                   : The type of the partition key
  ##   PreviousRspVersion: JString
  ##                     : The version of the previous rsp
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564889 = query.getOrDefault("api-version")
  valid_564889 = validateParameter(valid_564889, JString, required = true,
                                 default = nil)
  if valid_564889 != nil:
    section.add "api-version", valid_564889
  var valid_564890 = query.getOrDefault("PartitionKeyValue")
  valid_564890 = validateParameter(valid_564890, JString, required = false,
                                 default = nil)
  if valid_564890 != nil:
    section.add "PartitionKeyValue", valid_564890
  var valid_564891 = query.getOrDefault("timeout")
  valid_564891 = validateParameter(valid_564891, JInt, required = false, default = nil)
  if valid_564891 != nil:
    section.add "timeout", valid_564891
  var valid_564892 = query.getOrDefault("PartitionKeyType")
  valid_564892 = validateParameter(valid_564892, JInt, required = false, default = nil)
  if valid_564892 != nil:
    section.add "PartitionKeyType", valid_564892
  var valid_564893 = query.getOrDefault("PreviousRspVersion")
  valid_564893 = validateParameter(valid_564893, JString, required = false,
                                 default = nil)
  if valid_564893 != nil:
    section.add "PreviousRspVersion", valid_564893
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564894: Call_ServicesResolve_564885; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resolve services
  ## 
  let valid = call_564894.validator(path, query, header, formData, body)
  let scheme = call_564894.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564894.url(scheme.get, call_564894.host, call_564894.base,
                         call_564894.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564894, url, valid)

proc call*(call_564895: Call_ServicesResolve_564885; serviceName: string;
          apiVersion: string; PartitionKeyValue: string = ""; timeout: int = 0;
          PartitionKeyType: int = 0; PreviousRspVersion: string = ""): Recallable =
  ## servicesResolve
  ## Resolve services
  ##   serviceName: string (required)
  ##              : The name of the service
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   PartitionKeyValue: string
  ##                    : The value of the partition key
  ##   timeout: int
  ##          : The timeout in seconds
  ##   PartitionKeyType: int
  ##                   : The type of the partition key
  ##   PreviousRspVersion: string
  ##                     : The version of the previous rsp
  var path_564896 = newJObject()
  var query_564897 = newJObject()
  add(path_564896, "serviceName", newJString(serviceName))
  add(query_564897, "api-version", newJString(apiVersion))
  add(query_564897, "PartitionKeyValue", newJString(PartitionKeyValue))
  add(query_564897, "timeout", newJInt(timeout))
  add(query_564897, "PartitionKeyType", newJInt(PartitionKeyType))
  add(query_564897, "PreviousRspVersion", newJString(PreviousRspVersion))
  result = call_564895.call(path_564896, query_564897, nil, nil, nil)

var servicesResolve* = Call_ServicesResolve_564885(name: "servicesResolve",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Services/{serviceName}/$/ResolvePartition",
    validator: validate_ServicesResolve_564886, base: "", url: url_ServicesResolve_564887,
    schemes: {Scheme.Https})
type
  Call_ServicesUpdate_564898 = ref object of OpenApiRestCall_563548
proc url_ServicesUpdate_564900(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesUpdate_564899(path: JsonNode; query: JsonNode;
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
  var valid_564901 = path.getOrDefault("serviceName")
  valid_564901 = validateParameter(valid_564901, JString, required = true,
                                 default = nil)
  if valid_564901 != nil:
    section.add "serviceName", valid_564901
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the api
  ##   timeout: JInt
  ##          : The timeout in seconds
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564902 = query.getOrDefault("api-version")
  valid_564902 = validateParameter(valid_564902, JString, required = true,
                                 default = nil)
  if valid_564902 != nil:
    section.add "api-version", valid_564902
  var valid_564903 = query.getOrDefault("timeout")
  valid_564903 = validateParameter(valid_564903, JInt, required = false, default = nil)
  if valid_564903 != nil:
    section.add "timeout", valid_564903
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

proc call*(call_564905: Call_ServicesUpdate_564898; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update services
  ## 
  let valid = call_564905.validator(path, query, header, formData, body)
  let scheme = call_564905.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564905.url(scheme.get, call_564905.host, call_564905.base,
                         call_564905.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564905, url, valid)

proc call*(call_564906: Call_ServicesUpdate_564898; serviceName: string;
          apiVersion: string; updateServiceDescription: JsonNode; timeout: int = 0): Recallable =
  ## servicesUpdate
  ## Update services
  ##   serviceName: string (required)
  ##              : The name of the service
  ##   apiVersion: string (required)
  ##             : The version of the api
  ##   timeout: int
  ##          : The timeout in seconds
  ##   updateServiceDescription: JObject (required)
  ##                           : The description of the service update
  var path_564907 = newJObject()
  var query_564908 = newJObject()
  var body_564909 = newJObject()
  add(path_564907, "serviceName", newJString(serviceName))
  add(query_564908, "api-version", newJString(apiVersion))
  add(query_564908, "timeout", newJInt(timeout))
  if updateServiceDescription != nil:
    body_564909 = updateServiceDescription
  result = call_564906.call(path_564907, query_564908, nil, nil, body_564909)

var servicesUpdate* = Call_ServicesUpdate_564898(name: "servicesUpdate",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Services/{serviceName}/$/Update", validator: validate_ServicesUpdate_564899,
    base: "", url: url_ServicesUpdate_564900, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
