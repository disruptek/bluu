
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ServiceFabricManagementClient
## version: 2019-03-01-preview
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
  macServiceName = "servicefabric-cluster"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563777 = ref object of OpenApiRestCall_563555
proc url_OperationsList_563779(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563778(path: JsonNode; query: JsonNode;
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
  var valid_563927 = query.getOrDefault("api-version")
  valid_563927 = validateParameter(valid_563927, JString, required = true,
                                 default = nil)
  if valid_563927 != nil:
    section.add "api-version", valid_563927
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563954: Call_OperationsList_563777; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of available Service Fabric resource provider API operations.
  ## 
  let valid = call_563954.validator(path, query, header, formData, body)
  let scheme = call_563954.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563954.url(scheme.get, call_563954.host, call_563954.base,
                         call_563954.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563954, url, valid)

proc call*(call_564025: Call_OperationsList_563777; apiVersion: string): Recallable =
  ## operationsList
  ## Get the list of available Service Fabric resource provider API operations.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API
  var query_564026 = newJObject()
  add(query_564026, "api-version", newJString(apiVersion))
  result = call_564025.call(nil, query_564026, nil, nil, nil)

var operationsList* = Call_OperationsList_563777(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ServiceFabric/operations",
    validator: validate_OperationsList_563778, base: "", url: url_OperationsList_563779,
    schemes: {Scheme.Https})
type
  Call_ClustersList_564066 = ref object of OpenApiRestCall_563555
proc url_ClustersList_564068(protocol: Scheme; host: string; base: string;
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

proc validate_ClustersList_564067(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564092 = path.getOrDefault("subscriptionId")
  valid_564092 = validateParameter(valid_564092, JString, required = true,
                                 default = nil)
  if valid_564092 != nil:
    section.add "subscriptionId", valid_564092
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564106 = query.getOrDefault("api-version")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_564106 != nil:
    section.add "api-version", valid_564106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564107: Call_ClustersList_564066; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all Service Fabric cluster resources created or in the process of being created in the subscription.
  ## 
  let valid = call_564107.validator(path, query, header, formData, body)
  let scheme = call_564107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564107.url(scheme.get, call_564107.host, call_564107.base,
                         call_564107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564107, url, valid)

proc call*(call_564108: Call_ClustersList_564066; subscriptionId: string;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## clustersList
  ## Gets all Service Fabric cluster resources created or in the process of being created in the subscription.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_564109 = newJObject()
  var query_564110 = newJObject()
  add(query_564110, "api-version", newJString(apiVersion))
  add(path_564109, "subscriptionId", newJString(subscriptionId))
  result = call_564108.call(path_564109, query_564110, nil, nil, nil)

var clustersList* = Call_ClustersList_564066(name: "clustersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabric/clusters",
    validator: validate_ClustersList_564067, base: "", url: url_ClustersList_564068,
    schemes: {Scheme.Https})
type
  Call_ClusterVersionsList_564111 = ref object of OpenApiRestCall_563555
proc url_ClusterVersionsList_564113(protocol: Scheme; host: string; base: string;
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

proc validate_ClusterVersionsList_564112(path: JsonNode; query: JsonNode;
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
  var valid_564114 = path.getOrDefault("subscriptionId")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "subscriptionId", valid_564114
  var valid_564115 = path.getOrDefault("location")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "location", valid_564115
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564116 = query.getOrDefault("api-version")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_564116 != nil:
    section.add "api-version", valid_564116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564117: Call_ClusterVersionsList_564111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all available code versions for Service Fabric cluster resources by location.
  ## 
  let valid = call_564117.validator(path, query, header, formData, body)
  let scheme = call_564117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564117.url(scheme.get, call_564117.host, call_564117.base,
                         call_564117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564117, url, valid)

proc call*(call_564118: Call_ClusterVersionsList_564111; subscriptionId: string;
          location: string; apiVersion: string = "2019-03-01-preview"): Recallable =
  ## clusterVersionsList
  ## Gets all available code versions for Service Fabric cluster resources by location.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   location: string (required)
  ##           : The location for the cluster code versions. This is different from cluster location.
  var path_564119 = newJObject()
  var query_564120 = newJObject()
  add(query_564120, "api-version", newJString(apiVersion))
  add(path_564119, "subscriptionId", newJString(subscriptionId))
  add(path_564119, "location", newJString(location))
  result = call_564118.call(path_564119, query_564120, nil, nil, nil)

var clusterVersionsList* = Call_ClusterVersionsList_564111(
    name: "clusterVersionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabric/locations/{location}/clusterVersions",
    validator: validate_ClusterVersionsList_564112, base: "",
    url: url_ClusterVersionsList_564113, schemes: {Scheme.Https})
type
  Call_ClusterVersionsGet_564121 = ref object of OpenApiRestCall_563555
proc url_ClusterVersionsGet_564123(protocol: Scheme; host: string; base: string;
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

proc validate_ClusterVersionsGet_564122(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets information about an available Service Fabric cluster code version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterVersion: JString (required)
  ##                 : The cluster code version.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   location: JString (required)
  ##           : The location for the cluster code versions. This is different from cluster location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterVersion` field"
  var valid_564124 = path.getOrDefault("clusterVersion")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "clusterVersion", valid_564124
  var valid_564125 = path.getOrDefault("subscriptionId")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "subscriptionId", valid_564125
  var valid_564126 = path.getOrDefault("location")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "location", valid_564126
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564127 = query.getOrDefault("api-version")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_564127 != nil:
    section.add "api-version", valid_564127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564128: Call_ClusterVersionsGet_564121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about an available Service Fabric cluster code version.
  ## 
  let valid = call_564128.validator(path, query, header, formData, body)
  let scheme = call_564128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564128.url(scheme.get, call_564128.host, call_564128.base,
                         call_564128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564128, url, valid)

proc call*(call_564129: Call_ClusterVersionsGet_564121; clusterVersion: string;
          subscriptionId: string; location: string;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## clusterVersionsGet
  ## Gets information about an available Service Fabric cluster code version.
  ##   clusterVersion: string (required)
  ##                 : The cluster code version.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   location: string (required)
  ##           : The location for the cluster code versions. This is different from cluster location.
  var path_564130 = newJObject()
  var query_564131 = newJObject()
  add(path_564130, "clusterVersion", newJString(clusterVersion))
  add(query_564131, "api-version", newJString(apiVersion))
  add(path_564130, "subscriptionId", newJString(subscriptionId))
  add(path_564130, "location", newJString(location))
  result = call_564129.call(path_564130, query_564131, nil, nil, nil)

var clusterVersionsGet* = Call_ClusterVersionsGet_564121(
    name: "clusterVersionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabric/locations/{location}/clusterVersions/{clusterVersion}",
    validator: validate_ClusterVersionsGet_564122, base: "",
    url: url_ClusterVersionsGet_564123, schemes: {Scheme.Https})
type
  Call_ClusterVersionsListByEnvironment_564132 = ref object of OpenApiRestCall_563555
proc url_ClusterVersionsListByEnvironment_564134(protocol: Scheme; host: string;
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

proc validate_ClusterVersionsListByEnvironment_564133(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all available code versions for Service Fabric cluster resources by environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   location: JString (required)
  ##           : The location for the cluster code versions. This is different from cluster location.
  ##   environment: JString (required)
  ##              : The operating system of the cluster. The default means all.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564135 = path.getOrDefault("subscriptionId")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "subscriptionId", valid_564135
  var valid_564136 = path.getOrDefault("location")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "location", valid_564136
  var valid_564137 = path.getOrDefault("environment")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = newJString("Windows"))
  if valid_564137 != nil:
    section.add "environment", valid_564137
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564138 = query.getOrDefault("api-version")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_564138 != nil:
    section.add "api-version", valid_564138
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564139: Call_ClusterVersionsListByEnvironment_564132;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all available code versions for Service Fabric cluster resources by environment.
  ## 
  let valid = call_564139.validator(path, query, header, formData, body)
  let scheme = call_564139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564139.url(scheme.get, call_564139.host, call_564139.base,
                         call_564139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564139, url, valid)

proc call*(call_564140: Call_ClusterVersionsListByEnvironment_564132;
          subscriptionId: string; location: string;
          apiVersion: string = "2019-03-01-preview"; environment: string = "Windows"): Recallable =
  ## clusterVersionsListByEnvironment
  ## Gets all available code versions for Service Fabric cluster resources by environment.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   location: string (required)
  ##           : The location for the cluster code versions. This is different from cluster location.
  ##   environment: string (required)
  ##              : The operating system of the cluster. The default means all.
  var path_564141 = newJObject()
  var query_564142 = newJObject()
  add(query_564142, "api-version", newJString(apiVersion))
  add(path_564141, "subscriptionId", newJString(subscriptionId))
  add(path_564141, "location", newJString(location))
  add(path_564141, "environment", newJString(environment))
  result = call_564140.call(path_564141, query_564142, nil, nil, nil)

var clusterVersionsListByEnvironment* = Call_ClusterVersionsListByEnvironment_564132(
    name: "clusterVersionsListByEnvironment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabric/locations/{location}/environments/{environment}/clusterVersions",
    validator: validate_ClusterVersionsListByEnvironment_564133, base: "",
    url: url_ClusterVersionsListByEnvironment_564134, schemes: {Scheme.Https})
type
  Call_ClusterVersionsGetByEnvironment_564143 = ref object of OpenApiRestCall_563555
proc url_ClusterVersionsGetByEnvironment_564145(protocol: Scheme; host: string;
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

proc validate_ClusterVersionsGetByEnvironment_564144(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about an available Service Fabric cluster code version by environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterVersion: JString (required)
  ##                 : The cluster code version.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   location: JString (required)
  ##           : The location for the cluster code versions. This is different from cluster location.
  ##   environment: JString (required)
  ##              : The operating system of the cluster. The default means all.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterVersion` field"
  var valid_564146 = path.getOrDefault("clusterVersion")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "clusterVersion", valid_564146
  var valid_564147 = path.getOrDefault("subscriptionId")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "subscriptionId", valid_564147
  var valid_564148 = path.getOrDefault("location")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "location", valid_564148
  var valid_564149 = path.getOrDefault("environment")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = newJString("Windows"))
  if valid_564149 != nil:
    section.add "environment", valid_564149
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564150 = query.getOrDefault("api-version")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_564150 != nil:
    section.add "api-version", valid_564150
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564151: Call_ClusterVersionsGetByEnvironment_564143;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about an available Service Fabric cluster code version by environment.
  ## 
  let valid = call_564151.validator(path, query, header, formData, body)
  let scheme = call_564151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564151.url(scheme.get, call_564151.host, call_564151.base,
                         call_564151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564151, url, valid)

proc call*(call_564152: Call_ClusterVersionsGetByEnvironment_564143;
          clusterVersion: string; subscriptionId: string; location: string;
          apiVersion: string = "2019-03-01-preview"; environment: string = "Windows"): Recallable =
  ## clusterVersionsGetByEnvironment
  ## Gets information about an available Service Fabric cluster code version by environment.
  ##   clusterVersion: string (required)
  ##                 : The cluster code version.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   location: string (required)
  ##           : The location for the cluster code versions. This is different from cluster location.
  ##   environment: string (required)
  ##              : The operating system of the cluster. The default means all.
  var path_564153 = newJObject()
  var query_564154 = newJObject()
  add(path_564153, "clusterVersion", newJString(clusterVersion))
  add(query_564154, "api-version", newJString(apiVersion))
  add(path_564153, "subscriptionId", newJString(subscriptionId))
  add(path_564153, "location", newJString(location))
  add(path_564153, "environment", newJString(environment))
  result = call_564152.call(path_564153, query_564154, nil, nil, nil)

var clusterVersionsGetByEnvironment* = Call_ClusterVersionsGetByEnvironment_564143(
    name: "clusterVersionsGetByEnvironment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabric/locations/{location}/environments/{environment}/clusterVersions/{clusterVersion}",
    validator: validate_ClusterVersionsGetByEnvironment_564144, base: "",
    url: url_ClusterVersionsGetByEnvironment_564145, schemes: {Scheme.Https})
type
  Call_ClustersCreate_564166 = ref object of OpenApiRestCall_563555
proc url_ClustersCreate_564168(protocol: Scheme; host: string; base: string;
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

proc validate_ClustersCreate_564167(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Create or update a Service Fabric cluster resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564169 = path.getOrDefault("clusterName")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "clusterName", valid_564169
  var valid_564170 = path.getOrDefault("subscriptionId")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "subscriptionId", valid_564170
  var valid_564171 = path.getOrDefault("resourceGroupName")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "resourceGroupName", valid_564171
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564172 = query.getOrDefault("api-version")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_564172 != nil:
    section.add "api-version", valid_564172
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

proc call*(call_564174: Call_ClustersCreate_564166; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Service Fabric cluster resource with the specified name.
  ## 
  let valid = call_564174.validator(path, query, header, formData, body)
  let scheme = call_564174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564174.url(scheme.get, call_564174.host, call_564174.base,
                         call_564174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564174, url, valid)

proc call*(call_564175: Call_ClustersCreate_564166; clusterName: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## clustersCreate
  ## Create or update a Service Fabric cluster resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : The cluster resource.
  var path_564176 = newJObject()
  var query_564177 = newJObject()
  var body_564178 = newJObject()
  add(path_564176, "clusterName", newJString(clusterName))
  add(query_564177, "api-version", newJString(apiVersion))
  add(path_564176, "subscriptionId", newJString(subscriptionId))
  add(path_564176, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564178 = parameters
  result = call_564175.call(path_564176, query_564177, nil, nil, body_564178)

var clustersCreate* = Call_ClustersCreate_564166(name: "clustersCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}",
    validator: validate_ClustersCreate_564167, base: "", url: url_ClustersCreate_564168,
    schemes: {Scheme.Https})
type
  Call_ClustersGet_564155 = ref object of OpenApiRestCall_563555
proc url_ClustersGet_564157(protocol: Scheme; host: string; base: string;
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

proc validate_ClustersGet_564156(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a Service Fabric cluster resource created or in the process of being created in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564158 = path.getOrDefault("clusterName")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "clusterName", valid_564158
  var valid_564159 = path.getOrDefault("subscriptionId")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "subscriptionId", valid_564159
  var valid_564160 = path.getOrDefault("resourceGroupName")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "resourceGroupName", valid_564160
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564161 = query.getOrDefault("api-version")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_564161 != nil:
    section.add "api-version", valid_564161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564162: Call_ClustersGet_564155; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Service Fabric cluster resource created or in the process of being created in the specified resource group.
  ## 
  let valid = call_564162.validator(path, query, header, formData, body)
  let scheme = call_564162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564162.url(scheme.get, call_564162.host, call_564162.base,
                         call_564162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564162, url, valid)

proc call*(call_564163: Call_ClustersGet_564155; clusterName: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## clustersGet
  ## Get a Service Fabric cluster resource created or in the process of being created in the specified resource group.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564164 = newJObject()
  var query_564165 = newJObject()
  add(path_564164, "clusterName", newJString(clusterName))
  add(query_564165, "api-version", newJString(apiVersion))
  add(path_564164, "subscriptionId", newJString(subscriptionId))
  add(path_564164, "resourceGroupName", newJString(resourceGroupName))
  result = call_564163.call(path_564164, query_564165, nil, nil, nil)

var clustersGet* = Call_ClustersGet_564155(name: "clustersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}",
                                        validator: validate_ClustersGet_564156,
                                        base: "", url: url_ClustersGet_564157,
                                        schemes: {Scheme.Https})
type
  Call_ClustersUpdate_564190 = ref object of OpenApiRestCall_563555
proc url_ClustersUpdate_564192(protocol: Scheme; host: string; base: string;
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

proc validate_ClustersUpdate_564191(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Update the configuration of a Service Fabric cluster resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564210 = path.getOrDefault("clusterName")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "clusterName", valid_564210
  var valid_564211 = path.getOrDefault("subscriptionId")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "subscriptionId", valid_564211
  var valid_564212 = path.getOrDefault("resourceGroupName")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "resourceGroupName", valid_564212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564213 = query.getOrDefault("api-version")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_564213 != nil:
    section.add "api-version", valid_564213
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

proc call*(call_564215: Call_ClustersUpdate_564190; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the configuration of a Service Fabric cluster resource with the specified name.
  ## 
  let valid = call_564215.validator(path, query, header, formData, body)
  let scheme = call_564215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564215.url(scheme.get, call_564215.host, call_564215.base,
                         call_564215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564215, url, valid)

proc call*(call_564216: Call_ClustersUpdate_564190; clusterName: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## clustersUpdate
  ## Update the configuration of a Service Fabric cluster resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : The parameters which contains the property value and property name which used to update the cluster configuration.
  var path_564217 = newJObject()
  var query_564218 = newJObject()
  var body_564219 = newJObject()
  add(path_564217, "clusterName", newJString(clusterName))
  add(query_564218, "api-version", newJString(apiVersion))
  add(path_564217, "subscriptionId", newJString(subscriptionId))
  add(path_564217, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564219 = parameters
  result = call_564216.call(path_564217, query_564218, nil, nil, body_564219)

var clustersUpdate* = Call_ClustersUpdate_564190(name: "clustersUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}",
    validator: validate_ClustersUpdate_564191, base: "", url: url_ClustersUpdate_564192,
    schemes: {Scheme.Https})
type
  Call_ClustersDelete_564179 = ref object of OpenApiRestCall_563555
proc url_ClustersDelete_564181(protocol: Scheme; host: string; base: string;
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

proc validate_ClustersDelete_564180(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete a Service Fabric cluster resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564182 = path.getOrDefault("clusterName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "clusterName", valid_564182
  var valid_564183 = path.getOrDefault("subscriptionId")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "subscriptionId", valid_564183
  var valid_564184 = path.getOrDefault("resourceGroupName")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "resourceGroupName", valid_564184
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564185 = query.getOrDefault("api-version")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_564185 != nil:
    section.add "api-version", valid_564185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564186: Call_ClustersDelete_564179; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Service Fabric cluster resource with the specified name.
  ## 
  let valid = call_564186.validator(path, query, header, formData, body)
  let scheme = call_564186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564186.url(scheme.get, call_564186.host, call_564186.base,
                         call_564186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564186, url, valid)

proc call*(call_564187: Call_ClustersDelete_564179; clusterName: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## clustersDelete
  ## Delete a Service Fabric cluster resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564188 = newJObject()
  var query_564189 = newJObject()
  add(path_564188, "clusterName", newJString(clusterName))
  add(query_564189, "api-version", newJString(apiVersion))
  add(path_564188, "subscriptionId", newJString(subscriptionId))
  add(path_564188, "resourceGroupName", newJString(resourceGroupName))
  result = call_564187.call(path_564188, query_564189, nil, nil, nil)

var clustersDelete* = Call_ClustersDelete_564179(name: "clustersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}",
    validator: validate_ClustersDelete_564180, base: "", url: url_ClustersDelete_564181,
    schemes: {Scheme.Https})
type
  Call_ClustersListByResourceGroup_564220 = ref object of OpenApiRestCall_563555
proc url_ClustersListByResourceGroup_564222(protocol: Scheme; host: string;
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

proc validate_ClustersListByResourceGroup_564221(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all Service Fabric cluster resources created or in the process of being created in the resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564223 = path.getOrDefault("subscriptionId")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "subscriptionId", valid_564223
  var valid_564224 = path.getOrDefault("resourceGroupName")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "resourceGroupName", valid_564224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564225 = query.getOrDefault("api-version")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_564225 != nil:
    section.add "api-version", valid_564225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564226: Call_ClustersListByResourceGroup_564220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all Service Fabric cluster resources created or in the process of being created in the resource group.
  ## 
  let valid = call_564226.validator(path, query, header, formData, body)
  let scheme = call_564226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564226.url(scheme.get, call_564226.host, call_564226.base,
                         call_564226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564226, url, valid)

proc call*(call_564227: Call_ClustersListByResourceGroup_564220;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## clustersListByResourceGroup
  ## Gets all Service Fabric cluster resources created or in the process of being created in the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564228 = newJObject()
  var query_564229 = newJObject()
  add(query_564229, "api-version", newJString(apiVersion))
  add(path_564228, "subscriptionId", newJString(subscriptionId))
  add(path_564228, "resourceGroupName", newJString(resourceGroupName))
  result = call_564227.call(path_564228, query_564229, nil, nil, nil)

var clustersListByResourceGroup* = Call_ClustersListByResourceGroup_564220(
    name: "clustersListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters",
    validator: validate_ClustersListByResourceGroup_564221, base: "",
    url: url_ClustersListByResourceGroup_564222, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
