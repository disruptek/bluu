
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567666 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567666](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567666): Option[Scheme] {.used.} =
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
  macServiceName = "servicefabric-application"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567888 = ref object of OpenApiRestCall_567666
proc url_OperationsList_567890(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567889(path: JsonNode; query: JsonNode;
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
  var valid_568036 = query.getOrDefault("api-version")
  valid_568036 = validateParameter(valid_568036, JString, required = true,
                                 default = nil)
  if valid_568036 != nil:
    section.add "api-version", valid_568036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568063: Call_OperationsList_567888; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of available Service Fabric resource provider API operations.
  ## 
  let valid = call_568063.validator(path, query, header, formData, body)
  let scheme = call_568063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568063.url(scheme.get, call_568063.host, call_568063.base,
                         call_568063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568063, url, valid)

proc call*(call_568134: Call_OperationsList_567888; apiVersion: string): Recallable =
  ## operationsList
  ## Get the list of available Service Fabric resource provider API operations.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API
  var query_568135 = newJObject()
  add(query_568135, "api-version", newJString(apiVersion))
  result = call_568134.call(nil, query_568135, nil, nil, nil)

var operationsList* = Call_OperationsList_567888(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ServiceFabric/operations",
    validator: validate_OperationsList_567889, base: "", url: url_OperationsList_567890,
    schemes: {Scheme.Https})
type
  Call_ApplicationTypesList_568175 = ref object of OpenApiRestCall_567666
proc url_ApplicationTypesList_568177(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationTypesList_568176(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all application type name resources created or in the process of being created in the Service Fabric cluster resource.
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
  var valid_568201 = path.getOrDefault("clusterName")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "clusterName", valid_568201
  var valid_568202 = path.getOrDefault("resourceGroupName")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "resourceGroupName", valid_568202
  var valid_568203 = path.getOrDefault("subscriptionId")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "subscriptionId", valid_568203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568217 = query.getOrDefault("api-version")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_568217 != nil:
    section.add "api-version", valid_568217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568218: Call_ApplicationTypesList_568175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all application type name resources created or in the process of being created in the Service Fabric cluster resource.
  ## 
  let valid = call_568218.validator(path, query, header, formData, body)
  let scheme = call_568218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568218.url(scheme.get, call_568218.host, call_568218.base,
                         call_568218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568218, url, valid)

proc call*(call_568219: Call_ApplicationTypesList_568175; clusterName: string;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## applicationTypesList
  ## Gets all application type name resources created or in the process of being created in the Service Fabric cluster resource.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_568220 = newJObject()
  var query_568221 = newJObject()
  add(path_568220, "clusterName", newJString(clusterName))
  add(path_568220, "resourceGroupName", newJString(resourceGroupName))
  add(query_568221, "api-version", newJString(apiVersion))
  add(path_568220, "subscriptionId", newJString(subscriptionId))
  result = call_568219.call(path_568220, query_568221, nil, nil, nil)

var applicationTypesList* = Call_ApplicationTypesList_568175(
    name: "applicationTypesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes",
    validator: validate_ApplicationTypesList_568176, base: "",
    url: url_ApplicationTypesList_568177, schemes: {Scheme.Https})
type
  Call_ApplicationTypesCreate_568234 = ref object of OpenApiRestCall_567666
proc url_ApplicationTypesCreate_568236(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationTypesCreate_568235(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a Service Fabric application type name resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   applicationTypeName: JString (required)
  ##                      : The name of the application type name resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568254 = path.getOrDefault("clusterName")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "clusterName", valid_568254
  var valid_568255 = path.getOrDefault("resourceGroupName")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "resourceGroupName", valid_568255
  var valid_568256 = path.getOrDefault("applicationTypeName")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "applicationTypeName", valid_568256
  var valid_568257 = path.getOrDefault("subscriptionId")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "subscriptionId", valid_568257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568258 = query.getOrDefault("api-version")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_568258 != nil:
    section.add "api-version", valid_568258
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

proc call*(call_568260: Call_ApplicationTypesCreate_568234; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Service Fabric application type name resource with the specified name.
  ## 
  let valid = call_568260.validator(path, query, header, formData, body)
  let scheme = call_568260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568260.url(scheme.get, call_568260.host, call_568260.base,
                         call_568260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568260, url, valid)

proc call*(call_568261: Call_ApplicationTypesCreate_568234; clusterName: string;
          resourceGroupName: string; applicationTypeName: string;
          subscriptionId: string; parameters: JsonNode;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## applicationTypesCreate
  ## Create or update a Service Fabric application type name resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type name resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   parameters: JObject (required)
  ##             : The application type name resource.
  var path_568262 = newJObject()
  var query_568263 = newJObject()
  var body_568264 = newJObject()
  add(path_568262, "clusterName", newJString(clusterName))
  add(path_568262, "resourceGroupName", newJString(resourceGroupName))
  add(query_568263, "api-version", newJString(apiVersion))
  add(path_568262, "applicationTypeName", newJString(applicationTypeName))
  add(path_568262, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568264 = parameters
  result = call_568261.call(path_568262, query_568263, nil, nil, body_568264)

var applicationTypesCreate* = Call_ApplicationTypesCreate_568234(
    name: "applicationTypesCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}",
    validator: validate_ApplicationTypesCreate_568235, base: "",
    url: url_ApplicationTypesCreate_568236, schemes: {Scheme.Https})
type
  Call_ApplicationTypesGet_568222 = ref object of OpenApiRestCall_567666
proc url_ApplicationTypesGet_568224(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationTypesGet_568223(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get a Service Fabric application type name resource created or in the process of being created in the Service Fabric cluster resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   applicationTypeName: JString (required)
  ##                      : The name of the application type name resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568225 = path.getOrDefault("clusterName")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "clusterName", valid_568225
  var valid_568226 = path.getOrDefault("resourceGroupName")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "resourceGroupName", valid_568226
  var valid_568227 = path.getOrDefault("applicationTypeName")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "applicationTypeName", valid_568227
  var valid_568228 = path.getOrDefault("subscriptionId")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "subscriptionId", valid_568228
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568229 = query.getOrDefault("api-version")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_568229 != nil:
    section.add "api-version", valid_568229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568230: Call_ApplicationTypesGet_568222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Service Fabric application type name resource created or in the process of being created in the Service Fabric cluster resource.
  ## 
  let valid = call_568230.validator(path, query, header, formData, body)
  let scheme = call_568230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568230.url(scheme.get, call_568230.host, call_568230.base,
                         call_568230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568230, url, valid)

proc call*(call_568231: Call_ApplicationTypesGet_568222; clusterName: string;
          resourceGroupName: string; applicationTypeName: string;
          subscriptionId: string; apiVersion: string = "2019-03-01-preview"): Recallable =
  ## applicationTypesGet
  ## Get a Service Fabric application type name resource created or in the process of being created in the Service Fabric cluster resource.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type name resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_568232 = newJObject()
  var query_568233 = newJObject()
  add(path_568232, "clusterName", newJString(clusterName))
  add(path_568232, "resourceGroupName", newJString(resourceGroupName))
  add(query_568233, "api-version", newJString(apiVersion))
  add(path_568232, "applicationTypeName", newJString(applicationTypeName))
  add(path_568232, "subscriptionId", newJString(subscriptionId))
  result = call_568231.call(path_568232, query_568233, nil, nil, nil)

var applicationTypesGet* = Call_ApplicationTypesGet_568222(
    name: "applicationTypesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}",
    validator: validate_ApplicationTypesGet_568223, base: "",
    url: url_ApplicationTypesGet_568224, schemes: {Scheme.Https})
type
  Call_ApplicationTypesDelete_568265 = ref object of OpenApiRestCall_567666
proc url_ApplicationTypesDelete_568267(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationTypesDelete_568266(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a Service Fabric application type name resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   applicationTypeName: JString (required)
  ##                      : The name of the application type name resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568268 = path.getOrDefault("clusterName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "clusterName", valid_568268
  var valid_568269 = path.getOrDefault("resourceGroupName")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "resourceGroupName", valid_568269
  var valid_568270 = path.getOrDefault("applicationTypeName")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "applicationTypeName", valid_568270
  var valid_568271 = path.getOrDefault("subscriptionId")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "subscriptionId", valid_568271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568272 = query.getOrDefault("api-version")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_568272 != nil:
    section.add "api-version", valid_568272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568273: Call_ApplicationTypesDelete_568265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Service Fabric application type name resource with the specified name.
  ## 
  let valid = call_568273.validator(path, query, header, formData, body)
  let scheme = call_568273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568273.url(scheme.get, call_568273.host, call_568273.base,
                         call_568273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568273, url, valid)

proc call*(call_568274: Call_ApplicationTypesDelete_568265; clusterName: string;
          resourceGroupName: string; applicationTypeName: string;
          subscriptionId: string; apiVersion: string = "2019-03-01-preview"): Recallable =
  ## applicationTypesDelete
  ## Delete a Service Fabric application type name resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type name resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_568275 = newJObject()
  var query_568276 = newJObject()
  add(path_568275, "clusterName", newJString(clusterName))
  add(path_568275, "resourceGroupName", newJString(resourceGroupName))
  add(query_568276, "api-version", newJString(apiVersion))
  add(path_568275, "applicationTypeName", newJString(applicationTypeName))
  add(path_568275, "subscriptionId", newJString(subscriptionId))
  result = call_568274.call(path_568275, query_568276, nil, nil, nil)

var applicationTypesDelete* = Call_ApplicationTypesDelete_568265(
    name: "applicationTypesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}",
    validator: validate_ApplicationTypesDelete_568266, base: "",
    url: url_ApplicationTypesDelete_568267, schemes: {Scheme.Https})
type
  Call_ApplicationTypeVersionsList_568277 = ref object of OpenApiRestCall_567666
proc url_ApplicationTypeVersionsList_568279(protocol: Scheme; host: string;
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

proc validate_ApplicationTypeVersionsList_568278(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all application type version resources created or in the process of being created in the Service Fabric application type name resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   applicationTypeName: JString (required)
  ##                      : The name of the application type name resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568280 = path.getOrDefault("clusterName")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "clusterName", valid_568280
  var valid_568281 = path.getOrDefault("resourceGroupName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "resourceGroupName", valid_568281
  var valid_568282 = path.getOrDefault("applicationTypeName")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "applicationTypeName", valid_568282
  var valid_568283 = path.getOrDefault("subscriptionId")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "subscriptionId", valid_568283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568284 = query.getOrDefault("api-version")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_568284 != nil:
    section.add "api-version", valid_568284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568285: Call_ApplicationTypeVersionsList_568277; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all application type version resources created or in the process of being created in the Service Fabric application type name resource.
  ## 
  let valid = call_568285.validator(path, query, header, formData, body)
  let scheme = call_568285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568285.url(scheme.get, call_568285.host, call_568285.base,
                         call_568285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568285, url, valid)

proc call*(call_568286: Call_ApplicationTypeVersionsList_568277;
          clusterName: string; resourceGroupName: string;
          applicationTypeName: string; subscriptionId: string;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## applicationTypeVersionsList
  ## Gets all application type version resources created or in the process of being created in the Service Fabric application type name resource.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type name resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_568287 = newJObject()
  var query_568288 = newJObject()
  add(path_568287, "clusterName", newJString(clusterName))
  add(path_568287, "resourceGroupName", newJString(resourceGroupName))
  add(query_568288, "api-version", newJString(apiVersion))
  add(path_568287, "applicationTypeName", newJString(applicationTypeName))
  add(path_568287, "subscriptionId", newJString(subscriptionId))
  result = call_568286.call(path_568287, query_568288, nil, nil, nil)

var applicationTypeVersionsList* = Call_ApplicationTypeVersionsList_568277(
    name: "applicationTypeVersionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}/versions",
    validator: validate_ApplicationTypeVersionsList_568278, base: "",
    url: url_ApplicationTypeVersionsList_568279, schemes: {Scheme.Https})
type
  Call_ApplicationTypeVersionsCreate_568302 = ref object of OpenApiRestCall_567666
proc url_ApplicationTypeVersionsCreate_568304(protocol: Scheme; host: string;
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

proc validate_ApplicationTypeVersionsCreate_568303(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a Service Fabric application type version resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   applicationTypeName: JString (required)
  ##                      : The name of the application type name resource.
  ##   version: JString (required)
  ##          : The application type version.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568305 = path.getOrDefault("clusterName")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "clusterName", valid_568305
  var valid_568306 = path.getOrDefault("resourceGroupName")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "resourceGroupName", valid_568306
  var valid_568307 = path.getOrDefault("applicationTypeName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "applicationTypeName", valid_568307
  var valid_568308 = path.getOrDefault("version")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "version", valid_568308
  var valid_568309 = path.getOrDefault("subscriptionId")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "subscriptionId", valid_568309
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568310 = query.getOrDefault("api-version")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_568310 != nil:
    section.add "api-version", valid_568310
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

proc call*(call_568312: Call_ApplicationTypeVersionsCreate_568302; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Service Fabric application type version resource with the specified name.
  ## 
  let valid = call_568312.validator(path, query, header, formData, body)
  let scheme = call_568312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568312.url(scheme.get, call_568312.host, call_568312.base,
                         call_568312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568312, url, valid)

proc call*(call_568313: Call_ApplicationTypeVersionsCreate_568302;
          clusterName: string; resourceGroupName: string;
          applicationTypeName: string; version: string; subscriptionId: string;
          parameters: JsonNode; apiVersion: string = "2019-03-01-preview"): Recallable =
  ## applicationTypeVersionsCreate
  ## Create or update a Service Fabric application type version resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type name resource.
  ##   version: string (required)
  ##          : The application type version.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   parameters: JObject (required)
  ##             : The application type version resource.
  var path_568314 = newJObject()
  var query_568315 = newJObject()
  var body_568316 = newJObject()
  add(path_568314, "clusterName", newJString(clusterName))
  add(path_568314, "resourceGroupName", newJString(resourceGroupName))
  add(query_568315, "api-version", newJString(apiVersion))
  add(path_568314, "applicationTypeName", newJString(applicationTypeName))
  add(path_568314, "version", newJString(version))
  add(path_568314, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568316 = parameters
  result = call_568313.call(path_568314, query_568315, nil, nil, body_568316)

var applicationTypeVersionsCreate* = Call_ApplicationTypeVersionsCreate_568302(
    name: "applicationTypeVersionsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}/versions/{version}",
    validator: validate_ApplicationTypeVersionsCreate_568303, base: "",
    url: url_ApplicationTypeVersionsCreate_568304, schemes: {Scheme.Https})
type
  Call_ApplicationTypeVersionsGet_568289 = ref object of OpenApiRestCall_567666
proc url_ApplicationTypeVersionsGet_568291(protocol: Scheme; host: string;
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

proc validate_ApplicationTypeVersionsGet_568290(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a Service Fabric application type version resource created or in the process of being created in the Service Fabric application type name resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   applicationTypeName: JString (required)
  ##                      : The name of the application type name resource.
  ##   version: JString (required)
  ##          : The application type version.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568292 = path.getOrDefault("clusterName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "clusterName", valid_568292
  var valid_568293 = path.getOrDefault("resourceGroupName")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "resourceGroupName", valid_568293
  var valid_568294 = path.getOrDefault("applicationTypeName")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "applicationTypeName", valid_568294
  var valid_568295 = path.getOrDefault("version")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "version", valid_568295
  var valid_568296 = path.getOrDefault("subscriptionId")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "subscriptionId", valid_568296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568297 = query.getOrDefault("api-version")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_568297 != nil:
    section.add "api-version", valid_568297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568298: Call_ApplicationTypeVersionsGet_568289; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Service Fabric application type version resource created or in the process of being created in the Service Fabric application type name resource.
  ## 
  let valid = call_568298.validator(path, query, header, formData, body)
  let scheme = call_568298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568298.url(scheme.get, call_568298.host, call_568298.base,
                         call_568298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568298, url, valid)

proc call*(call_568299: Call_ApplicationTypeVersionsGet_568289;
          clusterName: string; resourceGroupName: string;
          applicationTypeName: string; version: string; subscriptionId: string;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## applicationTypeVersionsGet
  ## Get a Service Fabric application type version resource created or in the process of being created in the Service Fabric application type name resource.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type name resource.
  ##   version: string (required)
  ##          : The application type version.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_568300 = newJObject()
  var query_568301 = newJObject()
  add(path_568300, "clusterName", newJString(clusterName))
  add(path_568300, "resourceGroupName", newJString(resourceGroupName))
  add(query_568301, "api-version", newJString(apiVersion))
  add(path_568300, "applicationTypeName", newJString(applicationTypeName))
  add(path_568300, "version", newJString(version))
  add(path_568300, "subscriptionId", newJString(subscriptionId))
  result = call_568299.call(path_568300, query_568301, nil, nil, nil)

var applicationTypeVersionsGet* = Call_ApplicationTypeVersionsGet_568289(
    name: "applicationTypeVersionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}/versions/{version}",
    validator: validate_ApplicationTypeVersionsGet_568290, base: "",
    url: url_ApplicationTypeVersionsGet_568291, schemes: {Scheme.Https})
type
  Call_ApplicationTypeVersionsDelete_568317 = ref object of OpenApiRestCall_567666
proc url_ApplicationTypeVersionsDelete_568319(protocol: Scheme; host: string;
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

proc validate_ApplicationTypeVersionsDelete_568318(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a Service Fabric application type version resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   applicationTypeName: JString (required)
  ##                      : The name of the application type name resource.
  ##   version: JString (required)
  ##          : The application type version.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568320 = path.getOrDefault("clusterName")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "clusterName", valid_568320
  var valid_568321 = path.getOrDefault("resourceGroupName")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "resourceGroupName", valid_568321
  var valid_568322 = path.getOrDefault("applicationTypeName")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "applicationTypeName", valid_568322
  var valid_568323 = path.getOrDefault("version")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "version", valid_568323
  var valid_568324 = path.getOrDefault("subscriptionId")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "subscriptionId", valid_568324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568325 = query.getOrDefault("api-version")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_568325 != nil:
    section.add "api-version", valid_568325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568326: Call_ApplicationTypeVersionsDelete_568317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Service Fabric application type version resource with the specified name.
  ## 
  let valid = call_568326.validator(path, query, header, formData, body)
  let scheme = call_568326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568326.url(scheme.get, call_568326.host, call_568326.base,
                         call_568326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568326, url, valid)

proc call*(call_568327: Call_ApplicationTypeVersionsDelete_568317;
          clusterName: string; resourceGroupName: string;
          applicationTypeName: string; version: string; subscriptionId: string;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## applicationTypeVersionsDelete
  ## Delete a Service Fabric application type version resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type name resource.
  ##   version: string (required)
  ##          : The application type version.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_568328 = newJObject()
  var query_568329 = newJObject()
  add(path_568328, "clusterName", newJString(clusterName))
  add(path_568328, "resourceGroupName", newJString(resourceGroupName))
  add(query_568329, "api-version", newJString(apiVersion))
  add(path_568328, "applicationTypeName", newJString(applicationTypeName))
  add(path_568328, "version", newJString(version))
  add(path_568328, "subscriptionId", newJString(subscriptionId))
  result = call_568327.call(path_568328, query_568329, nil, nil, nil)

var applicationTypeVersionsDelete* = Call_ApplicationTypeVersionsDelete_568317(
    name: "applicationTypeVersionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}/versions/{version}",
    validator: validate_ApplicationTypeVersionsDelete_568318, base: "",
    url: url_ApplicationTypeVersionsDelete_568319, schemes: {Scheme.Https})
type
  Call_ApplicationsList_568330 = ref object of OpenApiRestCall_567666
proc url_ApplicationsList_568332(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationsList_568331(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets all application resources created or in the process of being created in the Service Fabric cluster resource.
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
  var valid_568333 = path.getOrDefault("clusterName")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "clusterName", valid_568333
  var valid_568334 = path.getOrDefault("resourceGroupName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "resourceGroupName", valid_568334
  var valid_568335 = path.getOrDefault("subscriptionId")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "subscriptionId", valid_568335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568336 = query.getOrDefault("api-version")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_568336 != nil:
    section.add "api-version", valid_568336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568337: Call_ApplicationsList_568330; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all application resources created or in the process of being created in the Service Fabric cluster resource.
  ## 
  let valid = call_568337.validator(path, query, header, formData, body)
  let scheme = call_568337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568337.url(scheme.get, call_568337.host, call_568337.base,
                         call_568337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568337, url, valid)

proc call*(call_568338: Call_ApplicationsList_568330; clusterName: string;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## applicationsList
  ## Gets all application resources created or in the process of being created in the Service Fabric cluster resource.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_568339 = newJObject()
  var query_568340 = newJObject()
  add(path_568339, "clusterName", newJString(clusterName))
  add(path_568339, "resourceGroupName", newJString(resourceGroupName))
  add(query_568340, "api-version", newJString(apiVersion))
  add(path_568339, "subscriptionId", newJString(subscriptionId))
  result = call_568338.call(path_568339, query_568340, nil, nil, nil)

var applicationsList* = Call_ApplicationsList_568330(name: "applicationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications",
    validator: validate_ApplicationsList_568331, base: "",
    url: url_ApplicationsList_568332, schemes: {Scheme.Https})
type
  Call_ApplicationsCreate_568353 = ref object of OpenApiRestCall_567666
proc url_ApplicationsCreate_568355(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationsCreate_568354(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Create or update a Service Fabric application resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   applicationName: JString (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568356 = path.getOrDefault("clusterName")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "clusterName", valid_568356
  var valid_568357 = path.getOrDefault("resourceGroupName")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "resourceGroupName", valid_568357
  var valid_568358 = path.getOrDefault("applicationName")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "applicationName", valid_568358
  var valid_568359 = path.getOrDefault("subscriptionId")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "subscriptionId", valid_568359
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568360 = query.getOrDefault("api-version")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_568360 != nil:
    section.add "api-version", valid_568360
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

proc call*(call_568362: Call_ApplicationsCreate_568353; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Service Fabric application resource with the specified name.
  ## 
  let valid = call_568362.validator(path, query, header, formData, body)
  let scheme = call_568362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568362.url(scheme.get, call_568362.host, call_568362.base,
                         call_568362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568362, url, valid)

proc call*(call_568363: Call_ApplicationsCreate_568353; clusterName: string;
          resourceGroupName: string; applicationName: string;
          subscriptionId: string; parameters: JsonNode;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## applicationsCreate
  ## Create or update a Service Fabric application resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   parameters: JObject (required)
  ##             : The application resource.
  var path_568364 = newJObject()
  var query_568365 = newJObject()
  var body_568366 = newJObject()
  add(path_568364, "clusterName", newJString(clusterName))
  add(path_568364, "resourceGroupName", newJString(resourceGroupName))
  add(path_568364, "applicationName", newJString(applicationName))
  add(query_568365, "api-version", newJString(apiVersion))
  add(path_568364, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568366 = parameters
  result = call_568363.call(path_568364, query_568365, nil, nil, body_568366)

var applicationsCreate* = Call_ApplicationsCreate_568353(
    name: "applicationsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}",
    validator: validate_ApplicationsCreate_568354, base: "",
    url: url_ApplicationsCreate_568355, schemes: {Scheme.Https})
type
  Call_ApplicationsGet_568341 = ref object of OpenApiRestCall_567666
proc url_ApplicationsGet_568343(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationsGet_568342(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get a Service Fabric application resource created or in the process of being created in the Service Fabric cluster resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   applicationName: JString (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568344 = path.getOrDefault("clusterName")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "clusterName", valid_568344
  var valid_568345 = path.getOrDefault("resourceGroupName")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "resourceGroupName", valid_568345
  var valid_568346 = path.getOrDefault("applicationName")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "applicationName", valid_568346
  var valid_568347 = path.getOrDefault("subscriptionId")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "subscriptionId", valid_568347
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568348 = query.getOrDefault("api-version")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_568348 != nil:
    section.add "api-version", valid_568348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568349: Call_ApplicationsGet_568341; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Service Fabric application resource created or in the process of being created in the Service Fabric cluster resource.
  ## 
  let valid = call_568349.validator(path, query, header, formData, body)
  let scheme = call_568349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568349.url(scheme.get, call_568349.host, call_568349.base,
                         call_568349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568349, url, valid)

proc call*(call_568350: Call_ApplicationsGet_568341; clusterName: string;
          resourceGroupName: string; applicationName: string;
          subscriptionId: string; apiVersion: string = "2019-03-01-preview"): Recallable =
  ## applicationsGet
  ## Get a Service Fabric application resource created or in the process of being created in the Service Fabric cluster resource.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_568351 = newJObject()
  var query_568352 = newJObject()
  add(path_568351, "clusterName", newJString(clusterName))
  add(path_568351, "resourceGroupName", newJString(resourceGroupName))
  add(path_568351, "applicationName", newJString(applicationName))
  add(query_568352, "api-version", newJString(apiVersion))
  add(path_568351, "subscriptionId", newJString(subscriptionId))
  result = call_568350.call(path_568351, query_568352, nil, nil, nil)

var applicationsGet* = Call_ApplicationsGet_568341(name: "applicationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}",
    validator: validate_ApplicationsGet_568342, base: "", url: url_ApplicationsGet_568343,
    schemes: {Scheme.Https})
type
  Call_ApplicationsUpdate_568379 = ref object of OpenApiRestCall_567666
proc url_ApplicationsUpdate_568381(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationsUpdate_568380(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Update a Service Fabric application resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   applicationName: JString (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568382 = path.getOrDefault("clusterName")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "clusterName", valid_568382
  var valid_568383 = path.getOrDefault("resourceGroupName")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "resourceGroupName", valid_568383
  var valid_568384 = path.getOrDefault("applicationName")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "applicationName", valid_568384
  var valid_568385 = path.getOrDefault("subscriptionId")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "subscriptionId", valid_568385
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568386 = query.getOrDefault("api-version")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_568386 != nil:
    section.add "api-version", valid_568386
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

proc call*(call_568388: Call_ApplicationsUpdate_568379; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a Service Fabric application resource with the specified name.
  ## 
  let valid = call_568388.validator(path, query, header, formData, body)
  let scheme = call_568388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568388.url(scheme.get, call_568388.host, call_568388.base,
                         call_568388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568388, url, valid)

proc call*(call_568389: Call_ApplicationsUpdate_568379; clusterName: string;
          resourceGroupName: string; applicationName: string;
          subscriptionId: string; parameters: JsonNode;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## applicationsUpdate
  ## Update a Service Fabric application resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   parameters: JObject (required)
  ##             : The application resource for patch operations.
  var path_568390 = newJObject()
  var query_568391 = newJObject()
  var body_568392 = newJObject()
  add(path_568390, "clusterName", newJString(clusterName))
  add(path_568390, "resourceGroupName", newJString(resourceGroupName))
  add(path_568390, "applicationName", newJString(applicationName))
  add(query_568391, "api-version", newJString(apiVersion))
  add(path_568390, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568392 = parameters
  result = call_568389.call(path_568390, query_568391, nil, nil, body_568392)

var applicationsUpdate* = Call_ApplicationsUpdate_568379(
    name: "applicationsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}",
    validator: validate_ApplicationsUpdate_568380, base: "",
    url: url_ApplicationsUpdate_568381, schemes: {Scheme.Https})
type
  Call_ApplicationsDelete_568367 = ref object of OpenApiRestCall_567666
proc url_ApplicationsDelete_568369(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationsDelete_568368(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Delete a Service Fabric application resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   applicationName: JString (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568370 = path.getOrDefault("clusterName")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = nil)
  if valid_568370 != nil:
    section.add "clusterName", valid_568370
  var valid_568371 = path.getOrDefault("resourceGroupName")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "resourceGroupName", valid_568371
  var valid_568372 = path.getOrDefault("applicationName")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "applicationName", valid_568372
  var valid_568373 = path.getOrDefault("subscriptionId")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "subscriptionId", valid_568373
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568374 = query.getOrDefault("api-version")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_568374 != nil:
    section.add "api-version", valid_568374
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568375: Call_ApplicationsDelete_568367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Service Fabric application resource with the specified name.
  ## 
  let valid = call_568375.validator(path, query, header, formData, body)
  let scheme = call_568375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568375.url(scheme.get, call_568375.host, call_568375.base,
                         call_568375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568375, url, valid)

proc call*(call_568376: Call_ApplicationsDelete_568367; clusterName: string;
          resourceGroupName: string; applicationName: string;
          subscriptionId: string; apiVersion: string = "2019-03-01-preview"): Recallable =
  ## applicationsDelete
  ## Delete a Service Fabric application resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_568377 = newJObject()
  var query_568378 = newJObject()
  add(path_568377, "clusterName", newJString(clusterName))
  add(path_568377, "resourceGroupName", newJString(resourceGroupName))
  add(path_568377, "applicationName", newJString(applicationName))
  add(query_568378, "api-version", newJString(apiVersion))
  add(path_568377, "subscriptionId", newJString(subscriptionId))
  result = call_568376.call(path_568377, query_568378, nil, nil, nil)

var applicationsDelete* = Call_ApplicationsDelete_568367(
    name: "applicationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}",
    validator: validate_ApplicationsDelete_568368, base: "",
    url: url_ApplicationsDelete_568369, schemes: {Scheme.Https})
type
  Call_ServicesList_568393 = ref object of OpenApiRestCall_567666
proc url_ServicesList_568395(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesList_568394(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all service resources created or in the process of being created in the Service Fabric application resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   applicationName: JString (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568396 = path.getOrDefault("clusterName")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "clusterName", valid_568396
  var valid_568397 = path.getOrDefault("resourceGroupName")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "resourceGroupName", valid_568397
  var valid_568398 = path.getOrDefault("applicationName")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = nil)
  if valid_568398 != nil:
    section.add "applicationName", valid_568398
  var valid_568399 = path.getOrDefault("subscriptionId")
  valid_568399 = validateParameter(valid_568399, JString, required = true,
                                 default = nil)
  if valid_568399 != nil:
    section.add "subscriptionId", valid_568399
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568400 = query.getOrDefault("api-version")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_568400 != nil:
    section.add "api-version", valid_568400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568401: Call_ServicesList_568393; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all service resources created or in the process of being created in the Service Fabric application resource.
  ## 
  let valid = call_568401.validator(path, query, header, formData, body)
  let scheme = call_568401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568401.url(scheme.get, call_568401.host, call_568401.base,
                         call_568401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568401, url, valid)

proc call*(call_568402: Call_ServicesList_568393; clusterName: string;
          resourceGroupName: string; applicationName: string;
          subscriptionId: string; apiVersion: string = "2019-03-01-preview"): Recallable =
  ## servicesList
  ## Gets all service resources created or in the process of being created in the Service Fabric application resource.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_568403 = newJObject()
  var query_568404 = newJObject()
  add(path_568403, "clusterName", newJString(clusterName))
  add(path_568403, "resourceGroupName", newJString(resourceGroupName))
  add(path_568403, "applicationName", newJString(applicationName))
  add(query_568404, "api-version", newJString(apiVersion))
  add(path_568403, "subscriptionId", newJString(subscriptionId))
  result = call_568402.call(path_568403, query_568404, nil, nil, nil)

var servicesList* = Call_ServicesList_568393(name: "servicesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}/services",
    validator: validate_ServicesList_568394, base: "", url: url_ServicesList_568395,
    schemes: {Scheme.Https})
type
  Call_ServicesCreate_568418 = ref object of OpenApiRestCall_567666
proc url_ServicesCreate_568420(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesCreate_568419(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Create or update a Service Fabric service resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   applicationName: JString (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   serviceName: JString (required)
  ##              : The name of the service resource in the format of {applicationName}~{serviceName}.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568421 = path.getOrDefault("clusterName")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "clusterName", valid_568421
  var valid_568422 = path.getOrDefault("resourceGroupName")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "resourceGroupName", valid_568422
  var valid_568423 = path.getOrDefault("applicationName")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "applicationName", valid_568423
  var valid_568424 = path.getOrDefault("subscriptionId")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "subscriptionId", valid_568424
  var valid_568425 = path.getOrDefault("serviceName")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "serviceName", valid_568425
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568426 = query.getOrDefault("api-version")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_568426 != nil:
    section.add "api-version", valid_568426
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

proc call*(call_568428: Call_ServicesCreate_568418; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Service Fabric service resource with the specified name.
  ## 
  let valid = call_568428.validator(path, query, header, formData, body)
  let scheme = call_568428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568428.url(scheme.get, call_568428.host, call_568428.base,
                         call_568428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568428, url, valid)

proc call*(call_568429: Call_ServicesCreate_568418; clusterName: string;
          resourceGroupName: string; applicationName: string;
          subscriptionId: string; parameters: JsonNode; serviceName: string;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## servicesCreate
  ## Create or update a Service Fabric service resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   parameters: JObject (required)
  ##             : The service resource.
  ##   serviceName: string (required)
  ##              : The name of the service resource in the format of {applicationName}~{serviceName}.
  var path_568430 = newJObject()
  var query_568431 = newJObject()
  var body_568432 = newJObject()
  add(path_568430, "clusterName", newJString(clusterName))
  add(path_568430, "resourceGroupName", newJString(resourceGroupName))
  add(path_568430, "applicationName", newJString(applicationName))
  add(query_568431, "api-version", newJString(apiVersion))
  add(path_568430, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568432 = parameters
  add(path_568430, "serviceName", newJString(serviceName))
  result = call_568429.call(path_568430, query_568431, nil, nil, body_568432)

var servicesCreate* = Call_ServicesCreate_568418(name: "servicesCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}/services/{serviceName}",
    validator: validate_ServicesCreate_568419, base: "", url: url_ServicesCreate_568420,
    schemes: {Scheme.Https})
type
  Call_ServicesGet_568405 = ref object of OpenApiRestCall_567666
proc url_ServicesGet_568407(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesGet_568406(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a Service Fabric service resource created or in the process of being created in the Service Fabric application resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   applicationName: JString (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   serviceName: JString (required)
  ##              : The name of the service resource in the format of {applicationName}~{serviceName}.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568408 = path.getOrDefault("clusterName")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "clusterName", valid_568408
  var valid_568409 = path.getOrDefault("resourceGroupName")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "resourceGroupName", valid_568409
  var valid_568410 = path.getOrDefault("applicationName")
  valid_568410 = validateParameter(valid_568410, JString, required = true,
                                 default = nil)
  if valid_568410 != nil:
    section.add "applicationName", valid_568410
  var valid_568411 = path.getOrDefault("subscriptionId")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "subscriptionId", valid_568411
  var valid_568412 = path.getOrDefault("serviceName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "serviceName", valid_568412
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568413 = query.getOrDefault("api-version")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_568413 != nil:
    section.add "api-version", valid_568413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568414: Call_ServicesGet_568405; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Service Fabric service resource created or in the process of being created in the Service Fabric application resource.
  ## 
  let valid = call_568414.validator(path, query, header, formData, body)
  let scheme = call_568414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568414.url(scheme.get, call_568414.host, call_568414.base,
                         call_568414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568414, url, valid)

proc call*(call_568415: Call_ServicesGet_568405; clusterName: string;
          resourceGroupName: string; applicationName: string;
          subscriptionId: string; serviceName: string;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## servicesGet
  ## Get a Service Fabric service resource created or in the process of being created in the Service Fabric application resource.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   serviceName: string (required)
  ##              : The name of the service resource in the format of {applicationName}~{serviceName}.
  var path_568416 = newJObject()
  var query_568417 = newJObject()
  add(path_568416, "clusterName", newJString(clusterName))
  add(path_568416, "resourceGroupName", newJString(resourceGroupName))
  add(path_568416, "applicationName", newJString(applicationName))
  add(query_568417, "api-version", newJString(apiVersion))
  add(path_568416, "subscriptionId", newJString(subscriptionId))
  add(path_568416, "serviceName", newJString(serviceName))
  result = call_568415.call(path_568416, query_568417, nil, nil, nil)

var servicesGet* = Call_ServicesGet_568405(name: "servicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}/services/{serviceName}",
                                        validator: validate_ServicesGet_568406,
                                        base: "", url: url_ServicesGet_568407,
                                        schemes: {Scheme.Https})
type
  Call_ServicesUpdate_568446 = ref object of OpenApiRestCall_567666
proc url_ServicesUpdate_568448(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesUpdate_568447(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Update a Service Fabric service resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   applicationName: JString (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   serviceName: JString (required)
  ##              : The name of the service resource in the format of {applicationName}~{serviceName}.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568449 = path.getOrDefault("clusterName")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "clusterName", valid_568449
  var valid_568450 = path.getOrDefault("resourceGroupName")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "resourceGroupName", valid_568450
  var valid_568451 = path.getOrDefault("applicationName")
  valid_568451 = validateParameter(valid_568451, JString, required = true,
                                 default = nil)
  if valid_568451 != nil:
    section.add "applicationName", valid_568451
  var valid_568452 = path.getOrDefault("subscriptionId")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "subscriptionId", valid_568452
  var valid_568453 = path.getOrDefault("serviceName")
  valid_568453 = validateParameter(valid_568453, JString, required = true,
                                 default = nil)
  if valid_568453 != nil:
    section.add "serviceName", valid_568453
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568454 = query.getOrDefault("api-version")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_568454 != nil:
    section.add "api-version", valid_568454
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

proc call*(call_568456: Call_ServicesUpdate_568446; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a Service Fabric service resource with the specified name.
  ## 
  let valid = call_568456.validator(path, query, header, formData, body)
  let scheme = call_568456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568456.url(scheme.get, call_568456.host, call_568456.base,
                         call_568456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568456, url, valid)

proc call*(call_568457: Call_ServicesUpdate_568446; clusterName: string;
          resourceGroupName: string; applicationName: string;
          subscriptionId: string; parameters: JsonNode; serviceName: string;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## servicesUpdate
  ## Update a Service Fabric service resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   parameters: JObject (required)
  ##             : The service resource for patch operations.
  ##   serviceName: string (required)
  ##              : The name of the service resource in the format of {applicationName}~{serviceName}.
  var path_568458 = newJObject()
  var query_568459 = newJObject()
  var body_568460 = newJObject()
  add(path_568458, "clusterName", newJString(clusterName))
  add(path_568458, "resourceGroupName", newJString(resourceGroupName))
  add(path_568458, "applicationName", newJString(applicationName))
  add(query_568459, "api-version", newJString(apiVersion))
  add(path_568458, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568460 = parameters
  add(path_568458, "serviceName", newJString(serviceName))
  result = call_568457.call(path_568458, query_568459, nil, nil, body_568460)

var servicesUpdate* = Call_ServicesUpdate_568446(name: "servicesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}/services/{serviceName}",
    validator: validate_ServicesUpdate_568447, base: "", url: url_ServicesUpdate_568448,
    schemes: {Scheme.Https})
type
  Call_ServicesDelete_568433 = ref object of OpenApiRestCall_567666
proc url_ServicesDelete_568435(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesDelete_568434(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete a Service Fabric service resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   applicationName: JString (required)
  ##                  : The name of the application resource.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   serviceName: JString (required)
  ##              : The name of the service resource in the format of {applicationName}~{serviceName}.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_568436 = path.getOrDefault("clusterName")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "clusterName", valid_568436
  var valid_568437 = path.getOrDefault("resourceGroupName")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "resourceGroupName", valid_568437
  var valid_568438 = path.getOrDefault("applicationName")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "applicationName", valid_568438
  var valid_568439 = path.getOrDefault("subscriptionId")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "subscriptionId", valid_568439
  var valid_568440 = path.getOrDefault("serviceName")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "serviceName", valid_568440
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568441 = query.getOrDefault("api-version")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_568441 != nil:
    section.add "api-version", valid_568441
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568442: Call_ServicesDelete_568433; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Service Fabric service resource with the specified name.
  ## 
  let valid = call_568442.validator(path, query, header, formData, body)
  let scheme = call_568442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568442.url(scheme.get, call_568442.host, call_568442.base,
                         call_568442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568442, url, valid)

proc call*(call_568443: Call_ServicesDelete_568433; clusterName: string;
          resourceGroupName: string; applicationName: string;
          subscriptionId: string; serviceName: string;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## servicesDelete
  ## Delete a Service Fabric service resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   serviceName: string (required)
  ##              : The name of the service resource in the format of {applicationName}~{serviceName}.
  var path_568444 = newJObject()
  var query_568445 = newJObject()
  add(path_568444, "clusterName", newJString(clusterName))
  add(path_568444, "resourceGroupName", newJString(resourceGroupName))
  add(path_568444, "applicationName", newJString(applicationName))
  add(query_568445, "api-version", newJString(apiVersion))
  add(path_568444, "subscriptionId", newJString(subscriptionId))
  add(path_568444, "serviceName", newJString(serviceName))
  result = call_568443.call(path_568444, query_568445, nil, nil, nil)

var servicesDelete* = Call_ServicesDelete_568433(name: "servicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}/services/{serviceName}",
    validator: validate_ServicesDelete_568434, base: "", url: url_ServicesDelete_568435,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
