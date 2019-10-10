
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on Property entity associated with your Azure API Management deployment. API Management policies are a powerful capability of the system that allow the publisher to change the behavior of the API through configuration. Policies are a collection of statements that are executed sequentially on the request or response of an API. Policy statements can be constructed using literal text values, policy expressions, and properties. Each API Management service instance has a properties collection of key/value pairs that are global to the service instance. These properties can be used to manage constant string values across all API configuration and policies.
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
  macServiceName = "apimanagement-apimproperties"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PropertyListByService_573879 = ref object of OpenApiRestCall_573657
proc url_PropertyListByService_573881(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/properties")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PropertyListByService_573880(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of properties defined within a service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-properties
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574042 = path.getOrDefault("resourceGroupName")
  valid_574042 = validateParameter(valid_574042, JString, required = true,
                                 default = nil)
  if valid_574042 != nil:
    section.add "resourceGroupName", valid_574042
  var valid_574043 = path.getOrDefault("subscriptionId")
  valid_574043 = validateParameter(valid_574043, JString, required = true,
                                 default = nil)
  if valid_574043 != nil:
    section.add "subscriptionId", valid_574043
  var valid_574044 = path.getOrDefault("serviceName")
  valid_574044 = validateParameter(valid_574044, JString, required = true,
                                 default = nil)
  if valid_574044 != nil:
    section.add "serviceName", valid_574044
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field | Supported operators    | Supported functions                                   |
  ## 
  ## |-------|------------------------|-------------------------------------------------------|
  ## | tags  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith, any, all |
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith           |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574045 = query.getOrDefault("api-version")
  valid_574045 = validateParameter(valid_574045, JString, required = true,
                                 default = nil)
  if valid_574045 != nil:
    section.add "api-version", valid_574045
  var valid_574046 = query.getOrDefault("$top")
  valid_574046 = validateParameter(valid_574046, JInt, required = false, default = nil)
  if valid_574046 != nil:
    section.add "$top", valid_574046
  var valid_574047 = query.getOrDefault("$skip")
  valid_574047 = validateParameter(valid_574047, JInt, required = false, default = nil)
  if valid_574047 != nil:
    section.add "$skip", valid_574047
  var valid_574048 = query.getOrDefault("$filter")
  valid_574048 = validateParameter(valid_574048, JString, required = false,
                                 default = nil)
  if valid_574048 != nil:
    section.add "$filter", valid_574048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574075: Call_PropertyListByService_573879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of properties defined within a service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-properties
  let valid = call_574075.validator(path, query, header, formData, body)
  let scheme = call_574075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574075.url(scheme.get, call_574075.host, call_574075.base,
                         call_574075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574075, url, valid)

proc call*(call_574146: Call_PropertyListByService_573879;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## propertyListByService
  ## Lists a collection of properties defined within a service instance.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-properties
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field | Supported operators    | Supported functions                                   |
  ## 
  ## |-------|------------------------|-------------------------------------------------------|
  ## | tags  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith, any, all |
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith           |
  var path_574147 = newJObject()
  var query_574149 = newJObject()
  add(path_574147, "resourceGroupName", newJString(resourceGroupName))
  add(query_574149, "api-version", newJString(apiVersion))
  add(path_574147, "subscriptionId", newJString(subscriptionId))
  add(query_574149, "$top", newJInt(Top))
  add(query_574149, "$skip", newJInt(Skip))
  add(path_574147, "serviceName", newJString(serviceName))
  add(query_574149, "$filter", newJString(Filter))
  result = call_574146.call(path_574147, query_574149, nil, nil, nil)

var propertyListByService* = Call_PropertyListByService_573879(
    name: "propertyListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/properties",
    validator: validate_PropertyListByService_573880, base: "",
    url: url_PropertyListByService_573881, schemes: {Scheme.Https})
type
  Call_PropertyCreateOrUpdate_574209 = ref object of OpenApiRestCall_573657
proc url_PropertyCreateOrUpdate_574211(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "propId" in path, "`propId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/properties/"),
               (kind: VariableSegment, value: "propId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PropertyCreateOrUpdate_574210(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   propId: JString (required)
  ##         : Identifier of the property.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574229 = path.getOrDefault("resourceGroupName")
  valid_574229 = validateParameter(valid_574229, JString, required = true,
                                 default = nil)
  if valid_574229 != nil:
    section.add "resourceGroupName", valid_574229
  var valid_574230 = path.getOrDefault("subscriptionId")
  valid_574230 = validateParameter(valid_574230, JString, required = true,
                                 default = nil)
  if valid_574230 != nil:
    section.add "subscriptionId", valid_574230
  var valid_574231 = path.getOrDefault("propId")
  valid_574231 = validateParameter(valid_574231, JString, required = true,
                                 default = nil)
  if valid_574231 != nil:
    section.add "propId", valid_574231
  var valid_574232 = path.getOrDefault("serviceName")
  valid_574232 = validateParameter(valid_574232, JString, required = true,
                                 default = nil)
  if valid_574232 != nil:
    section.add "serviceName", valid_574232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574233 = query.getOrDefault("api-version")
  valid_574233 = validateParameter(valid_574233, JString, required = true,
                                 default = nil)
  if valid_574233 != nil:
    section.add "api-version", valid_574233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574235: Call_PropertyCreateOrUpdate_574209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a property.
  ## 
  let valid = call_574235.validator(path, query, header, formData, body)
  let scheme = call_574235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574235.url(scheme.get, call_574235.host, call_574235.base,
                         call_574235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574235, url, valid)

proc call*(call_574236: Call_PropertyCreateOrUpdate_574209;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          propId: string; parameters: JsonNode; serviceName: string): Recallable =
  ## propertyCreateOrUpdate
  ## Creates or updates a property.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   propId: string (required)
  ##         : Identifier of the property.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_574237 = newJObject()
  var query_574238 = newJObject()
  var body_574239 = newJObject()
  add(path_574237, "resourceGroupName", newJString(resourceGroupName))
  add(query_574238, "api-version", newJString(apiVersion))
  add(path_574237, "subscriptionId", newJString(subscriptionId))
  add(path_574237, "propId", newJString(propId))
  if parameters != nil:
    body_574239 = parameters
  add(path_574237, "serviceName", newJString(serviceName))
  result = call_574236.call(path_574237, query_574238, nil, nil, body_574239)

var propertyCreateOrUpdate* = Call_PropertyCreateOrUpdate_574209(
    name: "propertyCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/properties/{propId}",
    validator: validate_PropertyCreateOrUpdate_574210, base: "",
    url: url_PropertyCreateOrUpdate_574211, schemes: {Scheme.Https})
type
  Call_PropertyGetEntityTag_574253 = ref object of OpenApiRestCall_573657
proc url_PropertyGetEntityTag_574255(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "propId" in path, "`propId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/properties/"),
               (kind: VariableSegment, value: "propId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PropertyGetEntityTag_574254(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the property specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   propId: JString (required)
  ##         : Identifier of the property.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574256 = path.getOrDefault("resourceGroupName")
  valid_574256 = validateParameter(valid_574256, JString, required = true,
                                 default = nil)
  if valid_574256 != nil:
    section.add "resourceGroupName", valid_574256
  var valid_574257 = path.getOrDefault("subscriptionId")
  valid_574257 = validateParameter(valid_574257, JString, required = true,
                                 default = nil)
  if valid_574257 != nil:
    section.add "subscriptionId", valid_574257
  var valid_574258 = path.getOrDefault("propId")
  valid_574258 = validateParameter(valid_574258, JString, required = true,
                                 default = nil)
  if valid_574258 != nil:
    section.add "propId", valid_574258
  var valid_574259 = path.getOrDefault("serviceName")
  valid_574259 = validateParameter(valid_574259, JString, required = true,
                                 default = nil)
  if valid_574259 != nil:
    section.add "serviceName", valid_574259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574260 = query.getOrDefault("api-version")
  valid_574260 = validateParameter(valid_574260, JString, required = true,
                                 default = nil)
  if valid_574260 != nil:
    section.add "api-version", valid_574260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574261: Call_PropertyGetEntityTag_574253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the property specified by its identifier.
  ## 
  let valid = call_574261.validator(path, query, header, formData, body)
  let scheme = call_574261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574261.url(scheme.get, call_574261.host, call_574261.base,
                         call_574261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574261, url, valid)

proc call*(call_574262: Call_PropertyGetEntityTag_574253;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          propId: string; serviceName: string): Recallable =
  ## propertyGetEntityTag
  ## Gets the entity state (Etag) version of the property specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   propId: string (required)
  ##         : Identifier of the property.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_574263 = newJObject()
  var query_574264 = newJObject()
  add(path_574263, "resourceGroupName", newJString(resourceGroupName))
  add(query_574264, "api-version", newJString(apiVersion))
  add(path_574263, "subscriptionId", newJString(subscriptionId))
  add(path_574263, "propId", newJString(propId))
  add(path_574263, "serviceName", newJString(serviceName))
  result = call_574262.call(path_574263, query_574264, nil, nil, nil)

var propertyGetEntityTag* = Call_PropertyGetEntityTag_574253(
    name: "propertyGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/properties/{propId}",
    validator: validate_PropertyGetEntityTag_574254, base: "",
    url: url_PropertyGetEntityTag_574255, schemes: {Scheme.Https})
type
  Call_PropertyGet_574188 = ref object of OpenApiRestCall_573657
proc url_PropertyGet_574190(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "propId" in path, "`propId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/properties/"),
               (kind: VariableSegment, value: "propId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PropertyGet_574189(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the property specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   propId: JString (required)
  ##         : Identifier of the property.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574200 = path.getOrDefault("resourceGroupName")
  valid_574200 = validateParameter(valid_574200, JString, required = true,
                                 default = nil)
  if valid_574200 != nil:
    section.add "resourceGroupName", valid_574200
  var valid_574201 = path.getOrDefault("subscriptionId")
  valid_574201 = validateParameter(valid_574201, JString, required = true,
                                 default = nil)
  if valid_574201 != nil:
    section.add "subscriptionId", valid_574201
  var valid_574202 = path.getOrDefault("propId")
  valid_574202 = validateParameter(valid_574202, JString, required = true,
                                 default = nil)
  if valid_574202 != nil:
    section.add "propId", valid_574202
  var valid_574203 = path.getOrDefault("serviceName")
  valid_574203 = validateParameter(valid_574203, JString, required = true,
                                 default = nil)
  if valid_574203 != nil:
    section.add "serviceName", valid_574203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574204 = query.getOrDefault("api-version")
  valid_574204 = validateParameter(valid_574204, JString, required = true,
                                 default = nil)
  if valid_574204 != nil:
    section.add "api-version", valid_574204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574205: Call_PropertyGet_574188; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the property specified by its identifier.
  ## 
  let valid = call_574205.validator(path, query, header, formData, body)
  let scheme = call_574205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574205.url(scheme.get, call_574205.host, call_574205.base,
                         call_574205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574205, url, valid)

proc call*(call_574206: Call_PropertyGet_574188; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; propId: string;
          serviceName: string): Recallable =
  ## propertyGet
  ## Gets the details of the property specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   propId: string (required)
  ##         : Identifier of the property.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_574207 = newJObject()
  var query_574208 = newJObject()
  add(path_574207, "resourceGroupName", newJString(resourceGroupName))
  add(query_574208, "api-version", newJString(apiVersion))
  add(path_574207, "subscriptionId", newJString(subscriptionId))
  add(path_574207, "propId", newJString(propId))
  add(path_574207, "serviceName", newJString(serviceName))
  result = call_574206.call(path_574207, query_574208, nil, nil, nil)

var propertyGet* = Call_PropertyGet_574188(name: "propertyGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/properties/{propId}",
                                        validator: validate_PropertyGet_574189,
                                        base: "", url: url_PropertyGet_574190,
                                        schemes: {Scheme.Https})
type
  Call_PropertyUpdate_574265 = ref object of OpenApiRestCall_573657
proc url_PropertyUpdate_574267(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "propId" in path, "`propId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/properties/"),
               (kind: VariableSegment, value: "propId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PropertyUpdate_574266(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates the specific property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   propId: JString (required)
  ##         : Identifier of the property.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574268 = path.getOrDefault("resourceGroupName")
  valid_574268 = validateParameter(valid_574268, JString, required = true,
                                 default = nil)
  if valid_574268 != nil:
    section.add "resourceGroupName", valid_574268
  var valid_574269 = path.getOrDefault("subscriptionId")
  valid_574269 = validateParameter(valid_574269, JString, required = true,
                                 default = nil)
  if valid_574269 != nil:
    section.add "subscriptionId", valid_574269
  var valid_574270 = path.getOrDefault("propId")
  valid_574270 = validateParameter(valid_574270, JString, required = true,
                                 default = nil)
  if valid_574270 != nil:
    section.add "propId", valid_574270
  var valid_574271 = path.getOrDefault("serviceName")
  valid_574271 = validateParameter(valid_574271, JString, required = true,
                                 default = nil)
  if valid_574271 != nil:
    section.add "serviceName", valid_574271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574272 = query.getOrDefault("api-version")
  valid_574272 = validateParameter(valid_574272, JString, required = true,
                                 default = nil)
  if valid_574272 != nil:
    section.add "api-version", valid_574272
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the property to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_574273 = header.getOrDefault("If-Match")
  valid_574273 = validateParameter(valid_574273, JString, required = true,
                                 default = nil)
  if valid_574273 != nil:
    section.add "If-Match", valid_574273
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574275: Call_PropertyUpdate_574265; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specific property.
  ## 
  let valid = call_574275.validator(path, query, header, formData, body)
  let scheme = call_574275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574275.url(scheme.get, call_574275.host, call_574275.base,
                         call_574275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574275, url, valid)

proc call*(call_574276: Call_PropertyUpdate_574265; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; propId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## propertyUpdate
  ## Updates the specific property.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   propId: string (required)
  ##         : Identifier of the property.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_574277 = newJObject()
  var query_574278 = newJObject()
  var body_574279 = newJObject()
  add(path_574277, "resourceGroupName", newJString(resourceGroupName))
  add(query_574278, "api-version", newJString(apiVersion))
  add(path_574277, "subscriptionId", newJString(subscriptionId))
  add(path_574277, "propId", newJString(propId))
  if parameters != nil:
    body_574279 = parameters
  add(path_574277, "serviceName", newJString(serviceName))
  result = call_574276.call(path_574277, query_574278, nil, nil, body_574279)

var propertyUpdate* = Call_PropertyUpdate_574265(name: "propertyUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/properties/{propId}",
    validator: validate_PropertyUpdate_574266, base: "", url: url_PropertyUpdate_574267,
    schemes: {Scheme.Https})
type
  Call_PropertyDelete_574240 = ref object of OpenApiRestCall_573657
proc url_PropertyDelete_574242(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "propId" in path, "`propId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/properties/"),
               (kind: VariableSegment, value: "propId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PropertyDelete_574241(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes specific property from the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   propId: JString (required)
  ##         : Identifier of the property.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574243 = path.getOrDefault("resourceGroupName")
  valid_574243 = validateParameter(valid_574243, JString, required = true,
                                 default = nil)
  if valid_574243 != nil:
    section.add "resourceGroupName", valid_574243
  var valid_574244 = path.getOrDefault("subscriptionId")
  valid_574244 = validateParameter(valid_574244, JString, required = true,
                                 default = nil)
  if valid_574244 != nil:
    section.add "subscriptionId", valid_574244
  var valid_574245 = path.getOrDefault("propId")
  valid_574245 = validateParameter(valid_574245, JString, required = true,
                                 default = nil)
  if valid_574245 != nil:
    section.add "propId", valid_574245
  var valid_574246 = path.getOrDefault("serviceName")
  valid_574246 = validateParameter(valid_574246, JString, required = true,
                                 default = nil)
  if valid_574246 != nil:
    section.add "serviceName", valid_574246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574247 = query.getOrDefault("api-version")
  valid_574247 = validateParameter(valid_574247, JString, required = true,
                                 default = nil)
  if valid_574247 != nil:
    section.add "api-version", valid_574247
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the property to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_574248 = header.getOrDefault("If-Match")
  valid_574248 = validateParameter(valid_574248, JString, required = true,
                                 default = nil)
  if valid_574248 != nil:
    section.add "If-Match", valid_574248
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574249: Call_PropertyDelete_574240; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specific property from the API Management service instance.
  ## 
  let valid = call_574249.validator(path, query, header, formData, body)
  let scheme = call_574249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574249.url(scheme.get, call_574249.host, call_574249.base,
                         call_574249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574249, url, valid)

proc call*(call_574250: Call_PropertyDelete_574240; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; propId: string;
          serviceName: string): Recallable =
  ## propertyDelete
  ## Deletes specific property from the API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   propId: string (required)
  ##         : Identifier of the property.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_574251 = newJObject()
  var query_574252 = newJObject()
  add(path_574251, "resourceGroupName", newJString(resourceGroupName))
  add(query_574252, "api-version", newJString(apiVersion))
  add(path_574251, "subscriptionId", newJString(subscriptionId))
  add(path_574251, "propId", newJString(propId))
  add(path_574251, "serviceName", newJString(serviceName))
  result = call_574250.call(path_574251, query_574252, nil, nil, nil)

var propertyDelete* = Call_PropertyDelete_574240(name: "propertyDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/properties/{propId}",
    validator: validate_PropertyDelete_574241, base: "", url: url_PropertyDelete_574242,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
