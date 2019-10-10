
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ServiceFabricManagementClient
## version: 2019-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Service Fabric Resource Provider API Client
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

  OpenApiRestCall_573657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573657): Option[Scheme] {.used.} =
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
  macServiceName = "servicefabric-cluster"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_573879 = ref object of OpenApiRestCall_573657
proc url_OperationsList_573881(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_573880(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get the list of available Service Fabric resource provider API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574027 = query.getOrDefault("api-version")
  valid_574027 = validateParameter(valid_574027, JString, required = true,
                                 default = nil)
  if valid_574027 != nil:
    section.add "api-version", valid_574027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574054: Call_OperationsList_573879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of available Service Fabric resource provider API operations.
  ## 
  let valid = call_574054.validator(path, query, header, formData, body)
  let scheme = call_574054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574054.url(scheme.get, call_574054.host, call_574054.base,
                         call_574054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574054, url, valid)

proc call*(call_574125: Call_OperationsList_573879; apiVersion: string): Recallable =
  ## operationsList
  ## Get the list of available Service Fabric resource provider API operations.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API
  var query_574126 = newJObject()
  add(query_574126, "api-version", newJString(apiVersion))
  result = call_574125.call(nil, query_574126, nil, nil, nil)

var operationsList* = Call_OperationsList_573879(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ServiceFabric/operations",
    validator: validate_OperationsList_573880, base: "", url: url_OperationsList_573881,
    schemes: {Scheme.Https})
type
  Call_ClustersList_574166 = ref object of OpenApiRestCall_573657
proc url_ClustersList_574168(protocol: Scheme; host: string; base: string;
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

proc validate_ClustersList_574167(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all Service Fabric cluster resources created or in the process of being created in the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574192 = path.getOrDefault("subscriptionId")
  valid_574192 = validateParameter(valid_574192, JString, required = true,
                                 default = nil)
  if valid_574192 != nil:
    section.add "subscriptionId", valid_574192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574206 = query.getOrDefault("api-version")
  valid_574206 = validateParameter(valid_574206, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574206 != nil:
    section.add "api-version", valid_574206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574207: Call_ClustersList_574166; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all Service Fabric cluster resources created or in the process of being created in the subscription.
  ## 
  let valid = call_574207.validator(path, query, header, formData, body)
  let scheme = call_574207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574207.url(scheme.get, call_574207.host, call_574207.base,
                         call_574207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574207, url, valid)

proc call*(call_574208: Call_ClustersList_574166; subscriptionId: string;
          apiVersion: string = "2019-03-01"): Recallable =
  ## clustersList
  ## Gets all Service Fabric cluster resources created or in the process of being created in the subscription.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_574209 = newJObject()
  var query_574210 = newJObject()
  add(query_574210, "api-version", newJString(apiVersion))
  add(path_574209, "subscriptionId", newJString(subscriptionId))
  result = call_574208.call(path_574209, query_574210, nil, nil, nil)

var clustersList* = Call_ClustersList_574166(name: "clustersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabric/clusters",
    validator: validate_ClustersList_574167, base: "", url: url_ClustersList_574168,
    schemes: {Scheme.Https})
type
  Call_ClusterVersionsList_574211 = ref object of OpenApiRestCall_573657
proc url_ClusterVersionsList_574213(protocol: Scheme; host: string; base: string;
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

proc validate_ClusterVersionsList_574212(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets all available code versions for Service Fabric cluster resources by location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   location: JString (required)
  ##           : The location for the cluster code versions. This is different from cluster location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574214 = path.getOrDefault("subscriptionId")
  valid_574214 = validateParameter(valid_574214, JString, required = true,
                                 default = nil)
  if valid_574214 != nil:
    section.add "subscriptionId", valid_574214
  var valid_574215 = path.getOrDefault("location")
  valid_574215 = validateParameter(valid_574215, JString, required = true,
                                 default = nil)
  if valid_574215 != nil:
    section.add "location", valid_574215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574216 = query.getOrDefault("api-version")
  valid_574216 = validateParameter(valid_574216, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574216 != nil:
    section.add "api-version", valid_574216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574217: Call_ClusterVersionsList_574211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all available code versions for Service Fabric cluster resources by location.
  ## 
  let valid = call_574217.validator(path, query, header, formData, body)
  let scheme = call_574217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574217.url(scheme.get, call_574217.host, call_574217.base,
                         call_574217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574217, url, valid)

proc call*(call_574218: Call_ClusterVersionsList_574211; subscriptionId: string;
          location: string; apiVersion: string = "2019-03-01"): Recallable =
  ## clusterVersionsList
  ## Gets all available code versions for Service Fabric cluster resources by location.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   location: string (required)
  ##           : The location for the cluster code versions. This is different from cluster location.
  var path_574219 = newJObject()
  var query_574220 = newJObject()
  add(query_574220, "api-version", newJString(apiVersion))
  add(path_574219, "subscriptionId", newJString(subscriptionId))
  add(path_574219, "location", newJString(location))
  result = call_574218.call(path_574219, query_574220, nil, nil, nil)

var clusterVersionsList* = Call_ClusterVersionsList_574211(
    name: "clusterVersionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabric/locations/{location}/clusterVersions",
    validator: validate_ClusterVersionsList_574212, base: "",
    url: url_ClusterVersionsList_574213, schemes: {Scheme.Https})
type
  Call_ClusterVersionsGet_574221 = ref object of OpenApiRestCall_573657
proc url_ClusterVersionsGet_574223(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_ClusterVersionsGet_574222(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets information about an available Service Fabric cluster code version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   clusterVersion: JString (required)
  ##                 : The cluster code version.
  ##   location: JString (required)
  ##           : The location for the cluster code versions. This is different from cluster location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574224 = path.getOrDefault("subscriptionId")
  valid_574224 = validateParameter(valid_574224, JString, required = true,
                                 default = nil)
  if valid_574224 != nil:
    section.add "subscriptionId", valid_574224
  var valid_574225 = path.getOrDefault("clusterVersion")
  valid_574225 = validateParameter(valid_574225, JString, required = true,
                                 default = nil)
  if valid_574225 != nil:
    section.add "clusterVersion", valid_574225
  var valid_574226 = path.getOrDefault("location")
  valid_574226 = validateParameter(valid_574226, JString, required = true,
                                 default = nil)
  if valid_574226 != nil:
    section.add "location", valid_574226
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574227 = query.getOrDefault("api-version")
  valid_574227 = validateParameter(valid_574227, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574227 != nil:
    section.add "api-version", valid_574227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574228: Call_ClusterVersionsGet_574221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about an available Service Fabric cluster code version.
  ## 
  let valid = call_574228.validator(path, query, header, formData, body)
  let scheme = call_574228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574228.url(scheme.get, call_574228.host, call_574228.base,
                         call_574228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574228, url, valid)

proc call*(call_574229: Call_ClusterVersionsGet_574221; subscriptionId: string;
          clusterVersion: string; location: string;
          apiVersion: string = "2019-03-01"): Recallable =
  ## clusterVersionsGet
  ## Gets information about an available Service Fabric cluster code version.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   clusterVersion: string (required)
  ##                 : The cluster code version.
  ##   location: string (required)
  ##           : The location for the cluster code versions. This is different from cluster location.
  var path_574230 = newJObject()
  var query_574231 = newJObject()
  add(query_574231, "api-version", newJString(apiVersion))
  add(path_574230, "subscriptionId", newJString(subscriptionId))
  add(path_574230, "clusterVersion", newJString(clusterVersion))
  add(path_574230, "location", newJString(location))
  result = call_574229.call(path_574230, query_574231, nil, nil, nil)

var clusterVersionsGet* = Call_ClusterVersionsGet_574221(
    name: "clusterVersionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabric/locations/{location}/clusterVersions/{clusterVersion}",
    validator: validate_ClusterVersionsGet_574222, base: "",
    url: url_ClusterVersionsGet_574223, schemes: {Scheme.Https})
type
  Call_ClusterVersionsListByEnvironment_574232 = ref object of OpenApiRestCall_573657
proc url_ClusterVersionsListByEnvironment_574234(protocol: Scheme; host: string;
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

proc validate_ClusterVersionsListByEnvironment_574233(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all available code versions for Service Fabric cluster resources by environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   environment: JString (required)
  ##              : The operating system of the cluster. The default means all.
  ##   location: JString (required)
  ##           : The location for the cluster code versions. This is different from cluster location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574235 = path.getOrDefault("subscriptionId")
  valid_574235 = validateParameter(valid_574235, JString, required = true,
                                 default = nil)
  if valid_574235 != nil:
    section.add "subscriptionId", valid_574235
  var valid_574236 = path.getOrDefault("environment")
  valid_574236 = validateParameter(valid_574236, JString, required = true,
                                 default = newJString("Windows"))
  if valid_574236 != nil:
    section.add "environment", valid_574236
  var valid_574237 = path.getOrDefault("location")
  valid_574237 = validateParameter(valid_574237, JString, required = true,
                                 default = nil)
  if valid_574237 != nil:
    section.add "location", valid_574237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574238 = query.getOrDefault("api-version")
  valid_574238 = validateParameter(valid_574238, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574238 != nil:
    section.add "api-version", valid_574238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574239: Call_ClusterVersionsListByEnvironment_574232;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all available code versions for Service Fabric cluster resources by environment.
  ## 
  let valid = call_574239.validator(path, query, header, formData, body)
  let scheme = call_574239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574239.url(scheme.get, call_574239.host, call_574239.base,
                         call_574239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574239, url, valid)

proc call*(call_574240: Call_ClusterVersionsListByEnvironment_574232;
          subscriptionId: string; location: string;
          apiVersion: string = "2019-03-01"; environment: string = "Windows"): Recallable =
  ## clusterVersionsListByEnvironment
  ## Gets all available code versions for Service Fabric cluster resources by environment.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   environment: string (required)
  ##              : The operating system of the cluster. The default means all.
  ##   location: string (required)
  ##           : The location for the cluster code versions. This is different from cluster location.
  var path_574241 = newJObject()
  var query_574242 = newJObject()
  add(query_574242, "api-version", newJString(apiVersion))
  add(path_574241, "subscriptionId", newJString(subscriptionId))
  add(path_574241, "environment", newJString(environment))
  add(path_574241, "location", newJString(location))
  result = call_574240.call(path_574241, query_574242, nil, nil, nil)

var clusterVersionsListByEnvironment* = Call_ClusterVersionsListByEnvironment_574232(
    name: "clusterVersionsListByEnvironment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabric/locations/{location}/environments/{environment}/clusterVersions",
    validator: validate_ClusterVersionsListByEnvironment_574233, base: "",
    url: url_ClusterVersionsListByEnvironment_574234, schemes: {Scheme.Https})
type
  Call_ClusterVersionsGetByEnvironment_574243 = ref object of OpenApiRestCall_573657
proc url_ClusterVersionsGetByEnvironment_574245(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_ClusterVersionsGetByEnvironment_574244(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about an available Service Fabric cluster code version by environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   environment: JString (required)
  ##              : The operating system of the cluster. The default means all.
  ##   clusterVersion: JString (required)
  ##                 : The cluster code version.
  ##   location: JString (required)
  ##           : The location for the cluster code versions. This is different from cluster location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574246 = path.getOrDefault("subscriptionId")
  valid_574246 = validateParameter(valid_574246, JString, required = true,
                                 default = nil)
  if valid_574246 != nil:
    section.add "subscriptionId", valid_574246
  var valid_574247 = path.getOrDefault("environment")
  valid_574247 = validateParameter(valid_574247, JString, required = true,
                                 default = newJString("Windows"))
  if valid_574247 != nil:
    section.add "environment", valid_574247
  var valid_574248 = path.getOrDefault("clusterVersion")
  valid_574248 = validateParameter(valid_574248, JString, required = true,
                                 default = nil)
  if valid_574248 != nil:
    section.add "clusterVersion", valid_574248
  var valid_574249 = path.getOrDefault("location")
  valid_574249 = validateParameter(valid_574249, JString, required = true,
                                 default = nil)
  if valid_574249 != nil:
    section.add "location", valid_574249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574250 = query.getOrDefault("api-version")
  valid_574250 = validateParameter(valid_574250, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574250 != nil:
    section.add "api-version", valid_574250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574251: Call_ClusterVersionsGetByEnvironment_574243;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about an available Service Fabric cluster code version by environment.
  ## 
  let valid = call_574251.validator(path, query, header, formData, body)
  let scheme = call_574251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574251.url(scheme.get, call_574251.host, call_574251.base,
                         call_574251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574251, url, valid)

proc call*(call_574252: Call_ClusterVersionsGetByEnvironment_574243;
          subscriptionId: string; clusterVersion: string; location: string;
          apiVersion: string = "2019-03-01"; environment: string = "Windows"): Recallable =
  ## clusterVersionsGetByEnvironment
  ## Gets information about an available Service Fabric cluster code version by environment.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   environment: string (required)
  ##              : The operating system of the cluster. The default means all.
  ##   clusterVersion: string (required)
  ##                 : The cluster code version.
  ##   location: string (required)
  ##           : The location for the cluster code versions. This is different from cluster location.
  var path_574253 = newJObject()
  var query_574254 = newJObject()
  add(query_574254, "api-version", newJString(apiVersion))
  add(path_574253, "subscriptionId", newJString(subscriptionId))
  add(path_574253, "environment", newJString(environment))
  add(path_574253, "clusterVersion", newJString(clusterVersion))
  add(path_574253, "location", newJString(location))
  result = call_574252.call(path_574253, query_574254, nil, nil, nil)

var clusterVersionsGetByEnvironment* = Call_ClusterVersionsGetByEnvironment_574243(
    name: "clusterVersionsGetByEnvironment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabric/locations/{location}/environments/{environment}/clusterVersions/{clusterVersion}",
    validator: validate_ClusterVersionsGetByEnvironment_574244, base: "",
    url: url_ClusterVersionsGetByEnvironment_574245, schemes: {Scheme.Https})
type
  Call_ClustersCreateOrUpdate_574266 = ref object of OpenApiRestCall_573657
proc url_ClustersCreateOrUpdate_574268(protocol: Scheme; host: string; base: string;
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

proc validate_ClustersCreateOrUpdate_574267(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a Service Fabric cluster resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_574269 = path.getOrDefault("clusterName")
  valid_574269 = validateParameter(valid_574269, JString, required = true,
                                 default = nil)
  if valid_574269 != nil:
    section.add "clusterName", valid_574269
  var valid_574270 = path.getOrDefault("resourceGroupName")
  valid_574270 = validateParameter(valid_574270, JString, required = true,
                                 default = nil)
  if valid_574270 != nil:
    section.add "resourceGroupName", valid_574270
  var valid_574271 = path.getOrDefault("subscriptionId")
  valid_574271 = validateParameter(valid_574271, JString, required = true,
                                 default = nil)
  if valid_574271 != nil:
    section.add "subscriptionId", valid_574271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574272 = query.getOrDefault("api-version")
  valid_574272 = validateParameter(valid_574272, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574272 != nil:
    section.add "api-version", valid_574272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The cluster resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574274: Call_ClustersCreateOrUpdate_574266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Service Fabric cluster resource with the specified name.
  ## 
  let valid = call_574274.validator(path, query, header, formData, body)
  let scheme = call_574274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574274.url(scheme.get, call_574274.host, call_574274.base,
                         call_574274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574274, url, valid)

proc call*(call_574275: Call_ClustersCreateOrUpdate_574266; clusterName: string;
          resourceGroupName: string; subscriptionId: string; parameters: JsonNode;
          apiVersion: string = "2019-03-01"): Recallable =
  ## clustersCreateOrUpdate
  ## Create or update a Service Fabric cluster resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   parameters: JObject (required)
  ##             : The cluster resource.
  var path_574276 = newJObject()
  var query_574277 = newJObject()
  var body_574278 = newJObject()
  add(path_574276, "clusterName", newJString(clusterName))
  add(path_574276, "resourceGroupName", newJString(resourceGroupName))
  add(query_574277, "api-version", newJString(apiVersion))
  add(path_574276, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574278 = parameters
  result = call_574275.call(path_574276, query_574277, nil, nil, body_574278)

var clustersCreateOrUpdate* = Call_ClustersCreateOrUpdate_574266(
    name: "clustersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}",
    validator: validate_ClustersCreateOrUpdate_574267, base: "",
    url: url_ClustersCreateOrUpdate_574268, schemes: {Scheme.Https})
type
  Call_ClustersGet_574255 = ref object of OpenApiRestCall_573657
proc url_ClustersGet_574257(protocol: Scheme; host: string; base: string;
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

proc validate_ClustersGet_574256(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a Service Fabric cluster resource created or in the process of being created in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_574258 = path.getOrDefault("clusterName")
  valid_574258 = validateParameter(valid_574258, JString, required = true,
                                 default = nil)
  if valid_574258 != nil:
    section.add "clusterName", valid_574258
  var valid_574259 = path.getOrDefault("resourceGroupName")
  valid_574259 = validateParameter(valid_574259, JString, required = true,
                                 default = nil)
  if valid_574259 != nil:
    section.add "resourceGroupName", valid_574259
  var valid_574260 = path.getOrDefault("subscriptionId")
  valid_574260 = validateParameter(valid_574260, JString, required = true,
                                 default = nil)
  if valid_574260 != nil:
    section.add "subscriptionId", valid_574260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574261 = query.getOrDefault("api-version")
  valid_574261 = validateParameter(valid_574261, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574261 != nil:
    section.add "api-version", valid_574261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574262: Call_ClustersGet_574255; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Service Fabric cluster resource created or in the process of being created in the specified resource group.
  ## 
  let valid = call_574262.validator(path, query, header, formData, body)
  let scheme = call_574262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574262.url(scheme.get, call_574262.host, call_574262.base,
                         call_574262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574262, url, valid)

proc call*(call_574263: Call_ClustersGet_574255; clusterName: string;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2019-03-01"): Recallable =
  ## clustersGet
  ## Get a Service Fabric cluster resource created or in the process of being created in the specified resource group.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_574264 = newJObject()
  var query_574265 = newJObject()
  add(path_574264, "clusterName", newJString(clusterName))
  add(path_574264, "resourceGroupName", newJString(resourceGroupName))
  add(query_574265, "api-version", newJString(apiVersion))
  add(path_574264, "subscriptionId", newJString(subscriptionId))
  result = call_574263.call(path_574264, query_574265, nil, nil, nil)

var clustersGet* = Call_ClustersGet_574255(name: "clustersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}",
                                        validator: validate_ClustersGet_574256,
                                        base: "", url: url_ClustersGet_574257,
                                        schemes: {Scheme.Https})
type
  Call_ClustersUpdate_574290 = ref object of OpenApiRestCall_573657
proc url_ClustersUpdate_574292(protocol: Scheme; host: string; base: string;
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

proc validate_ClustersUpdate_574291(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Update the configuration of a Service Fabric cluster resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_574310 = path.getOrDefault("clusterName")
  valid_574310 = validateParameter(valid_574310, JString, required = true,
                                 default = nil)
  if valid_574310 != nil:
    section.add "clusterName", valid_574310
  var valid_574311 = path.getOrDefault("resourceGroupName")
  valid_574311 = validateParameter(valid_574311, JString, required = true,
                                 default = nil)
  if valid_574311 != nil:
    section.add "resourceGroupName", valid_574311
  var valid_574312 = path.getOrDefault("subscriptionId")
  valid_574312 = validateParameter(valid_574312, JString, required = true,
                                 default = nil)
  if valid_574312 != nil:
    section.add "subscriptionId", valid_574312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574313 = query.getOrDefault("api-version")
  valid_574313 = validateParameter(valid_574313, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574313 != nil:
    section.add "api-version", valid_574313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters which contains the property value and property name which used to update the cluster configuration.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574315: Call_ClustersUpdate_574290; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the configuration of a Service Fabric cluster resource with the specified name.
  ## 
  let valid = call_574315.validator(path, query, header, formData, body)
  let scheme = call_574315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574315.url(scheme.get, call_574315.host, call_574315.base,
                         call_574315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574315, url, valid)

proc call*(call_574316: Call_ClustersUpdate_574290; clusterName: string;
          resourceGroupName: string; subscriptionId: string; parameters: JsonNode;
          apiVersion: string = "2019-03-01"): Recallable =
  ## clustersUpdate
  ## Update the configuration of a Service Fabric cluster resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   parameters: JObject (required)
  ##             : The parameters which contains the property value and property name which used to update the cluster configuration.
  var path_574317 = newJObject()
  var query_574318 = newJObject()
  var body_574319 = newJObject()
  add(path_574317, "clusterName", newJString(clusterName))
  add(path_574317, "resourceGroupName", newJString(resourceGroupName))
  add(query_574318, "api-version", newJString(apiVersion))
  add(path_574317, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574319 = parameters
  result = call_574316.call(path_574317, query_574318, nil, nil, body_574319)

var clustersUpdate* = Call_ClustersUpdate_574290(name: "clustersUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}",
    validator: validate_ClustersUpdate_574291, base: "", url: url_ClustersUpdate_574292,
    schemes: {Scheme.Https})
type
  Call_ClustersDelete_574279 = ref object of OpenApiRestCall_573657
proc url_ClustersDelete_574281(protocol: Scheme; host: string; base: string;
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

proc validate_ClustersDelete_574280(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete a Service Fabric cluster resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_574282 = path.getOrDefault("clusterName")
  valid_574282 = validateParameter(valid_574282, JString, required = true,
                                 default = nil)
  if valid_574282 != nil:
    section.add "clusterName", valid_574282
  var valid_574283 = path.getOrDefault("resourceGroupName")
  valid_574283 = validateParameter(valid_574283, JString, required = true,
                                 default = nil)
  if valid_574283 != nil:
    section.add "resourceGroupName", valid_574283
  var valid_574284 = path.getOrDefault("subscriptionId")
  valid_574284 = validateParameter(valid_574284, JString, required = true,
                                 default = nil)
  if valid_574284 != nil:
    section.add "subscriptionId", valid_574284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574285 = query.getOrDefault("api-version")
  valid_574285 = validateParameter(valid_574285, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574285 != nil:
    section.add "api-version", valid_574285
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574286: Call_ClustersDelete_574279; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Service Fabric cluster resource with the specified name.
  ## 
  let valid = call_574286.validator(path, query, header, formData, body)
  let scheme = call_574286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574286.url(scheme.get, call_574286.host, call_574286.base,
                         call_574286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574286, url, valid)

proc call*(call_574287: Call_ClustersDelete_574279; clusterName: string;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2019-03-01"): Recallable =
  ## clustersDelete
  ## Delete a Service Fabric cluster resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_574288 = newJObject()
  var query_574289 = newJObject()
  add(path_574288, "clusterName", newJString(clusterName))
  add(path_574288, "resourceGroupName", newJString(resourceGroupName))
  add(query_574289, "api-version", newJString(apiVersion))
  add(path_574288, "subscriptionId", newJString(subscriptionId))
  result = call_574287.call(path_574288, query_574289, nil, nil, nil)

var clustersDelete* = Call_ClustersDelete_574279(name: "clustersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}",
    validator: validate_ClustersDelete_574280, base: "", url: url_ClustersDelete_574281,
    schemes: {Scheme.Https})
type
  Call_ClustersListByResourceGroup_574320 = ref object of OpenApiRestCall_573657
proc url_ClustersListByResourceGroup_574322(protocol: Scheme; host: string;
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

proc validate_ClustersListByResourceGroup_574321(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all Service Fabric cluster resources created or in the process of being created in the resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574323 = path.getOrDefault("resourceGroupName")
  valid_574323 = validateParameter(valid_574323, JString, required = true,
                                 default = nil)
  if valid_574323 != nil:
    section.add "resourceGroupName", valid_574323
  var valid_574324 = path.getOrDefault("subscriptionId")
  valid_574324 = validateParameter(valid_574324, JString, required = true,
                                 default = nil)
  if valid_574324 != nil:
    section.add "subscriptionId", valid_574324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574325 = query.getOrDefault("api-version")
  valid_574325 = validateParameter(valid_574325, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574325 != nil:
    section.add "api-version", valid_574325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574326: Call_ClustersListByResourceGroup_574320; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all Service Fabric cluster resources created or in the process of being created in the resource group.
  ## 
  let valid = call_574326.validator(path, query, header, formData, body)
  let scheme = call_574326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574326.url(scheme.get, call_574326.host, call_574326.base,
                         call_574326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574326, url, valid)

proc call*(call_574327: Call_ClustersListByResourceGroup_574320;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2019-03-01"): Recallable =
  ## clustersListByResourceGroup
  ## Gets all Service Fabric cluster resources created or in the process of being created in the resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_574328 = newJObject()
  var query_574329 = newJObject()
  add(path_574328, "resourceGroupName", newJString(resourceGroupName))
  add(query_574329, "api-version", newJString(apiVersion))
  add(path_574328, "subscriptionId", newJString(subscriptionId))
  result = call_574327.call(path_574328, query_574329, nil, nil, nil)

var clustersListByResourceGroup* = Call_ClustersListByResourceGroup_574320(
    name: "clustersListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters",
    validator: validate_ClustersListByResourceGroup_574321, base: "",
    url: url_ClustersListByResourceGroup_574322, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
