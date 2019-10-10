
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

  OpenApiRestCall_573666 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573666](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573666): Option[Scheme] {.used.} =
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
  Call_OperationsList_573888 = ref object of OpenApiRestCall_573666
proc url_OperationsList_573890(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_573889(path: JsonNode; query: JsonNode;
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
  var valid_574036 = query.getOrDefault("api-version")
  valid_574036 = validateParameter(valid_574036, JString, required = true,
                                 default = nil)
  if valid_574036 != nil:
    section.add "api-version", valid_574036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574063: Call_OperationsList_573888; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of available Service Fabric resource provider API operations.
  ## 
  let valid = call_574063.validator(path, query, header, formData, body)
  let scheme = call_574063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574063.url(scheme.get, call_574063.host, call_574063.base,
                         call_574063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574063, url, valid)

proc call*(call_574134: Call_OperationsList_573888; apiVersion: string): Recallable =
  ## operationsList
  ## Get the list of available Service Fabric resource provider API operations.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API
  var query_574135 = newJObject()
  add(query_574135, "api-version", newJString(apiVersion))
  result = call_574134.call(nil, query_574135, nil, nil, nil)

var operationsList* = Call_OperationsList_573888(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ServiceFabric/operations",
    validator: validate_OperationsList_573889, base: "", url: url_OperationsList_573890,
    schemes: {Scheme.Https})
type
  Call_ApplicationTypesList_574175 = ref object of OpenApiRestCall_573666
proc url_ApplicationTypesList_574177(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationTypesList_574176(path: JsonNode; query: JsonNode;
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
  var valid_574201 = path.getOrDefault("clusterName")
  valid_574201 = validateParameter(valid_574201, JString, required = true,
                                 default = nil)
  if valid_574201 != nil:
    section.add "clusterName", valid_574201
  var valid_574202 = path.getOrDefault("resourceGroupName")
  valid_574202 = validateParameter(valid_574202, JString, required = true,
                                 default = nil)
  if valid_574202 != nil:
    section.add "resourceGroupName", valid_574202
  var valid_574203 = path.getOrDefault("subscriptionId")
  valid_574203 = validateParameter(valid_574203, JString, required = true,
                                 default = nil)
  if valid_574203 != nil:
    section.add "subscriptionId", valid_574203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574217 = query.getOrDefault("api-version")
  valid_574217 = validateParameter(valid_574217, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574217 != nil:
    section.add "api-version", valid_574217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574218: Call_ApplicationTypesList_574175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all application type name resources created or in the process of being created in the Service Fabric cluster resource.
  ## 
  let valid = call_574218.validator(path, query, header, formData, body)
  let scheme = call_574218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574218.url(scheme.get, call_574218.host, call_574218.base,
                         call_574218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574218, url, valid)

proc call*(call_574219: Call_ApplicationTypesList_574175; clusterName: string;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2019-03-01"): Recallable =
  ## applicationTypesList
  ## Gets all application type name resources created or in the process of being created in the Service Fabric cluster resource.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_574220 = newJObject()
  var query_574221 = newJObject()
  add(path_574220, "clusterName", newJString(clusterName))
  add(path_574220, "resourceGroupName", newJString(resourceGroupName))
  add(query_574221, "api-version", newJString(apiVersion))
  add(path_574220, "subscriptionId", newJString(subscriptionId))
  result = call_574219.call(path_574220, query_574221, nil, nil, nil)

var applicationTypesList* = Call_ApplicationTypesList_574175(
    name: "applicationTypesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes",
    validator: validate_ApplicationTypesList_574176, base: "",
    url: url_ApplicationTypesList_574177, schemes: {Scheme.Https})
type
  Call_ApplicationTypesCreateOrUpdate_574234 = ref object of OpenApiRestCall_573666
proc url_ApplicationTypesCreateOrUpdate_574236(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "applicationTypeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationTypesCreateOrUpdate_574235(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_574254 = path.getOrDefault("clusterName")
  valid_574254 = validateParameter(valid_574254, JString, required = true,
                                 default = nil)
  if valid_574254 != nil:
    section.add "clusterName", valid_574254
  var valid_574255 = path.getOrDefault("resourceGroupName")
  valid_574255 = validateParameter(valid_574255, JString, required = true,
                                 default = nil)
  if valid_574255 != nil:
    section.add "resourceGroupName", valid_574255
  var valid_574256 = path.getOrDefault("applicationTypeName")
  valid_574256 = validateParameter(valid_574256, JString, required = true,
                                 default = nil)
  if valid_574256 != nil:
    section.add "applicationTypeName", valid_574256
  var valid_574257 = path.getOrDefault("subscriptionId")
  valid_574257 = validateParameter(valid_574257, JString, required = true,
                                 default = nil)
  if valid_574257 != nil:
    section.add "subscriptionId", valid_574257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574258 = query.getOrDefault("api-version")
  valid_574258 = validateParameter(valid_574258, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574258 != nil:
    section.add "api-version", valid_574258
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

proc call*(call_574260: Call_ApplicationTypesCreateOrUpdate_574234; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Service Fabric application type name resource with the specified name.
  ## 
  let valid = call_574260.validator(path, query, header, formData, body)
  let scheme = call_574260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574260.url(scheme.get, call_574260.host, call_574260.base,
                         call_574260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574260, url, valid)

proc call*(call_574261: Call_ApplicationTypesCreateOrUpdate_574234;
          clusterName: string; resourceGroupName: string;
          applicationTypeName: string; subscriptionId: string; parameters: JsonNode;
          apiVersion: string = "2019-03-01"): Recallable =
  ## applicationTypesCreateOrUpdate
  ## Create or update a Service Fabric application type name resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type name resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   parameters: JObject (required)
  ##             : The application type name resource.
  var path_574262 = newJObject()
  var query_574263 = newJObject()
  var body_574264 = newJObject()
  add(path_574262, "clusterName", newJString(clusterName))
  add(path_574262, "resourceGroupName", newJString(resourceGroupName))
  add(query_574263, "api-version", newJString(apiVersion))
  add(path_574262, "applicationTypeName", newJString(applicationTypeName))
  add(path_574262, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574264 = parameters
  result = call_574261.call(path_574262, query_574263, nil, nil, body_574264)

var applicationTypesCreateOrUpdate* = Call_ApplicationTypesCreateOrUpdate_574234(
    name: "applicationTypesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}",
    validator: validate_ApplicationTypesCreateOrUpdate_574235, base: "",
    url: url_ApplicationTypesCreateOrUpdate_574236, schemes: {Scheme.Https})
type
  Call_ApplicationTypesGet_574222 = ref object of OpenApiRestCall_573666
proc url_ApplicationTypesGet_574224(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationTypesGet_574223(path: JsonNode; query: JsonNode;
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
  var valid_574225 = path.getOrDefault("clusterName")
  valid_574225 = validateParameter(valid_574225, JString, required = true,
                                 default = nil)
  if valid_574225 != nil:
    section.add "clusterName", valid_574225
  var valid_574226 = path.getOrDefault("resourceGroupName")
  valid_574226 = validateParameter(valid_574226, JString, required = true,
                                 default = nil)
  if valid_574226 != nil:
    section.add "resourceGroupName", valid_574226
  var valid_574227 = path.getOrDefault("applicationTypeName")
  valid_574227 = validateParameter(valid_574227, JString, required = true,
                                 default = nil)
  if valid_574227 != nil:
    section.add "applicationTypeName", valid_574227
  var valid_574228 = path.getOrDefault("subscriptionId")
  valid_574228 = validateParameter(valid_574228, JString, required = true,
                                 default = nil)
  if valid_574228 != nil:
    section.add "subscriptionId", valid_574228
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574229 = query.getOrDefault("api-version")
  valid_574229 = validateParameter(valid_574229, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574229 != nil:
    section.add "api-version", valid_574229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574230: Call_ApplicationTypesGet_574222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Service Fabric application type name resource created or in the process of being created in the Service Fabric cluster resource.
  ## 
  let valid = call_574230.validator(path, query, header, formData, body)
  let scheme = call_574230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574230.url(scheme.get, call_574230.host, call_574230.base,
                         call_574230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574230, url, valid)

proc call*(call_574231: Call_ApplicationTypesGet_574222; clusterName: string;
          resourceGroupName: string; applicationTypeName: string;
          subscriptionId: string; apiVersion: string = "2019-03-01"): Recallable =
  ## applicationTypesGet
  ## Get a Service Fabric application type name resource created or in the process of being created in the Service Fabric cluster resource.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type name resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_574232 = newJObject()
  var query_574233 = newJObject()
  add(path_574232, "clusterName", newJString(clusterName))
  add(path_574232, "resourceGroupName", newJString(resourceGroupName))
  add(query_574233, "api-version", newJString(apiVersion))
  add(path_574232, "applicationTypeName", newJString(applicationTypeName))
  add(path_574232, "subscriptionId", newJString(subscriptionId))
  result = call_574231.call(path_574232, query_574233, nil, nil, nil)

var applicationTypesGet* = Call_ApplicationTypesGet_574222(
    name: "applicationTypesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}",
    validator: validate_ApplicationTypesGet_574223, base: "",
    url: url_ApplicationTypesGet_574224, schemes: {Scheme.Https})
type
  Call_ApplicationTypesDelete_574265 = ref object of OpenApiRestCall_573666
proc url_ApplicationTypesDelete_574267(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationTypesDelete_574266(path: JsonNode; query: JsonNode;
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
  var valid_574268 = path.getOrDefault("clusterName")
  valid_574268 = validateParameter(valid_574268, JString, required = true,
                                 default = nil)
  if valid_574268 != nil:
    section.add "clusterName", valid_574268
  var valid_574269 = path.getOrDefault("resourceGroupName")
  valid_574269 = validateParameter(valid_574269, JString, required = true,
                                 default = nil)
  if valid_574269 != nil:
    section.add "resourceGroupName", valid_574269
  var valid_574270 = path.getOrDefault("applicationTypeName")
  valid_574270 = validateParameter(valid_574270, JString, required = true,
                                 default = nil)
  if valid_574270 != nil:
    section.add "applicationTypeName", valid_574270
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
  if body != nil:
    result.add "body", body

proc call*(call_574273: Call_ApplicationTypesDelete_574265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Service Fabric application type name resource with the specified name.
  ## 
  let valid = call_574273.validator(path, query, header, formData, body)
  let scheme = call_574273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574273.url(scheme.get, call_574273.host, call_574273.base,
                         call_574273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574273, url, valid)

proc call*(call_574274: Call_ApplicationTypesDelete_574265; clusterName: string;
          resourceGroupName: string; applicationTypeName: string;
          subscriptionId: string; apiVersion: string = "2019-03-01"): Recallable =
  ## applicationTypesDelete
  ## Delete a Service Fabric application type name resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type name resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_574275 = newJObject()
  var query_574276 = newJObject()
  add(path_574275, "clusterName", newJString(clusterName))
  add(path_574275, "resourceGroupName", newJString(resourceGroupName))
  add(query_574276, "api-version", newJString(apiVersion))
  add(path_574275, "applicationTypeName", newJString(applicationTypeName))
  add(path_574275, "subscriptionId", newJString(subscriptionId))
  result = call_574274.call(path_574275, query_574276, nil, nil, nil)

var applicationTypesDelete* = Call_ApplicationTypesDelete_574265(
    name: "applicationTypesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}",
    validator: validate_ApplicationTypesDelete_574266, base: "",
    url: url_ApplicationTypesDelete_574267, schemes: {Scheme.Https})
type
  Call_ApplicationTypeVersionsList_574277 = ref object of OpenApiRestCall_573666
proc url_ApplicationTypeVersionsList_574279(protocol: Scheme; host: string;
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

proc validate_ApplicationTypeVersionsList_574278(path: JsonNode; query: JsonNode;
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
  var valid_574280 = path.getOrDefault("clusterName")
  valid_574280 = validateParameter(valid_574280, JString, required = true,
                                 default = nil)
  if valid_574280 != nil:
    section.add "clusterName", valid_574280
  var valid_574281 = path.getOrDefault("resourceGroupName")
  valid_574281 = validateParameter(valid_574281, JString, required = true,
                                 default = nil)
  if valid_574281 != nil:
    section.add "resourceGroupName", valid_574281
  var valid_574282 = path.getOrDefault("applicationTypeName")
  valid_574282 = validateParameter(valid_574282, JString, required = true,
                                 default = nil)
  if valid_574282 != nil:
    section.add "applicationTypeName", valid_574282
  var valid_574283 = path.getOrDefault("subscriptionId")
  valid_574283 = validateParameter(valid_574283, JString, required = true,
                                 default = nil)
  if valid_574283 != nil:
    section.add "subscriptionId", valid_574283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574284 = query.getOrDefault("api-version")
  valid_574284 = validateParameter(valid_574284, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574284 != nil:
    section.add "api-version", valid_574284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574285: Call_ApplicationTypeVersionsList_574277; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all application type version resources created or in the process of being created in the Service Fabric application type name resource.
  ## 
  let valid = call_574285.validator(path, query, header, formData, body)
  let scheme = call_574285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574285.url(scheme.get, call_574285.host, call_574285.base,
                         call_574285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574285, url, valid)

proc call*(call_574286: Call_ApplicationTypeVersionsList_574277;
          clusterName: string; resourceGroupName: string;
          applicationTypeName: string; subscriptionId: string;
          apiVersion: string = "2019-03-01"): Recallable =
  ## applicationTypeVersionsList
  ## Gets all application type version resources created or in the process of being created in the Service Fabric application type name resource.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type name resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_574287 = newJObject()
  var query_574288 = newJObject()
  add(path_574287, "clusterName", newJString(clusterName))
  add(path_574287, "resourceGroupName", newJString(resourceGroupName))
  add(query_574288, "api-version", newJString(apiVersion))
  add(path_574287, "applicationTypeName", newJString(applicationTypeName))
  add(path_574287, "subscriptionId", newJString(subscriptionId))
  result = call_574286.call(path_574287, query_574288, nil, nil, nil)

var applicationTypeVersionsList* = Call_ApplicationTypeVersionsList_574277(
    name: "applicationTypeVersionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}/versions",
    validator: validate_ApplicationTypeVersionsList_574278, base: "",
    url: url_ApplicationTypeVersionsList_574279, schemes: {Scheme.Https})
type
  Call_ApplicationTypeVersionsCreateOrUpdate_574302 = ref object of OpenApiRestCall_573666
proc url_ApplicationTypeVersionsCreateOrUpdate_574304(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_ApplicationTypeVersionsCreateOrUpdate_574303(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_574305 = path.getOrDefault("clusterName")
  valid_574305 = validateParameter(valid_574305, JString, required = true,
                                 default = nil)
  if valid_574305 != nil:
    section.add "clusterName", valid_574305
  var valid_574306 = path.getOrDefault("resourceGroupName")
  valid_574306 = validateParameter(valid_574306, JString, required = true,
                                 default = nil)
  if valid_574306 != nil:
    section.add "resourceGroupName", valid_574306
  var valid_574307 = path.getOrDefault("applicationTypeName")
  valid_574307 = validateParameter(valid_574307, JString, required = true,
                                 default = nil)
  if valid_574307 != nil:
    section.add "applicationTypeName", valid_574307
  var valid_574308 = path.getOrDefault("version")
  valid_574308 = validateParameter(valid_574308, JString, required = true,
                                 default = nil)
  if valid_574308 != nil:
    section.add "version", valid_574308
  var valid_574309 = path.getOrDefault("subscriptionId")
  valid_574309 = validateParameter(valid_574309, JString, required = true,
                                 default = nil)
  if valid_574309 != nil:
    section.add "subscriptionId", valid_574309
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574310 = query.getOrDefault("api-version")
  valid_574310 = validateParameter(valid_574310, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574310 != nil:
    section.add "api-version", valid_574310
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

proc call*(call_574312: Call_ApplicationTypeVersionsCreateOrUpdate_574302;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a Service Fabric application type version resource with the specified name.
  ## 
  let valid = call_574312.validator(path, query, header, formData, body)
  let scheme = call_574312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574312.url(scheme.get, call_574312.host, call_574312.base,
                         call_574312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574312, url, valid)

proc call*(call_574313: Call_ApplicationTypeVersionsCreateOrUpdate_574302;
          clusterName: string; resourceGroupName: string;
          applicationTypeName: string; version: string; subscriptionId: string;
          parameters: JsonNode; apiVersion: string = "2019-03-01"): Recallable =
  ## applicationTypeVersionsCreateOrUpdate
  ## Create or update a Service Fabric application type version resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type name resource.
  ##   version: string (required)
  ##          : The application type version.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   parameters: JObject (required)
  ##             : The application type version resource.
  var path_574314 = newJObject()
  var query_574315 = newJObject()
  var body_574316 = newJObject()
  add(path_574314, "clusterName", newJString(clusterName))
  add(path_574314, "resourceGroupName", newJString(resourceGroupName))
  add(query_574315, "api-version", newJString(apiVersion))
  add(path_574314, "applicationTypeName", newJString(applicationTypeName))
  add(path_574314, "version", newJString(version))
  add(path_574314, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574316 = parameters
  result = call_574313.call(path_574314, query_574315, nil, nil, body_574316)

var applicationTypeVersionsCreateOrUpdate* = Call_ApplicationTypeVersionsCreateOrUpdate_574302(
    name: "applicationTypeVersionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}/versions/{version}",
    validator: validate_ApplicationTypeVersionsCreateOrUpdate_574303, base: "",
    url: url_ApplicationTypeVersionsCreateOrUpdate_574304, schemes: {Scheme.Https})
type
  Call_ApplicationTypeVersionsGet_574289 = ref object of OpenApiRestCall_573666
proc url_ApplicationTypeVersionsGet_574291(protocol: Scheme; host: string;
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

proc validate_ApplicationTypeVersionsGet_574290(path: JsonNode; query: JsonNode;
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
  var valid_574292 = path.getOrDefault("clusterName")
  valid_574292 = validateParameter(valid_574292, JString, required = true,
                                 default = nil)
  if valid_574292 != nil:
    section.add "clusterName", valid_574292
  var valid_574293 = path.getOrDefault("resourceGroupName")
  valid_574293 = validateParameter(valid_574293, JString, required = true,
                                 default = nil)
  if valid_574293 != nil:
    section.add "resourceGroupName", valid_574293
  var valid_574294 = path.getOrDefault("applicationTypeName")
  valid_574294 = validateParameter(valid_574294, JString, required = true,
                                 default = nil)
  if valid_574294 != nil:
    section.add "applicationTypeName", valid_574294
  var valid_574295 = path.getOrDefault("version")
  valid_574295 = validateParameter(valid_574295, JString, required = true,
                                 default = nil)
  if valid_574295 != nil:
    section.add "version", valid_574295
  var valid_574296 = path.getOrDefault("subscriptionId")
  valid_574296 = validateParameter(valid_574296, JString, required = true,
                                 default = nil)
  if valid_574296 != nil:
    section.add "subscriptionId", valid_574296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574297 = query.getOrDefault("api-version")
  valid_574297 = validateParameter(valid_574297, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574297 != nil:
    section.add "api-version", valid_574297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574298: Call_ApplicationTypeVersionsGet_574289; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Service Fabric application type version resource created or in the process of being created in the Service Fabric application type name resource.
  ## 
  let valid = call_574298.validator(path, query, header, formData, body)
  let scheme = call_574298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574298.url(scheme.get, call_574298.host, call_574298.base,
                         call_574298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574298, url, valid)

proc call*(call_574299: Call_ApplicationTypeVersionsGet_574289;
          clusterName: string; resourceGroupName: string;
          applicationTypeName: string; version: string; subscriptionId: string;
          apiVersion: string = "2019-03-01"): Recallable =
  ## applicationTypeVersionsGet
  ## Get a Service Fabric application type version resource created or in the process of being created in the Service Fabric application type name resource.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type name resource.
  ##   version: string (required)
  ##          : The application type version.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_574300 = newJObject()
  var query_574301 = newJObject()
  add(path_574300, "clusterName", newJString(clusterName))
  add(path_574300, "resourceGroupName", newJString(resourceGroupName))
  add(query_574301, "api-version", newJString(apiVersion))
  add(path_574300, "applicationTypeName", newJString(applicationTypeName))
  add(path_574300, "version", newJString(version))
  add(path_574300, "subscriptionId", newJString(subscriptionId))
  result = call_574299.call(path_574300, query_574301, nil, nil, nil)

var applicationTypeVersionsGet* = Call_ApplicationTypeVersionsGet_574289(
    name: "applicationTypeVersionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}/versions/{version}",
    validator: validate_ApplicationTypeVersionsGet_574290, base: "",
    url: url_ApplicationTypeVersionsGet_574291, schemes: {Scheme.Https})
type
  Call_ApplicationTypeVersionsDelete_574317 = ref object of OpenApiRestCall_573666
proc url_ApplicationTypeVersionsDelete_574319(protocol: Scheme; host: string;
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

proc validate_ApplicationTypeVersionsDelete_574318(path: JsonNode; query: JsonNode;
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
  var valid_574320 = path.getOrDefault("clusterName")
  valid_574320 = validateParameter(valid_574320, JString, required = true,
                                 default = nil)
  if valid_574320 != nil:
    section.add "clusterName", valid_574320
  var valid_574321 = path.getOrDefault("resourceGroupName")
  valid_574321 = validateParameter(valid_574321, JString, required = true,
                                 default = nil)
  if valid_574321 != nil:
    section.add "resourceGroupName", valid_574321
  var valid_574322 = path.getOrDefault("applicationTypeName")
  valid_574322 = validateParameter(valid_574322, JString, required = true,
                                 default = nil)
  if valid_574322 != nil:
    section.add "applicationTypeName", valid_574322
  var valid_574323 = path.getOrDefault("version")
  valid_574323 = validateParameter(valid_574323, JString, required = true,
                                 default = nil)
  if valid_574323 != nil:
    section.add "version", valid_574323
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

proc call*(call_574326: Call_ApplicationTypeVersionsDelete_574317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Service Fabric application type version resource with the specified name.
  ## 
  let valid = call_574326.validator(path, query, header, formData, body)
  let scheme = call_574326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574326.url(scheme.get, call_574326.host, call_574326.base,
                         call_574326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574326, url, valid)

proc call*(call_574327: Call_ApplicationTypeVersionsDelete_574317;
          clusterName: string; resourceGroupName: string;
          applicationTypeName: string; version: string; subscriptionId: string;
          apiVersion: string = "2019-03-01"): Recallable =
  ## applicationTypeVersionsDelete
  ## Delete a Service Fabric application type version resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type name resource.
  ##   version: string (required)
  ##          : The application type version.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_574328 = newJObject()
  var query_574329 = newJObject()
  add(path_574328, "clusterName", newJString(clusterName))
  add(path_574328, "resourceGroupName", newJString(resourceGroupName))
  add(query_574329, "api-version", newJString(apiVersion))
  add(path_574328, "applicationTypeName", newJString(applicationTypeName))
  add(path_574328, "version", newJString(version))
  add(path_574328, "subscriptionId", newJString(subscriptionId))
  result = call_574327.call(path_574328, query_574329, nil, nil, nil)

var applicationTypeVersionsDelete* = Call_ApplicationTypeVersionsDelete_574317(
    name: "applicationTypeVersionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}/versions/{version}",
    validator: validate_ApplicationTypeVersionsDelete_574318, base: "",
    url: url_ApplicationTypeVersionsDelete_574319, schemes: {Scheme.Https})
type
  Call_ApplicationsList_574330 = ref object of OpenApiRestCall_573666
proc url_ApplicationsList_574332(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationsList_574331(path: JsonNode; query: JsonNode;
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
  var valid_574333 = path.getOrDefault("clusterName")
  valid_574333 = validateParameter(valid_574333, JString, required = true,
                                 default = nil)
  if valid_574333 != nil:
    section.add "clusterName", valid_574333
  var valid_574334 = path.getOrDefault("resourceGroupName")
  valid_574334 = validateParameter(valid_574334, JString, required = true,
                                 default = nil)
  if valid_574334 != nil:
    section.add "resourceGroupName", valid_574334
  var valid_574335 = path.getOrDefault("subscriptionId")
  valid_574335 = validateParameter(valid_574335, JString, required = true,
                                 default = nil)
  if valid_574335 != nil:
    section.add "subscriptionId", valid_574335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574336 = query.getOrDefault("api-version")
  valid_574336 = validateParameter(valid_574336, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574336 != nil:
    section.add "api-version", valid_574336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574337: Call_ApplicationsList_574330; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all application resources created or in the process of being created in the Service Fabric cluster resource.
  ## 
  let valid = call_574337.validator(path, query, header, formData, body)
  let scheme = call_574337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574337.url(scheme.get, call_574337.host, call_574337.base,
                         call_574337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574337, url, valid)

proc call*(call_574338: Call_ApplicationsList_574330; clusterName: string;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2019-03-01"): Recallable =
  ## applicationsList
  ## Gets all application resources created or in the process of being created in the Service Fabric cluster resource.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_574339 = newJObject()
  var query_574340 = newJObject()
  add(path_574339, "clusterName", newJString(clusterName))
  add(path_574339, "resourceGroupName", newJString(resourceGroupName))
  add(query_574340, "api-version", newJString(apiVersion))
  add(path_574339, "subscriptionId", newJString(subscriptionId))
  result = call_574338.call(path_574339, query_574340, nil, nil, nil)

var applicationsList* = Call_ApplicationsList_574330(name: "applicationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications",
    validator: validate_ApplicationsList_574331, base: "",
    url: url_ApplicationsList_574332, schemes: {Scheme.Https})
type
  Call_ApplicationsCreateOrUpdate_574353 = ref object of OpenApiRestCall_573666
proc url_ApplicationsCreateOrUpdate_574355(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_ApplicationsCreateOrUpdate_574354(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_574356 = path.getOrDefault("clusterName")
  valid_574356 = validateParameter(valid_574356, JString, required = true,
                                 default = nil)
  if valid_574356 != nil:
    section.add "clusterName", valid_574356
  var valid_574357 = path.getOrDefault("resourceGroupName")
  valid_574357 = validateParameter(valid_574357, JString, required = true,
                                 default = nil)
  if valid_574357 != nil:
    section.add "resourceGroupName", valid_574357
  var valid_574358 = path.getOrDefault("applicationName")
  valid_574358 = validateParameter(valid_574358, JString, required = true,
                                 default = nil)
  if valid_574358 != nil:
    section.add "applicationName", valid_574358
  var valid_574359 = path.getOrDefault("subscriptionId")
  valid_574359 = validateParameter(valid_574359, JString, required = true,
                                 default = nil)
  if valid_574359 != nil:
    section.add "subscriptionId", valid_574359
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574360 = query.getOrDefault("api-version")
  valid_574360 = validateParameter(valid_574360, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574360 != nil:
    section.add "api-version", valid_574360
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

proc call*(call_574362: Call_ApplicationsCreateOrUpdate_574353; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Service Fabric application resource with the specified name.
  ## 
  let valid = call_574362.validator(path, query, header, formData, body)
  let scheme = call_574362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574362.url(scheme.get, call_574362.host, call_574362.base,
                         call_574362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574362, url, valid)

proc call*(call_574363: Call_ApplicationsCreateOrUpdate_574353;
          clusterName: string; resourceGroupName: string; applicationName: string;
          subscriptionId: string; parameters: JsonNode;
          apiVersion: string = "2019-03-01"): Recallable =
  ## applicationsCreateOrUpdate
  ## Create or update a Service Fabric application resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   parameters: JObject (required)
  ##             : The application resource.
  var path_574364 = newJObject()
  var query_574365 = newJObject()
  var body_574366 = newJObject()
  add(path_574364, "clusterName", newJString(clusterName))
  add(path_574364, "resourceGroupName", newJString(resourceGroupName))
  add(path_574364, "applicationName", newJString(applicationName))
  add(query_574365, "api-version", newJString(apiVersion))
  add(path_574364, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574366 = parameters
  result = call_574363.call(path_574364, query_574365, nil, nil, body_574366)

var applicationsCreateOrUpdate* = Call_ApplicationsCreateOrUpdate_574353(
    name: "applicationsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}",
    validator: validate_ApplicationsCreateOrUpdate_574354, base: "",
    url: url_ApplicationsCreateOrUpdate_574355, schemes: {Scheme.Https})
type
  Call_ApplicationsGet_574341 = ref object of OpenApiRestCall_573666
proc url_ApplicationsGet_574343(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationsGet_574342(path: JsonNode; query: JsonNode;
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
  var valid_574344 = path.getOrDefault("clusterName")
  valid_574344 = validateParameter(valid_574344, JString, required = true,
                                 default = nil)
  if valid_574344 != nil:
    section.add "clusterName", valid_574344
  var valid_574345 = path.getOrDefault("resourceGroupName")
  valid_574345 = validateParameter(valid_574345, JString, required = true,
                                 default = nil)
  if valid_574345 != nil:
    section.add "resourceGroupName", valid_574345
  var valid_574346 = path.getOrDefault("applicationName")
  valid_574346 = validateParameter(valid_574346, JString, required = true,
                                 default = nil)
  if valid_574346 != nil:
    section.add "applicationName", valid_574346
  var valid_574347 = path.getOrDefault("subscriptionId")
  valid_574347 = validateParameter(valid_574347, JString, required = true,
                                 default = nil)
  if valid_574347 != nil:
    section.add "subscriptionId", valid_574347
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574348 = query.getOrDefault("api-version")
  valid_574348 = validateParameter(valid_574348, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574348 != nil:
    section.add "api-version", valid_574348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574349: Call_ApplicationsGet_574341; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Service Fabric application resource created or in the process of being created in the Service Fabric cluster resource.
  ## 
  let valid = call_574349.validator(path, query, header, formData, body)
  let scheme = call_574349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574349.url(scheme.get, call_574349.host, call_574349.base,
                         call_574349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574349, url, valid)

proc call*(call_574350: Call_ApplicationsGet_574341; clusterName: string;
          resourceGroupName: string; applicationName: string;
          subscriptionId: string; apiVersion: string = "2019-03-01"): Recallable =
  ## applicationsGet
  ## Get a Service Fabric application resource created or in the process of being created in the Service Fabric cluster resource.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_574351 = newJObject()
  var query_574352 = newJObject()
  add(path_574351, "clusterName", newJString(clusterName))
  add(path_574351, "resourceGroupName", newJString(resourceGroupName))
  add(path_574351, "applicationName", newJString(applicationName))
  add(query_574352, "api-version", newJString(apiVersion))
  add(path_574351, "subscriptionId", newJString(subscriptionId))
  result = call_574350.call(path_574351, query_574352, nil, nil, nil)

var applicationsGet* = Call_ApplicationsGet_574341(name: "applicationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}",
    validator: validate_ApplicationsGet_574342, base: "", url: url_ApplicationsGet_574343,
    schemes: {Scheme.Https})
type
  Call_ApplicationsUpdate_574379 = ref object of OpenApiRestCall_573666
proc url_ApplicationsUpdate_574381(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationsUpdate_574380(path: JsonNode; query: JsonNode;
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
  var valid_574382 = path.getOrDefault("clusterName")
  valid_574382 = validateParameter(valid_574382, JString, required = true,
                                 default = nil)
  if valid_574382 != nil:
    section.add "clusterName", valid_574382
  var valid_574383 = path.getOrDefault("resourceGroupName")
  valid_574383 = validateParameter(valid_574383, JString, required = true,
                                 default = nil)
  if valid_574383 != nil:
    section.add "resourceGroupName", valid_574383
  var valid_574384 = path.getOrDefault("applicationName")
  valid_574384 = validateParameter(valid_574384, JString, required = true,
                                 default = nil)
  if valid_574384 != nil:
    section.add "applicationName", valid_574384
  var valid_574385 = path.getOrDefault("subscriptionId")
  valid_574385 = validateParameter(valid_574385, JString, required = true,
                                 default = nil)
  if valid_574385 != nil:
    section.add "subscriptionId", valid_574385
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574386 = query.getOrDefault("api-version")
  valid_574386 = validateParameter(valid_574386, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574386 != nil:
    section.add "api-version", valid_574386
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

proc call*(call_574388: Call_ApplicationsUpdate_574379; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a Service Fabric application resource with the specified name.
  ## 
  let valid = call_574388.validator(path, query, header, formData, body)
  let scheme = call_574388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574388.url(scheme.get, call_574388.host, call_574388.base,
                         call_574388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574388, url, valid)

proc call*(call_574389: Call_ApplicationsUpdate_574379; clusterName: string;
          resourceGroupName: string; applicationName: string;
          subscriptionId: string; parameters: JsonNode;
          apiVersion: string = "2019-03-01"): Recallable =
  ## applicationsUpdate
  ## Update a Service Fabric application resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   parameters: JObject (required)
  ##             : The application resource for patch operations.
  var path_574390 = newJObject()
  var query_574391 = newJObject()
  var body_574392 = newJObject()
  add(path_574390, "clusterName", newJString(clusterName))
  add(path_574390, "resourceGroupName", newJString(resourceGroupName))
  add(path_574390, "applicationName", newJString(applicationName))
  add(query_574391, "api-version", newJString(apiVersion))
  add(path_574390, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574392 = parameters
  result = call_574389.call(path_574390, query_574391, nil, nil, body_574392)

var applicationsUpdate* = Call_ApplicationsUpdate_574379(
    name: "applicationsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}",
    validator: validate_ApplicationsUpdate_574380, base: "",
    url: url_ApplicationsUpdate_574381, schemes: {Scheme.Https})
type
  Call_ApplicationsDelete_574367 = ref object of OpenApiRestCall_573666
proc url_ApplicationsDelete_574369(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationsDelete_574368(path: JsonNode; query: JsonNode;
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
  var valid_574370 = path.getOrDefault("clusterName")
  valid_574370 = validateParameter(valid_574370, JString, required = true,
                                 default = nil)
  if valid_574370 != nil:
    section.add "clusterName", valid_574370
  var valid_574371 = path.getOrDefault("resourceGroupName")
  valid_574371 = validateParameter(valid_574371, JString, required = true,
                                 default = nil)
  if valid_574371 != nil:
    section.add "resourceGroupName", valid_574371
  var valid_574372 = path.getOrDefault("applicationName")
  valid_574372 = validateParameter(valid_574372, JString, required = true,
                                 default = nil)
  if valid_574372 != nil:
    section.add "applicationName", valid_574372
  var valid_574373 = path.getOrDefault("subscriptionId")
  valid_574373 = validateParameter(valid_574373, JString, required = true,
                                 default = nil)
  if valid_574373 != nil:
    section.add "subscriptionId", valid_574373
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574374 = query.getOrDefault("api-version")
  valid_574374 = validateParameter(valid_574374, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574374 != nil:
    section.add "api-version", valid_574374
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574375: Call_ApplicationsDelete_574367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Service Fabric application resource with the specified name.
  ## 
  let valid = call_574375.validator(path, query, header, formData, body)
  let scheme = call_574375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574375.url(scheme.get, call_574375.host, call_574375.base,
                         call_574375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574375, url, valid)

proc call*(call_574376: Call_ApplicationsDelete_574367; clusterName: string;
          resourceGroupName: string; applicationName: string;
          subscriptionId: string; apiVersion: string = "2019-03-01"): Recallable =
  ## applicationsDelete
  ## Delete a Service Fabric application resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_574377 = newJObject()
  var query_574378 = newJObject()
  add(path_574377, "clusterName", newJString(clusterName))
  add(path_574377, "resourceGroupName", newJString(resourceGroupName))
  add(path_574377, "applicationName", newJString(applicationName))
  add(query_574378, "api-version", newJString(apiVersion))
  add(path_574377, "subscriptionId", newJString(subscriptionId))
  result = call_574376.call(path_574377, query_574378, nil, nil, nil)

var applicationsDelete* = Call_ApplicationsDelete_574367(
    name: "applicationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}",
    validator: validate_ApplicationsDelete_574368, base: "",
    url: url_ApplicationsDelete_574369, schemes: {Scheme.Https})
type
  Call_ServicesList_574393 = ref object of OpenApiRestCall_573666
proc url_ServicesList_574395(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesList_574394(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574396 = path.getOrDefault("clusterName")
  valid_574396 = validateParameter(valid_574396, JString, required = true,
                                 default = nil)
  if valid_574396 != nil:
    section.add "clusterName", valid_574396
  var valid_574397 = path.getOrDefault("resourceGroupName")
  valid_574397 = validateParameter(valid_574397, JString, required = true,
                                 default = nil)
  if valid_574397 != nil:
    section.add "resourceGroupName", valid_574397
  var valid_574398 = path.getOrDefault("applicationName")
  valid_574398 = validateParameter(valid_574398, JString, required = true,
                                 default = nil)
  if valid_574398 != nil:
    section.add "applicationName", valid_574398
  var valid_574399 = path.getOrDefault("subscriptionId")
  valid_574399 = validateParameter(valid_574399, JString, required = true,
                                 default = nil)
  if valid_574399 != nil:
    section.add "subscriptionId", valid_574399
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574400 = query.getOrDefault("api-version")
  valid_574400 = validateParameter(valid_574400, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574400 != nil:
    section.add "api-version", valid_574400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574401: Call_ServicesList_574393; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all service resources created or in the process of being created in the Service Fabric application resource.
  ## 
  let valid = call_574401.validator(path, query, header, formData, body)
  let scheme = call_574401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574401.url(scheme.get, call_574401.host, call_574401.base,
                         call_574401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574401, url, valid)

proc call*(call_574402: Call_ServicesList_574393; clusterName: string;
          resourceGroupName: string; applicationName: string;
          subscriptionId: string; apiVersion: string = "2019-03-01"): Recallable =
  ## servicesList
  ## Gets all service resources created or in the process of being created in the Service Fabric application resource.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_574403 = newJObject()
  var query_574404 = newJObject()
  add(path_574403, "clusterName", newJString(clusterName))
  add(path_574403, "resourceGroupName", newJString(resourceGroupName))
  add(path_574403, "applicationName", newJString(applicationName))
  add(query_574404, "api-version", newJString(apiVersion))
  add(path_574403, "subscriptionId", newJString(subscriptionId))
  result = call_574402.call(path_574403, query_574404, nil, nil, nil)

var servicesList* = Call_ServicesList_574393(name: "servicesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}/services",
    validator: validate_ServicesList_574394, base: "", url: url_ServicesList_574395,
    schemes: {Scheme.Https})
type
  Call_ServicesCreateOrUpdate_574418 = ref object of OpenApiRestCall_573666
proc url_ServicesCreateOrUpdate_574420(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesCreateOrUpdate_574419(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_574421 = path.getOrDefault("clusterName")
  valid_574421 = validateParameter(valid_574421, JString, required = true,
                                 default = nil)
  if valid_574421 != nil:
    section.add "clusterName", valid_574421
  var valid_574422 = path.getOrDefault("resourceGroupName")
  valid_574422 = validateParameter(valid_574422, JString, required = true,
                                 default = nil)
  if valid_574422 != nil:
    section.add "resourceGroupName", valid_574422
  var valid_574423 = path.getOrDefault("applicationName")
  valid_574423 = validateParameter(valid_574423, JString, required = true,
                                 default = nil)
  if valid_574423 != nil:
    section.add "applicationName", valid_574423
  var valid_574424 = path.getOrDefault("subscriptionId")
  valid_574424 = validateParameter(valid_574424, JString, required = true,
                                 default = nil)
  if valid_574424 != nil:
    section.add "subscriptionId", valid_574424
  var valid_574425 = path.getOrDefault("serviceName")
  valid_574425 = validateParameter(valid_574425, JString, required = true,
                                 default = nil)
  if valid_574425 != nil:
    section.add "serviceName", valid_574425
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574426 = query.getOrDefault("api-version")
  valid_574426 = validateParameter(valid_574426, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574426 != nil:
    section.add "api-version", valid_574426
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

proc call*(call_574428: Call_ServicesCreateOrUpdate_574418; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Service Fabric service resource with the specified name.
  ## 
  let valid = call_574428.validator(path, query, header, formData, body)
  let scheme = call_574428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574428.url(scheme.get, call_574428.host, call_574428.base,
                         call_574428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574428, url, valid)

proc call*(call_574429: Call_ServicesCreateOrUpdate_574418; clusterName: string;
          resourceGroupName: string; applicationName: string;
          subscriptionId: string; parameters: JsonNode; serviceName: string;
          apiVersion: string = "2019-03-01"): Recallable =
  ## servicesCreateOrUpdate
  ## Create or update a Service Fabric service resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   parameters: JObject (required)
  ##             : The service resource.
  ##   serviceName: string (required)
  ##              : The name of the service resource in the format of {applicationName}~{serviceName}.
  var path_574430 = newJObject()
  var query_574431 = newJObject()
  var body_574432 = newJObject()
  add(path_574430, "clusterName", newJString(clusterName))
  add(path_574430, "resourceGroupName", newJString(resourceGroupName))
  add(path_574430, "applicationName", newJString(applicationName))
  add(query_574431, "api-version", newJString(apiVersion))
  add(path_574430, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574432 = parameters
  add(path_574430, "serviceName", newJString(serviceName))
  result = call_574429.call(path_574430, query_574431, nil, nil, body_574432)

var servicesCreateOrUpdate* = Call_ServicesCreateOrUpdate_574418(
    name: "servicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}/services/{serviceName}",
    validator: validate_ServicesCreateOrUpdate_574419, base: "",
    url: url_ServicesCreateOrUpdate_574420, schemes: {Scheme.Https})
type
  Call_ServicesGet_574405 = ref object of OpenApiRestCall_573666
proc url_ServicesGet_574407(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesGet_574406(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574408 = path.getOrDefault("clusterName")
  valid_574408 = validateParameter(valid_574408, JString, required = true,
                                 default = nil)
  if valid_574408 != nil:
    section.add "clusterName", valid_574408
  var valid_574409 = path.getOrDefault("resourceGroupName")
  valid_574409 = validateParameter(valid_574409, JString, required = true,
                                 default = nil)
  if valid_574409 != nil:
    section.add "resourceGroupName", valid_574409
  var valid_574410 = path.getOrDefault("applicationName")
  valid_574410 = validateParameter(valid_574410, JString, required = true,
                                 default = nil)
  if valid_574410 != nil:
    section.add "applicationName", valid_574410
  var valid_574411 = path.getOrDefault("subscriptionId")
  valid_574411 = validateParameter(valid_574411, JString, required = true,
                                 default = nil)
  if valid_574411 != nil:
    section.add "subscriptionId", valid_574411
  var valid_574412 = path.getOrDefault("serviceName")
  valid_574412 = validateParameter(valid_574412, JString, required = true,
                                 default = nil)
  if valid_574412 != nil:
    section.add "serviceName", valid_574412
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574413 = query.getOrDefault("api-version")
  valid_574413 = validateParameter(valid_574413, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574413 != nil:
    section.add "api-version", valid_574413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574414: Call_ServicesGet_574405; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Service Fabric service resource created or in the process of being created in the Service Fabric application resource.
  ## 
  let valid = call_574414.validator(path, query, header, formData, body)
  let scheme = call_574414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574414.url(scheme.get, call_574414.host, call_574414.base,
                         call_574414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574414, url, valid)

proc call*(call_574415: Call_ServicesGet_574405; clusterName: string;
          resourceGroupName: string; applicationName: string;
          subscriptionId: string; serviceName: string;
          apiVersion: string = "2019-03-01"): Recallable =
  ## servicesGet
  ## Get a Service Fabric service resource created or in the process of being created in the Service Fabric application resource.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   serviceName: string (required)
  ##              : The name of the service resource in the format of {applicationName}~{serviceName}.
  var path_574416 = newJObject()
  var query_574417 = newJObject()
  add(path_574416, "clusterName", newJString(clusterName))
  add(path_574416, "resourceGroupName", newJString(resourceGroupName))
  add(path_574416, "applicationName", newJString(applicationName))
  add(query_574417, "api-version", newJString(apiVersion))
  add(path_574416, "subscriptionId", newJString(subscriptionId))
  add(path_574416, "serviceName", newJString(serviceName))
  result = call_574415.call(path_574416, query_574417, nil, nil, nil)

var servicesGet* = Call_ServicesGet_574405(name: "servicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}/services/{serviceName}",
                                        validator: validate_ServicesGet_574406,
                                        base: "", url: url_ServicesGet_574407,
                                        schemes: {Scheme.Https})
type
  Call_ServicesUpdate_574446 = ref object of OpenApiRestCall_573666
proc url_ServicesUpdate_574448(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesUpdate_574447(path: JsonNode; query: JsonNode;
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
  var valid_574449 = path.getOrDefault("clusterName")
  valid_574449 = validateParameter(valid_574449, JString, required = true,
                                 default = nil)
  if valid_574449 != nil:
    section.add "clusterName", valid_574449
  var valid_574450 = path.getOrDefault("resourceGroupName")
  valid_574450 = validateParameter(valid_574450, JString, required = true,
                                 default = nil)
  if valid_574450 != nil:
    section.add "resourceGroupName", valid_574450
  var valid_574451 = path.getOrDefault("applicationName")
  valid_574451 = validateParameter(valid_574451, JString, required = true,
                                 default = nil)
  if valid_574451 != nil:
    section.add "applicationName", valid_574451
  var valid_574452 = path.getOrDefault("subscriptionId")
  valid_574452 = validateParameter(valid_574452, JString, required = true,
                                 default = nil)
  if valid_574452 != nil:
    section.add "subscriptionId", valid_574452
  var valid_574453 = path.getOrDefault("serviceName")
  valid_574453 = validateParameter(valid_574453, JString, required = true,
                                 default = nil)
  if valid_574453 != nil:
    section.add "serviceName", valid_574453
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574454 = query.getOrDefault("api-version")
  valid_574454 = validateParameter(valid_574454, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574454 != nil:
    section.add "api-version", valid_574454
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

proc call*(call_574456: Call_ServicesUpdate_574446; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a Service Fabric service resource with the specified name.
  ## 
  let valid = call_574456.validator(path, query, header, formData, body)
  let scheme = call_574456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574456.url(scheme.get, call_574456.host, call_574456.base,
                         call_574456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574456, url, valid)

proc call*(call_574457: Call_ServicesUpdate_574446; clusterName: string;
          resourceGroupName: string; applicationName: string;
          subscriptionId: string; parameters: JsonNode; serviceName: string;
          apiVersion: string = "2019-03-01"): Recallable =
  ## servicesUpdate
  ## Update a Service Fabric service resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   parameters: JObject (required)
  ##             : The service resource for patch operations.
  ##   serviceName: string (required)
  ##              : The name of the service resource in the format of {applicationName}~{serviceName}.
  var path_574458 = newJObject()
  var query_574459 = newJObject()
  var body_574460 = newJObject()
  add(path_574458, "clusterName", newJString(clusterName))
  add(path_574458, "resourceGroupName", newJString(resourceGroupName))
  add(path_574458, "applicationName", newJString(applicationName))
  add(query_574459, "api-version", newJString(apiVersion))
  add(path_574458, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574460 = parameters
  add(path_574458, "serviceName", newJString(serviceName))
  result = call_574457.call(path_574458, query_574459, nil, nil, body_574460)

var servicesUpdate* = Call_ServicesUpdate_574446(name: "servicesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}/services/{serviceName}",
    validator: validate_ServicesUpdate_574447, base: "", url: url_ServicesUpdate_574448,
    schemes: {Scheme.Https})
type
  Call_ServicesDelete_574433 = ref object of OpenApiRestCall_573666
proc url_ServicesDelete_574435(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesDelete_574434(path: JsonNode; query: JsonNode;
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
  var valid_574436 = path.getOrDefault("clusterName")
  valid_574436 = validateParameter(valid_574436, JString, required = true,
                                 default = nil)
  if valid_574436 != nil:
    section.add "clusterName", valid_574436
  var valid_574437 = path.getOrDefault("resourceGroupName")
  valid_574437 = validateParameter(valid_574437, JString, required = true,
                                 default = nil)
  if valid_574437 != nil:
    section.add "resourceGroupName", valid_574437
  var valid_574438 = path.getOrDefault("applicationName")
  valid_574438 = validateParameter(valid_574438, JString, required = true,
                                 default = nil)
  if valid_574438 != nil:
    section.add "applicationName", valid_574438
  var valid_574439 = path.getOrDefault("subscriptionId")
  valid_574439 = validateParameter(valid_574439, JString, required = true,
                                 default = nil)
  if valid_574439 != nil:
    section.add "subscriptionId", valid_574439
  var valid_574440 = path.getOrDefault("serviceName")
  valid_574440 = validateParameter(valid_574440, JString, required = true,
                                 default = nil)
  if valid_574440 != nil:
    section.add "serviceName", valid_574440
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574441 = query.getOrDefault("api-version")
  valid_574441 = validateParameter(valid_574441, JString, required = true,
                                 default = newJString("2019-03-01"))
  if valid_574441 != nil:
    section.add "api-version", valid_574441
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574442: Call_ServicesDelete_574433; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Service Fabric service resource with the specified name.
  ## 
  let valid = call_574442.validator(path, query, header, formData, body)
  let scheme = call_574442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574442.url(scheme.get, call_574442.host, call_574442.base,
                         call_574442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574442, url, valid)

proc call*(call_574443: Call_ServicesDelete_574433; clusterName: string;
          resourceGroupName: string; applicationName: string;
          subscriptionId: string; serviceName: string;
          apiVersion: string = "2019-03-01"): Recallable =
  ## servicesDelete
  ## Delete a Service Fabric service resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   applicationName: string (required)
  ##                  : The name of the application resource.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   serviceName: string (required)
  ##              : The name of the service resource in the format of {applicationName}~{serviceName}.
  var path_574444 = newJObject()
  var query_574445 = newJObject()
  add(path_574444, "clusterName", newJString(clusterName))
  add(path_574444, "resourceGroupName", newJString(resourceGroupName))
  add(path_574444, "applicationName", newJString(applicationName))
  add(query_574445, "api-version", newJString(apiVersion))
  add(path_574444, "subscriptionId", newJString(subscriptionId))
  add(path_574444, "serviceName", newJString(serviceName))
  result = call_574443.call(path_574444, query_574445, nil, nil, nil)

var servicesDelete* = Call_ServicesDelete_574433(name: "servicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}/services/{serviceName}",
    validator: validate_ServicesDelete_574434, base: "", url: url_ServicesDelete_574435,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
