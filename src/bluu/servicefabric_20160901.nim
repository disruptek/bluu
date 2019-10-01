
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ServiceFabricManagementClient
## version: 2016-09-01
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  Call_OperationsList_567879 = ref object of OpenApiRestCall_567657
proc url_OperationsList_567881(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567880(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available ServiceFabric REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the ServiceFabric resource provider api
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568040 = query.getOrDefault("api-version")
  valid_568040 = validateParameter(valid_568040, JString, required = true,
                                 default = nil)
  if valid_568040 != nil:
    section.add "api-version", valid_568040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568063: Call_OperationsList_567879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available ServiceFabric REST API operations.
  ## 
  let valid = call_568063.validator(path, query, header, formData, body)
  let scheme = call_568063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568063.url(scheme.get, call_568063.host, call_568063.base,
                         call_568063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568063, url, valid)

proc call*(call_568134: Call_OperationsList_567879; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available ServiceFabric REST API operations.
  ##   apiVersion: string (required)
  ##             : The version of the ServiceFabric resource provider api
  var query_568135 = newJObject()
  add(query_568135, "api-version", newJString(apiVersion))
  result = call_568134.call(nil, query_568135, nil, nil, nil)

var operationsList* = Call_OperationsList_567879(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ServiceFabric/operations",
    validator: validate_OperationsList_567880, base: "", url: url_OperationsList_567881,
    schemes: {Scheme.Https})
type
  Call_ClustersList_568175 = ref object of OpenApiRestCall_567657
proc url_ClustersList_568177(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersList_568176(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List cluster resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568192 = path.getOrDefault("subscriptionId")
  valid_568192 = validateParameter(valid_568192, JString, required = true,
                                 default = nil)
  if valid_568192 != nil:
    section.add "subscriptionId", valid_568192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the ServiceFabric resource provider api
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568193 = query.getOrDefault("api-version")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "api-version", valid_568193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568194: Call_ClustersList_568175; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List cluster resource
  ## 
  let valid = call_568194.validator(path, query, header, formData, body)
  let scheme = call_568194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568194.url(scheme.get, call_568194.host, call_568194.base,
                         call_568194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568194, url, valid)

proc call*(call_568195: Call_ClustersList_568175; apiVersion: string;
          subscriptionId: string): Recallable =
  ## clustersList
  ## List cluster resource
  ##   apiVersion: string (required)
  ##             : The version of the ServiceFabric resource provider api
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568196 = newJObject()
  var query_568197 = newJObject()
  add(query_568197, "api-version", newJString(apiVersion))
  add(path_568196, "subscriptionId", newJString(subscriptionId))
  result = call_568195.call(path_568196, query_568197, nil, nil, nil)

var clustersList* = Call_ClustersList_568175(name: "clustersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabric/clusters",
    validator: validate_ClustersList_568176, base: "", url: url_ClustersList_568177,
    schemes: {Scheme.Https})
type
  Call_ClusterVersionsList_568198 = ref object of OpenApiRestCall_567657
proc url_ClusterVersionsList_568200(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/clusterVersions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClusterVersionsList_568199(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List cluster code versions by location
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   location: JString (required)
  ##           : The location for the cluster code versions, this is different from cluster location
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568201 = path.getOrDefault("subscriptionId")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "subscriptionId", valid_568201
  var valid_568202 = path.getOrDefault("location")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "location", valid_568202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the ServiceFabric resource provider api
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568203 = query.getOrDefault("api-version")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "api-version", valid_568203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568204: Call_ClusterVersionsList_568198; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List cluster code versions by location
  ## 
  let valid = call_568204.validator(path, query, header, formData, body)
  let scheme = call_568204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568204.url(scheme.get, call_568204.host, call_568204.base,
                         call_568204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568204, url, valid)

proc call*(call_568205: Call_ClusterVersionsList_568198; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## clusterVersionsList
  ## List cluster code versions by location
  ##   apiVersion: string (required)
  ##             : The version of the ServiceFabric resource provider api
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   location: string (required)
  ##           : The location for the cluster code versions, this is different from cluster location
  var path_568206 = newJObject()
  var query_568207 = newJObject()
  add(query_568207, "api-version", newJString(apiVersion))
  add(path_568206, "subscriptionId", newJString(subscriptionId))
  add(path_568206, "location", newJString(location))
  result = call_568205.call(path_568206, query_568207, nil, nil, nil)

var clusterVersionsList* = Call_ClusterVersionsList_568198(
    name: "clusterVersionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabric/locations/{location}/clusterVersions",
    validator: validate_ClusterVersionsList_568199, base: "",
    url: url_ClusterVersionsList_568200, schemes: {Scheme.Https})
type
  Call_ClusterVersionsListByVersion_568208 = ref object of OpenApiRestCall_567657
proc url_ClusterVersionsListByVersion_568210(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "clusterVersion" in path, "`clusterVersion` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/clusterVersions/"),
               (kind: VariableSegment, value: "clusterVersion")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClusterVersionsListByVersion_568209(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List cluster code versions by version
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   clusterVersion: JString (required)
  ##                 : The cluster code version
  ##   location: JString (required)
  ##           : The location for the cluster code versions, this is different from cluster location
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568211 = path.getOrDefault("subscriptionId")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "subscriptionId", valid_568211
  var valid_568212 = path.getOrDefault("clusterVersion")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "clusterVersion", valid_568212
  var valid_568213 = path.getOrDefault("location")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "location", valid_568213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the ServiceFabric resource provider api
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568214 = query.getOrDefault("api-version")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "api-version", valid_568214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568215: Call_ClusterVersionsListByVersion_568208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List cluster code versions by version
  ## 
  let valid = call_568215.validator(path, query, header, formData, body)
  let scheme = call_568215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568215.url(scheme.get, call_568215.host, call_568215.base,
                         call_568215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568215, url, valid)

proc call*(call_568216: Call_ClusterVersionsListByVersion_568208;
          apiVersion: string; subscriptionId: string; clusterVersion: string;
          location: string): Recallable =
  ## clusterVersionsListByVersion
  ## List cluster code versions by version
  ##   apiVersion: string (required)
  ##             : The version of the ServiceFabric resource provider api
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   clusterVersion: string (required)
  ##                 : The cluster code version
  ##   location: string (required)
  ##           : The location for the cluster code versions, this is different from cluster location
  var path_568217 = newJObject()
  var query_568218 = newJObject()
  add(query_568218, "api-version", newJString(apiVersion))
  add(path_568217, "subscriptionId", newJString(subscriptionId))
  add(path_568217, "clusterVersion", newJString(clusterVersion))
  add(path_568217, "location", newJString(location))
  result = call_568216.call(path_568217, query_568218, nil, nil, nil)

var clusterVersionsListByVersion* = Call_ClusterVersionsListByVersion_568208(
    name: "clusterVersionsListByVersion", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabric/locations/{location}/clusterVersions/{clusterVersion}",
    validator: validate_ClusterVersionsListByVersion_568209, base: "",
    url: url_ClusterVersionsListByVersion_568210, schemes: {Scheme.Https})
type
  Call_ClusterVersionsListByEnvironment_568219 = ref object of OpenApiRestCall_567657
proc url_ClusterVersionsListByEnvironment_568221(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "environment" in path, "`environment` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/environments/"),
               (kind: VariableSegment, value: "environment"),
               (kind: ConstantSegment, value: "/clusterVersions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClusterVersionsListByEnvironment_568220(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List cluster code versions by environment
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   environment: JString (required)
  ##              : Cluster operating system, the default means all
  ##   location: JString (required)
  ##           : The location for the cluster code versions, this is different from cluster location
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568222 = path.getOrDefault("subscriptionId")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "subscriptionId", valid_568222
  var valid_568236 = path.getOrDefault("environment")
  valid_568236 = validateParameter(valid_568236, JString, required = true,
                                 default = newJString("Windows"))
  if valid_568236 != nil:
    section.add "environment", valid_568236
  var valid_568237 = path.getOrDefault("location")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "location", valid_568237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the ServiceFabric resource provider api
  section = newJObject()
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
  if body != nil:
    result.add "body", body

proc call*(call_568239: Call_ClusterVersionsListByEnvironment_568219;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List cluster code versions by environment
  ## 
  let valid = call_568239.validator(path, query, header, formData, body)
  let scheme = call_568239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568239.url(scheme.get, call_568239.host, call_568239.base,
                         call_568239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568239, url, valid)

proc call*(call_568240: Call_ClusterVersionsListByEnvironment_568219;
          apiVersion: string; subscriptionId: string; location: string;
          environment: string = "Windows"): Recallable =
  ## clusterVersionsListByEnvironment
  ## List cluster code versions by environment
  ##   apiVersion: string (required)
  ##             : The version of the ServiceFabric resource provider api
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   environment: string (required)
  ##              : Cluster operating system, the default means all
  ##   location: string (required)
  ##           : The location for the cluster code versions, this is different from cluster location
  var path_568241 = newJObject()
  var query_568242 = newJObject()
  add(query_568242, "api-version", newJString(apiVersion))
  add(path_568241, "subscriptionId", newJString(subscriptionId))
  add(path_568241, "environment", newJString(environment))
  add(path_568241, "location", newJString(location))
  result = call_568240.call(path_568241, query_568242, nil, nil, nil)

var clusterVersionsListByEnvironment* = Call_ClusterVersionsListByEnvironment_568219(
    name: "clusterVersionsListByEnvironment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabric/locations/{location}/environments/{environment}/clusterVersions",
    validator: validate_ClusterVersionsListByEnvironment_568220, base: "",
    url: url_ClusterVersionsListByEnvironment_568221, schemes: {Scheme.Https})
type
  Call_ClusterVersionsGet_568243 = ref object of OpenApiRestCall_567657
proc url_ClusterVersionsGet_568245(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "environment" in path, "`environment` is a required path parameter"
  assert "clusterVersion" in path, "`clusterVersion` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/environments/"),
               (kind: VariableSegment, value: "environment"),
               (kind: ConstantSegment, value: "/clusterVersions/"),
               (kind: VariableSegment, value: "clusterVersion")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClusterVersionsGet_568244(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get cluster code versions by environment and version
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   environment: JString (required)
  ##              : Cluster operating system, the default means all
  ##   clusterVersion: JString (required)
  ##                 : The cluster code version
  ##   location: JString (required)
  ##           : The location for the cluster code versions, this is different from cluster location
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568246 = path.getOrDefault("subscriptionId")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "subscriptionId", valid_568246
  var valid_568247 = path.getOrDefault("environment")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = newJString("Windows"))
  if valid_568247 != nil:
    section.add "environment", valid_568247
  var valid_568248 = path.getOrDefault("clusterVersion")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "clusterVersion", valid_568248
  var valid_568249 = path.getOrDefault("location")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "location", valid_568249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the ServiceFabric resource provider api
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568250 = query.getOrDefault("api-version")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "api-version", valid_568250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568251: Call_ClusterVersionsGet_568243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get cluster code versions by environment and version
  ## 
  let valid = call_568251.validator(path, query, header, formData, body)
  let scheme = call_568251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568251.url(scheme.get, call_568251.host, call_568251.base,
                         call_568251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568251, url, valid)

proc call*(call_568252: Call_ClusterVersionsGet_568243; apiVersion: string;
          subscriptionId: string; clusterVersion: string; location: string;
          environment: string = "Windows"): Recallable =
  ## clusterVersionsGet
  ## Get cluster code versions by environment and version
  ##   apiVersion: string (required)
  ##             : The version of the ServiceFabric resource provider api
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   environment: string (required)
  ##              : Cluster operating system, the default means all
  ##   clusterVersion: string (required)
  ##                 : The cluster code version
  ##   location: string (required)
  ##           : The location for the cluster code versions, this is different from cluster location
  var path_568253 = newJObject()
  var query_568254 = newJObject()
  add(query_568254, "api-version", newJString(apiVersion))
  add(path_568253, "subscriptionId", newJString(subscriptionId))
  add(path_568253, "environment", newJString(environment))
  add(path_568253, "clusterVersion", newJString(clusterVersion))
  add(path_568253, "location", newJString(location))
  result = call_568252.call(path_568253, query_568254, nil, nil, nil)

var clusterVersionsGet* = Call_ClusterVersionsGet_568243(
    name: "clusterVersionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabric/locations/{location}/environments/{environment}/clusterVersions/{clusterVersion}",
    validator: validate_ClusterVersionsGet_568244, base: "",
    url: url_ClusterVersionsGet_568245, schemes: {Scheme.Https})
type
  Call_ClustersCreate_568266 = ref object of OpenApiRestCall_567657
proc url_ClustersCreate_568268(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersCreate_568267(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Create cluster resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the resource belongs or get created
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568286 = path.getOrDefault("clusterName")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "clusterName", valid_568286
  var valid_568287 = path.getOrDefault("resourceGroupName")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "resourceGroupName", valid_568287
  var valid_568288 = path.getOrDefault("subscriptionId")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "subscriptionId", valid_568288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the ServiceFabric resource provider api
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568289 = query.getOrDefault("api-version")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "api-version", valid_568289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Put Request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568291: Call_ClustersCreate_568266; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create cluster resource
  ## 
  let valid = call_568291.validator(path, query, header, formData, body)
  let scheme = call_568291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568291.url(scheme.get, call_568291.host, call_568291.base,
                         call_568291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568291, url, valid)

proc call*(call_568292: Call_ClustersCreate_568266; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## clustersCreate
  ## Create cluster resource
  ##   clusterName: string (required)
  ##              : The name of the cluster resource
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the resource belongs or get created
  ##   apiVersion: string (required)
  ##             : The version of the ServiceFabric resource provider api
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   parameters: JObject (required)
  ##             : Put Request
  var path_568293 = newJObject()
  var query_568294 = newJObject()
  var body_568295 = newJObject()
  add(path_568293, "clusterName", newJString(clusterName))
  add(path_568293, "resourceGroupName", newJString(resourceGroupName))
  add(query_568294, "api-version", newJString(apiVersion))
  add(path_568293, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568295 = parameters
  result = call_568292.call(path_568293, query_568294, nil, nil, body_568295)

var clustersCreate* = Call_ClustersCreate_568266(name: "clustersCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}",
    validator: validate_ClustersCreate_568267, base: "", url: url_ClustersCreate_568268,
    schemes: {Scheme.Https})
type
  Call_ClustersGet_568255 = ref object of OpenApiRestCall_567657
proc url_ClustersGet_568257(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersGet_568256(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get cluster resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the resource belongs or get created
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568258 = path.getOrDefault("clusterName")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "clusterName", valid_568258
  var valid_568259 = path.getOrDefault("resourceGroupName")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "resourceGroupName", valid_568259
  var valid_568260 = path.getOrDefault("subscriptionId")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "subscriptionId", valid_568260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the ServiceFabric resource provider api
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568261 = query.getOrDefault("api-version")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "api-version", valid_568261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568262: Call_ClustersGet_568255; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get cluster resource
  ## 
  let valid = call_568262.validator(path, query, header, formData, body)
  let scheme = call_568262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568262.url(scheme.get, call_568262.host, call_568262.base,
                         call_568262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568262, url, valid)

proc call*(call_568263: Call_ClustersGet_568255; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## clustersGet
  ## Get cluster resource
  ##   clusterName: string (required)
  ##              : The name of the cluster resource
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the resource belongs or get created
  ##   apiVersion: string (required)
  ##             : The version of the ServiceFabric resource provider api
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568264 = newJObject()
  var query_568265 = newJObject()
  add(path_568264, "clusterName", newJString(clusterName))
  add(path_568264, "resourceGroupName", newJString(resourceGroupName))
  add(query_568265, "api-version", newJString(apiVersion))
  add(path_568264, "subscriptionId", newJString(subscriptionId))
  result = call_568263.call(path_568264, query_568265, nil, nil, nil)

var clustersGet* = Call_ClustersGet_568255(name: "clustersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}",
                                        validator: validate_ClustersGet_568256,
                                        base: "", url: url_ClustersGet_568257,
                                        schemes: {Scheme.Https})
type
  Call_ClustersUpdate_568307 = ref object of OpenApiRestCall_567657
proc url_ClustersUpdate_568309(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersUpdate_568308(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Update cluster configuration
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the resource belongs or get created
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568310 = path.getOrDefault("clusterName")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "clusterName", valid_568310
  var valid_568311 = path.getOrDefault("resourceGroupName")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "resourceGroupName", valid_568311
  var valid_568312 = path.getOrDefault("subscriptionId")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "subscriptionId", valid_568312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the ServiceFabric resource provider api
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568313 = query.getOrDefault("api-version")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "api-version", valid_568313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters which contains the property value and property name which used to update the cluster configuration
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568315: Call_ClustersUpdate_568307; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update cluster configuration
  ## 
  let valid = call_568315.validator(path, query, header, formData, body)
  let scheme = call_568315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568315.url(scheme.get, call_568315.host, call_568315.base,
                         call_568315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568315, url, valid)

proc call*(call_568316: Call_ClustersUpdate_568307; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## clustersUpdate
  ## Update cluster configuration
  ##   clusterName: string (required)
  ##              : The name of the cluster resource
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the resource belongs or get created
  ##   apiVersion: string (required)
  ##             : The version of the ServiceFabric resource provider api
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   parameters: JObject (required)
  ##             : The parameters which contains the property value and property name which used to update the cluster configuration
  var path_568317 = newJObject()
  var query_568318 = newJObject()
  var body_568319 = newJObject()
  add(path_568317, "clusterName", newJString(clusterName))
  add(path_568317, "resourceGroupName", newJString(resourceGroupName))
  add(query_568318, "api-version", newJString(apiVersion))
  add(path_568317, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568319 = parameters
  result = call_568316.call(path_568317, query_568318, nil, nil, body_568319)

var clustersUpdate* = Call_ClustersUpdate_568307(name: "clustersUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}",
    validator: validate_ClustersUpdate_568308, base: "", url: url_ClustersUpdate_568309,
    schemes: {Scheme.Https})
type
  Call_ClustersDelete_568296 = ref object of OpenApiRestCall_567657
proc url_ClustersDelete_568298(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersDelete_568297(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete cluster resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the resource belongs or get created
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568299 = path.getOrDefault("clusterName")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "clusterName", valid_568299
  var valid_568300 = path.getOrDefault("resourceGroupName")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "resourceGroupName", valid_568300
  var valid_568301 = path.getOrDefault("subscriptionId")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "subscriptionId", valid_568301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the ServiceFabric resource provider api
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568302 = query.getOrDefault("api-version")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "api-version", valid_568302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568303: Call_ClustersDelete_568296; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete cluster resource
  ## 
  let valid = call_568303.validator(path, query, header, formData, body)
  let scheme = call_568303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568303.url(scheme.get, call_568303.host, call_568303.base,
                         call_568303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568303, url, valid)

proc call*(call_568304: Call_ClustersDelete_568296; clusterName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## clustersDelete
  ## Delete cluster resource
  ##   clusterName: string (required)
  ##              : The name of the cluster resource
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the resource belongs or get created
  ##   apiVersion: string (required)
  ##             : The version of the ServiceFabric resource provider api
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568305 = newJObject()
  var query_568306 = newJObject()
  add(path_568305, "clusterName", newJString(clusterName))
  add(path_568305, "resourceGroupName", newJString(resourceGroupName))
  add(query_568306, "api-version", newJString(apiVersion))
  add(path_568305, "subscriptionId", newJString(subscriptionId))
  result = call_568304.call(path_568305, query_568306, nil, nil, nil)

var clustersDelete* = Call_ClustersDelete_568296(name: "clustersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}",
    validator: validate_ClustersDelete_568297, base: "", url: url_ClustersDelete_568298,
    schemes: {Scheme.Https})
type
  Call_ClustersListByResourceGroup_568320 = ref object of OpenApiRestCall_567657
proc url_ClustersListByResourceGroup_568322(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersListByResourceGroup_568321(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List cluster resource by resource group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the resource belongs or get created
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568323 = path.getOrDefault("resourceGroupName")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "resourceGroupName", valid_568323
  var valid_568324 = path.getOrDefault("subscriptionId")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "subscriptionId", valid_568324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the ServiceFabric resource provider api
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568325 = query.getOrDefault("api-version")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "api-version", valid_568325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568326: Call_ClustersListByResourceGroup_568320; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List cluster resource by resource group
  ## 
  let valid = call_568326.validator(path, query, header, formData, body)
  let scheme = call_568326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568326.url(scheme.get, call_568326.host, call_568326.base,
                         call_568326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568326, url, valid)

proc call*(call_568327: Call_ClustersListByResourceGroup_568320;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## clustersListByResourceGroup
  ## List cluster resource by resource group
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the resource belongs or get created
  ##   apiVersion: string (required)
  ##             : The version of the ServiceFabric resource provider api
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_568328 = newJObject()
  var query_568329 = newJObject()
  add(path_568328, "resourceGroupName", newJString(resourceGroupName))
  add(query_568329, "api-version", newJString(apiVersion))
  add(path_568328, "subscriptionId", newJString(subscriptionId))
  result = call_568327.call(path_568328, query_568329, nil, nil, nil)

var clustersListByResourceGroup* = Call_ClustersListByResourceGroup_568320(
    name: "clustersListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters",
    validator: validate_ClustersListByResourceGroup_568321, base: "",
    url: url_ClustersListByResourceGroup_568322, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
