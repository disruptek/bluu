
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2018-01-01
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

  OpenApiRestCall_596457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596457): Option[Scheme] {.used.} =
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
  Call_PropertyListByService_596679 = ref object of OpenApiRestCall_596457
proc url_PropertyListByService_596681(protocol: Scheme; host: string; base: string;
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

proc validate_PropertyListByService_596680(path: JsonNode; query: JsonNode;
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
  var valid_596842 = path.getOrDefault("resourceGroupName")
  valid_596842 = validateParameter(valid_596842, JString, required = true,
                                 default = nil)
  if valid_596842 != nil:
    section.add "resourceGroupName", valid_596842
  var valid_596843 = path.getOrDefault("subscriptionId")
  valid_596843 = validateParameter(valid_596843, JString, required = true,
                                 default = nil)
  if valid_596843 != nil:
    section.add "subscriptionId", valid_596843
  var valid_596844 = path.getOrDefault("serviceName")
  valid_596844 = validateParameter(valid_596844, JString, required = true,
                                 default = nil)
  if valid_596844 != nil:
    section.add "serviceName", valid_596844
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
  var valid_596845 = query.getOrDefault("api-version")
  valid_596845 = validateParameter(valid_596845, JString, required = true,
                                 default = nil)
  if valid_596845 != nil:
    section.add "api-version", valid_596845
  var valid_596846 = query.getOrDefault("$top")
  valid_596846 = validateParameter(valid_596846, JInt, required = false, default = nil)
  if valid_596846 != nil:
    section.add "$top", valid_596846
  var valid_596847 = query.getOrDefault("$skip")
  valid_596847 = validateParameter(valid_596847, JInt, required = false, default = nil)
  if valid_596847 != nil:
    section.add "$skip", valid_596847
  var valid_596848 = query.getOrDefault("$filter")
  valid_596848 = validateParameter(valid_596848, JString, required = false,
                                 default = nil)
  if valid_596848 != nil:
    section.add "$filter", valid_596848
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596875: Call_PropertyListByService_596679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of properties defined within a service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-properties
  let valid = call_596875.validator(path, query, header, formData, body)
  let scheme = call_596875.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596875.url(scheme.get, call_596875.host, call_596875.base,
                         call_596875.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596875, url, valid)

proc call*(call_596946: Call_PropertyListByService_596679;
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
  var path_596947 = newJObject()
  var query_596949 = newJObject()
  add(path_596947, "resourceGroupName", newJString(resourceGroupName))
  add(query_596949, "api-version", newJString(apiVersion))
  add(path_596947, "subscriptionId", newJString(subscriptionId))
  add(query_596949, "$top", newJInt(Top))
  add(query_596949, "$skip", newJInt(Skip))
  add(path_596947, "serviceName", newJString(serviceName))
  add(query_596949, "$filter", newJString(Filter))
  result = call_596946.call(path_596947, query_596949, nil, nil, nil)

var propertyListByService* = Call_PropertyListByService_596679(
    name: "propertyListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/properties",
    validator: validate_PropertyListByService_596680, base: "",
    url: url_PropertyListByService_596681, schemes: {Scheme.Https})
type
  Call_PropertyCreateOrUpdate_597009 = ref object of OpenApiRestCall_596457
proc url_PropertyCreateOrUpdate_597011(protocol: Scheme; host: string; base: string;
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

proc validate_PropertyCreateOrUpdate_597010(path: JsonNode; query: JsonNode;
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
  var valid_597029 = path.getOrDefault("resourceGroupName")
  valid_597029 = validateParameter(valid_597029, JString, required = true,
                                 default = nil)
  if valid_597029 != nil:
    section.add "resourceGroupName", valid_597029
  var valid_597030 = path.getOrDefault("subscriptionId")
  valid_597030 = validateParameter(valid_597030, JString, required = true,
                                 default = nil)
  if valid_597030 != nil:
    section.add "subscriptionId", valid_597030
  var valid_597031 = path.getOrDefault("propId")
  valid_597031 = validateParameter(valid_597031, JString, required = true,
                                 default = nil)
  if valid_597031 != nil:
    section.add "propId", valid_597031
  var valid_597032 = path.getOrDefault("serviceName")
  valid_597032 = validateParameter(valid_597032, JString, required = true,
                                 default = nil)
  if valid_597032 != nil:
    section.add "serviceName", valid_597032
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597033 = query.getOrDefault("api-version")
  valid_597033 = validateParameter(valid_597033, JString, required = true,
                                 default = nil)
  if valid_597033 != nil:
    section.add "api-version", valid_597033
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_597034 = header.getOrDefault("If-Match")
  valid_597034 = validateParameter(valid_597034, JString, required = false,
                                 default = nil)
  if valid_597034 != nil:
    section.add "If-Match", valid_597034
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

proc call*(call_597036: Call_PropertyCreateOrUpdate_597009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a property.
  ## 
  let valid = call_597036.validator(path, query, header, formData, body)
  let scheme = call_597036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597036.url(scheme.get, call_597036.host, call_597036.base,
                         call_597036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597036, url, valid)

proc call*(call_597037: Call_PropertyCreateOrUpdate_597009;
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
  var path_597038 = newJObject()
  var query_597039 = newJObject()
  var body_597040 = newJObject()
  add(path_597038, "resourceGroupName", newJString(resourceGroupName))
  add(query_597039, "api-version", newJString(apiVersion))
  add(path_597038, "subscriptionId", newJString(subscriptionId))
  add(path_597038, "propId", newJString(propId))
  if parameters != nil:
    body_597040 = parameters
  add(path_597038, "serviceName", newJString(serviceName))
  result = call_597037.call(path_597038, query_597039, nil, nil, body_597040)

var propertyCreateOrUpdate* = Call_PropertyCreateOrUpdate_597009(
    name: "propertyCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/properties/{propId}",
    validator: validate_PropertyCreateOrUpdate_597010, base: "",
    url: url_PropertyCreateOrUpdate_597011, schemes: {Scheme.Https})
type
  Call_PropertyGetEntityTag_597054 = ref object of OpenApiRestCall_596457
proc url_PropertyGetEntityTag_597056(protocol: Scheme; host: string; base: string;
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

proc validate_PropertyGetEntityTag_597055(path: JsonNode; query: JsonNode;
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
  var valid_597057 = path.getOrDefault("resourceGroupName")
  valid_597057 = validateParameter(valid_597057, JString, required = true,
                                 default = nil)
  if valid_597057 != nil:
    section.add "resourceGroupName", valid_597057
  var valid_597058 = path.getOrDefault("subscriptionId")
  valid_597058 = validateParameter(valid_597058, JString, required = true,
                                 default = nil)
  if valid_597058 != nil:
    section.add "subscriptionId", valid_597058
  var valid_597059 = path.getOrDefault("propId")
  valid_597059 = validateParameter(valid_597059, JString, required = true,
                                 default = nil)
  if valid_597059 != nil:
    section.add "propId", valid_597059
  var valid_597060 = path.getOrDefault("serviceName")
  valid_597060 = validateParameter(valid_597060, JString, required = true,
                                 default = nil)
  if valid_597060 != nil:
    section.add "serviceName", valid_597060
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597061 = query.getOrDefault("api-version")
  valid_597061 = validateParameter(valid_597061, JString, required = true,
                                 default = nil)
  if valid_597061 != nil:
    section.add "api-version", valid_597061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597062: Call_PropertyGetEntityTag_597054; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the property specified by its identifier.
  ## 
  let valid = call_597062.validator(path, query, header, formData, body)
  let scheme = call_597062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597062.url(scheme.get, call_597062.host, call_597062.base,
                         call_597062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597062, url, valid)

proc call*(call_597063: Call_PropertyGetEntityTag_597054;
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
  var path_597064 = newJObject()
  var query_597065 = newJObject()
  add(path_597064, "resourceGroupName", newJString(resourceGroupName))
  add(query_597065, "api-version", newJString(apiVersion))
  add(path_597064, "subscriptionId", newJString(subscriptionId))
  add(path_597064, "propId", newJString(propId))
  add(path_597064, "serviceName", newJString(serviceName))
  result = call_597063.call(path_597064, query_597065, nil, nil, nil)

var propertyGetEntityTag* = Call_PropertyGetEntityTag_597054(
    name: "propertyGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/properties/{propId}",
    validator: validate_PropertyGetEntityTag_597055, base: "",
    url: url_PropertyGetEntityTag_597056, schemes: {Scheme.Https})
type
  Call_PropertyGet_596988 = ref object of OpenApiRestCall_596457
proc url_PropertyGet_596990(protocol: Scheme; host: string; base: string;
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

proc validate_PropertyGet_596989(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_597000 = path.getOrDefault("resourceGroupName")
  valid_597000 = validateParameter(valid_597000, JString, required = true,
                                 default = nil)
  if valid_597000 != nil:
    section.add "resourceGroupName", valid_597000
  var valid_597001 = path.getOrDefault("subscriptionId")
  valid_597001 = validateParameter(valid_597001, JString, required = true,
                                 default = nil)
  if valid_597001 != nil:
    section.add "subscriptionId", valid_597001
  var valid_597002 = path.getOrDefault("propId")
  valid_597002 = validateParameter(valid_597002, JString, required = true,
                                 default = nil)
  if valid_597002 != nil:
    section.add "propId", valid_597002
  var valid_597003 = path.getOrDefault("serviceName")
  valid_597003 = validateParameter(valid_597003, JString, required = true,
                                 default = nil)
  if valid_597003 != nil:
    section.add "serviceName", valid_597003
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597004 = query.getOrDefault("api-version")
  valid_597004 = validateParameter(valid_597004, JString, required = true,
                                 default = nil)
  if valid_597004 != nil:
    section.add "api-version", valid_597004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597005: Call_PropertyGet_596988; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the property specified by its identifier.
  ## 
  let valid = call_597005.validator(path, query, header, formData, body)
  let scheme = call_597005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597005.url(scheme.get, call_597005.host, call_597005.base,
                         call_597005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597005, url, valid)

proc call*(call_597006: Call_PropertyGet_596988; resourceGroupName: string;
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
  var path_597007 = newJObject()
  var query_597008 = newJObject()
  add(path_597007, "resourceGroupName", newJString(resourceGroupName))
  add(query_597008, "api-version", newJString(apiVersion))
  add(path_597007, "subscriptionId", newJString(subscriptionId))
  add(path_597007, "propId", newJString(propId))
  add(path_597007, "serviceName", newJString(serviceName))
  result = call_597006.call(path_597007, query_597008, nil, nil, nil)

var propertyGet* = Call_PropertyGet_596988(name: "propertyGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/properties/{propId}",
                                        validator: validate_PropertyGet_596989,
                                        base: "", url: url_PropertyGet_596990,
                                        schemes: {Scheme.Https})
type
  Call_PropertyUpdate_597066 = ref object of OpenApiRestCall_596457
proc url_PropertyUpdate_597068(protocol: Scheme; host: string; base: string;
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

proc validate_PropertyUpdate_597067(path: JsonNode; query: JsonNode;
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
  var valid_597069 = path.getOrDefault("resourceGroupName")
  valid_597069 = validateParameter(valid_597069, JString, required = true,
                                 default = nil)
  if valid_597069 != nil:
    section.add "resourceGroupName", valid_597069
  var valid_597070 = path.getOrDefault("subscriptionId")
  valid_597070 = validateParameter(valid_597070, JString, required = true,
                                 default = nil)
  if valid_597070 != nil:
    section.add "subscriptionId", valid_597070
  var valid_597071 = path.getOrDefault("propId")
  valid_597071 = validateParameter(valid_597071, JString, required = true,
                                 default = nil)
  if valid_597071 != nil:
    section.add "propId", valid_597071
  var valid_597072 = path.getOrDefault("serviceName")
  valid_597072 = validateParameter(valid_597072, JString, required = true,
                                 default = nil)
  if valid_597072 != nil:
    section.add "serviceName", valid_597072
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597073 = query.getOrDefault("api-version")
  valid_597073 = validateParameter(valid_597073, JString, required = true,
                                 default = nil)
  if valid_597073 != nil:
    section.add "api-version", valid_597073
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597074 = header.getOrDefault("If-Match")
  valid_597074 = validateParameter(valid_597074, JString, required = true,
                                 default = nil)
  if valid_597074 != nil:
    section.add "If-Match", valid_597074
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

proc call*(call_597076: Call_PropertyUpdate_597066; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specific property.
  ## 
  let valid = call_597076.validator(path, query, header, formData, body)
  let scheme = call_597076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597076.url(scheme.get, call_597076.host, call_597076.base,
                         call_597076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597076, url, valid)

proc call*(call_597077: Call_PropertyUpdate_597066; resourceGroupName: string;
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
  var path_597078 = newJObject()
  var query_597079 = newJObject()
  var body_597080 = newJObject()
  add(path_597078, "resourceGroupName", newJString(resourceGroupName))
  add(query_597079, "api-version", newJString(apiVersion))
  add(path_597078, "subscriptionId", newJString(subscriptionId))
  add(path_597078, "propId", newJString(propId))
  if parameters != nil:
    body_597080 = parameters
  add(path_597078, "serviceName", newJString(serviceName))
  result = call_597077.call(path_597078, query_597079, nil, nil, body_597080)

var propertyUpdate* = Call_PropertyUpdate_597066(name: "propertyUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/properties/{propId}",
    validator: validate_PropertyUpdate_597067, base: "", url: url_PropertyUpdate_597068,
    schemes: {Scheme.Https})
type
  Call_PropertyDelete_597041 = ref object of OpenApiRestCall_596457
proc url_PropertyDelete_597043(protocol: Scheme; host: string; base: string;
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

proc validate_PropertyDelete_597042(path: JsonNode; query: JsonNode;
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
  var valid_597044 = path.getOrDefault("resourceGroupName")
  valid_597044 = validateParameter(valid_597044, JString, required = true,
                                 default = nil)
  if valid_597044 != nil:
    section.add "resourceGroupName", valid_597044
  var valid_597045 = path.getOrDefault("subscriptionId")
  valid_597045 = validateParameter(valid_597045, JString, required = true,
                                 default = nil)
  if valid_597045 != nil:
    section.add "subscriptionId", valid_597045
  var valid_597046 = path.getOrDefault("propId")
  valid_597046 = validateParameter(valid_597046, JString, required = true,
                                 default = nil)
  if valid_597046 != nil:
    section.add "propId", valid_597046
  var valid_597047 = path.getOrDefault("serviceName")
  valid_597047 = validateParameter(valid_597047, JString, required = true,
                                 default = nil)
  if valid_597047 != nil:
    section.add "serviceName", valid_597047
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597048 = query.getOrDefault("api-version")
  valid_597048 = validateParameter(valid_597048, JString, required = true,
                                 default = nil)
  if valid_597048 != nil:
    section.add "api-version", valid_597048
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597049 = header.getOrDefault("If-Match")
  valid_597049 = validateParameter(valid_597049, JString, required = true,
                                 default = nil)
  if valid_597049 != nil:
    section.add "If-Match", valid_597049
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597050: Call_PropertyDelete_597041; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specific property from the API Management service instance.
  ## 
  let valid = call_597050.validator(path, query, header, formData, body)
  let scheme = call_597050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597050.url(scheme.get, call_597050.host, call_597050.base,
                         call_597050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597050, url, valid)

proc call*(call_597051: Call_PropertyDelete_597041; resourceGroupName: string;
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
  var path_597052 = newJObject()
  var query_597053 = newJObject()
  add(path_597052, "resourceGroupName", newJString(resourceGroupName))
  add(query_597053, "api-version", newJString(apiVersion))
  add(path_597052, "subscriptionId", newJString(subscriptionId))
  add(path_597052, "propId", newJString(propId))
  add(path_597052, "serviceName", newJString(serviceName))
  result = call_597051.call(path_597052, query_597053, nil, nil, nil)

var propertyDelete* = Call_PropertyDelete_597041(name: "propertyDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/properties/{propId}",
    validator: validate_PropertyDelete_597042, base: "", url: url_PropertyDelete_597043,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
