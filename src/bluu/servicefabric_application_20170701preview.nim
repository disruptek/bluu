
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ServiceFabricManagementClient
## version: 2017-07-01-preview
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

  OpenApiRestCall_563564 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563564](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563564): Option[Scheme] {.used.} =
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
  macServiceName = "servicefabric-application"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563786 = ref object of OpenApiRestCall_563564
proc url_OperationsList_563788(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563787(path: JsonNode; query: JsonNode;
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
  var valid_563936 = query.getOrDefault("api-version")
  valid_563936 = validateParameter(valid_563936, JString, required = true,
                                 default = nil)
  if valid_563936 != nil:
    section.add "api-version", valid_563936
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563963: Call_OperationsList_563786; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of available Service Fabric resource provider API operations.
  ## 
  let valid = call_563963.validator(path, query, header, formData, body)
  let scheme = call_563963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563963.url(scheme.get, call_563963.host, call_563963.base,
                         call_563963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563963, url, valid)

proc call*(call_564034: Call_OperationsList_563786; apiVersion: string): Recallable =
  ## operationsList
  ## Get the list of available Service Fabric resource provider API operations.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API
  var query_564035 = newJObject()
  add(query_564035, "api-version", newJString(apiVersion))
  result = call_564034.call(nil, query_564035, nil, nil, nil)

var operationsList* = Call_OperationsList_563786(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ServiceFabric/operations",
    validator: validate_OperationsList_563787, base: "", url: url_OperationsList_563788,
    schemes: {Scheme.Https})
type
  Call_ApplicationTypesList_564075 = ref object of OpenApiRestCall_563564
proc url_ApplicationTypesList_564077(protocol: Scheme; host: string; base: string;
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
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/applicationTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationTypesList_564076(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all application type name resources created or in the process of being created in the Service Fabric cluster resource.
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
  var valid_564101 = path.getOrDefault("clusterName")
  valid_564101 = validateParameter(valid_564101, JString, required = true,
                                 default = nil)
  if valid_564101 != nil:
    section.add "clusterName", valid_564101
  var valid_564102 = path.getOrDefault("subscriptionId")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "subscriptionId", valid_564102
  var valid_564103 = path.getOrDefault("resourceGroupName")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "resourceGroupName", valid_564103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564117 = query.getOrDefault("api-version")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = newJString("2017-07-01-preview"))
  if valid_564117 != nil:
    section.add "api-version", valid_564117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564118: Call_ApplicationTypesList_564075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all application type name resources created or in the process of being created in the Service Fabric cluster resource.
  ## 
  let valid = call_564118.validator(path, query, header, formData, body)
  let scheme = call_564118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564118.url(scheme.get, call_564118.host, call_564118.base,
                         call_564118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564118, url, valid)

proc call*(call_564119: Call_ApplicationTypesList_564075; clusterName: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2017-07-01-preview"): Recallable =
  ## applicationTypesList
  ## Gets all application type name resources created or in the process of being created in the Service Fabric cluster resource.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564120 = newJObject()
  var query_564121 = newJObject()
  add(path_564120, "clusterName", newJString(clusterName))
  add(query_564121, "api-version", newJString(apiVersion))
  add(path_564120, "subscriptionId", newJString(subscriptionId))
  add(path_564120, "resourceGroupName", newJString(resourceGroupName))
  result = call_564119.call(path_564120, query_564121, nil, nil, nil)

var applicationTypesList* = Call_ApplicationTypesList_564075(
    name: "applicationTypesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes",
    validator: validate_ApplicationTypesList_564076, base: "",
    url: url_ApplicationTypesList_564077, schemes: {Scheme.Https})
type
  Call_ApplicationTypesCreate_564134 = ref object of OpenApiRestCall_563564
proc url_ApplicationTypesCreate_564136(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "applicationTypeName" in path,
        "`applicationTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/applicationTypes/"),
               (kind: VariableSegment, value: "applicationTypeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationTypesCreate_564135(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a Service Fabric application type name resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   applicationTypeName: JString (required)
  ##                      : The name of the application type name resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564154 = path.getOrDefault("clusterName")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "clusterName", valid_564154
  var valid_564155 = path.getOrDefault("subscriptionId")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "subscriptionId", valid_564155
  var valid_564156 = path.getOrDefault("applicationTypeName")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "applicationTypeName", valid_564156
  var valid_564157 = path.getOrDefault("resourceGroupName")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "resourceGroupName", valid_564157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564158 = query.getOrDefault("api-version")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = newJString("2017-07-01-preview"))
  if valid_564158 != nil:
    section.add "api-version", valid_564158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The application type name resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564160: Call_ApplicationTypesCreate_564134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Service Fabric application type name resource with the specified name.
  ## 
  let valid = call_564160.validator(path, query, header, formData, body)
  let scheme = call_564160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564160.url(scheme.get, call_564160.host, call_564160.base,
                         call_564160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564160, url, valid)

proc call*(call_564161: Call_ApplicationTypesCreate_564134; clusterName: string;
          subscriptionId: string; applicationTypeName: string;
          resourceGroupName: string; parameters: JsonNode;
          apiVersion: string = "2017-07-01-preview"): Recallable =
  ## applicationTypesCreate
  ## Create or update a Service Fabric application type name resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type name resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : The application type name resource.
  var path_564162 = newJObject()
  var query_564163 = newJObject()
  var body_564164 = newJObject()
  add(path_564162, "clusterName", newJString(clusterName))
  add(query_564163, "api-version", newJString(apiVersion))
  add(path_564162, "subscriptionId", newJString(subscriptionId))
  add(path_564162, "applicationTypeName", newJString(applicationTypeName))
  add(path_564162, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564164 = parameters
  result = call_564161.call(path_564162, query_564163, nil, nil, body_564164)

var applicationTypesCreate* = Call_ApplicationTypesCreate_564134(
    name: "applicationTypesCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}",
    validator: validate_ApplicationTypesCreate_564135, base: "",
    url: url_ApplicationTypesCreate_564136, schemes: {Scheme.Https})
type
  Call_ApplicationTypesGet_564122 = ref object of OpenApiRestCall_563564
proc url_ApplicationTypesGet_564124(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "applicationTypeName" in path,
        "`applicationTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/applicationTypes/"),
               (kind: VariableSegment, value: "applicationTypeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationTypesGet_564123(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get a Service Fabric application type name resource created or in the process of being created in the Service Fabric cluster resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   applicationTypeName: JString (required)
  ##                      : The name of the application type name resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564125 = path.getOrDefault("clusterName")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "clusterName", valid_564125
  var valid_564126 = path.getOrDefault("subscriptionId")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "subscriptionId", valid_564126
  var valid_564127 = path.getOrDefault("applicationTypeName")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "applicationTypeName", valid_564127
  var valid_564128 = path.getOrDefault("resourceGroupName")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "resourceGroupName", valid_564128
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564129 = query.getOrDefault("api-version")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = newJString("2017-07-01-preview"))
  if valid_564129 != nil:
    section.add "api-version", valid_564129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564130: Call_ApplicationTypesGet_564122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Service Fabric application type name resource created or in the process of being created in the Service Fabric cluster resource.
  ## 
  let valid = call_564130.validator(path, query, header, formData, body)
  let scheme = call_564130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564130.url(scheme.get, call_564130.host, call_564130.base,
                         call_564130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564130, url, valid)

proc call*(call_564131: Call_ApplicationTypesGet_564122; clusterName: string;
          subscriptionId: string; applicationTypeName: string;
          resourceGroupName: string; apiVersion: string = "2017-07-01-preview"): Recallable =
  ## applicationTypesGet
  ## Get a Service Fabric application type name resource created or in the process of being created in the Service Fabric cluster resource.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type name resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564132 = newJObject()
  var query_564133 = newJObject()
  add(path_564132, "clusterName", newJString(clusterName))
  add(query_564133, "api-version", newJString(apiVersion))
  add(path_564132, "subscriptionId", newJString(subscriptionId))
  add(path_564132, "applicationTypeName", newJString(applicationTypeName))
  add(path_564132, "resourceGroupName", newJString(resourceGroupName))
  result = call_564131.call(path_564132, query_564133, nil, nil, nil)

var applicationTypesGet* = Call_ApplicationTypesGet_564122(
    name: "applicationTypesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}",
    validator: validate_ApplicationTypesGet_564123, base: "",
    url: url_ApplicationTypesGet_564124, schemes: {Scheme.Https})
type
  Call_ApplicationTypesDelete_564165 = ref object of OpenApiRestCall_563564
proc url_ApplicationTypesDelete_564167(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "applicationTypeName" in path,
        "`applicationTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/applicationTypes/"),
               (kind: VariableSegment, value: "applicationTypeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationTypesDelete_564166(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a Service Fabric application type name resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   applicationTypeName: JString (required)
  ##                      : The name of the application type name resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564168 = path.getOrDefault("clusterName")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "clusterName", valid_564168
  var valid_564169 = path.getOrDefault("subscriptionId")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "subscriptionId", valid_564169
  var valid_564170 = path.getOrDefault("applicationTypeName")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "applicationTypeName", valid_564170
  var valid_564171 = path.getOrDefault("resourceGroupName")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "resourceGroupName", valid_564171
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564172 = query.getOrDefault("api-version")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = newJString("2017-07-01-preview"))
  if valid_564172 != nil:
    section.add "api-version", valid_564172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564173: Call_ApplicationTypesDelete_564165; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Service Fabric application type name resource with the specified name.
  ## 
  let valid = call_564173.validator(path, query, header, formData, body)
  let scheme = call_564173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564173.url(scheme.get, call_564173.host, call_564173.base,
                         call_564173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564173, url, valid)

proc call*(call_564174: Call_ApplicationTypesDelete_564165; clusterName: string;
          subscriptionId: string; applicationTypeName: string;
          resourceGroupName: string; apiVersion: string = "2017-07-01-preview"): Recallable =
  ## applicationTypesDelete
  ## Delete a Service Fabric application type name resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type name resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564175 = newJObject()
  var query_564176 = newJObject()
  add(path_564175, "clusterName", newJString(clusterName))
  add(query_564176, "api-version", newJString(apiVersion))
  add(path_564175, "subscriptionId", newJString(subscriptionId))
  add(path_564175, "applicationTypeName", newJString(applicationTypeName))
  add(path_564175, "resourceGroupName", newJString(resourceGroupName))
  result = call_564174.call(path_564175, query_564176, nil, nil, nil)

var applicationTypesDelete* = Call_ApplicationTypesDelete_564165(
    name: "applicationTypesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}",
    validator: validate_ApplicationTypesDelete_564166, base: "",
    url: url_ApplicationTypesDelete_564167, schemes: {Scheme.Https})
type
  Call_ApplicationTypeVersionsList_564177 = ref object of OpenApiRestCall_563564
proc url_ApplicationTypeVersionsList_564179(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "applicationTypeName" in path,
        "`applicationTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/applicationTypes/"),
               (kind: VariableSegment, value: "applicationTypeName"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationTypeVersionsList_564178(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all application type version resources created or in the process of being created in the Service Fabric application type name resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   applicationTypeName: JString (required)
  ##                      : The name of the application type name resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564180 = path.getOrDefault("clusterName")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "clusterName", valid_564180
  var valid_564181 = path.getOrDefault("subscriptionId")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "subscriptionId", valid_564181
  var valid_564182 = path.getOrDefault("applicationTypeName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "applicationTypeName", valid_564182
  var valid_564183 = path.getOrDefault("resourceGroupName")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "resourceGroupName", valid_564183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564184 = query.getOrDefault("api-version")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = newJString("2017-07-01-preview"))
  if valid_564184 != nil:
    section.add "api-version", valid_564184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564185: Call_ApplicationTypeVersionsList_564177; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all application type version resources created or in the process of being created in the Service Fabric application type name resource.
  ## 
  let valid = call_564185.validator(path, query, header, formData, body)
  let scheme = call_564185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564185.url(scheme.get, call_564185.host, call_564185.base,
                         call_564185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564185, url, valid)

proc call*(call_564186: Call_ApplicationTypeVersionsList_564177;
          clusterName: string; subscriptionId: string; applicationTypeName: string;
          resourceGroupName: string; apiVersion: string = "2017-07-01-preview"): Recallable =
  ## applicationTypeVersionsList
  ## Gets all application type version resources created or in the process of being created in the Service Fabric application type name resource.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type name resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564187 = newJObject()
  var query_564188 = newJObject()
  add(path_564187, "clusterName", newJString(clusterName))
  add(query_564188, "api-version", newJString(apiVersion))
  add(path_564187, "subscriptionId", newJString(subscriptionId))
  add(path_564187, "applicationTypeName", newJString(applicationTypeName))
  add(path_564187, "resourceGroupName", newJString(resourceGroupName))
  result = call_564186.call(path_564187, query_564188, nil, nil, nil)

var applicationTypeVersionsList* = Call_ApplicationTypeVersionsList_564177(
    name: "applicationTypeVersionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}/versions",
    validator: validate_ApplicationTypeVersionsList_564178, base: "",
    url: url_ApplicationTypeVersionsList_564179, schemes: {Scheme.Https})
type
  Call_ApplicationTypeVersionsCreate_564202 = ref object of OpenApiRestCall_563564
proc url_ApplicationTypeVersionsCreate_564204(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "applicationTypeName" in path,
        "`applicationTypeName` is a required path parameter"
  assert "version" in path, "`version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/applicationTypes/"),
               (kind: VariableSegment, value: "applicationTypeName"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "version")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationTypeVersionsCreate_564203(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a Service Fabric application type version resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   version: JString (required)
  ##          : The application type version.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   applicationTypeName: JString (required)
  ##                      : The name of the application type name resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564205 = path.getOrDefault("clusterName")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "clusterName", valid_564205
  var valid_564206 = path.getOrDefault("version")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "version", valid_564206
  var valid_564207 = path.getOrDefault("subscriptionId")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "subscriptionId", valid_564207
  var valid_564208 = path.getOrDefault("applicationTypeName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "applicationTypeName", valid_564208
  var valid_564209 = path.getOrDefault("resourceGroupName")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "resourceGroupName", valid_564209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564210 = query.getOrDefault("api-version")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = newJString("2017-07-01-preview"))
  if valid_564210 != nil:
    section.add "api-version", valid_564210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The application type version resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564212: Call_ApplicationTypeVersionsCreate_564202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Service Fabric application type version resource with the specified name.
  ## 
  let valid = call_564212.validator(path, query, header, formData, body)
  let scheme = call_564212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564212.url(scheme.get, call_564212.host, call_564212.base,
                         call_564212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564212, url, valid)

proc call*(call_564213: Call_ApplicationTypeVersionsCreate_564202;
          clusterName: string; version: string; subscriptionId: string;
          applicationTypeName: string; resourceGroupName: string;
          parameters: JsonNode; apiVersion: string = "2017-07-01-preview"): Recallable =
  ## applicationTypeVersionsCreate
  ## Create or update a Service Fabric application type version resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   version: string (required)
  ##          : The application type version.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type name resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : The application type version resource.
  var path_564214 = newJObject()
  var query_564215 = newJObject()
  var body_564216 = newJObject()
  add(path_564214, "clusterName", newJString(clusterName))
  add(path_564214, "version", newJString(version))
  add(query_564215, "api-version", newJString(apiVersion))
  add(path_564214, "subscriptionId", newJString(subscriptionId))
  add(path_564214, "applicationTypeName", newJString(applicationTypeName))
  add(path_564214, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564216 = parameters
  result = call_564213.call(path_564214, query_564215, nil, nil, body_564216)

var applicationTypeVersionsCreate* = Call_ApplicationTypeVersionsCreate_564202(
    name: "applicationTypeVersionsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}/versions/{version}",
    validator: validate_ApplicationTypeVersionsCreate_564203, base: "",
    url: url_ApplicationTypeVersionsCreate_564204, schemes: {Scheme.Https})
type
  Call_ApplicationTypeVersionsGet_564189 = ref object of OpenApiRestCall_563564
proc url_ApplicationTypeVersionsGet_564191(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "applicationTypeName" in path,
        "`applicationTypeName` is a required path parameter"
  assert "version" in path, "`version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/applicationTypes/"),
               (kind: VariableSegment, value: "applicationTypeName"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "version")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationTypeVersionsGet_564190(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a Service Fabric application type version resource created or in the process of being created in the Service Fabric application type name resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   version: JString (required)
  ##          : The application type version.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   applicationTypeName: JString (required)
  ##                      : The name of the application type name resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564192 = path.getOrDefault("clusterName")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "clusterName", valid_564192
  var valid_564193 = path.getOrDefault("version")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "version", valid_564193
  var valid_564194 = path.getOrDefault("subscriptionId")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "subscriptionId", valid_564194
  var valid_564195 = path.getOrDefault("applicationTypeName")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "applicationTypeName", valid_564195
  var valid_564196 = path.getOrDefault("resourceGroupName")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "resourceGroupName", valid_564196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564197 = query.getOrDefault("api-version")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = newJString("2017-07-01-preview"))
  if valid_564197 != nil:
    section.add "api-version", valid_564197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564198: Call_ApplicationTypeVersionsGet_564189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Service Fabric application type version resource created or in the process of being created in the Service Fabric application type name resource.
  ## 
  let valid = call_564198.validator(path, query, header, formData, body)
  let scheme = call_564198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564198.url(scheme.get, call_564198.host, call_564198.base,
                         call_564198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564198, url, valid)

proc call*(call_564199: Call_ApplicationTypeVersionsGet_564189;
          clusterName: string; version: string; subscriptionId: string;
          applicationTypeName: string; resourceGroupName: string;
          apiVersion: string = "2017-07-01-preview"): Recallable =
  ## applicationTypeVersionsGet
  ## Get a Service Fabric application type version resource created or in the process of being created in the Service Fabric application type name resource.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   version: string (required)
  ##          : The application type version.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type name resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564200 = newJObject()
  var query_564201 = newJObject()
  add(path_564200, "clusterName", newJString(clusterName))
  add(path_564200, "version", newJString(version))
  add(query_564201, "api-version", newJString(apiVersion))
  add(path_564200, "subscriptionId", newJString(subscriptionId))
  add(path_564200, "applicationTypeName", newJString(applicationTypeName))
  add(path_564200, "resourceGroupName", newJString(resourceGroupName))
  result = call_564199.call(path_564200, query_564201, nil, nil, nil)

var applicationTypeVersionsGet* = Call_ApplicationTypeVersionsGet_564189(
    name: "applicationTypeVersionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}/versions/{version}",
    validator: validate_ApplicationTypeVersionsGet_564190, base: "",
    url: url_ApplicationTypeVersionsGet_564191, schemes: {Scheme.Https})
type
  Call_ApplicationTypeVersionsDelete_564217 = ref object of OpenApiRestCall_563564
proc url_ApplicationTypeVersionsDelete_564219(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "applicationTypeName" in path,
        "`applicationTypeName` is a required path parameter"
  assert "version" in path, "`version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/applicationTypes/"),
               (kind: VariableSegment, value: "applicationTypeName"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "version")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationTypeVersionsDelete_564218(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a Service Fabric application type version resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   version: JString (required)
  ##          : The application type version.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   applicationTypeName: JString (required)
  ##                      : The name of the application type name resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564220 = path.getOrDefault("clusterName")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "clusterName", valid_564220
  var valid_564221 = path.getOrDefault("version")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "version", valid_564221
  var valid_564222 = path.getOrDefault("subscriptionId")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "subscriptionId", valid_564222
  var valid_564223 = path.getOrDefault("applicationTypeName")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "applicationTypeName", valid_564223
  var valid_564224 = path.getOrDefault("resourceGroupName")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "resourceGroupName", valid_564224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564225 = query.getOrDefault("api-version")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = newJString("2017-07-01-preview"))
  if valid_564225 != nil:
    section.add "api-version", valid_564225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564226: Call_ApplicationTypeVersionsDelete_564217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Service Fabric application type version resource with the specified name.
  ## 
  let valid = call_564226.validator(path, query, header, formData, body)
  let scheme = call_564226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564226.url(scheme.get, call_564226.host, call_564226.base,
                         call_564226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564226, url, valid)

proc call*(call_564227: Call_ApplicationTypeVersionsDelete_564217;
          clusterName: string; version: string; subscriptionId: string;
          applicationTypeName: string; resourceGroupName: string;
          apiVersion: string = "2017-07-01-preview"): Recallable =
  ## applicationTypeVersionsDelete
  ## Delete a Service Fabric application type version resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   version: string (required)
  ##          : The application type version.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type name resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564228 = newJObject()
  var query_564229 = newJObject()
  add(path_564228, "clusterName", newJString(clusterName))
  add(path_564228, "version", newJString(version))
  add(query_564229, "api-version", newJString(apiVersion))
  add(path_564228, "subscriptionId", newJString(subscriptionId))
  add(path_564228, "applicationTypeName", newJString(applicationTypeName))
  add(path_564228, "resourceGroupName", newJString(resourceGroupName))
  result = call_564227.call(path_564228, query_564229, nil, nil, nil)

var applicationTypeVersionsDelete* = Call_ApplicationTypeVersionsDelete_564217(
    name: "applicationTypeVersionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}/versions/{version}",
    validator: validate_ApplicationTypeVersionsDelete_564218, base: "",
    url: url_ApplicationTypeVersionsDelete_564219, schemes: {Scheme.Https})
type
  Call_ApplicationsList_564230 = ref object of OpenApiRestCall_563564
proc url_ApplicationsList_564232(protocol: Scheme; host: string; base: string;
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
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/applications")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationsList_564231(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets all application resources created or in the process of being created in the Service Fabric cluster resource.
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
  var valid_564233 = path.getOrDefault("clusterName")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "clusterName", valid_564233
  var valid_564234 = path.getOrDefault("subscriptionId")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "subscriptionId", valid_564234
  var valid_564235 = path.getOrDefault("resourceGroupName")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "resourceGroupName", valid_564235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564236 = query.getOrDefault("api-version")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = newJString("2017-07-01-preview"))
  if valid_564236 != nil:
    section.add "api-version", valid_564236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564237: Call_ApplicationsList_564230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all application resources created or in the process of being created in the Service Fabric cluster resource.
  ## 
  let valid = call_564237.validator(path, query, header, formData, body)
  let scheme = call_564237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564237.url(scheme.get, call_564237.host, call_564237.base,
                         call_564237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564237, url, valid)

proc call*(call_564238: Call_ApplicationsList_564230; clusterName: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2017-07-01-preview"): Recallable =
  ## applicationsList
  ## Gets all application resources created or in the process of being created in the Service Fabric cluster resource.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564239 = newJObject()
  var query_564240 = newJObject()
  add(path_564239, "clusterName", newJString(clusterName))
  add(query_564240, "api-version", newJString(apiVersion))
  add(path_564239, "subscriptionId", newJString(subscriptionId))
  add(path_564239, "resourceGroupName", newJString(resourceGroupName))
  result = call_564238.call(path_564239, query_564240, nil, nil, nil)

var applicationsList* = Call_ApplicationsList_564230(name: "applicationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications",
    validator: validate_ApplicationsList_564231, base: "",
    url: url_ApplicationsList_564232, schemes: {Scheme.Https})
type
  Call_ApplicationsCreate_564253 = ref object of OpenApiRestCall_563564
proc url_ApplicationsCreate_564255(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationsCreate_564254(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Create or update a Service Fabric application resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   applicationName: JString (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564256 = path.getOrDefault("clusterName")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "clusterName", valid_564256
  var valid_564257 = path.getOrDefault("applicationName")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "applicationName", valid_564257
  var valid_564258 = path.getOrDefault("subscriptionId")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "subscriptionId", valid_564258
  var valid_564259 = path.getOrDefault("resourceGroupName")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "resourceGroupName", valid_564259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564260 = query.getOrDefault("api-version")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = newJString("2017-07-01-preview"))
  if valid_564260 != nil:
    section.add "api-version", valid_564260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The application resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564262: Call_ApplicationsCreate_564253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Service Fabric application resource with the specified name.
  ## 
  let valid = call_564262.validator(path, query, header, formData, body)
  let scheme = call_564262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564262.url(scheme.get, call_564262.host, call_564262.base,
                         call_564262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564262, url, valid)

proc call*(call_564263: Call_ApplicationsCreate_564253; clusterName: string;
          applicationName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode;
          apiVersion: string = "2017-07-01-preview"): Recallable =
  ## applicationsCreate
  ## Create or update a Service Fabric application resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : The application resource.
  var path_564264 = newJObject()
  var query_564265 = newJObject()
  var body_564266 = newJObject()
  add(path_564264, "clusterName", newJString(clusterName))
  add(query_564265, "api-version", newJString(apiVersion))
  add(path_564264, "applicationName", newJString(applicationName))
  add(path_564264, "subscriptionId", newJString(subscriptionId))
  add(path_564264, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564266 = parameters
  result = call_564263.call(path_564264, query_564265, nil, nil, body_564266)

var applicationsCreate* = Call_ApplicationsCreate_564253(
    name: "applicationsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}",
    validator: validate_ApplicationsCreate_564254, base: "",
    url: url_ApplicationsCreate_564255, schemes: {Scheme.Https})
type
  Call_ApplicationsGet_564241 = ref object of OpenApiRestCall_563564
proc url_ApplicationsGet_564243(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationsGet_564242(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get a Service Fabric application resource created or in the process of being created in the Service Fabric cluster resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   applicationName: JString (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564244 = path.getOrDefault("clusterName")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "clusterName", valid_564244
  var valid_564245 = path.getOrDefault("applicationName")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "applicationName", valid_564245
  var valid_564246 = path.getOrDefault("subscriptionId")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "subscriptionId", valid_564246
  var valid_564247 = path.getOrDefault("resourceGroupName")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "resourceGroupName", valid_564247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564248 = query.getOrDefault("api-version")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = newJString("2017-07-01-preview"))
  if valid_564248 != nil:
    section.add "api-version", valid_564248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564249: Call_ApplicationsGet_564241; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Service Fabric application resource created or in the process of being created in the Service Fabric cluster resource.
  ## 
  let valid = call_564249.validator(path, query, header, formData, body)
  let scheme = call_564249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564249.url(scheme.get, call_564249.host, call_564249.base,
                         call_564249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564249, url, valid)

proc call*(call_564250: Call_ApplicationsGet_564241; clusterName: string;
          applicationName: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2017-07-01-preview"): Recallable =
  ## applicationsGet
  ## Get a Service Fabric application resource created or in the process of being created in the Service Fabric cluster resource.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564251 = newJObject()
  var query_564252 = newJObject()
  add(path_564251, "clusterName", newJString(clusterName))
  add(query_564252, "api-version", newJString(apiVersion))
  add(path_564251, "applicationName", newJString(applicationName))
  add(path_564251, "subscriptionId", newJString(subscriptionId))
  add(path_564251, "resourceGroupName", newJString(resourceGroupName))
  result = call_564250.call(path_564251, query_564252, nil, nil, nil)

var applicationsGet* = Call_ApplicationsGet_564241(name: "applicationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}",
    validator: validate_ApplicationsGet_564242, base: "", url: url_ApplicationsGet_564243,
    schemes: {Scheme.Https})
type
  Call_ApplicationsUpdate_564279 = ref object of OpenApiRestCall_563564
proc url_ApplicationsUpdate_564281(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationsUpdate_564280(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Update a Service Fabric application resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   applicationName: JString (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564282 = path.getOrDefault("clusterName")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "clusterName", valid_564282
  var valid_564283 = path.getOrDefault("applicationName")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "applicationName", valid_564283
  var valid_564284 = path.getOrDefault("subscriptionId")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "subscriptionId", valid_564284
  var valid_564285 = path.getOrDefault("resourceGroupName")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "resourceGroupName", valid_564285
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564286 = query.getOrDefault("api-version")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = newJString("2017-07-01-preview"))
  if valid_564286 != nil:
    section.add "api-version", valid_564286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The application resource for patch operations.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564288: Call_ApplicationsUpdate_564279; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a Service Fabric application resource with the specified name.
  ## 
  let valid = call_564288.validator(path, query, header, formData, body)
  let scheme = call_564288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564288.url(scheme.get, call_564288.host, call_564288.base,
                         call_564288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564288, url, valid)

proc call*(call_564289: Call_ApplicationsUpdate_564279; clusterName: string;
          applicationName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode;
          apiVersion: string = "2017-07-01-preview"): Recallable =
  ## applicationsUpdate
  ## Update a Service Fabric application resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : The application resource for patch operations.
  var path_564290 = newJObject()
  var query_564291 = newJObject()
  var body_564292 = newJObject()
  add(path_564290, "clusterName", newJString(clusterName))
  add(query_564291, "api-version", newJString(apiVersion))
  add(path_564290, "applicationName", newJString(applicationName))
  add(path_564290, "subscriptionId", newJString(subscriptionId))
  add(path_564290, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564292 = parameters
  result = call_564289.call(path_564290, query_564291, nil, nil, body_564292)

var applicationsUpdate* = Call_ApplicationsUpdate_564279(
    name: "applicationsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}",
    validator: validate_ApplicationsUpdate_564280, base: "",
    url: url_ApplicationsUpdate_564281, schemes: {Scheme.Https})
type
  Call_ApplicationsDelete_564267 = ref object of OpenApiRestCall_563564
proc url_ApplicationsDelete_564269(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationsDelete_564268(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Delete a Service Fabric application resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   applicationName: JString (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564270 = path.getOrDefault("clusterName")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "clusterName", valid_564270
  var valid_564271 = path.getOrDefault("applicationName")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "applicationName", valid_564271
  var valid_564272 = path.getOrDefault("subscriptionId")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "subscriptionId", valid_564272
  var valid_564273 = path.getOrDefault("resourceGroupName")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "resourceGroupName", valid_564273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564274 = query.getOrDefault("api-version")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = newJString("2017-07-01-preview"))
  if valid_564274 != nil:
    section.add "api-version", valid_564274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564275: Call_ApplicationsDelete_564267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Service Fabric application resource with the specified name.
  ## 
  let valid = call_564275.validator(path, query, header, formData, body)
  let scheme = call_564275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564275.url(scheme.get, call_564275.host, call_564275.base,
                         call_564275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564275, url, valid)

proc call*(call_564276: Call_ApplicationsDelete_564267; clusterName: string;
          applicationName: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2017-07-01-preview"): Recallable =
  ## applicationsDelete
  ## Delete a Service Fabric application resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564277 = newJObject()
  var query_564278 = newJObject()
  add(path_564277, "clusterName", newJString(clusterName))
  add(query_564278, "api-version", newJString(apiVersion))
  add(path_564277, "applicationName", newJString(applicationName))
  add(path_564277, "subscriptionId", newJString(subscriptionId))
  add(path_564277, "resourceGroupName", newJString(resourceGroupName))
  result = call_564276.call(path_564277, query_564278, nil, nil, nil)

var applicationsDelete* = Call_ApplicationsDelete_564267(
    name: "applicationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}",
    validator: validate_ApplicationsDelete_564268, base: "",
    url: url_ApplicationsDelete_564269, schemes: {Scheme.Https})
type
  Call_ServicesList_564293 = ref object of OpenApiRestCall_563564
proc url_ServicesList_564295(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesList_564294(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all service resources created or in the process of being created in the Service Fabric application resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   applicationName: JString (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564296 = path.getOrDefault("clusterName")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "clusterName", valid_564296
  var valid_564297 = path.getOrDefault("applicationName")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "applicationName", valid_564297
  var valid_564298 = path.getOrDefault("subscriptionId")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "subscriptionId", valid_564298
  var valid_564299 = path.getOrDefault("resourceGroupName")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "resourceGroupName", valid_564299
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564300 = query.getOrDefault("api-version")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = newJString("2017-07-01-preview"))
  if valid_564300 != nil:
    section.add "api-version", valid_564300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564301: Call_ServicesList_564293; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all service resources created or in the process of being created in the Service Fabric application resource.
  ## 
  let valid = call_564301.validator(path, query, header, formData, body)
  let scheme = call_564301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564301.url(scheme.get, call_564301.host, call_564301.base,
                         call_564301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564301, url, valid)

proc call*(call_564302: Call_ServicesList_564293; clusterName: string;
          applicationName: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2017-07-01-preview"): Recallable =
  ## servicesList
  ## Gets all service resources created or in the process of being created in the Service Fabric application resource.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564303 = newJObject()
  var query_564304 = newJObject()
  add(path_564303, "clusterName", newJString(clusterName))
  add(query_564304, "api-version", newJString(apiVersion))
  add(path_564303, "applicationName", newJString(applicationName))
  add(path_564303, "subscriptionId", newJString(subscriptionId))
  add(path_564303, "resourceGroupName", newJString(resourceGroupName))
  result = call_564302.call(path_564303, query_564304, nil, nil, nil)

var servicesList* = Call_ServicesList_564293(name: "servicesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}/services",
    validator: validate_ServicesList_564294, base: "", url: url_ServicesList_564295,
    schemes: {Scheme.Https})
type
  Call_ServicesCreate_564318 = ref object of OpenApiRestCall_563564
proc url_ServicesCreate_564320(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesCreate_564319(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Create or update a Service Fabric service resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   serviceName: JString (required)
  ##              : The name of the service resource in the format of {applicationName}~{serviceName}.
  ##   applicationName: JString (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564321 = path.getOrDefault("clusterName")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "clusterName", valid_564321
  var valid_564322 = path.getOrDefault("serviceName")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "serviceName", valid_564322
  var valid_564323 = path.getOrDefault("applicationName")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "applicationName", valid_564323
  var valid_564324 = path.getOrDefault("subscriptionId")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "subscriptionId", valid_564324
  var valid_564325 = path.getOrDefault("resourceGroupName")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "resourceGroupName", valid_564325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564326 = query.getOrDefault("api-version")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = newJString("2017-07-01-preview"))
  if valid_564326 != nil:
    section.add "api-version", valid_564326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The service resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564328: Call_ServicesCreate_564318; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Service Fabric service resource with the specified name.
  ## 
  let valid = call_564328.validator(path, query, header, formData, body)
  let scheme = call_564328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564328.url(scheme.get, call_564328.host, call_564328.base,
                         call_564328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564328, url, valid)

proc call*(call_564329: Call_ServicesCreate_564318; clusterName: string;
          serviceName: string; applicationName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode;
          apiVersion: string = "2017-07-01-preview"): Recallable =
  ## servicesCreate
  ## Create or update a Service Fabric service resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   serviceName: string (required)
  ##              : The name of the service resource in the format of {applicationName}~{serviceName}.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : The service resource.
  var path_564330 = newJObject()
  var query_564331 = newJObject()
  var body_564332 = newJObject()
  add(path_564330, "clusterName", newJString(clusterName))
  add(path_564330, "serviceName", newJString(serviceName))
  add(query_564331, "api-version", newJString(apiVersion))
  add(path_564330, "applicationName", newJString(applicationName))
  add(path_564330, "subscriptionId", newJString(subscriptionId))
  add(path_564330, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564332 = parameters
  result = call_564329.call(path_564330, query_564331, nil, nil, body_564332)

var servicesCreate* = Call_ServicesCreate_564318(name: "servicesCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}/services/{serviceName}",
    validator: validate_ServicesCreate_564319, base: "", url: url_ServicesCreate_564320,
    schemes: {Scheme.Https})
type
  Call_ServicesGet_564305 = ref object of OpenApiRestCall_563564
proc url_ServicesGet_564307(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesGet_564306(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a Service Fabric service resource created or in the process of being created in the Service Fabric application resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   serviceName: JString (required)
  ##              : The name of the service resource in the format of {applicationName}~{serviceName}.
  ##   applicationName: JString (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564308 = path.getOrDefault("clusterName")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = nil)
  if valid_564308 != nil:
    section.add "clusterName", valid_564308
  var valid_564309 = path.getOrDefault("serviceName")
  valid_564309 = validateParameter(valid_564309, JString, required = true,
                                 default = nil)
  if valid_564309 != nil:
    section.add "serviceName", valid_564309
  var valid_564310 = path.getOrDefault("applicationName")
  valid_564310 = validateParameter(valid_564310, JString, required = true,
                                 default = nil)
  if valid_564310 != nil:
    section.add "applicationName", valid_564310
  var valid_564311 = path.getOrDefault("subscriptionId")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "subscriptionId", valid_564311
  var valid_564312 = path.getOrDefault("resourceGroupName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "resourceGroupName", valid_564312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564313 = query.getOrDefault("api-version")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = newJString("2017-07-01-preview"))
  if valid_564313 != nil:
    section.add "api-version", valid_564313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564314: Call_ServicesGet_564305; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Service Fabric service resource created or in the process of being created in the Service Fabric application resource.
  ## 
  let valid = call_564314.validator(path, query, header, formData, body)
  let scheme = call_564314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564314.url(scheme.get, call_564314.host, call_564314.base,
                         call_564314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564314, url, valid)

proc call*(call_564315: Call_ServicesGet_564305; clusterName: string;
          serviceName: string; applicationName: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2017-07-01-preview"): Recallable =
  ## servicesGet
  ## Get a Service Fabric service resource created or in the process of being created in the Service Fabric application resource.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   serviceName: string (required)
  ##              : The name of the service resource in the format of {applicationName}~{serviceName}.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564316 = newJObject()
  var query_564317 = newJObject()
  add(path_564316, "clusterName", newJString(clusterName))
  add(path_564316, "serviceName", newJString(serviceName))
  add(query_564317, "api-version", newJString(apiVersion))
  add(path_564316, "applicationName", newJString(applicationName))
  add(path_564316, "subscriptionId", newJString(subscriptionId))
  add(path_564316, "resourceGroupName", newJString(resourceGroupName))
  result = call_564315.call(path_564316, query_564317, nil, nil, nil)

var servicesGet* = Call_ServicesGet_564305(name: "servicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}/services/{serviceName}",
                                        validator: validate_ServicesGet_564306,
                                        base: "", url: url_ServicesGet_564307,
                                        schemes: {Scheme.Https})
type
  Call_ServicesUpdate_564346 = ref object of OpenApiRestCall_563564
proc url_ServicesUpdate_564348(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesUpdate_564347(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Update a Service Fabric service resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   serviceName: JString (required)
  ##              : The name of the service resource in the format of {applicationName}~{serviceName}.
  ##   applicationName: JString (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564349 = path.getOrDefault("clusterName")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "clusterName", valid_564349
  var valid_564350 = path.getOrDefault("serviceName")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "serviceName", valid_564350
  var valid_564351 = path.getOrDefault("applicationName")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "applicationName", valid_564351
  var valid_564352 = path.getOrDefault("subscriptionId")
  valid_564352 = validateParameter(valid_564352, JString, required = true,
                                 default = nil)
  if valid_564352 != nil:
    section.add "subscriptionId", valid_564352
  var valid_564353 = path.getOrDefault("resourceGroupName")
  valid_564353 = validateParameter(valid_564353, JString, required = true,
                                 default = nil)
  if valid_564353 != nil:
    section.add "resourceGroupName", valid_564353
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564354 = query.getOrDefault("api-version")
  valid_564354 = validateParameter(valid_564354, JString, required = true,
                                 default = newJString("2017-07-01-preview"))
  if valid_564354 != nil:
    section.add "api-version", valid_564354
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The service resource for patch operations.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564356: Call_ServicesUpdate_564346; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a Service Fabric service resource with the specified name.
  ## 
  let valid = call_564356.validator(path, query, header, formData, body)
  let scheme = call_564356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564356.url(scheme.get, call_564356.host, call_564356.base,
                         call_564356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564356, url, valid)

proc call*(call_564357: Call_ServicesUpdate_564346; clusterName: string;
          serviceName: string; applicationName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode;
          apiVersion: string = "2017-07-01-preview"): Recallable =
  ## servicesUpdate
  ## Update a Service Fabric service resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   serviceName: string (required)
  ##              : The name of the service resource in the format of {applicationName}~{serviceName}.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : The service resource for patch operations.
  var path_564358 = newJObject()
  var query_564359 = newJObject()
  var body_564360 = newJObject()
  add(path_564358, "clusterName", newJString(clusterName))
  add(path_564358, "serviceName", newJString(serviceName))
  add(query_564359, "api-version", newJString(apiVersion))
  add(path_564358, "applicationName", newJString(applicationName))
  add(path_564358, "subscriptionId", newJString(subscriptionId))
  add(path_564358, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564360 = parameters
  result = call_564357.call(path_564358, query_564359, nil, nil, body_564360)

var servicesUpdate* = Call_ServicesUpdate_564346(name: "servicesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}/services/{serviceName}",
    validator: validate_ServicesUpdate_564347, base: "", url: url_ServicesUpdate_564348,
    schemes: {Scheme.Https})
type
  Call_ServicesDelete_564333 = ref object of OpenApiRestCall_563564
proc url_ServicesDelete_564335(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters/"),
               (kind: VariableSegment, value: "clusterName"),
               (kind: ConstantSegment, value: "/applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesDelete_564334(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete a Service Fabric service resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   serviceName: JString (required)
  ##              : The name of the service resource in the format of {applicationName}~{serviceName}.
  ##   applicationName: JString (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_564336 = path.getOrDefault("clusterName")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "clusterName", valid_564336
  var valid_564337 = path.getOrDefault("serviceName")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "serviceName", valid_564337
  var valid_564338 = path.getOrDefault("applicationName")
  valid_564338 = validateParameter(valid_564338, JString, required = true,
                                 default = nil)
  if valid_564338 != nil:
    section.add "applicationName", valid_564338
  var valid_564339 = path.getOrDefault("subscriptionId")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = nil)
  if valid_564339 != nil:
    section.add "subscriptionId", valid_564339
  var valid_564340 = path.getOrDefault("resourceGroupName")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "resourceGroupName", valid_564340
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564341 = query.getOrDefault("api-version")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = newJString("2017-07-01-preview"))
  if valid_564341 != nil:
    section.add "api-version", valid_564341
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564342: Call_ServicesDelete_564333; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Service Fabric service resource with the specified name.
  ## 
  let valid = call_564342.validator(path, query, header, formData, body)
  let scheme = call_564342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564342.url(scheme.get, call_564342.host, call_564342.base,
                         call_564342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564342, url, valid)

proc call*(call_564343: Call_ServicesDelete_564333; clusterName: string;
          serviceName: string; applicationName: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2017-07-01-preview"): Recallable =
  ## servicesDelete
  ## Delete a Service Fabric service resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   serviceName: string (required)
  ##              : The name of the service resource in the format of {applicationName}~{serviceName}.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2017-07-01-preview" for this specification.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564344 = newJObject()
  var query_564345 = newJObject()
  add(path_564344, "clusterName", newJString(clusterName))
  add(path_564344, "serviceName", newJString(serviceName))
  add(query_564345, "api-version", newJString(apiVersion))
  add(path_564344, "applicationName", newJString(applicationName))
  add(path_564344, "subscriptionId", newJString(subscriptionId))
  add(path_564344, "resourceGroupName", newJString(resourceGroupName))
  result = call_564343.call(path_564344, query_564345, nil, nil, nil)

var servicesDelete* = Call_ServicesDelete_564333(name: "servicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}/services/{serviceName}",
    validator: validate_ServicesDelete_564334, base: "", url: url_ServicesDelete_564335,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
