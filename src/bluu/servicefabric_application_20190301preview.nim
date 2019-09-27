
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593437): Option[Scheme] {.used.} =
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
  macServiceName = "servicefabric-application"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593659 = ref object of OpenApiRestCall_593437
proc url_OperationsList_593661(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593660(path: JsonNode; query: JsonNode;
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
  var valid_593807 = query.getOrDefault("api-version")
  valid_593807 = validateParameter(valid_593807, JString, required = true,
                                 default = nil)
  if valid_593807 != nil:
    section.add "api-version", valid_593807
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593834: Call_OperationsList_593659; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of available Service Fabric resource provider API operations.
  ## 
  let valid = call_593834.validator(path, query, header, formData, body)
  let scheme = call_593834.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593834.url(scheme.get, call_593834.host, call_593834.base,
                         call_593834.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593834, url, valid)

proc call*(call_593905: Call_OperationsList_593659; apiVersion: string): Recallable =
  ## operationsList
  ## Get the list of available Service Fabric resource provider API operations.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API
  var query_593906 = newJObject()
  add(query_593906, "api-version", newJString(apiVersion))
  result = call_593905.call(nil, query_593906, nil, nil, nil)

var operationsList* = Call_OperationsList_593659(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ServiceFabric/operations",
    validator: validate_OperationsList_593660, base: "", url: url_OperationsList_593661,
    schemes: {Scheme.Https})
type
  Call_ApplicationTypesList_593946 = ref object of OpenApiRestCall_593437
proc url_ApplicationTypesList_593948(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationTypesList_593947(path: JsonNode; query: JsonNode;
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
  var valid_593972 = path.getOrDefault("clusterName")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "clusterName", valid_593972
  var valid_593973 = path.getOrDefault("resourceGroupName")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "resourceGroupName", valid_593973
  var valid_593974 = path.getOrDefault("subscriptionId")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "subscriptionId", valid_593974
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593988 = query.getOrDefault("api-version")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_593988 != nil:
    section.add "api-version", valid_593988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593989: Call_ApplicationTypesList_593946; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all application type name resources created or in the process of being created in the Service Fabric cluster resource.
  ## 
  let valid = call_593989.validator(path, query, header, formData, body)
  let scheme = call_593989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593989.url(scheme.get, call_593989.host, call_593989.base,
                         call_593989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593989, url, valid)

proc call*(call_593990: Call_ApplicationTypesList_593946; clusterName: string;
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
  var path_593991 = newJObject()
  var query_593992 = newJObject()
  add(path_593991, "clusterName", newJString(clusterName))
  add(path_593991, "resourceGroupName", newJString(resourceGroupName))
  add(query_593992, "api-version", newJString(apiVersion))
  add(path_593991, "subscriptionId", newJString(subscriptionId))
  result = call_593990.call(path_593991, query_593992, nil, nil, nil)

var applicationTypesList* = Call_ApplicationTypesList_593946(
    name: "applicationTypesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes",
    validator: validate_ApplicationTypesList_593947, base: "",
    url: url_ApplicationTypesList_593948, schemes: {Scheme.Https})
type
  Call_ApplicationTypesCreate_594005 = ref object of OpenApiRestCall_593437
proc url_ApplicationTypesCreate_594007(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationTypesCreate_594006(path: JsonNode; query: JsonNode;
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
  var valid_594025 = path.getOrDefault("clusterName")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "clusterName", valid_594025
  var valid_594026 = path.getOrDefault("resourceGroupName")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "resourceGroupName", valid_594026
  var valid_594027 = path.getOrDefault("applicationTypeName")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "applicationTypeName", valid_594027
  var valid_594028 = path.getOrDefault("subscriptionId")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "subscriptionId", valid_594028
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594029 = query.getOrDefault("api-version")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_594029 != nil:
    section.add "api-version", valid_594029
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

proc call*(call_594031: Call_ApplicationTypesCreate_594005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Service Fabric application type name resource with the specified name.
  ## 
  let valid = call_594031.validator(path, query, header, formData, body)
  let scheme = call_594031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594031.url(scheme.get, call_594031.host, call_594031.base,
                         call_594031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594031, url, valid)

proc call*(call_594032: Call_ApplicationTypesCreate_594005; clusterName: string;
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
  var path_594033 = newJObject()
  var query_594034 = newJObject()
  var body_594035 = newJObject()
  add(path_594033, "clusterName", newJString(clusterName))
  add(path_594033, "resourceGroupName", newJString(resourceGroupName))
  add(query_594034, "api-version", newJString(apiVersion))
  add(path_594033, "applicationTypeName", newJString(applicationTypeName))
  add(path_594033, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594035 = parameters
  result = call_594032.call(path_594033, query_594034, nil, nil, body_594035)

var applicationTypesCreate* = Call_ApplicationTypesCreate_594005(
    name: "applicationTypesCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}",
    validator: validate_ApplicationTypesCreate_594006, base: "",
    url: url_ApplicationTypesCreate_594007, schemes: {Scheme.Https})
type
  Call_ApplicationTypesGet_593993 = ref object of OpenApiRestCall_593437
proc url_ApplicationTypesGet_593995(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationTypesGet_593994(path: JsonNode; query: JsonNode;
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
  var valid_593996 = path.getOrDefault("clusterName")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "clusterName", valid_593996
  var valid_593997 = path.getOrDefault("resourceGroupName")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "resourceGroupName", valid_593997
  var valid_593998 = path.getOrDefault("applicationTypeName")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "applicationTypeName", valid_593998
  var valid_593999 = path.getOrDefault("subscriptionId")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "subscriptionId", valid_593999
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594000 = query.getOrDefault("api-version")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_594000 != nil:
    section.add "api-version", valid_594000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594001: Call_ApplicationTypesGet_593993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Service Fabric application type name resource created or in the process of being created in the Service Fabric cluster resource.
  ## 
  let valid = call_594001.validator(path, query, header, formData, body)
  let scheme = call_594001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594001.url(scheme.get, call_594001.host, call_594001.base,
                         call_594001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594001, url, valid)

proc call*(call_594002: Call_ApplicationTypesGet_593993; clusterName: string;
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
  var path_594003 = newJObject()
  var query_594004 = newJObject()
  add(path_594003, "clusterName", newJString(clusterName))
  add(path_594003, "resourceGroupName", newJString(resourceGroupName))
  add(query_594004, "api-version", newJString(apiVersion))
  add(path_594003, "applicationTypeName", newJString(applicationTypeName))
  add(path_594003, "subscriptionId", newJString(subscriptionId))
  result = call_594002.call(path_594003, query_594004, nil, nil, nil)

var applicationTypesGet* = Call_ApplicationTypesGet_593993(
    name: "applicationTypesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}",
    validator: validate_ApplicationTypesGet_593994, base: "",
    url: url_ApplicationTypesGet_593995, schemes: {Scheme.Https})
type
  Call_ApplicationTypesDelete_594036 = ref object of OpenApiRestCall_593437
proc url_ApplicationTypesDelete_594038(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationTypesDelete_594037(path: JsonNode; query: JsonNode;
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
  var valid_594039 = path.getOrDefault("clusterName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "clusterName", valid_594039
  var valid_594040 = path.getOrDefault("resourceGroupName")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "resourceGroupName", valid_594040
  var valid_594041 = path.getOrDefault("applicationTypeName")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "applicationTypeName", valid_594041
  var valid_594042 = path.getOrDefault("subscriptionId")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "subscriptionId", valid_594042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594043 = query.getOrDefault("api-version")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_594043 != nil:
    section.add "api-version", valid_594043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594044: Call_ApplicationTypesDelete_594036; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Service Fabric application type name resource with the specified name.
  ## 
  let valid = call_594044.validator(path, query, header, formData, body)
  let scheme = call_594044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594044.url(scheme.get, call_594044.host, call_594044.base,
                         call_594044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594044, url, valid)

proc call*(call_594045: Call_ApplicationTypesDelete_594036; clusterName: string;
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
  var path_594046 = newJObject()
  var query_594047 = newJObject()
  add(path_594046, "clusterName", newJString(clusterName))
  add(path_594046, "resourceGroupName", newJString(resourceGroupName))
  add(query_594047, "api-version", newJString(apiVersion))
  add(path_594046, "applicationTypeName", newJString(applicationTypeName))
  add(path_594046, "subscriptionId", newJString(subscriptionId))
  result = call_594045.call(path_594046, query_594047, nil, nil, nil)

var applicationTypesDelete* = Call_ApplicationTypesDelete_594036(
    name: "applicationTypesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}",
    validator: validate_ApplicationTypesDelete_594037, base: "",
    url: url_ApplicationTypesDelete_594038, schemes: {Scheme.Https})
type
  Call_ApplicationTypeVersionsList_594048 = ref object of OpenApiRestCall_593437
proc url_ApplicationTypeVersionsList_594050(protocol: Scheme; host: string;
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

proc validate_ApplicationTypeVersionsList_594049(path: JsonNode; query: JsonNode;
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
  var valid_594051 = path.getOrDefault("clusterName")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "clusterName", valid_594051
  var valid_594052 = path.getOrDefault("resourceGroupName")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "resourceGroupName", valid_594052
  var valid_594053 = path.getOrDefault("applicationTypeName")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "applicationTypeName", valid_594053
  var valid_594054 = path.getOrDefault("subscriptionId")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "subscriptionId", valid_594054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594055 = query.getOrDefault("api-version")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_594055 != nil:
    section.add "api-version", valid_594055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594056: Call_ApplicationTypeVersionsList_594048; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all application type version resources created or in the process of being created in the Service Fabric application type name resource.
  ## 
  let valid = call_594056.validator(path, query, header, formData, body)
  let scheme = call_594056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594056.url(scheme.get, call_594056.host, call_594056.base,
                         call_594056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594056, url, valid)

proc call*(call_594057: Call_ApplicationTypeVersionsList_594048;
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
  var path_594058 = newJObject()
  var query_594059 = newJObject()
  add(path_594058, "clusterName", newJString(clusterName))
  add(path_594058, "resourceGroupName", newJString(resourceGroupName))
  add(query_594059, "api-version", newJString(apiVersion))
  add(path_594058, "applicationTypeName", newJString(applicationTypeName))
  add(path_594058, "subscriptionId", newJString(subscriptionId))
  result = call_594057.call(path_594058, query_594059, nil, nil, nil)

var applicationTypeVersionsList* = Call_ApplicationTypeVersionsList_594048(
    name: "applicationTypeVersionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}/versions",
    validator: validate_ApplicationTypeVersionsList_594049, base: "",
    url: url_ApplicationTypeVersionsList_594050, schemes: {Scheme.Https})
type
  Call_ApplicationTypeVersionsCreate_594073 = ref object of OpenApiRestCall_593437
proc url_ApplicationTypeVersionsCreate_594075(protocol: Scheme; host: string;
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

proc validate_ApplicationTypeVersionsCreate_594074(path: JsonNode; query: JsonNode;
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
  var valid_594076 = path.getOrDefault("clusterName")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "clusterName", valid_594076
  var valid_594077 = path.getOrDefault("resourceGroupName")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "resourceGroupName", valid_594077
  var valid_594078 = path.getOrDefault("applicationTypeName")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "applicationTypeName", valid_594078
  var valid_594079 = path.getOrDefault("version")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "version", valid_594079
  var valid_594080 = path.getOrDefault("subscriptionId")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "subscriptionId", valid_594080
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594081 = query.getOrDefault("api-version")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_594081 != nil:
    section.add "api-version", valid_594081
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

proc call*(call_594083: Call_ApplicationTypeVersionsCreate_594073; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Service Fabric application type version resource with the specified name.
  ## 
  let valid = call_594083.validator(path, query, header, formData, body)
  let scheme = call_594083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594083.url(scheme.get, call_594083.host, call_594083.base,
                         call_594083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594083, url, valid)

proc call*(call_594084: Call_ApplicationTypeVersionsCreate_594073;
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
  var path_594085 = newJObject()
  var query_594086 = newJObject()
  var body_594087 = newJObject()
  add(path_594085, "clusterName", newJString(clusterName))
  add(path_594085, "resourceGroupName", newJString(resourceGroupName))
  add(query_594086, "api-version", newJString(apiVersion))
  add(path_594085, "applicationTypeName", newJString(applicationTypeName))
  add(path_594085, "version", newJString(version))
  add(path_594085, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594087 = parameters
  result = call_594084.call(path_594085, query_594086, nil, nil, body_594087)

var applicationTypeVersionsCreate* = Call_ApplicationTypeVersionsCreate_594073(
    name: "applicationTypeVersionsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}/versions/{version}",
    validator: validate_ApplicationTypeVersionsCreate_594074, base: "",
    url: url_ApplicationTypeVersionsCreate_594075, schemes: {Scheme.Https})
type
  Call_ApplicationTypeVersionsGet_594060 = ref object of OpenApiRestCall_593437
proc url_ApplicationTypeVersionsGet_594062(protocol: Scheme; host: string;
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

proc validate_ApplicationTypeVersionsGet_594061(path: JsonNode; query: JsonNode;
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
  var valid_594063 = path.getOrDefault("clusterName")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "clusterName", valid_594063
  var valid_594064 = path.getOrDefault("resourceGroupName")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "resourceGroupName", valid_594064
  var valid_594065 = path.getOrDefault("applicationTypeName")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "applicationTypeName", valid_594065
  var valid_594066 = path.getOrDefault("version")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "version", valid_594066
  var valid_594067 = path.getOrDefault("subscriptionId")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "subscriptionId", valid_594067
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594068 = query.getOrDefault("api-version")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_594068 != nil:
    section.add "api-version", valid_594068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594069: Call_ApplicationTypeVersionsGet_594060; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Service Fabric application type version resource created or in the process of being created in the Service Fabric application type name resource.
  ## 
  let valid = call_594069.validator(path, query, header, formData, body)
  let scheme = call_594069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594069.url(scheme.get, call_594069.host, call_594069.base,
                         call_594069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594069, url, valid)

proc call*(call_594070: Call_ApplicationTypeVersionsGet_594060;
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
  var path_594071 = newJObject()
  var query_594072 = newJObject()
  add(path_594071, "clusterName", newJString(clusterName))
  add(path_594071, "resourceGroupName", newJString(resourceGroupName))
  add(query_594072, "api-version", newJString(apiVersion))
  add(path_594071, "applicationTypeName", newJString(applicationTypeName))
  add(path_594071, "version", newJString(version))
  add(path_594071, "subscriptionId", newJString(subscriptionId))
  result = call_594070.call(path_594071, query_594072, nil, nil, nil)

var applicationTypeVersionsGet* = Call_ApplicationTypeVersionsGet_594060(
    name: "applicationTypeVersionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}/versions/{version}",
    validator: validate_ApplicationTypeVersionsGet_594061, base: "",
    url: url_ApplicationTypeVersionsGet_594062, schemes: {Scheme.Https})
type
  Call_ApplicationTypeVersionsDelete_594088 = ref object of OpenApiRestCall_593437
proc url_ApplicationTypeVersionsDelete_594090(protocol: Scheme; host: string;
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

proc validate_ApplicationTypeVersionsDelete_594089(path: JsonNode; query: JsonNode;
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
  var valid_594091 = path.getOrDefault("clusterName")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "clusterName", valid_594091
  var valid_594092 = path.getOrDefault("resourceGroupName")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "resourceGroupName", valid_594092
  var valid_594093 = path.getOrDefault("applicationTypeName")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "applicationTypeName", valid_594093
  var valid_594094 = path.getOrDefault("version")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "version", valid_594094
  var valid_594095 = path.getOrDefault("subscriptionId")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "subscriptionId", valid_594095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594096 = query.getOrDefault("api-version")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_594096 != nil:
    section.add "api-version", valid_594096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594097: Call_ApplicationTypeVersionsDelete_594088; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Service Fabric application type version resource with the specified name.
  ## 
  let valid = call_594097.validator(path, query, header, formData, body)
  let scheme = call_594097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594097.url(scheme.get, call_594097.host, call_594097.base,
                         call_594097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594097, url, valid)

proc call*(call_594098: Call_ApplicationTypeVersionsDelete_594088;
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
  var path_594099 = newJObject()
  var query_594100 = newJObject()
  add(path_594099, "clusterName", newJString(clusterName))
  add(path_594099, "resourceGroupName", newJString(resourceGroupName))
  add(query_594100, "api-version", newJString(apiVersion))
  add(path_594099, "applicationTypeName", newJString(applicationTypeName))
  add(path_594099, "version", newJString(version))
  add(path_594099, "subscriptionId", newJString(subscriptionId))
  result = call_594098.call(path_594099, query_594100, nil, nil, nil)

var applicationTypeVersionsDelete* = Call_ApplicationTypeVersionsDelete_594088(
    name: "applicationTypeVersionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applicationTypes/{applicationTypeName}/versions/{version}",
    validator: validate_ApplicationTypeVersionsDelete_594089, base: "",
    url: url_ApplicationTypeVersionsDelete_594090, schemes: {Scheme.Https})
type
  Call_ApplicationsList_594101 = ref object of OpenApiRestCall_593437
proc url_ApplicationsList_594103(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationsList_594102(path: JsonNode; query: JsonNode;
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
  var valid_594104 = path.getOrDefault("clusterName")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "clusterName", valid_594104
  var valid_594105 = path.getOrDefault("resourceGroupName")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "resourceGroupName", valid_594105
  var valid_594106 = path.getOrDefault("subscriptionId")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "subscriptionId", valid_594106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594107 = query.getOrDefault("api-version")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_594107 != nil:
    section.add "api-version", valid_594107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594108: Call_ApplicationsList_594101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all application resources created or in the process of being created in the Service Fabric cluster resource.
  ## 
  let valid = call_594108.validator(path, query, header, formData, body)
  let scheme = call_594108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594108.url(scheme.get, call_594108.host, call_594108.base,
                         call_594108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594108, url, valid)

proc call*(call_594109: Call_ApplicationsList_594101; clusterName: string;
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
  var path_594110 = newJObject()
  var query_594111 = newJObject()
  add(path_594110, "clusterName", newJString(clusterName))
  add(path_594110, "resourceGroupName", newJString(resourceGroupName))
  add(query_594111, "api-version", newJString(apiVersion))
  add(path_594110, "subscriptionId", newJString(subscriptionId))
  result = call_594109.call(path_594110, query_594111, nil, nil, nil)

var applicationsList* = Call_ApplicationsList_594101(name: "applicationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications",
    validator: validate_ApplicationsList_594102, base: "",
    url: url_ApplicationsList_594103, schemes: {Scheme.Https})
type
  Call_ApplicationsCreate_594124 = ref object of OpenApiRestCall_593437
proc url_ApplicationsCreate_594126(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationsCreate_594125(path: JsonNode; query: JsonNode;
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
  var valid_594127 = path.getOrDefault("clusterName")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "clusterName", valid_594127
  var valid_594128 = path.getOrDefault("resourceGroupName")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "resourceGroupName", valid_594128
  var valid_594129 = path.getOrDefault("applicationName")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "applicationName", valid_594129
  var valid_594130 = path.getOrDefault("subscriptionId")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "subscriptionId", valid_594130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594131 = query.getOrDefault("api-version")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_594131 != nil:
    section.add "api-version", valid_594131
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

proc call*(call_594133: Call_ApplicationsCreate_594124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Service Fabric application resource with the specified name.
  ## 
  let valid = call_594133.validator(path, query, header, formData, body)
  let scheme = call_594133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594133.url(scheme.get, call_594133.host, call_594133.base,
                         call_594133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594133, url, valid)

proc call*(call_594134: Call_ApplicationsCreate_594124; clusterName: string;
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
  var path_594135 = newJObject()
  var query_594136 = newJObject()
  var body_594137 = newJObject()
  add(path_594135, "clusterName", newJString(clusterName))
  add(path_594135, "resourceGroupName", newJString(resourceGroupName))
  add(path_594135, "applicationName", newJString(applicationName))
  add(query_594136, "api-version", newJString(apiVersion))
  add(path_594135, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594137 = parameters
  result = call_594134.call(path_594135, query_594136, nil, nil, body_594137)

var applicationsCreate* = Call_ApplicationsCreate_594124(
    name: "applicationsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}",
    validator: validate_ApplicationsCreate_594125, base: "",
    url: url_ApplicationsCreate_594126, schemes: {Scheme.Https})
type
  Call_ApplicationsGet_594112 = ref object of OpenApiRestCall_593437
proc url_ApplicationsGet_594114(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationsGet_594113(path: JsonNode; query: JsonNode;
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
  var valid_594115 = path.getOrDefault("clusterName")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "clusterName", valid_594115
  var valid_594116 = path.getOrDefault("resourceGroupName")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "resourceGroupName", valid_594116
  var valid_594117 = path.getOrDefault("applicationName")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "applicationName", valid_594117
  var valid_594118 = path.getOrDefault("subscriptionId")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "subscriptionId", valid_594118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594119 = query.getOrDefault("api-version")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_594119 != nil:
    section.add "api-version", valid_594119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594120: Call_ApplicationsGet_594112; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Service Fabric application resource created or in the process of being created in the Service Fabric cluster resource.
  ## 
  let valid = call_594120.validator(path, query, header, formData, body)
  let scheme = call_594120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594120.url(scheme.get, call_594120.host, call_594120.base,
                         call_594120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594120, url, valid)

proc call*(call_594121: Call_ApplicationsGet_594112; clusterName: string;
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
  var path_594122 = newJObject()
  var query_594123 = newJObject()
  add(path_594122, "clusterName", newJString(clusterName))
  add(path_594122, "resourceGroupName", newJString(resourceGroupName))
  add(path_594122, "applicationName", newJString(applicationName))
  add(query_594123, "api-version", newJString(apiVersion))
  add(path_594122, "subscriptionId", newJString(subscriptionId))
  result = call_594121.call(path_594122, query_594123, nil, nil, nil)

var applicationsGet* = Call_ApplicationsGet_594112(name: "applicationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}",
    validator: validate_ApplicationsGet_594113, base: "", url: url_ApplicationsGet_594114,
    schemes: {Scheme.Https})
type
  Call_ApplicationsUpdate_594150 = ref object of OpenApiRestCall_593437
proc url_ApplicationsUpdate_594152(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationsUpdate_594151(path: JsonNode; query: JsonNode;
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
  var valid_594153 = path.getOrDefault("clusterName")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "clusterName", valid_594153
  var valid_594154 = path.getOrDefault("resourceGroupName")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "resourceGroupName", valid_594154
  var valid_594155 = path.getOrDefault("applicationName")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "applicationName", valid_594155
  var valid_594156 = path.getOrDefault("subscriptionId")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "subscriptionId", valid_594156
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594157 = query.getOrDefault("api-version")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_594157 != nil:
    section.add "api-version", valid_594157
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

proc call*(call_594159: Call_ApplicationsUpdate_594150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a Service Fabric application resource with the specified name.
  ## 
  let valid = call_594159.validator(path, query, header, formData, body)
  let scheme = call_594159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594159.url(scheme.get, call_594159.host, call_594159.base,
                         call_594159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594159, url, valid)

proc call*(call_594160: Call_ApplicationsUpdate_594150; clusterName: string;
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
  var path_594161 = newJObject()
  var query_594162 = newJObject()
  var body_594163 = newJObject()
  add(path_594161, "clusterName", newJString(clusterName))
  add(path_594161, "resourceGroupName", newJString(resourceGroupName))
  add(path_594161, "applicationName", newJString(applicationName))
  add(query_594162, "api-version", newJString(apiVersion))
  add(path_594161, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594163 = parameters
  result = call_594160.call(path_594161, query_594162, nil, nil, body_594163)

var applicationsUpdate* = Call_ApplicationsUpdate_594150(
    name: "applicationsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}",
    validator: validate_ApplicationsUpdate_594151, base: "",
    url: url_ApplicationsUpdate_594152, schemes: {Scheme.Https})
type
  Call_ApplicationsDelete_594138 = ref object of OpenApiRestCall_593437
proc url_ApplicationsDelete_594140(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationsDelete_594139(path: JsonNode; query: JsonNode;
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
  var valid_594141 = path.getOrDefault("clusterName")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "clusterName", valid_594141
  var valid_594142 = path.getOrDefault("resourceGroupName")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "resourceGroupName", valid_594142
  var valid_594143 = path.getOrDefault("applicationName")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "applicationName", valid_594143
  var valid_594144 = path.getOrDefault("subscriptionId")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "subscriptionId", valid_594144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594145 = query.getOrDefault("api-version")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_594145 != nil:
    section.add "api-version", valid_594145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594146: Call_ApplicationsDelete_594138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Service Fabric application resource with the specified name.
  ## 
  let valid = call_594146.validator(path, query, header, formData, body)
  let scheme = call_594146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594146.url(scheme.get, call_594146.host, call_594146.base,
                         call_594146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594146, url, valid)

proc call*(call_594147: Call_ApplicationsDelete_594138; clusterName: string;
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
  var path_594148 = newJObject()
  var query_594149 = newJObject()
  add(path_594148, "clusterName", newJString(clusterName))
  add(path_594148, "resourceGroupName", newJString(resourceGroupName))
  add(path_594148, "applicationName", newJString(applicationName))
  add(query_594149, "api-version", newJString(apiVersion))
  add(path_594148, "subscriptionId", newJString(subscriptionId))
  result = call_594147.call(path_594148, query_594149, nil, nil, nil)

var applicationsDelete* = Call_ApplicationsDelete_594138(
    name: "applicationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}",
    validator: validate_ApplicationsDelete_594139, base: "",
    url: url_ApplicationsDelete_594140, schemes: {Scheme.Https})
type
  Call_ServicesList_594164 = ref object of OpenApiRestCall_593437
proc url_ServicesList_594166(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesList_594165(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594167 = path.getOrDefault("clusterName")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "clusterName", valid_594167
  var valid_594168 = path.getOrDefault("resourceGroupName")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "resourceGroupName", valid_594168
  var valid_594169 = path.getOrDefault("applicationName")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "applicationName", valid_594169
  var valid_594170 = path.getOrDefault("subscriptionId")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "subscriptionId", valid_594170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594171 = query.getOrDefault("api-version")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_594171 != nil:
    section.add "api-version", valid_594171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594172: Call_ServicesList_594164; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all service resources created or in the process of being created in the Service Fabric application resource.
  ## 
  let valid = call_594172.validator(path, query, header, formData, body)
  let scheme = call_594172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594172.url(scheme.get, call_594172.host, call_594172.base,
                         call_594172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594172, url, valid)

proc call*(call_594173: Call_ServicesList_594164; clusterName: string;
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
  var path_594174 = newJObject()
  var query_594175 = newJObject()
  add(path_594174, "clusterName", newJString(clusterName))
  add(path_594174, "resourceGroupName", newJString(resourceGroupName))
  add(path_594174, "applicationName", newJString(applicationName))
  add(query_594175, "api-version", newJString(apiVersion))
  add(path_594174, "subscriptionId", newJString(subscriptionId))
  result = call_594173.call(path_594174, query_594175, nil, nil, nil)

var servicesList* = Call_ServicesList_594164(name: "servicesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}/services",
    validator: validate_ServicesList_594165, base: "", url: url_ServicesList_594166,
    schemes: {Scheme.Https})
type
  Call_ServicesCreate_594189 = ref object of OpenApiRestCall_593437
proc url_ServicesCreate_594191(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesCreate_594190(path: JsonNode; query: JsonNode;
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
  var valid_594192 = path.getOrDefault("clusterName")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "clusterName", valid_594192
  var valid_594193 = path.getOrDefault("resourceGroupName")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "resourceGroupName", valid_594193
  var valid_594194 = path.getOrDefault("applicationName")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "applicationName", valid_594194
  var valid_594195 = path.getOrDefault("subscriptionId")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "subscriptionId", valid_594195
  var valid_594196 = path.getOrDefault("serviceName")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = nil)
  if valid_594196 != nil:
    section.add "serviceName", valid_594196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594197 = query.getOrDefault("api-version")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_594197 != nil:
    section.add "api-version", valid_594197
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

proc call*(call_594199: Call_ServicesCreate_594189; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Service Fabric service resource with the specified name.
  ## 
  let valid = call_594199.validator(path, query, header, formData, body)
  let scheme = call_594199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594199.url(scheme.get, call_594199.host, call_594199.base,
                         call_594199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594199, url, valid)

proc call*(call_594200: Call_ServicesCreate_594189; clusterName: string;
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
  var path_594201 = newJObject()
  var query_594202 = newJObject()
  var body_594203 = newJObject()
  add(path_594201, "clusterName", newJString(clusterName))
  add(path_594201, "resourceGroupName", newJString(resourceGroupName))
  add(path_594201, "applicationName", newJString(applicationName))
  add(query_594202, "api-version", newJString(apiVersion))
  add(path_594201, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594203 = parameters
  add(path_594201, "serviceName", newJString(serviceName))
  result = call_594200.call(path_594201, query_594202, nil, nil, body_594203)

var servicesCreate* = Call_ServicesCreate_594189(name: "servicesCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}/services/{serviceName}",
    validator: validate_ServicesCreate_594190, base: "", url: url_ServicesCreate_594191,
    schemes: {Scheme.Https})
type
  Call_ServicesGet_594176 = ref object of OpenApiRestCall_593437
proc url_ServicesGet_594178(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesGet_594177(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594179 = path.getOrDefault("clusterName")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "clusterName", valid_594179
  var valid_594180 = path.getOrDefault("resourceGroupName")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "resourceGroupName", valid_594180
  var valid_594181 = path.getOrDefault("applicationName")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "applicationName", valid_594181
  var valid_594182 = path.getOrDefault("subscriptionId")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "subscriptionId", valid_594182
  var valid_594183 = path.getOrDefault("serviceName")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "serviceName", valid_594183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594184 = query.getOrDefault("api-version")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_594184 != nil:
    section.add "api-version", valid_594184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594185: Call_ServicesGet_594176; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Service Fabric service resource created or in the process of being created in the Service Fabric application resource.
  ## 
  let valid = call_594185.validator(path, query, header, formData, body)
  let scheme = call_594185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594185.url(scheme.get, call_594185.host, call_594185.base,
                         call_594185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594185, url, valid)

proc call*(call_594186: Call_ServicesGet_594176; clusterName: string;
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
  var path_594187 = newJObject()
  var query_594188 = newJObject()
  add(path_594187, "clusterName", newJString(clusterName))
  add(path_594187, "resourceGroupName", newJString(resourceGroupName))
  add(path_594187, "applicationName", newJString(applicationName))
  add(query_594188, "api-version", newJString(apiVersion))
  add(path_594187, "subscriptionId", newJString(subscriptionId))
  add(path_594187, "serviceName", newJString(serviceName))
  result = call_594186.call(path_594187, query_594188, nil, nil, nil)

var servicesGet* = Call_ServicesGet_594176(name: "servicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}/services/{serviceName}",
                                        validator: validate_ServicesGet_594177,
                                        base: "", url: url_ServicesGet_594178,
                                        schemes: {Scheme.Https})
type
  Call_ServicesUpdate_594217 = ref object of OpenApiRestCall_593437
proc url_ServicesUpdate_594219(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesUpdate_594218(path: JsonNode; query: JsonNode;
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
  var valid_594220 = path.getOrDefault("clusterName")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "clusterName", valid_594220
  var valid_594221 = path.getOrDefault("resourceGroupName")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "resourceGroupName", valid_594221
  var valid_594222 = path.getOrDefault("applicationName")
  valid_594222 = validateParameter(valid_594222, JString, required = true,
                                 default = nil)
  if valid_594222 != nil:
    section.add "applicationName", valid_594222
  var valid_594223 = path.getOrDefault("subscriptionId")
  valid_594223 = validateParameter(valid_594223, JString, required = true,
                                 default = nil)
  if valid_594223 != nil:
    section.add "subscriptionId", valid_594223
  var valid_594224 = path.getOrDefault("serviceName")
  valid_594224 = validateParameter(valid_594224, JString, required = true,
                                 default = nil)
  if valid_594224 != nil:
    section.add "serviceName", valid_594224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594225 = query.getOrDefault("api-version")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_594225 != nil:
    section.add "api-version", valid_594225
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

proc call*(call_594227: Call_ServicesUpdate_594217; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a Service Fabric service resource with the specified name.
  ## 
  let valid = call_594227.validator(path, query, header, formData, body)
  let scheme = call_594227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594227.url(scheme.get, call_594227.host, call_594227.base,
                         call_594227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594227, url, valid)

proc call*(call_594228: Call_ServicesUpdate_594217; clusterName: string;
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
  var path_594229 = newJObject()
  var query_594230 = newJObject()
  var body_594231 = newJObject()
  add(path_594229, "clusterName", newJString(clusterName))
  add(path_594229, "resourceGroupName", newJString(resourceGroupName))
  add(path_594229, "applicationName", newJString(applicationName))
  add(query_594230, "api-version", newJString(apiVersion))
  add(path_594229, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594231 = parameters
  add(path_594229, "serviceName", newJString(serviceName))
  result = call_594228.call(path_594229, query_594230, nil, nil, body_594231)

var servicesUpdate* = Call_ServicesUpdate_594217(name: "servicesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}/services/{serviceName}",
    validator: validate_ServicesUpdate_594218, base: "", url: url_ServicesUpdate_594219,
    schemes: {Scheme.Https})
type
  Call_ServicesDelete_594204 = ref object of OpenApiRestCall_593437
proc url_ServicesDelete_594206(protocol: Scheme; host: string; base: string;
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

proc validate_ServicesDelete_594205(path: JsonNode; query: JsonNode;
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
  var valid_594207 = path.getOrDefault("clusterName")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "clusterName", valid_594207
  var valid_594208 = path.getOrDefault("resourceGroupName")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "resourceGroupName", valid_594208
  var valid_594209 = path.getOrDefault("applicationName")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "applicationName", valid_594209
  var valid_594210 = path.getOrDefault("subscriptionId")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "subscriptionId", valid_594210
  var valid_594211 = path.getOrDefault("serviceName")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "serviceName", valid_594211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594212 = query.getOrDefault("api-version")
  valid_594212 = validateParameter(valid_594212, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_594212 != nil:
    section.add "api-version", valid_594212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594213: Call_ServicesDelete_594204; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Service Fabric service resource with the specified name.
  ## 
  let valid = call_594213.validator(path, query, header, formData, body)
  let scheme = call_594213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594213.url(scheme.get, call_594213.host, call_594213.base,
                         call_594213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594213, url, valid)

proc call*(call_594214: Call_ServicesDelete_594204; clusterName: string;
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
  var path_594215 = newJObject()
  var query_594216 = newJObject()
  add(path_594215, "clusterName", newJString(clusterName))
  add(path_594215, "resourceGroupName", newJString(resourceGroupName))
  add(path_594215, "applicationName", newJString(applicationName))
  add(query_594216, "api-version", newJString(apiVersion))
  add(path_594215, "subscriptionId", newJString(subscriptionId))
  add(path_594215, "serviceName", newJString(serviceName))
  result = call_594214.call(path_594215, query_594216, nil, nil, nil)

var servicesDelete* = Call_ServicesDelete_594204(name: "servicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}/applications/{applicationName}/services/{serviceName}",
    validator: validate_ServicesDelete_594205, base: "", url: url_ServicesDelete_594206,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
