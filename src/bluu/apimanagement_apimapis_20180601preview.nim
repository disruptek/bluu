
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2018-06-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on API entity and their Operations associated with your Azure API Management deployment.
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

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement-apimapis"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ApiListByService_593647 = ref object of OpenApiRestCall_593425
proc url_ApiListByService_593649(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/apis")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiListByService_593648(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists all APIs of the API Management service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-create-apis
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
  var valid_593810 = path.getOrDefault("resourceGroupName")
  valid_593810 = validateParameter(valid_593810, JString, required = true,
                                 default = nil)
  if valid_593810 != nil:
    section.add "resourceGroupName", valid_593810
  var valid_593811 = path.getOrDefault("subscriptionId")
  valid_593811 = validateParameter(valid_593811, JString, required = true,
                                 default = nil)
  if valid_593811 != nil:
    section.add "subscriptionId", valid_593811
  var valid_593812 = path.getOrDefault("serviceName")
  valid_593812 = validateParameter(valid_593812, JString, required = true,
                                 default = nil)
  if valid_593812 != nil:
    section.add "serviceName", valid_593812
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   expandApiVersionSet: JBool
  ##                      : Include full ApiVersionSet resource in response
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   tags: JString
  ##       : Include tags in the response.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |serviceUrl | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |path | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593813 = query.getOrDefault("api-version")
  valid_593813 = validateParameter(valid_593813, JString, required = true,
                                 default = nil)
  if valid_593813 != nil:
    section.add "api-version", valid_593813
  var valid_593814 = query.getOrDefault("expandApiVersionSet")
  valid_593814 = validateParameter(valid_593814, JBool, required = false, default = nil)
  if valid_593814 != nil:
    section.add "expandApiVersionSet", valid_593814
  var valid_593815 = query.getOrDefault("$top")
  valid_593815 = validateParameter(valid_593815, JInt, required = false, default = nil)
  if valid_593815 != nil:
    section.add "$top", valid_593815
  var valid_593816 = query.getOrDefault("$skip")
  valid_593816 = validateParameter(valid_593816, JInt, required = false, default = nil)
  if valid_593816 != nil:
    section.add "$skip", valid_593816
  var valid_593817 = query.getOrDefault("tags")
  valid_593817 = validateParameter(valid_593817, JString, required = false,
                                 default = nil)
  if valid_593817 != nil:
    section.add "tags", valid_593817
  var valid_593818 = query.getOrDefault("$filter")
  valid_593818 = validateParameter(valid_593818, JString, required = false,
                                 default = nil)
  if valid_593818 != nil:
    section.add "$filter", valid_593818
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593845: Call_ApiListByService_593647; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all APIs of the API Management service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-create-apis
  let valid = call_593845.validator(path, query, header, formData, body)
  let scheme = call_593845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593845.url(scheme.get, call_593845.host, call_593845.base,
                         call_593845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593845, url, valid)

proc call*(call_593916: Call_ApiListByService_593647; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          expandApiVersionSet: bool = false; Top: int = 0; Skip: int = 0; tags: string = "";
          Filter: string = ""): Recallable =
  ## apiListByService
  ## Lists all APIs of the API Management service instance.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-create-apis
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   expandApiVersionSet: bool
  ##                      : Include full ApiVersionSet resource in response
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   tags: string
  ##       : Include tags in the response.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |serviceUrl | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |path | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  var path_593917 = newJObject()
  var query_593919 = newJObject()
  add(path_593917, "resourceGroupName", newJString(resourceGroupName))
  add(query_593919, "api-version", newJString(apiVersion))
  add(path_593917, "subscriptionId", newJString(subscriptionId))
  add(query_593919, "expandApiVersionSet", newJBool(expandApiVersionSet))
  add(query_593919, "$top", newJInt(Top))
  add(query_593919, "$skip", newJInt(Skip))
  add(query_593919, "tags", newJString(tags))
  add(path_593917, "serviceName", newJString(serviceName))
  add(query_593919, "$filter", newJString(Filter))
  result = call_593916.call(path_593917, query_593919, nil, nil, nil)

var apiListByService* = Call_ApiListByService_593647(name: "apiListByService",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis",
    validator: validate_ApiListByService_593648, base: "",
    url: url_ApiListByService_593649, schemes: {Scheme.Https})
type
  Call_ApiCreateOrUpdate_593970 = ref object of OpenApiRestCall_593425
proc url_ApiCreateOrUpdate_593972(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiCreateOrUpdate_593971(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates new or updates existing specified API of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594000 = path.getOrDefault("resourceGroupName")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "resourceGroupName", valid_594000
  var valid_594001 = path.getOrDefault("apiId")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "apiId", valid_594001
  var valid_594002 = path.getOrDefault("subscriptionId")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "subscriptionId", valid_594002
  var valid_594003 = path.getOrDefault("serviceName")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "serviceName", valid_594003
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594004 = query.getOrDefault("api-version")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "api-version", valid_594004
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_594005 = header.getOrDefault("If-Match")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "If-Match", valid_594005
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create or update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594007: Call_ApiCreateOrUpdate_593970; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates new or updates existing specified API of the API Management service instance.
  ## 
  let valid = call_594007.validator(path, query, header, formData, body)
  let scheme = call_594007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594007.url(scheme.get, call_594007.host, call_594007.base,
                         call_594007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594007, url, valid)

proc call*(call_594008: Call_ApiCreateOrUpdate_593970; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## apiCreateOrUpdate
  ## Creates new or updates existing specified API of the API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create or update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594009 = newJObject()
  var query_594010 = newJObject()
  var body_594011 = newJObject()
  add(path_594009, "resourceGroupName", newJString(resourceGroupName))
  add(query_594010, "api-version", newJString(apiVersion))
  add(path_594009, "apiId", newJString(apiId))
  add(path_594009, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594011 = parameters
  add(path_594009, "serviceName", newJString(serviceName))
  result = call_594008.call(path_594009, query_594010, nil, nil, body_594011)

var apiCreateOrUpdate* = Call_ApiCreateOrUpdate_593970(name: "apiCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}",
    validator: validate_ApiCreateOrUpdate_593971, base: "",
    url: url_ApiCreateOrUpdate_593972, schemes: {Scheme.Https})
type
  Call_ApiGetEntityTag_594026 = ref object of OpenApiRestCall_593425
proc url_ApiGetEntityTag_594028(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiGetEntityTag_594027(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594029 = path.getOrDefault("resourceGroupName")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "resourceGroupName", valid_594029
  var valid_594030 = path.getOrDefault("apiId")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "apiId", valid_594030
  var valid_594031 = path.getOrDefault("subscriptionId")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "subscriptionId", valid_594031
  var valid_594032 = path.getOrDefault("serviceName")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "serviceName", valid_594032
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594033 = query.getOrDefault("api-version")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "api-version", valid_594033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594034: Call_ApiGetEntityTag_594026; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the API specified by its identifier.
  ## 
  let valid = call_594034.validator(path, query, header, formData, body)
  let scheme = call_594034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594034.url(scheme.get, call_594034.host, call_594034.base,
                         call_594034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594034, url, valid)

proc call*(call_594035: Call_ApiGetEntityTag_594026; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## apiGetEntityTag
  ## Gets the entity state (Etag) version of the API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594036 = newJObject()
  var query_594037 = newJObject()
  add(path_594036, "resourceGroupName", newJString(resourceGroupName))
  add(query_594037, "api-version", newJString(apiVersion))
  add(path_594036, "apiId", newJString(apiId))
  add(path_594036, "subscriptionId", newJString(subscriptionId))
  add(path_594036, "serviceName", newJString(serviceName))
  result = call_594035.call(path_594036, query_594037, nil, nil, nil)

var apiGetEntityTag* = Call_ApiGetEntityTag_594026(name: "apiGetEntityTag",
    meth: HttpMethod.HttpHead, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}",
    validator: validate_ApiGetEntityTag_594027, base: "", url: url_ApiGetEntityTag_594028,
    schemes: {Scheme.Https})
type
  Call_ApiGet_593958 = ref object of OpenApiRestCall_593425
proc url_ApiGet_593960(protocol: Scheme; host: string; base: string; route: string;
                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiGet_593959(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593961 = path.getOrDefault("resourceGroupName")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "resourceGroupName", valid_593961
  var valid_593962 = path.getOrDefault("apiId")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "apiId", valid_593962
  var valid_593963 = path.getOrDefault("subscriptionId")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "subscriptionId", valid_593963
  var valid_593964 = path.getOrDefault("serviceName")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "serviceName", valid_593964
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593965 = query.getOrDefault("api-version")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "api-version", valid_593965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593966: Call_ApiGet_593958; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the API specified by its identifier.
  ## 
  let valid = call_593966.validator(path, query, header, formData, body)
  let scheme = call_593966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593966.url(scheme.get, call_593966.host, call_593966.base,
                         call_593966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593966, url, valid)

proc call*(call_593967: Call_ApiGet_593958; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## apiGet
  ## Gets the details of the API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_593968 = newJObject()
  var query_593969 = newJObject()
  add(path_593968, "resourceGroupName", newJString(resourceGroupName))
  add(query_593969, "api-version", newJString(apiVersion))
  add(path_593968, "apiId", newJString(apiId))
  add(path_593968, "subscriptionId", newJString(subscriptionId))
  add(path_593968, "serviceName", newJString(serviceName))
  result = call_593967.call(path_593968, query_593969, nil, nil, nil)

var apiGet* = Call_ApiGet_593958(name: "apiGet", meth: HttpMethod.HttpGet,
                              host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}",
                              validator: validate_ApiGet_593959, base: "",
                              url: url_ApiGet_593960, schemes: {Scheme.Https})
type
  Call_ApiUpdate_594038 = ref object of OpenApiRestCall_593425
proc url_ApiUpdate_594040(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiUpdate_594039(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified API of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594041 = path.getOrDefault("resourceGroupName")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "resourceGroupName", valid_594041
  var valid_594042 = path.getOrDefault("apiId")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "apiId", valid_594042
  var valid_594043 = path.getOrDefault("subscriptionId")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "subscriptionId", valid_594043
  var valid_594044 = path.getOrDefault("serviceName")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "serviceName", valid_594044
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594045 = query.getOrDefault("api-version")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "api-version", valid_594045
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594046 = header.getOrDefault("If-Match")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "If-Match", valid_594046
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : API Update Contract parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594048: Call_ApiUpdate_594038; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified API of the API Management service instance.
  ## 
  let valid = call_594048.validator(path, query, header, formData, body)
  let scheme = call_594048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594048.url(scheme.get, call_594048.host, call_594048.base,
                         call_594048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594048, url, valid)

proc call*(call_594049: Call_ApiUpdate_594038; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## apiUpdate
  ## Updates the specified API of the API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : API Update Contract parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594050 = newJObject()
  var query_594051 = newJObject()
  var body_594052 = newJObject()
  add(path_594050, "resourceGroupName", newJString(resourceGroupName))
  add(query_594051, "api-version", newJString(apiVersion))
  add(path_594050, "apiId", newJString(apiId))
  add(path_594050, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594052 = parameters
  add(path_594050, "serviceName", newJString(serviceName))
  result = call_594049.call(path_594050, query_594051, nil, nil, body_594052)

var apiUpdate* = Call_ApiUpdate_594038(name: "apiUpdate", meth: HttpMethod.HttpPatch,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}",
                                    validator: validate_ApiUpdate_594039,
                                    base: "", url: url_ApiUpdate_594040,
                                    schemes: {Scheme.Https})
type
  Call_ApiDelete_594012 = ref object of OpenApiRestCall_593425
proc url_ApiDelete_594014(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiDelete_594013(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified API of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594015 = path.getOrDefault("resourceGroupName")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "resourceGroupName", valid_594015
  var valid_594016 = path.getOrDefault("apiId")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "apiId", valid_594016
  var valid_594017 = path.getOrDefault("subscriptionId")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "subscriptionId", valid_594017
  var valid_594018 = path.getOrDefault("serviceName")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "serviceName", valid_594018
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   deleteRevisions: JBool
  ##                  : Delete all revisions of the Api.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594019 = query.getOrDefault("api-version")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "api-version", valid_594019
  var valid_594020 = query.getOrDefault("deleteRevisions")
  valid_594020 = validateParameter(valid_594020, JBool, required = false, default = nil)
  if valid_594020 != nil:
    section.add "deleteRevisions", valid_594020
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594021 = header.getOrDefault("If-Match")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "If-Match", valid_594021
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594022: Call_ApiDelete_594012; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified API of the API Management service instance.
  ## 
  let valid = call_594022.validator(path, query, header, formData, body)
  let scheme = call_594022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594022.url(scheme.get, call_594022.host, call_594022.base,
                         call_594022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594022, url, valid)

proc call*(call_594023: Call_ApiDelete_594012; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string; deleteRevisions: bool = false): Recallable =
  ## apiDelete
  ## Deletes the specified API of the API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   deleteRevisions: bool
  ##                  : Delete all revisions of the Api.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594024 = newJObject()
  var query_594025 = newJObject()
  add(path_594024, "resourceGroupName", newJString(resourceGroupName))
  add(query_594025, "api-version", newJString(apiVersion))
  add(path_594024, "apiId", newJString(apiId))
  add(path_594024, "subscriptionId", newJString(subscriptionId))
  add(query_594025, "deleteRevisions", newJBool(deleteRevisions))
  add(path_594024, "serviceName", newJString(serviceName))
  result = call_594023.call(path_594024, query_594025, nil, nil, nil)

var apiDelete* = Call_ApiDelete_594012(name: "apiDelete",
                                    meth: HttpMethod.HttpDelete,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}",
                                    validator: validate_ApiDelete_594013,
                                    base: "", url: url_ApiDelete_594014,
                                    schemes: {Scheme.Https})
type
  Call_ApiDiagnosticListByService_594053 = ref object of OpenApiRestCall_593425
proc url_ApiDiagnosticListByService_594055(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/diagnostics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiDiagnosticListByService_594054(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all diagnostics of an API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594056 = path.getOrDefault("resourceGroupName")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "resourceGroupName", valid_594056
  var valid_594057 = path.getOrDefault("apiId")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "apiId", valid_594057
  var valid_594058 = path.getOrDefault("subscriptionId")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "subscriptionId", valid_594058
  var valid_594059 = path.getOrDefault("serviceName")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "serviceName", valid_594059
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594060 = query.getOrDefault("api-version")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "api-version", valid_594060
  var valid_594061 = query.getOrDefault("$top")
  valid_594061 = validateParameter(valid_594061, JInt, required = false, default = nil)
  if valid_594061 != nil:
    section.add "$top", valid_594061
  var valid_594062 = query.getOrDefault("$skip")
  valid_594062 = validateParameter(valid_594062, JInt, required = false, default = nil)
  if valid_594062 != nil:
    section.add "$skip", valid_594062
  var valid_594063 = query.getOrDefault("$filter")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "$filter", valid_594063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594064: Call_ApiDiagnosticListByService_594053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all diagnostics of an API.
  ## 
  let valid = call_594064.validator(path, query, header, formData, body)
  let scheme = call_594064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594064.url(scheme.get, call_594064.host, call_594064.base,
                         call_594064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594064, url, valid)

proc call*(call_594065: Call_ApiDiagnosticListByService_594053;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; Top: int = 0; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## apiDiagnosticListByService
  ## Lists all diagnostics of an API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  var path_594066 = newJObject()
  var query_594067 = newJObject()
  add(path_594066, "resourceGroupName", newJString(resourceGroupName))
  add(query_594067, "api-version", newJString(apiVersion))
  add(path_594066, "apiId", newJString(apiId))
  add(path_594066, "subscriptionId", newJString(subscriptionId))
  add(query_594067, "$top", newJInt(Top))
  add(query_594067, "$skip", newJInt(Skip))
  add(path_594066, "serviceName", newJString(serviceName))
  add(query_594067, "$filter", newJString(Filter))
  result = call_594065.call(path_594066, query_594067, nil, nil, nil)

var apiDiagnosticListByService* = Call_ApiDiagnosticListByService_594053(
    name: "apiDiagnosticListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics",
    validator: validate_ApiDiagnosticListByService_594054, base: "",
    url: url_ApiDiagnosticListByService_594055, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticCreateOrUpdate_594081 = ref object of OpenApiRestCall_593425
proc url_ApiDiagnosticCreateOrUpdate_594083(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "diagnosticId" in path, "`diagnosticId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiDiagnosticCreateOrUpdate_594082(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Diagnostic for an API or updates an existing one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594084 = path.getOrDefault("resourceGroupName")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "resourceGroupName", valid_594084
  var valid_594085 = path.getOrDefault("apiId")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "apiId", valid_594085
  var valid_594086 = path.getOrDefault("subscriptionId")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "subscriptionId", valid_594086
  var valid_594087 = path.getOrDefault("diagnosticId")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "diagnosticId", valid_594087
  var valid_594088 = path.getOrDefault("serviceName")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "serviceName", valid_594088
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594089 = query.getOrDefault("api-version")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "api-version", valid_594089
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_594090 = header.getOrDefault("If-Match")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "If-Match", valid_594090
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

proc call*(call_594092: Call_ApiDiagnosticCreateOrUpdate_594081; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Diagnostic for an API or updates an existing one.
  ## 
  let valid = call_594092.validator(path, query, header, formData, body)
  let scheme = call_594092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594092.url(scheme.get, call_594092.host, call_594092.base,
                         call_594092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594092, url, valid)

proc call*(call_594093: Call_ApiDiagnosticCreateOrUpdate_594081;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; diagnosticId: string; parameters: JsonNode;
          serviceName: string): Recallable =
  ## apiDiagnosticCreateOrUpdate
  ## Creates a new Diagnostic for an API or updates an existing one.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: string (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594094 = newJObject()
  var query_594095 = newJObject()
  var body_594096 = newJObject()
  add(path_594094, "resourceGroupName", newJString(resourceGroupName))
  add(query_594095, "api-version", newJString(apiVersion))
  add(path_594094, "apiId", newJString(apiId))
  add(path_594094, "subscriptionId", newJString(subscriptionId))
  add(path_594094, "diagnosticId", newJString(diagnosticId))
  if parameters != nil:
    body_594096 = parameters
  add(path_594094, "serviceName", newJString(serviceName))
  result = call_594093.call(path_594094, query_594095, nil, nil, body_594096)

var apiDiagnosticCreateOrUpdate* = Call_ApiDiagnosticCreateOrUpdate_594081(
    name: "apiDiagnosticCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}",
    validator: validate_ApiDiagnosticCreateOrUpdate_594082, base: "",
    url: url_ApiDiagnosticCreateOrUpdate_594083, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticGetEntityTag_594111 = ref object of OpenApiRestCall_593425
proc url_ApiDiagnosticGetEntityTag_594113(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "diagnosticId" in path, "`diagnosticId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiDiagnosticGetEntityTag_594112(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the Diagnostic for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594114 = path.getOrDefault("resourceGroupName")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "resourceGroupName", valid_594114
  var valid_594115 = path.getOrDefault("apiId")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "apiId", valid_594115
  var valid_594116 = path.getOrDefault("subscriptionId")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "subscriptionId", valid_594116
  var valid_594117 = path.getOrDefault("diagnosticId")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "diagnosticId", valid_594117
  var valid_594118 = path.getOrDefault("serviceName")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "serviceName", valid_594118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594119 = query.getOrDefault("api-version")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "api-version", valid_594119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594120: Call_ApiDiagnosticGetEntityTag_594111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the Diagnostic for an API specified by its identifier.
  ## 
  let valid = call_594120.validator(path, query, header, formData, body)
  let scheme = call_594120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594120.url(scheme.get, call_594120.host, call_594120.base,
                         call_594120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594120, url, valid)

proc call*(call_594121: Call_ApiDiagnosticGetEntityTag_594111;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; diagnosticId: string; serviceName: string): Recallable =
  ## apiDiagnosticGetEntityTag
  ## Gets the entity state (Etag) version of the Diagnostic for an API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: string (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594122 = newJObject()
  var query_594123 = newJObject()
  add(path_594122, "resourceGroupName", newJString(resourceGroupName))
  add(query_594123, "api-version", newJString(apiVersion))
  add(path_594122, "apiId", newJString(apiId))
  add(path_594122, "subscriptionId", newJString(subscriptionId))
  add(path_594122, "diagnosticId", newJString(diagnosticId))
  add(path_594122, "serviceName", newJString(serviceName))
  result = call_594121.call(path_594122, query_594123, nil, nil, nil)

var apiDiagnosticGetEntityTag* = Call_ApiDiagnosticGetEntityTag_594111(
    name: "apiDiagnosticGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}",
    validator: validate_ApiDiagnosticGetEntityTag_594112, base: "",
    url: url_ApiDiagnosticGetEntityTag_594113, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticGet_594068 = ref object of OpenApiRestCall_593425
proc url_ApiDiagnosticGet_594070(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "diagnosticId" in path, "`diagnosticId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiDiagnosticGet_594069(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the details of the Diagnostic for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594071 = path.getOrDefault("resourceGroupName")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "resourceGroupName", valid_594071
  var valid_594072 = path.getOrDefault("apiId")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "apiId", valid_594072
  var valid_594073 = path.getOrDefault("subscriptionId")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "subscriptionId", valid_594073
  var valid_594074 = path.getOrDefault("diagnosticId")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "diagnosticId", valid_594074
  var valid_594075 = path.getOrDefault("serviceName")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "serviceName", valid_594075
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594076 = query.getOrDefault("api-version")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "api-version", valid_594076
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594077: Call_ApiDiagnosticGet_594068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the Diagnostic for an API specified by its identifier.
  ## 
  let valid = call_594077.validator(path, query, header, formData, body)
  let scheme = call_594077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594077.url(scheme.get, call_594077.host, call_594077.base,
                         call_594077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594077, url, valid)

proc call*(call_594078: Call_ApiDiagnosticGet_594068; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          diagnosticId: string; serviceName: string): Recallable =
  ## apiDiagnosticGet
  ## Gets the details of the Diagnostic for an API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: string (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594079 = newJObject()
  var query_594080 = newJObject()
  add(path_594079, "resourceGroupName", newJString(resourceGroupName))
  add(query_594080, "api-version", newJString(apiVersion))
  add(path_594079, "apiId", newJString(apiId))
  add(path_594079, "subscriptionId", newJString(subscriptionId))
  add(path_594079, "diagnosticId", newJString(diagnosticId))
  add(path_594079, "serviceName", newJString(serviceName))
  result = call_594078.call(path_594079, query_594080, nil, nil, nil)

var apiDiagnosticGet* = Call_ApiDiagnosticGet_594068(name: "apiDiagnosticGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}",
    validator: validate_ApiDiagnosticGet_594069, base: "",
    url: url_ApiDiagnosticGet_594070, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticUpdate_594124 = ref object of OpenApiRestCall_593425
proc url_ApiDiagnosticUpdate_594126(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "diagnosticId" in path, "`diagnosticId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiDiagnosticUpdate_594125(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates the details of the Diagnostic for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594127 = path.getOrDefault("resourceGroupName")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "resourceGroupName", valid_594127
  var valid_594128 = path.getOrDefault("apiId")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "apiId", valid_594128
  var valid_594129 = path.getOrDefault("subscriptionId")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "subscriptionId", valid_594129
  var valid_594130 = path.getOrDefault("diagnosticId")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "diagnosticId", valid_594130
  var valid_594131 = path.getOrDefault("serviceName")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "serviceName", valid_594131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594132 = query.getOrDefault("api-version")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "api-version", valid_594132
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594133 = header.getOrDefault("If-Match")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "If-Match", valid_594133
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Diagnostic Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594135: Call_ApiDiagnosticUpdate_594124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the Diagnostic for an API specified by its identifier.
  ## 
  let valid = call_594135.validator(path, query, header, formData, body)
  let scheme = call_594135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594135.url(scheme.get, call_594135.host, call_594135.base,
                         call_594135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594135, url, valid)

proc call*(call_594136: Call_ApiDiagnosticUpdate_594124; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          diagnosticId: string; parameters: JsonNode; serviceName: string): Recallable =
  ## apiDiagnosticUpdate
  ## Updates the details of the Diagnostic for an API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: string (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   parameters: JObject (required)
  ##             : Diagnostic Update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594137 = newJObject()
  var query_594138 = newJObject()
  var body_594139 = newJObject()
  add(path_594137, "resourceGroupName", newJString(resourceGroupName))
  add(query_594138, "api-version", newJString(apiVersion))
  add(path_594137, "apiId", newJString(apiId))
  add(path_594137, "subscriptionId", newJString(subscriptionId))
  add(path_594137, "diagnosticId", newJString(diagnosticId))
  if parameters != nil:
    body_594139 = parameters
  add(path_594137, "serviceName", newJString(serviceName))
  result = call_594136.call(path_594137, query_594138, nil, nil, body_594139)

var apiDiagnosticUpdate* = Call_ApiDiagnosticUpdate_594124(
    name: "apiDiagnosticUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}",
    validator: validate_ApiDiagnosticUpdate_594125, base: "",
    url: url_ApiDiagnosticUpdate_594126, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticDelete_594097 = ref object of OpenApiRestCall_593425
proc url_ApiDiagnosticDelete_594099(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "diagnosticId" in path, "`diagnosticId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/diagnostics/"),
               (kind: VariableSegment, value: "diagnosticId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiDiagnosticDelete_594098(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes the specified Diagnostic from an API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594100 = path.getOrDefault("resourceGroupName")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "resourceGroupName", valid_594100
  var valid_594101 = path.getOrDefault("apiId")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "apiId", valid_594101
  var valid_594102 = path.getOrDefault("subscriptionId")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "subscriptionId", valid_594102
  var valid_594103 = path.getOrDefault("diagnosticId")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "diagnosticId", valid_594103
  var valid_594104 = path.getOrDefault("serviceName")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "serviceName", valid_594104
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594105 = query.getOrDefault("api-version")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "api-version", valid_594105
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594106 = header.getOrDefault("If-Match")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "If-Match", valid_594106
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594107: Call_ApiDiagnosticDelete_594097; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Diagnostic from an API.
  ## 
  let valid = call_594107.validator(path, query, header, formData, body)
  let scheme = call_594107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594107.url(scheme.get, call_594107.host, call_594107.base,
                         call_594107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594107, url, valid)

proc call*(call_594108: Call_ApiDiagnosticDelete_594097; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          diagnosticId: string; serviceName: string): Recallable =
  ## apiDiagnosticDelete
  ## Deletes the specified Diagnostic from an API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: string (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594109 = newJObject()
  var query_594110 = newJObject()
  add(path_594109, "resourceGroupName", newJString(resourceGroupName))
  add(query_594110, "api-version", newJString(apiVersion))
  add(path_594109, "apiId", newJString(apiId))
  add(path_594109, "subscriptionId", newJString(subscriptionId))
  add(path_594109, "diagnosticId", newJString(diagnosticId))
  add(path_594109, "serviceName", newJString(serviceName))
  result = call_594108.call(path_594109, query_594110, nil, nil, nil)

var apiDiagnosticDelete* = Call_ApiDiagnosticDelete_594097(
    name: "apiDiagnosticDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}",
    validator: validate_ApiDiagnosticDelete_594098, base: "",
    url: url_ApiDiagnosticDelete_594099, schemes: {Scheme.Https})
type
  Call_ApiIssueListByService_594140 = ref object of OpenApiRestCall_593425
proc url_ApiIssueListByService_594142(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueListByService_594141(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all issues associated with the specified API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594143 = path.getOrDefault("resourceGroupName")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "resourceGroupName", valid_594143
  var valid_594144 = path.getOrDefault("apiId")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "apiId", valid_594144
  var valid_594145 = path.getOrDefault("subscriptionId")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "subscriptionId", valid_594145
  var valid_594146 = path.getOrDefault("serviceName")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "serviceName", valid_594146
  result.add "path", section
  ## parameters in `query` object:
  ##   expandCommentsAttachments: JBool
  ##                            : Expand the comment attachments. 
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |userId | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |state | eq |    |
  ## 
  section = newJObject()
  var valid_594147 = query.getOrDefault("expandCommentsAttachments")
  valid_594147 = validateParameter(valid_594147, JBool, required = false, default = nil)
  if valid_594147 != nil:
    section.add "expandCommentsAttachments", valid_594147
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594148 = query.getOrDefault("api-version")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "api-version", valid_594148
  var valid_594149 = query.getOrDefault("$top")
  valid_594149 = validateParameter(valid_594149, JInt, required = false, default = nil)
  if valid_594149 != nil:
    section.add "$top", valid_594149
  var valid_594150 = query.getOrDefault("$skip")
  valid_594150 = validateParameter(valid_594150, JInt, required = false, default = nil)
  if valid_594150 != nil:
    section.add "$skip", valid_594150
  var valid_594151 = query.getOrDefault("$filter")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "$filter", valid_594151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594152: Call_ApiIssueListByService_594140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all issues associated with the specified API.
  ## 
  let valid = call_594152.validator(path, query, header, formData, body)
  let scheme = call_594152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594152.url(scheme.get, call_594152.host, call_594152.base,
                         call_594152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594152, url, valid)

proc call*(call_594153: Call_ApiIssueListByService_594140;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string;
          expandCommentsAttachments: bool = false; Top: int = 0; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## apiIssueListByService
  ## Lists all issues associated with the specified API.
  ##   expandCommentsAttachments: bool
  ##                            : Expand the comment attachments. 
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |userId | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |state | eq |    |
  ## 
  var path_594154 = newJObject()
  var query_594155 = newJObject()
  add(query_594155, "expandCommentsAttachments",
      newJBool(expandCommentsAttachments))
  add(path_594154, "resourceGroupName", newJString(resourceGroupName))
  add(query_594155, "api-version", newJString(apiVersion))
  add(path_594154, "apiId", newJString(apiId))
  add(path_594154, "subscriptionId", newJString(subscriptionId))
  add(query_594155, "$top", newJInt(Top))
  add(query_594155, "$skip", newJInt(Skip))
  add(path_594154, "serviceName", newJString(serviceName))
  add(query_594155, "$filter", newJString(Filter))
  result = call_594153.call(path_594154, query_594155, nil, nil, nil)

var apiIssueListByService* = Call_ApiIssueListByService_594140(
    name: "apiIssueListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues",
    validator: validate_ApiIssueListByService_594141, base: "",
    url: url_ApiIssueListByService_594142, schemes: {Scheme.Https})
type
  Call_ApiIssueCreateOrUpdate_594170 = ref object of OpenApiRestCall_593425
proc url_ApiIssueCreateOrUpdate_594172(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueCreateOrUpdate_594171(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Issue for an API or updates an existing one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594173 = path.getOrDefault("resourceGroupName")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "resourceGroupName", valid_594173
  var valid_594174 = path.getOrDefault("apiId")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "apiId", valid_594174
  var valid_594175 = path.getOrDefault("issueId")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "issueId", valid_594175
  var valid_594176 = path.getOrDefault("subscriptionId")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "subscriptionId", valid_594176
  var valid_594177 = path.getOrDefault("serviceName")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "serviceName", valid_594177
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594178 = query.getOrDefault("api-version")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "api-version", valid_594178
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_594179 = header.getOrDefault("If-Match")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = nil)
  if valid_594179 != nil:
    section.add "If-Match", valid_594179
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

proc call*(call_594181: Call_ApiIssueCreateOrUpdate_594170; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Issue for an API or updates an existing one.
  ## 
  let valid = call_594181.validator(path, query, header, formData, body)
  let scheme = call_594181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594181.url(scheme.get, call_594181.host, call_594181.base,
                         call_594181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594181, url, valid)

proc call*(call_594182: Call_ApiIssueCreateOrUpdate_594170;
          resourceGroupName: string; apiVersion: string; apiId: string;
          issueId: string; subscriptionId: string; parameters: JsonNode;
          serviceName: string): Recallable =
  ## apiIssueCreateOrUpdate
  ## Creates a new Issue for an API or updates an existing one.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594183 = newJObject()
  var query_594184 = newJObject()
  var body_594185 = newJObject()
  add(path_594183, "resourceGroupName", newJString(resourceGroupName))
  add(query_594184, "api-version", newJString(apiVersion))
  add(path_594183, "apiId", newJString(apiId))
  add(path_594183, "issueId", newJString(issueId))
  add(path_594183, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594185 = parameters
  add(path_594183, "serviceName", newJString(serviceName))
  result = call_594182.call(path_594183, query_594184, nil, nil, body_594185)

var apiIssueCreateOrUpdate* = Call_ApiIssueCreateOrUpdate_594170(
    name: "apiIssueCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}",
    validator: validate_ApiIssueCreateOrUpdate_594171, base: "",
    url: url_ApiIssueCreateOrUpdate_594172, schemes: {Scheme.Https})
type
  Call_ApiIssueGetEntityTag_594200 = ref object of OpenApiRestCall_593425
proc url_ApiIssueGetEntityTag_594202(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueGetEntityTag_594201(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the Issue for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594203 = path.getOrDefault("resourceGroupName")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "resourceGroupName", valid_594203
  var valid_594204 = path.getOrDefault("apiId")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "apiId", valid_594204
  var valid_594205 = path.getOrDefault("issueId")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "issueId", valid_594205
  var valid_594206 = path.getOrDefault("subscriptionId")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = nil)
  if valid_594206 != nil:
    section.add "subscriptionId", valid_594206
  var valid_594207 = path.getOrDefault("serviceName")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "serviceName", valid_594207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594208 = query.getOrDefault("api-version")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "api-version", valid_594208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594209: Call_ApiIssueGetEntityTag_594200; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the Issue for an API specified by its identifier.
  ## 
  let valid = call_594209.validator(path, query, header, formData, body)
  let scheme = call_594209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594209.url(scheme.get, call_594209.host, call_594209.base,
                         call_594209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594209, url, valid)

proc call*(call_594210: Call_ApiIssueGetEntityTag_594200;
          resourceGroupName: string; apiVersion: string; apiId: string;
          issueId: string; subscriptionId: string; serviceName: string): Recallable =
  ## apiIssueGetEntityTag
  ## Gets the entity state (Etag) version of the Issue for an API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594211 = newJObject()
  var query_594212 = newJObject()
  add(path_594211, "resourceGroupName", newJString(resourceGroupName))
  add(query_594212, "api-version", newJString(apiVersion))
  add(path_594211, "apiId", newJString(apiId))
  add(path_594211, "issueId", newJString(issueId))
  add(path_594211, "subscriptionId", newJString(subscriptionId))
  add(path_594211, "serviceName", newJString(serviceName))
  result = call_594210.call(path_594211, query_594212, nil, nil, nil)

var apiIssueGetEntityTag* = Call_ApiIssueGetEntityTag_594200(
    name: "apiIssueGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}",
    validator: validate_ApiIssueGetEntityTag_594201, base: "",
    url: url_ApiIssueGetEntityTag_594202, schemes: {Scheme.Https})
type
  Call_ApiIssueGet_594156 = ref object of OpenApiRestCall_593425
proc url_ApiIssueGet_594158(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueGet_594157(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the Issue for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594159 = path.getOrDefault("resourceGroupName")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "resourceGroupName", valid_594159
  var valid_594160 = path.getOrDefault("apiId")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "apiId", valid_594160
  var valid_594161 = path.getOrDefault("issueId")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "issueId", valid_594161
  var valid_594162 = path.getOrDefault("subscriptionId")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "subscriptionId", valid_594162
  var valid_594163 = path.getOrDefault("serviceName")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "serviceName", valid_594163
  result.add "path", section
  ## parameters in `query` object:
  ##   expandCommentsAttachments: JBool
  ##                            : Expand the comment attachments. 
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  var valid_594164 = query.getOrDefault("expandCommentsAttachments")
  valid_594164 = validateParameter(valid_594164, JBool, required = false, default = nil)
  if valid_594164 != nil:
    section.add "expandCommentsAttachments", valid_594164
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594165 = query.getOrDefault("api-version")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "api-version", valid_594165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594166: Call_ApiIssueGet_594156; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the Issue for an API specified by its identifier.
  ## 
  let valid = call_594166.validator(path, query, header, formData, body)
  let scheme = call_594166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594166.url(scheme.get, call_594166.host, call_594166.base,
                         call_594166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594166, url, valid)

proc call*(call_594167: Call_ApiIssueGet_594156; resourceGroupName: string;
          apiVersion: string; apiId: string; issueId: string; subscriptionId: string;
          serviceName: string; expandCommentsAttachments: bool = false): Recallable =
  ## apiIssueGet
  ## Gets the details of the Issue for an API specified by its identifier.
  ##   expandCommentsAttachments: bool
  ##                            : Expand the comment attachments. 
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594168 = newJObject()
  var query_594169 = newJObject()
  add(query_594169, "expandCommentsAttachments",
      newJBool(expandCommentsAttachments))
  add(path_594168, "resourceGroupName", newJString(resourceGroupName))
  add(query_594169, "api-version", newJString(apiVersion))
  add(path_594168, "apiId", newJString(apiId))
  add(path_594168, "issueId", newJString(issueId))
  add(path_594168, "subscriptionId", newJString(subscriptionId))
  add(path_594168, "serviceName", newJString(serviceName))
  result = call_594167.call(path_594168, query_594169, nil, nil, nil)

var apiIssueGet* = Call_ApiIssueGet_594156(name: "apiIssueGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}",
                                        validator: validate_ApiIssueGet_594157,
                                        base: "", url: url_ApiIssueGet_594158,
                                        schemes: {Scheme.Https})
type
  Call_ApiIssueUpdate_594213 = ref object of OpenApiRestCall_593425
proc url_ApiIssueUpdate_594215(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueUpdate_594214(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates an existing issue for an API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594216 = path.getOrDefault("resourceGroupName")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "resourceGroupName", valid_594216
  var valid_594217 = path.getOrDefault("apiId")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "apiId", valid_594217
  var valid_594218 = path.getOrDefault("issueId")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "issueId", valid_594218
  var valid_594219 = path.getOrDefault("subscriptionId")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "subscriptionId", valid_594219
  var valid_594220 = path.getOrDefault("serviceName")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "serviceName", valid_594220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594221 = query.getOrDefault("api-version")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "api-version", valid_594221
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594222 = header.getOrDefault("If-Match")
  valid_594222 = validateParameter(valid_594222, JString, required = true,
                                 default = nil)
  if valid_594222 != nil:
    section.add "If-Match", valid_594222
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

proc call*(call_594224: Call_ApiIssueUpdate_594213; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing issue for an API.
  ## 
  let valid = call_594224.validator(path, query, header, formData, body)
  let scheme = call_594224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594224.url(scheme.get, call_594224.host, call_594224.base,
                         call_594224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594224, url, valid)

proc call*(call_594225: Call_ApiIssueUpdate_594213; resourceGroupName: string;
          apiVersion: string; apiId: string; issueId: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## apiIssueUpdate
  ## Updates an existing issue for an API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594226 = newJObject()
  var query_594227 = newJObject()
  var body_594228 = newJObject()
  add(path_594226, "resourceGroupName", newJString(resourceGroupName))
  add(query_594227, "api-version", newJString(apiVersion))
  add(path_594226, "apiId", newJString(apiId))
  add(path_594226, "issueId", newJString(issueId))
  add(path_594226, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594228 = parameters
  add(path_594226, "serviceName", newJString(serviceName))
  result = call_594225.call(path_594226, query_594227, nil, nil, body_594228)

var apiIssueUpdate* = Call_ApiIssueUpdate_594213(name: "apiIssueUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}",
    validator: validate_ApiIssueUpdate_594214, base: "", url: url_ApiIssueUpdate_594215,
    schemes: {Scheme.Https})
type
  Call_ApiIssueDelete_594186 = ref object of OpenApiRestCall_593425
proc url_ApiIssueDelete_594188(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueDelete_594187(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes the specified Issue from an API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594189 = path.getOrDefault("resourceGroupName")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "resourceGroupName", valid_594189
  var valid_594190 = path.getOrDefault("apiId")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "apiId", valid_594190
  var valid_594191 = path.getOrDefault("issueId")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "issueId", valid_594191
  var valid_594192 = path.getOrDefault("subscriptionId")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "subscriptionId", valid_594192
  var valid_594193 = path.getOrDefault("serviceName")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "serviceName", valid_594193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594194 = query.getOrDefault("api-version")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "api-version", valid_594194
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594195 = header.getOrDefault("If-Match")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "If-Match", valid_594195
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594196: Call_ApiIssueDelete_594186; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Issue from an API.
  ## 
  let valid = call_594196.validator(path, query, header, formData, body)
  let scheme = call_594196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594196.url(scheme.get, call_594196.host, call_594196.base,
                         call_594196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594196, url, valid)

proc call*(call_594197: Call_ApiIssueDelete_594186; resourceGroupName: string;
          apiVersion: string; apiId: string; issueId: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## apiIssueDelete
  ## Deletes the specified Issue from an API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594198 = newJObject()
  var query_594199 = newJObject()
  add(path_594198, "resourceGroupName", newJString(resourceGroupName))
  add(query_594199, "api-version", newJString(apiVersion))
  add(path_594198, "apiId", newJString(apiId))
  add(path_594198, "issueId", newJString(issueId))
  add(path_594198, "subscriptionId", newJString(subscriptionId))
  add(path_594198, "serviceName", newJString(serviceName))
  result = call_594197.call(path_594198, query_594199, nil, nil, nil)

var apiIssueDelete* = Call_ApiIssueDelete_594186(name: "apiIssueDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}",
    validator: validate_ApiIssueDelete_594187, base: "", url: url_ApiIssueDelete_594188,
    schemes: {Scheme.Https})
type
  Call_ApiIssueAttachmentListByService_594229 = ref object of OpenApiRestCall_593425
proc url_ApiIssueAttachmentListByService_594231(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId"),
               (kind: ConstantSegment, value: "/attachments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueAttachmentListByService_594230(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all attachments for the Issue associated with the specified API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594232 = path.getOrDefault("resourceGroupName")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = nil)
  if valid_594232 != nil:
    section.add "resourceGroupName", valid_594232
  var valid_594233 = path.getOrDefault("apiId")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "apiId", valid_594233
  var valid_594234 = path.getOrDefault("issueId")
  valid_594234 = validateParameter(valid_594234, JString, required = true,
                                 default = nil)
  if valid_594234 != nil:
    section.add "issueId", valid_594234
  var valid_594235 = path.getOrDefault("subscriptionId")
  valid_594235 = validateParameter(valid_594235, JString, required = true,
                                 default = nil)
  if valid_594235 != nil:
    section.add "subscriptionId", valid_594235
  var valid_594236 = path.getOrDefault("serviceName")
  valid_594236 = validateParameter(valid_594236, JString, required = true,
                                 default = nil)
  if valid_594236 != nil:
    section.add "serviceName", valid_594236
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |userId | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594237 = query.getOrDefault("api-version")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "api-version", valid_594237
  var valid_594238 = query.getOrDefault("$top")
  valid_594238 = validateParameter(valid_594238, JInt, required = false, default = nil)
  if valid_594238 != nil:
    section.add "$top", valid_594238
  var valid_594239 = query.getOrDefault("$skip")
  valid_594239 = validateParameter(valid_594239, JInt, required = false, default = nil)
  if valid_594239 != nil:
    section.add "$skip", valid_594239
  var valid_594240 = query.getOrDefault("$filter")
  valid_594240 = validateParameter(valid_594240, JString, required = false,
                                 default = nil)
  if valid_594240 != nil:
    section.add "$filter", valid_594240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594241: Call_ApiIssueAttachmentListByService_594229;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all attachments for the Issue associated with the specified API.
  ## 
  let valid = call_594241.validator(path, query, header, formData, body)
  let scheme = call_594241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594241.url(scheme.get, call_594241.host, call_594241.base,
                         call_594241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594241, url, valid)

proc call*(call_594242: Call_ApiIssueAttachmentListByService_594229;
          resourceGroupName: string; apiVersion: string; apiId: string;
          issueId: string; subscriptionId: string; serviceName: string; Top: int = 0;
          Skip: int = 0; Filter: string = ""): Recallable =
  ## apiIssueAttachmentListByService
  ## Lists all attachments for the Issue associated with the specified API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |userId | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  var path_594243 = newJObject()
  var query_594244 = newJObject()
  add(path_594243, "resourceGroupName", newJString(resourceGroupName))
  add(query_594244, "api-version", newJString(apiVersion))
  add(path_594243, "apiId", newJString(apiId))
  add(path_594243, "issueId", newJString(issueId))
  add(path_594243, "subscriptionId", newJString(subscriptionId))
  add(query_594244, "$top", newJInt(Top))
  add(query_594244, "$skip", newJInt(Skip))
  add(path_594243, "serviceName", newJString(serviceName))
  add(query_594244, "$filter", newJString(Filter))
  result = call_594242.call(path_594243, query_594244, nil, nil, nil)

var apiIssueAttachmentListByService* = Call_ApiIssueAttachmentListByService_594229(
    name: "apiIssueAttachmentListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/attachments",
    validator: validate_ApiIssueAttachmentListByService_594230, base: "",
    url: url_ApiIssueAttachmentListByService_594231, schemes: {Scheme.Https})
type
  Call_ApiIssueAttachmentCreateOrUpdate_594259 = ref object of OpenApiRestCall_593425
proc url_ApiIssueAttachmentCreateOrUpdate_594261(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  assert "attachmentId" in path, "`attachmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId"),
               (kind: ConstantSegment, value: "/attachments/"),
               (kind: VariableSegment, value: "attachmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueAttachmentCreateOrUpdate_594260(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Attachment for the Issue in an API or updates an existing one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   attachmentId: JString (required)
  ##               : Attachment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594262 = path.getOrDefault("resourceGroupName")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "resourceGroupName", valid_594262
  var valid_594263 = path.getOrDefault("apiId")
  valid_594263 = validateParameter(valid_594263, JString, required = true,
                                 default = nil)
  if valid_594263 != nil:
    section.add "apiId", valid_594263
  var valid_594264 = path.getOrDefault("issueId")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = nil)
  if valid_594264 != nil:
    section.add "issueId", valid_594264
  var valid_594265 = path.getOrDefault("subscriptionId")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = nil)
  if valid_594265 != nil:
    section.add "subscriptionId", valid_594265
  var valid_594266 = path.getOrDefault("attachmentId")
  valid_594266 = validateParameter(valid_594266, JString, required = true,
                                 default = nil)
  if valid_594266 != nil:
    section.add "attachmentId", valid_594266
  var valid_594267 = path.getOrDefault("serviceName")
  valid_594267 = validateParameter(valid_594267, JString, required = true,
                                 default = nil)
  if valid_594267 != nil:
    section.add "serviceName", valid_594267
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594268 = query.getOrDefault("api-version")
  valid_594268 = validateParameter(valid_594268, JString, required = true,
                                 default = nil)
  if valid_594268 != nil:
    section.add "api-version", valid_594268
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_594269 = header.getOrDefault("If-Match")
  valid_594269 = validateParameter(valid_594269, JString, required = false,
                                 default = nil)
  if valid_594269 != nil:
    section.add "If-Match", valid_594269
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

proc call*(call_594271: Call_ApiIssueAttachmentCreateOrUpdate_594259;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new Attachment for the Issue in an API or updates an existing one.
  ## 
  let valid = call_594271.validator(path, query, header, formData, body)
  let scheme = call_594271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594271.url(scheme.get, call_594271.host, call_594271.base,
                         call_594271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594271, url, valid)

proc call*(call_594272: Call_ApiIssueAttachmentCreateOrUpdate_594259;
          resourceGroupName: string; apiVersion: string; apiId: string;
          issueId: string; subscriptionId: string; attachmentId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## apiIssueAttachmentCreateOrUpdate
  ## Creates a new Attachment for the Issue in an API or updates an existing one.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   attachmentId: string (required)
  ##               : Attachment identifier within an Issue. Must be unique in the current Issue.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594273 = newJObject()
  var query_594274 = newJObject()
  var body_594275 = newJObject()
  add(path_594273, "resourceGroupName", newJString(resourceGroupName))
  add(query_594274, "api-version", newJString(apiVersion))
  add(path_594273, "apiId", newJString(apiId))
  add(path_594273, "issueId", newJString(issueId))
  add(path_594273, "subscriptionId", newJString(subscriptionId))
  add(path_594273, "attachmentId", newJString(attachmentId))
  if parameters != nil:
    body_594275 = parameters
  add(path_594273, "serviceName", newJString(serviceName))
  result = call_594272.call(path_594273, query_594274, nil, nil, body_594275)

var apiIssueAttachmentCreateOrUpdate* = Call_ApiIssueAttachmentCreateOrUpdate_594259(
    name: "apiIssueAttachmentCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/attachments/{attachmentId}",
    validator: validate_ApiIssueAttachmentCreateOrUpdate_594260, base: "",
    url: url_ApiIssueAttachmentCreateOrUpdate_594261, schemes: {Scheme.Https})
type
  Call_ApiIssueAttachmentGetEntityTag_594291 = ref object of OpenApiRestCall_593425
proc url_ApiIssueAttachmentGetEntityTag_594293(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  assert "attachmentId" in path, "`attachmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId"),
               (kind: ConstantSegment, value: "/attachments/"),
               (kind: VariableSegment, value: "attachmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueAttachmentGetEntityTag_594292(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the issue Attachment for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   attachmentId: JString (required)
  ##               : Attachment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594294 = path.getOrDefault("resourceGroupName")
  valid_594294 = validateParameter(valid_594294, JString, required = true,
                                 default = nil)
  if valid_594294 != nil:
    section.add "resourceGroupName", valid_594294
  var valid_594295 = path.getOrDefault("apiId")
  valid_594295 = validateParameter(valid_594295, JString, required = true,
                                 default = nil)
  if valid_594295 != nil:
    section.add "apiId", valid_594295
  var valid_594296 = path.getOrDefault("issueId")
  valid_594296 = validateParameter(valid_594296, JString, required = true,
                                 default = nil)
  if valid_594296 != nil:
    section.add "issueId", valid_594296
  var valid_594297 = path.getOrDefault("subscriptionId")
  valid_594297 = validateParameter(valid_594297, JString, required = true,
                                 default = nil)
  if valid_594297 != nil:
    section.add "subscriptionId", valid_594297
  var valid_594298 = path.getOrDefault("attachmentId")
  valid_594298 = validateParameter(valid_594298, JString, required = true,
                                 default = nil)
  if valid_594298 != nil:
    section.add "attachmentId", valid_594298
  var valid_594299 = path.getOrDefault("serviceName")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "serviceName", valid_594299
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594300 = query.getOrDefault("api-version")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "api-version", valid_594300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594301: Call_ApiIssueAttachmentGetEntityTag_594291; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the issue Attachment for an API specified by its identifier.
  ## 
  let valid = call_594301.validator(path, query, header, formData, body)
  let scheme = call_594301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594301.url(scheme.get, call_594301.host, call_594301.base,
                         call_594301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594301, url, valid)

proc call*(call_594302: Call_ApiIssueAttachmentGetEntityTag_594291;
          resourceGroupName: string; apiVersion: string; apiId: string;
          issueId: string; subscriptionId: string; attachmentId: string;
          serviceName: string): Recallable =
  ## apiIssueAttachmentGetEntityTag
  ## Gets the entity state (Etag) version of the issue Attachment for an API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   attachmentId: string (required)
  ##               : Attachment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594303 = newJObject()
  var query_594304 = newJObject()
  add(path_594303, "resourceGroupName", newJString(resourceGroupName))
  add(query_594304, "api-version", newJString(apiVersion))
  add(path_594303, "apiId", newJString(apiId))
  add(path_594303, "issueId", newJString(issueId))
  add(path_594303, "subscriptionId", newJString(subscriptionId))
  add(path_594303, "attachmentId", newJString(attachmentId))
  add(path_594303, "serviceName", newJString(serviceName))
  result = call_594302.call(path_594303, query_594304, nil, nil, nil)

var apiIssueAttachmentGetEntityTag* = Call_ApiIssueAttachmentGetEntityTag_594291(
    name: "apiIssueAttachmentGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/attachments/{attachmentId}",
    validator: validate_ApiIssueAttachmentGetEntityTag_594292, base: "",
    url: url_ApiIssueAttachmentGetEntityTag_594293, schemes: {Scheme.Https})
type
  Call_ApiIssueAttachmentGet_594245 = ref object of OpenApiRestCall_593425
proc url_ApiIssueAttachmentGet_594247(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  assert "attachmentId" in path, "`attachmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId"),
               (kind: ConstantSegment, value: "/attachments/"),
               (kind: VariableSegment, value: "attachmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueAttachmentGet_594246(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the issue Attachment for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   attachmentId: JString (required)
  ##               : Attachment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594248 = path.getOrDefault("resourceGroupName")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "resourceGroupName", valid_594248
  var valid_594249 = path.getOrDefault("apiId")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "apiId", valid_594249
  var valid_594250 = path.getOrDefault("issueId")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = nil)
  if valid_594250 != nil:
    section.add "issueId", valid_594250
  var valid_594251 = path.getOrDefault("subscriptionId")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "subscriptionId", valid_594251
  var valid_594252 = path.getOrDefault("attachmentId")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "attachmentId", valid_594252
  var valid_594253 = path.getOrDefault("serviceName")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "serviceName", valid_594253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594254 = query.getOrDefault("api-version")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "api-version", valid_594254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594255: Call_ApiIssueAttachmentGet_594245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the issue Attachment for an API specified by its identifier.
  ## 
  let valid = call_594255.validator(path, query, header, formData, body)
  let scheme = call_594255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594255.url(scheme.get, call_594255.host, call_594255.base,
                         call_594255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594255, url, valid)

proc call*(call_594256: Call_ApiIssueAttachmentGet_594245;
          resourceGroupName: string; apiVersion: string; apiId: string;
          issueId: string; subscriptionId: string; attachmentId: string;
          serviceName: string): Recallable =
  ## apiIssueAttachmentGet
  ## Gets the details of the issue Attachment for an API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   attachmentId: string (required)
  ##               : Attachment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594257 = newJObject()
  var query_594258 = newJObject()
  add(path_594257, "resourceGroupName", newJString(resourceGroupName))
  add(query_594258, "api-version", newJString(apiVersion))
  add(path_594257, "apiId", newJString(apiId))
  add(path_594257, "issueId", newJString(issueId))
  add(path_594257, "subscriptionId", newJString(subscriptionId))
  add(path_594257, "attachmentId", newJString(attachmentId))
  add(path_594257, "serviceName", newJString(serviceName))
  result = call_594256.call(path_594257, query_594258, nil, nil, nil)

var apiIssueAttachmentGet* = Call_ApiIssueAttachmentGet_594245(
    name: "apiIssueAttachmentGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/attachments/{attachmentId}",
    validator: validate_ApiIssueAttachmentGet_594246, base: "",
    url: url_ApiIssueAttachmentGet_594247, schemes: {Scheme.Https})
type
  Call_ApiIssueAttachmentDelete_594276 = ref object of OpenApiRestCall_593425
proc url_ApiIssueAttachmentDelete_594278(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  assert "attachmentId" in path, "`attachmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId"),
               (kind: ConstantSegment, value: "/attachments/"),
               (kind: VariableSegment, value: "attachmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueAttachmentDelete_594277(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified comment from an Issue.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   attachmentId: JString (required)
  ##               : Attachment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594279 = path.getOrDefault("resourceGroupName")
  valid_594279 = validateParameter(valid_594279, JString, required = true,
                                 default = nil)
  if valid_594279 != nil:
    section.add "resourceGroupName", valid_594279
  var valid_594280 = path.getOrDefault("apiId")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = nil)
  if valid_594280 != nil:
    section.add "apiId", valid_594280
  var valid_594281 = path.getOrDefault("issueId")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "issueId", valid_594281
  var valid_594282 = path.getOrDefault("subscriptionId")
  valid_594282 = validateParameter(valid_594282, JString, required = true,
                                 default = nil)
  if valid_594282 != nil:
    section.add "subscriptionId", valid_594282
  var valid_594283 = path.getOrDefault("attachmentId")
  valid_594283 = validateParameter(valid_594283, JString, required = true,
                                 default = nil)
  if valid_594283 != nil:
    section.add "attachmentId", valid_594283
  var valid_594284 = path.getOrDefault("serviceName")
  valid_594284 = validateParameter(valid_594284, JString, required = true,
                                 default = nil)
  if valid_594284 != nil:
    section.add "serviceName", valid_594284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594285 = query.getOrDefault("api-version")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "api-version", valid_594285
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594286 = header.getOrDefault("If-Match")
  valid_594286 = validateParameter(valid_594286, JString, required = true,
                                 default = nil)
  if valid_594286 != nil:
    section.add "If-Match", valid_594286
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594287: Call_ApiIssueAttachmentDelete_594276; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified comment from an Issue.
  ## 
  let valid = call_594287.validator(path, query, header, formData, body)
  let scheme = call_594287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594287.url(scheme.get, call_594287.host, call_594287.base,
                         call_594287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594287, url, valid)

proc call*(call_594288: Call_ApiIssueAttachmentDelete_594276;
          resourceGroupName: string; apiVersion: string; apiId: string;
          issueId: string; subscriptionId: string; attachmentId: string;
          serviceName: string): Recallable =
  ## apiIssueAttachmentDelete
  ## Deletes the specified comment from an Issue.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   attachmentId: string (required)
  ##               : Attachment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594289 = newJObject()
  var query_594290 = newJObject()
  add(path_594289, "resourceGroupName", newJString(resourceGroupName))
  add(query_594290, "api-version", newJString(apiVersion))
  add(path_594289, "apiId", newJString(apiId))
  add(path_594289, "issueId", newJString(issueId))
  add(path_594289, "subscriptionId", newJString(subscriptionId))
  add(path_594289, "attachmentId", newJString(attachmentId))
  add(path_594289, "serviceName", newJString(serviceName))
  result = call_594288.call(path_594289, query_594290, nil, nil, nil)

var apiIssueAttachmentDelete* = Call_ApiIssueAttachmentDelete_594276(
    name: "apiIssueAttachmentDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/attachments/{attachmentId}",
    validator: validate_ApiIssueAttachmentDelete_594277, base: "",
    url: url_ApiIssueAttachmentDelete_594278, schemes: {Scheme.Https})
type
  Call_ApiIssueCommentListByService_594305 = ref object of OpenApiRestCall_593425
proc url_ApiIssueCommentListByService_594307(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId"),
               (kind: ConstantSegment, value: "/comments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueCommentListByService_594306(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all comments for the Issue associated with the specified API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594308 = path.getOrDefault("resourceGroupName")
  valid_594308 = validateParameter(valid_594308, JString, required = true,
                                 default = nil)
  if valid_594308 != nil:
    section.add "resourceGroupName", valid_594308
  var valid_594309 = path.getOrDefault("apiId")
  valid_594309 = validateParameter(valid_594309, JString, required = true,
                                 default = nil)
  if valid_594309 != nil:
    section.add "apiId", valid_594309
  var valid_594310 = path.getOrDefault("issueId")
  valid_594310 = validateParameter(valid_594310, JString, required = true,
                                 default = nil)
  if valid_594310 != nil:
    section.add "issueId", valid_594310
  var valid_594311 = path.getOrDefault("subscriptionId")
  valid_594311 = validateParameter(valid_594311, JString, required = true,
                                 default = nil)
  if valid_594311 != nil:
    section.add "subscriptionId", valid_594311
  var valid_594312 = path.getOrDefault("serviceName")
  valid_594312 = validateParameter(valid_594312, JString, required = true,
                                 default = nil)
  if valid_594312 != nil:
    section.add "serviceName", valid_594312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |userId | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594313 = query.getOrDefault("api-version")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "api-version", valid_594313
  var valid_594314 = query.getOrDefault("$top")
  valid_594314 = validateParameter(valid_594314, JInt, required = false, default = nil)
  if valid_594314 != nil:
    section.add "$top", valid_594314
  var valid_594315 = query.getOrDefault("$skip")
  valid_594315 = validateParameter(valid_594315, JInt, required = false, default = nil)
  if valid_594315 != nil:
    section.add "$skip", valid_594315
  var valid_594316 = query.getOrDefault("$filter")
  valid_594316 = validateParameter(valid_594316, JString, required = false,
                                 default = nil)
  if valid_594316 != nil:
    section.add "$filter", valid_594316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594317: Call_ApiIssueCommentListByService_594305; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all comments for the Issue associated with the specified API.
  ## 
  let valid = call_594317.validator(path, query, header, formData, body)
  let scheme = call_594317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594317.url(scheme.get, call_594317.host, call_594317.base,
                         call_594317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594317, url, valid)

proc call*(call_594318: Call_ApiIssueCommentListByService_594305;
          resourceGroupName: string; apiVersion: string; apiId: string;
          issueId: string; subscriptionId: string; serviceName: string; Top: int = 0;
          Skip: int = 0; Filter: string = ""): Recallable =
  ## apiIssueCommentListByService
  ## Lists all comments for the Issue associated with the specified API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |userId | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  var path_594319 = newJObject()
  var query_594320 = newJObject()
  add(path_594319, "resourceGroupName", newJString(resourceGroupName))
  add(query_594320, "api-version", newJString(apiVersion))
  add(path_594319, "apiId", newJString(apiId))
  add(path_594319, "issueId", newJString(issueId))
  add(path_594319, "subscriptionId", newJString(subscriptionId))
  add(query_594320, "$top", newJInt(Top))
  add(query_594320, "$skip", newJInt(Skip))
  add(path_594319, "serviceName", newJString(serviceName))
  add(query_594320, "$filter", newJString(Filter))
  result = call_594318.call(path_594319, query_594320, nil, nil, nil)

var apiIssueCommentListByService* = Call_ApiIssueCommentListByService_594305(
    name: "apiIssueCommentListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/comments",
    validator: validate_ApiIssueCommentListByService_594306, base: "",
    url: url_ApiIssueCommentListByService_594307, schemes: {Scheme.Https})
type
  Call_ApiIssueCommentCreateOrUpdate_594335 = ref object of OpenApiRestCall_593425
proc url_ApiIssueCommentCreateOrUpdate_594337(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueCommentCreateOrUpdate_594336(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Comment for the Issue in an API or updates an existing one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   commentId: JString (required)
  ##            : Comment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594338 = path.getOrDefault("resourceGroupName")
  valid_594338 = validateParameter(valid_594338, JString, required = true,
                                 default = nil)
  if valid_594338 != nil:
    section.add "resourceGroupName", valid_594338
  var valid_594339 = path.getOrDefault("apiId")
  valid_594339 = validateParameter(valid_594339, JString, required = true,
                                 default = nil)
  if valid_594339 != nil:
    section.add "apiId", valid_594339
  var valid_594340 = path.getOrDefault("issueId")
  valid_594340 = validateParameter(valid_594340, JString, required = true,
                                 default = nil)
  if valid_594340 != nil:
    section.add "issueId", valid_594340
  var valid_594341 = path.getOrDefault("subscriptionId")
  valid_594341 = validateParameter(valid_594341, JString, required = true,
                                 default = nil)
  if valid_594341 != nil:
    section.add "subscriptionId", valid_594341
  var valid_594342 = path.getOrDefault("commentId")
  valid_594342 = validateParameter(valid_594342, JString, required = true,
                                 default = nil)
  if valid_594342 != nil:
    section.add "commentId", valid_594342
  var valid_594343 = path.getOrDefault("serviceName")
  valid_594343 = validateParameter(valid_594343, JString, required = true,
                                 default = nil)
  if valid_594343 != nil:
    section.add "serviceName", valid_594343
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594344 = query.getOrDefault("api-version")
  valid_594344 = validateParameter(valid_594344, JString, required = true,
                                 default = nil)
  if valid_594344 != nil:
    section.add "api-version", valid_594344
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_594345 = header.getOrDefault("If-Match")
  valid_594345 = validateParameter(valid_594345, JString, required = false,
                                 default = nil)
  if valid_594345 != nil:
    section.add "If-Match", valid_594345
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

proc call*(call_594347: Call_ApiIssueCommentCreateOrUpdate_594335; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Comment for the Issue in an API or updates an existing one.
  ## 
  let valid = call_594347.validator(path, query, header, formData, body)
  let scheme = call_594347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594347.url(scheme.get, call_594347.host, call_594347.base,
                         call_594347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594347, url, valid)

proc call*(call_594348: Call_ApiIssueCommentCreateOrUpdate_594335;
          resourceGroupName: string; apiVersion: string; apiId: string;
          issueId: string; subscriptionId: string; commentId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## apiIssueCommentCreateOrUpdate
  ## Creates a new Comment for the Issue in an API or updates an existing one.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   commentId: string (required)
  ##            : Comment identifier within an Issue. Must be unique in the current Issue.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594349 = newJObject()
  var query_594350 = newJObject()
  var body_594351 = newJObject()
  add(path_594349, "resourceGroupName", newJString(resourceGroupName))
  add(query_594350, "api-version", newJString(apiVersion))
  add(path_594349, "apiId", newJString(apiId))
  add(path_594349, "issueId", newJString(issueId))
  add(path_594349, "subscriptionId", newJString(subscriptionId))
  add(path_594349, "commentId", newJString(commentId))
  if parameters != nil:
    body_594351 = parameters
  add(path_594349, "serviceName", newJString(serviceName))
  result = call_594348.call(path_594349, query_594350, nil, nil, body_594351)

var apiIssueCommentCreateOrUpdate* = Call_ApiIssueCommentCreateOrUpdate_594335(
    name: "apiIssueCommentCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/comments/{commentId}",
    validator: validate_ApiIssueCommentCreateOrUpdate_594336, base: "",
    url: url_ApiIssueCommentCreateOrUpdate_594337, schemes: {Scheme.Https})
type
  Call_ApiIssueCommentGetEntityTag_594367 = ref object of OpenApiRestCall_593425
proc url_ApiIssueCommentGetEntityTag_594369(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueCommentGetEntityTag_594368(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the issue Comment for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   commentId: JString (required)
  ##            : Comment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594370 = path.getOrDefault("resourceGroupName")
  valid_594370 = validateParameter(valid_594370, JString, required = true,
                                 default = nil)
  if valid_594370 != nil:
    section.add "resourceGroupName", valid_594370
  var valid_594371 = path.getOrDefault("apiId")
  valid_594371 = validateParameter(valid_594371, JString, required = true,
                                 default = nil)
  if valid_594371 != nil:
    section.add "apiId", valid_594371
  var valid_594372 = path.getOrDefault("issueId")
  valid_594372 = validateParameter(valid_594372, JString, required = true,
                                 default = nil)
  if valid_594372 != nil:
    section.add "issueId", valid_594372
  var valid_594373 = path.getOrDefault("subscriptionId")
  valid_594373 = validateParameter(valid_594373, JString, required = true,
                                 default = nil)
  if valid_594373 != nil:
    section.add "subscriptionId", valid_594373
  var valid_594374 = path.getOrDefault("commentId")
  valid_594374 = validateParameter(valid_594374, JString, required = true,
                                 default = nil)
  if valid_594374 != nil:
    section.add "commentId", valid_594374
  var valid_594375 = path.getOrDefault("serviceName")
  valid_594375 = validateParameter(valid_594375, JString, required = true,
                                 default = nil)
  if valid_594375 != nil:
    section.add "serviceName", valid_594375
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594376 = query.getOrDefault("api-version")
  valid_594376 = validateParameter(valid_594376, JString, required = true,
                                 default = nil)
  if valid_594376 != nil:
    section.add "api-version", valid_594376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594377: Call_ApiIssueCommentGetEntityTag_594367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the issue Comment for an API specified by its identifier.
  ## 
  let valid = call_594377.validator(path, query, header, formData, body)
  let scheme = call_594377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594377.url(scheme.get, call_594377.host, call_594377.base,
                         call_594377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594377, url, valid)

proc call*(call_594378: Call_ApiIssueCommentGetEntityTag_594367;
          resourceGroupName: string; apiVersion: string; apiId: string;
          issueId: string; subscriptionId: string; commentId: string;
          serviceName: string): Recallable =
  ## apiIssueCommentGetEntityTag
  ## Gets the entity state (Etag) version of the issue Comment for an API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   commentId: string (required)
  ##            : Comment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594379 = newJObject()
  var query_594380 = newJObject()
  add(path_594379, "resourceGroupName", newJString(resourceGroupName))
  add(query_594380, "api-version", newJString(apiVersion))
  add(path_594379, "apiId", newJString(apiId))
  add(path_594379, "issueId", newJString(issueId))
  add(path_594379, "subscriptionId", newJString(subscriptionId))
  add(path_594379, "commentId", newJString(commentId))
  add(path_594379, "serviceName", newJString(serviceName))
  result = call_594378.call(path_594379, query_594380, nil, nil, nil)

var apiIssueCommentGetEntityTag* = Call_ApiIssueCommentGetEntityTag_594367(
    name: "apiIssueCommentGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/comments/{commentId}",
    validator: validate_ApiIssueCommentGetEntityTag_594368, base: "",
    url: url_ApiIssueCommentGetEntityTag_594369, schemes: {Scheme.Https})
type
  Call_ApiIssueCommentGet_594321 = ref object of OpenApiRestCall_593425
proc url_ApiIssueCommentGet_594323(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueCommentGet_594322(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the details of the issue Comment for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   commentId: JString (required)
  ##            : Comment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594324 = path.getOrDefault("resourceGroupName")
  valid_594324 = validateParameter(valid_594324, JString, required = true,
                                 default = nil)
  if valid_594324 != nil:
    section.add "resourceGroupName", valid_594324
  var valid_594325 = path.getOrDefault("apiId")
  valid_594325 = validateParameter(valid_594325, JString, required = true,
                                 default = nil)
  if valid_594325 != nil:
    section.add "apiId", valid_594325
  var valid_594326 = path.getOrDefault("issueId")
  valid_594326 = validateParameter(valid_594326, JString, required = true,
                                 default = nil)
  if valid_594326 != nil:
    section.add "issueId", valid_594326
  var valid_594327 = path.getOrDefault("subscriptionId")
  valid_594327 = validateParameter(valid_594327, JString, required = true,
                                 default = nil)
  if valid_594327 != nil:
    section.add "subscriptionId", valid_594327
  var valid_594328 = path.getOrDefault("commentId")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "commentId", valid_594328
  var valid_594329 = path.getOrDefault("serviceName")
  valid_594329 = validateParameter(valid_594329, JString, required = true,
                                 default = nil)
  if valid_594329 != nil:
    section.add "serviceName", valid_594329
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594330 = query.getOrDefault("api-version")
  valid_594330 = validateParameter(valid_594330, JString, required = true,
                                 default = nil)
  if valid_594330 != nil:
    section.add "api-version", valid_594330
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594331: Call_ApiIssueCommentGet_594321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the issue Comment for an API specified by its identifier.
  ## 
  let valid = call_594331.validator(path, query, header, formData, body)
  let scheme = call_594331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594331.url(scheme.get, call_594331.host, call_594331.base,
                         call_594331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594331, url, valid)

proc call*(call_594332: Call_ApiIssueCommentGet_594321; resourceGroupName: string;
          apiVersion: string; apiId: string; issueId: string; subscriptionId: string;
          commentId: string; serviceName: string): Recallable =
  ## apiIssueCommentGet
  ## Gets the details of the issue Comment for an API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   commentId: string (required)
  ##            : Comment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594333 = newJObject()
  var query_594334 = newJObject()
  add(path_594333, "resourceGroupName", newJString(resourceGroupName))
  add(query_594334, "api-version", newJString(apiVersion))
  add(path_594333, "apiId", newJString(apiId))
  add(path_594333, "issueId", newJString(issueId))
  add(path_594333, "subscriptionId", newJString(subscriptionId))
  add(path_594333, "commentId", newJString(commentId))
  add(path_594333, "serviceName", newJString(serviceName))
  result = call_594332.call(path_594333, query_594334, nil, nil, nil)

var apiIssueCommentGet* = Call_ApiIssueCommentGet_594321(
    name: "apiIssueCommentGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/comments/{commentId}",
    validator: validate_ApiIssueCommentGet_594322, base: "",
    url: url_ApiIssueCommentGet_594323, schemes: {Scheme.Https})
type
  Call_ApiIssueCommentDelete_594352 = ref object of OpenApiRestCall_593425
proc url_ApiIssueCommentDelete_594354(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "issueId" in path, "`issueId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/issues/"),
               (kind: VariableSegment, value: "issueId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiIssueCommentDelete_594353(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified comment from an Issue.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   commentId: JString (required)
  ##            : Comment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594355 = path.getOrDefault("resourceGroupName")
  valid_594355 = validateParameter(valid_594355, JString, required = true,
                                 default = nil)
  if valid_594355 != nil:
    section.add "resourceGroupName", valid_594355
  var valid_594356 = path.getOrDefault("apiId")
  valid_594356 = validateParameter(valid_594356, JString, required = true,
                                 default = nil)
  if valid_594356 != nil:
    section.add "apiId", valid_594356
  var valid_594357 = path.getOrDefault("issueId")
  valid_594357 = validateParameter(valid_594357, JString, required = true,
                                 default = nil)
  if valid_594357 != nil:
    section.add "issueId", valid_594357
  var valid_594358 = path.getOrDefault("subscriptionId")
  valid_594358 = validateParameter(valid_594358, JString, required = true,
                                 default = nil)
  if valid_594358 != nil:
    section.add "subscriptionId", valid_594358
  var valid_594359 = path.getOrDefault("commentId")
  valid_594359 = validateParameter(valid_594359, JString, required = true,
                                 default = nil)
  if valid_594359 != nil:
    section.add "commentId", valid_594359
  var valid_594360 = path.getOrDefault("serviceName")
  valid_594360 = validateParameter(valid_594360, JString, required = true,
                                 default = nil)
  if valid_594360 != nil:
    section.add "serviceName", valid_594360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594361 = query.getOrDefault("api-version")
  valid_594361 = validateParameter(valid_594361, JString, required = true,
                                 default = nil)
  if valid_594361 != nil:
    section.add "api-version", valid_594361
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594362 = header.getOrDefault("If-Match")
  valid_594362 = validateParameter(valid_594362, JString, required = true,
                                 default = nil)
  if valid_594362 != nil:
    section.add "If-Match", valid_594362
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594363: Call_ApiIssueCommentDelete_594352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified comment from an Issue.
  ## 
  let valid = call_594363.validator(path, query, header, formData, body)
  let scheme = call_594363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594363.url(scheme.get, call_594363.host, call_594363.base,
                         call_594363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594363, url, valid)

proc call*(call_594364: Call_ApiIssueCommentDelete_594352;
          resourceGroupName: string; apiVersion: string; apiId: string;
          issueId: string; subscriptionId: string; commentId: string;
          serviceName: string): Recallable =
  ## apiIssueCommentDelete
  ## Deletes the specified comment from an Issue.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   commentId: string (required)
  ##            : Comment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594365 = newJObject()
  var query_594366 = newJObject()
  add(path_594365, "resourceGroupName", newJString(resourceGroupName))
  add(query_594366, "api-version", newJString(apiVersion))
  add(path_594365, "apiId", newJString(apiId))
  add(path_594365, "issueId", newJString(issueId))
  add(path_594365, "subscriptionId", newJString(subscriptionId))
  add(path_594365, "commentId", newJString(commentId))
  add(path_594365, "serviceName", newJString(serviceName))
  result = call_594364.call(path_594365, query_594366, nil, nil, nil)

var apiIssueCommentDelete* = Call_ApiIssueCommentDelete_594352(
    name: "apiIssueCommentDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/comments/{commentId}",
    validator: validate_ApiIssueCommentDelete_594353, base: "",
    url: url_ApiIssueCommentDelete_594354, schemes: {Scheme.Https})
type
  Call_ApiOperationListByApi_594381 = ref object of OpenApiRestCall_593425
proc url_ApiOperationListByApi_594383(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationListByApi_594382(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of the operations for the specified API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594384 = path.getOrDefault("resourceGroupName")
  valid_594384 = validateParameter(valid_594384, JString, required = true,
                                 default = nil)
  if valid_594384 != nil:
    section.add "resourceGroupName", valid_594384
  var valid_594385 = path.getOrDefault("apiId")
  valid_594385 = validateParameter(valid_594385, JString, required = true,
                                 default = nil)
  if valid_594385 != nil:
    section.add "apiId", valid_594385
  var valid_594386 = path.getOrDefault("subscriptionId")
  valid_594386 = validateParameter(valid_594386, JString, required = true,
                                 default = nil)
  if valid_594386 != nil:
    section.add "subscriptionId", valid_594386
  var valid_594387 = path.getOrDefault("serviceName")
  valid_594387 = validateParameter(valid_594387, JString, required = true,
                                 default = nil)
  if valid_594387 != nil:
    section.add "serviceName", valid_594387
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   tags: JString
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |method | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |urlTemplate | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594388 = query.getOrDefault("api-version")
  valid_594388 = validateParameter(valid_594388, JString, required = true,
                                 default = nil)
  if valid_594388 != nil:
    section.add "api-version", valid_594388
  var valid_594389 = query.getOrDefault("$top")
  valid_594389 = validateParameter(valid_594389, JInt, required = false, default = nil)
  if valid_594389 != nil:
    section.add "$top", valid_594389
  var valid_594390 = query.getOrDefault("$skip")
  valid_594390 = validateParameter(valid_594390, JInt, required = false, default = nil)
  if valid_594390 != nil:
    section.add "$skip", valid_594390
  var valid_594391 = query.getOrDefault("tags")
  valid_594391 = validateParameter(valid_594391, JString, required = false,
                                 default = nil)
  if valid_594391 != nil:
    section.add "tags", valid_594391
  var valid_594392 = query.getOrDefault("$filter")
  valid_594392 = validateParameter(valid_594392, JString, required = false,
                                 default = nil)
  if valid_594392 != nil:
    section.add "$filter", valid_594392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594393: Call_ApiOperationListByApi_594381; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of the operations for the specified API.
  ## 
  let valid = call_594393.validator(path, query, header, formData, body)
  let scheme = call_594393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594393.url(scheme.get, call_594393.host, call_594393.base,
                         call_594393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594393, url, valid)

proc call*(call_594394: Call_ApiOperationListByApi_594381;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; Top: int = 0; Skip: int = 0;
          tags: string = ""; Filter: string = ""): Recallable =
  ## apiOperationListByApi
  ## Lists a collection of the operations for the specified API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   tags: string
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |method | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |urlTemplate | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  var path_594395 = newJObject()
  var query_594396 = newJObject()
  add(path_594395, "resourceGroupName", newJString(resourceGroupName))
  add(query_594396, "api-version", newJString(apiVersion))
  add(path_594395, "apiId", newJString(apiId))
  add(path_594395, "subscriptionId", newJString(subscriptionId))
  add(query_594396, "$top", newJInt(Top))
  add(query_594396, "$skip", newJInt(Skip))
  add(query_594396, "tags", newJString(tags))
  add(path_594395, "serviceName", newJString(serviceName))
  add(query_594396, "$filter", newJString(Filter))
  result = call_594394.call(path_594395, query_594396, nil, nil, nil)

var apiOperationListByApi* = Call_ApiOperationListByApi_594381(
    name: "apiOperationListByApi", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations",
    validator: validate_ApiOperationListByApi_594382, base: "",
    url: url_ApiOperationListByApi_594383, schemes: {Scheme.Https})
type
  Call_ApiOperationCreateOrUpdate_594410 = ref object of OpenApiRestCall_593425
proc url_ApiOperationCreateOrUpdate_594412(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationCreateOrUpdate_594411(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new operation in the API or updates an existing one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594413 = path.getOrDefault("resourceGroupName")
  valid_594413 = validateParameter(valid_594413, JString, required = true,
                                 default = nil)
  if valid_594413 != nil:
    section.add "resourceGroupName", valid_594413
  var valid_594414 = path.getOrDefault("apiId")
  valid_594414 = validateParameter(valid_594414, JString, required = true,
                                 default = nil)
  if valid_594414 != nil:
    section.add "apiId", valid_594414
  var valid_594415 = path.getOrDefault("subscriptionId")
  valid_594415 = validateParameter(valid_594415, JString, required = true,
                                 default = nil)
  if valid_594415 != nil:
    section.add "subscriptionId", valid_594415
  var valid_594416 = path.getOrDefault("serviceName")
  valid_594416 = validateParameter(valid_594416, JString, required = true,
                                 default = nil)
  if valid_594416 != nil:
    section.add "serviceName", valid_594416
  var valid_594417 = path.getOrDefault("operationId")
  valid_594417 = validateParameter(valid_594417, JString, required = true,
                                 default = nil)
  if valid_594417 != nil:
    section.add "operationId", valid_594417
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594418 = query.getOrDefault("api-version")
  valid_594418 = validateParameter(valid_594418, JString, required = true,
                                 default = nil)
  if valid_594418 != nil:
    section.add "api-version", valid_594418
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_594419 = header.getOrDefault("If-Match")
  valid_594419 = validateParameter(valid_594419, JString, required = false,
                                 default = nil)
  if valid_594419 != nil:
    section.add "If-Match", valid_594419
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

proc call*(call_594421: Call_ApiOperationCreateOrUpdate_594410; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new operation in the API or updates an existing one.
  ## 
  let valid = call_594421.validator(path, query, header, formData, body)
  let scheme = call_594421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594421.url(scheme.get, call_594421.host, call_594421.base,
                         call_594421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594421, url, valid)

proc call*(call_594422: Call_ApiOperationCreateOrUpdate_594410;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; parameters: JsonNode; serviceName: string;
          operationId: string): Recallable =
  ## apiOperationCreateOrUpdate
  ## Creates a new operation in the API or updates an existing one.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_594423 = newJObject()
  var query_594424 = newJObject()
  var body_594425 = newJObject()
  add(path_594423, "resourceGroupName", newJString(resourceGroupName))
  add(query_594424, "api-version", newJString(apiVersion))
  add(path_594423, "apiId", newJString(apiId))
  add(path_594423, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594425 = parameters
  add(path_594423, "serviceName", newJString(serviceName))
  add(path_594423, "operationId", newJString(operationId))
  result = call_594422.call(path_594423, query_594424, nil, nil, body_594425)

var apiOperationCreateOrUpdate* = Call_ApiOperationCreateOrUpdate_594410(
    name: "apiOperationCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationCreateOrUpdate_594411, base: "",
    url: url_ApiOperationCreateOrUpdate_594412, schemes: {Scheme.Https})
type
  Call_ApiOperationGetEntityTag_594440 = ref object of OpenApiRestCall_593425
proc url_ApiOperationGetEntityTag_594442(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationGetEntityTag_594441(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the API operation specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594443 = path.getOrDefault("resourceGroupName")
  valid_594443 = validateParameter(valid_594443, JString, required = true,
                                 default = nil)
  if valid_594443 != nil:
    section.add "resourceGroupName", valid_594443
  var valid_594444 = path.getOrDefault("apiId")
  valid_594444 = validateParameter(valid_594444, JString, required = true,
                                 default = nil)
  if valid_594444 != nil:
    section.add "apiId", valid_594444
  var valid_594445 = path.getOrDefault("subscriptionId")
  valid_594445 = validateParameter(valid_594445, JString, required = true,
                                 default = nil)
  if valid_594445 != nil:
    section.add "subscriptionId", valid_594445
  var valid_594446 = path.getOrDefault("serviceName")
  valid_594446 = validateParameter(valid_594446, JString, required = true,
                                 default = nil)
  if valid_594446 != nil:
    section.add "serviceName", valid_594446
  var valid_594447 = path.getOrDefault("operationId")
  valid_594447 = validateParameter(valid_594447, JString, required = true,
                                 default = nil)
  if valid_594447 != nil:
    section.add "operationId", valid_594447
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594448 = query.getOrDefault("api-version")
  valid_594448 = validateParameter(valid_594448, JString, required = true,
                                 default = nil)
  if valid_594448 != nil:
    section.add "api-version", valid_594448
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594449: Call_ApiOperationGetEntityTag_594440; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the API operation specified by its identifier.
  ## 
  let valid = call_594449.validator(path, query, header, formData, body)
  let scheme = call_594449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594449.url(scheme.get, call_594449.host, call_594449.base,
                         call_594449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594449, url, valid)

proc call*(call_594450: Call_ApiOperationGetEntityTag_594440;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; operationId: string): Recallable =
  ## apiOperationGetEntityTag
  ## Gets the entity state (Etag) version of the API operation specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_594451 = newJObject()
  var query_594452 = newJObject()
  add(path_594451, "resourceGroupName", newJString(resourceGroupName))
  add(query_594452, "api-version", newJString(apiVersion))
  add(path_594451, "apiId", newJString(apiId))
  add(path_594451, "subscriptionId", newJString(subscriptionId))
  add(path_594451, "serviceName", newJString(serviceName))
  add(path_594451, "operationId", newJString(operationId))
  result = call_594450.call(path_594451, query_594452, nil, nil, nil)

var apiOperationGetEntityTag* = Call_ApiOperationGetEntityTag_594440(
    name: "apiOperationGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationGetEntityTag_594441, base: "",
    url: url_ApiOperationGetEntityTag_594442, schemes: {Scheme.Https})
type
  Call_ApiOperationGet_594397 = ref object of OpenApiRestCall_593425
proc url_ApiOperationGet_594399(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationGet_594398(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the details of the API Operation specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594400 = path.getOrDefault("resourceGroupName")
  valid_594400 = validateParameter(valid_594400, JString, required = true,
                                 default = nil)
  if valid_594400 != nil:
    section.add "resourceGroupName", valid_594400
  var valid_594401 = path.getOrDefault("apiId")
  valid_594401 = validateParameter(valid_594401, JString, required = true,
                                 default = nil)
  if valid_594401 != nil:
    section.add "apiId", valid_594401
  var valid_594402 = path.getOrDefault("subscriptionId")
  valid_594402 = validateParameter(valid_594402, JString, required = true,
                                 default = nil)
  if valid_594402 != nil:
    section.add "subscriptionId", valid_594402
  var valid_594403 = path.getOrDefault("serviceName")
  valid_594403 = validateParameter(valid_594403, JString, required = true,
                                 default = nil)
  if valid_594403 != nil:
    section.add "serviceName", valid_594403
  var valid_594404 = path.getOrDefault("operationId")
  valid_594404 = validateParameter(valid_594404, JString, required = true,
                                 default = nil)
  if valid_594404 != nil:
    section.add "operationId", valid_594404
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594405 = query.getOrDefault("api-version")
  valid_594405 = validateParameter(valid_594405, JString, required = true,
                                 default = nil)
  if valid_594405 != nil:
    section.add "api-version", valid_594405
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594406: Call_ApiOperationGet_594397; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the API Operation specified by its identifier.
  ## 
  let valid = call_594406.validator(path, query, header, formData, body)
  let scheme = call_594406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594406.url(scheme.get, call_594406.host, call_594406.base,
                         call_594406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594406, url, valid)

proc call*(call_594407: Call_ApiOperationGet_594397; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string; operationId: string): Recallable =
  ## apiOperationGet
  ## Gets the details of the API Operation specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_594408 = newJObject()
  var query_594409 = newJObject()
  add(path_594408, "resourceGroupName", newJString(resourceGroupName))
  add(query_594409, "api-version", newJString(apiVersion))
  add(path_594408, "apiId", newJString(apiId))
  add(path_594408, "subscriptionId", newJString(subscriptionId))
  add(path_594408, "serviceName", newJString(serviceName))
  add(path_594408, "operationId", newJString(operationId))
  result = call_594407.call(path_594408, query_594409, nil, nil, nil)

var apiOperationGet* = Call_ApiOperationGet_594397(name: "apiOperationGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationGet_594398, base: "", url: url_ApiOperationGet_594399,
    schemes: {Scheme.Https})
type
  Call_ApiOperationUpdate_594453 = ref object of OpenApiRestCall_593425
proc url_ApiOperationUpdate_594455(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationUpdate_594454(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the details of the operation in the API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594456 = path.getOrDefault("resourceGroupName")
  valid_594456 = validateParameter(valid_594456, JString, required = true,
                                 default = nil)
  if valid_594456 != nil:
    section.add "resourceGroupName", valid_594456
  var valid_594457 = path.getOrDefault("apiId")
  valid_594457 = validateParameter(valid_594457, JString, required = true,
                                 default = nil)
  if valid_594457 != nil:
    section.add "apiId", valid_594457
  var valid_594458 = path.getOrDefault("subscriptionId")
  valid_594458 = validateParameter(valid_594458, JString, required = true,
                                 default = nil)
  if valid_594458 != nil:
    section.add "subscriptionId", valid_594458
  var valid_594459 = path.getOrDefault("serviceName")
  valid_594459 = validateParameter(valid_594459, JString, required = true,
                                 default = nil)
  if valid_594459 != nil:
    section.add "serviceName", valid_594459
  var valid_594460 = path.getOrDefault("operationId")
  valid_594460 = validateParameter(valid_594460, JString, required = true,
                                 default = nil)
  if valid_594460 != nil:
    section.add "operationId", valid_594460
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594461 = query.getOrDefault("api-version")
  valid_594461 = validateParameter(valid_594461, JString, required = true,
                                 default = nil)
  if valid_594461 != nil:
    section.add "api-version", valid_594461
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594462 = header.getOrDefault("If-Match")
  valid_594462 = validateParameter(valid_594462, JString, required = true,
                                 default = nil)
  if valid_594462 != nil:
    section.add "If-Match", valid_594462
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : API Operation Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594464: Call_ApiOperationUpdate_594453; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the operation in the API specified by its identifier.
  ## 
  let valid = call_594464.validator(path, query, header, formData, body)
  let scheme = call_594464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594464.url(scheme.get, call_594464.host, call_594464.base,
                         call_594464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594464, url, valid)

proc call*(call_594465: Call_ApiOperationUpdate_594453; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string; operationId: string): Recallable =
  ## apiOperationUpdate
  ## Updates the details of the operation in the API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : API Operation Update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_594466 = newJObject()
  var query_594467 = newJObject()
  var body_594468 = newJObject()
  add(path_594466, "resourceGroupName", newJString(resourceGroupName))
  add(query_594467, "api-version", newJString(apiVersion))
  add(path_594466, "apiId", newJString(apiId))
  add(path_594466, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594468 = parameters
  add(path_594466, "serviceName", newJString(serviceName))
  add(path_594466, "operationId", newJString(operationId))
  result = call_594465.call(path_594466, query_594467, nil, nil, body_594468)

var apiOperationUpdate* = Call_ApiOperationUpdate_594453(
    name: "apiOperationUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationUpdate_594454, base: "",
    url: url_ApiOperationUpdate_594455, schemes: {Scheme.Https})
type
  Call_ApiOperationDelete_594426 = ref object of OpenApiRestCall_593425
proc url_ApiOperationDelete_594428(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationDelete_594427(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the specified operation in the API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594429 = path.getOrDefault("resourceGroupName")
  valid_594429 = validateParameter(valid_594429, JString, required = true,
                                 default = nil)
  if valid_594429 != nil:
    section.add "resourceGroupName", valid_594429
  var valid_594430 = path.getOrDefault("apiId")
  valid_594430 = validateParameter(valid_594430, JString, required = true,
                                 default = nil)
  if valid_594430 != nil:
    section.add "apiId", valid_594430
  var valid_594431 = path.getOrDefault("subscriptionId")
  valid_594431 = validateParameter(valid_594431, JString, required = true,
                                 default = nil)
  if valid_594431 != nil:
    section.add "subscriptionId", valid_594431
  var valid_594432 = path.getOrDefault("serviceName")
  valid_594432 = validateParameter(valid_594432, JString, required = true,
                                 default = nil)
  if valid_594432 != nil:
    section.add "serviceName", valid_594432
  var valid_594433 = path.getOrDefault("operationId")
  valid_594433 = validateParameter(valid_594433, JString, required = true,
                                 default = nil)
  if valid_594433 != nil:
    section.add "operationId", valid_594433
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594434 = query.getOrDefault("api-version")
  valid_594434 = validateParameter(valid_594434, JString, required = true,
                                 default = nil)
  if valid_594434 != nil:
    section.add "api-version", valid_594434
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594435 = header.getOrDefault("If-Match")
  valid_594435 = validateParameter(valid_594435, JString, required = true,
                                 default = nil)
  if valid_594435 != nil:
    section.add "If-Match", valid_594435
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594436: Call_ApiOperationDelete_594426; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified operation in the API.
  ## 
  let valid = call_594436.validator(path, query, header, formData, body)
  let scheme = call_594436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594436.url(scheme.get, call_594436.host, call_594436.base,
                         call_594436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594436, url, valid)

proc call*(call_594437: Call_ApiOperationDelete_594426; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string; operationId: string): Recallable =
  ## apiOperationDelete
  ## Deletes the specified operation in the API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_594438 = newJObject()
  var query_594439 = newJObject()
  add(path_594438, "resourceGroupName", newJString(resourceGroupName))
  add(query_594439, "api-version", newJString(apiVersion))
  add(path_594438, "apiId", newJString(apiId))
  add(path_594438, "subscriptionId", newJString(subscriptionId))
  add(path_594438, "serviceName", newJString(serviceName))
  add(path_594438, "operationId", newJString(operationId))
  result = call_594437.call(path_594438, query_594439, nil, nil, nil)

var apiOperationDelete* = Call_ApiOperationDelete_594426(
    name: "apiOperationDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationDelete_594427, base: "",
    url: url_ApiOperationDelete_594428, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyListByOperation_594469 = ref object of OpenApiRestCall_593425
proc url_ApiOperationPolicyListByOperation_594471(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/policies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationPolicyListByOperation_594470(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of policy configuration at the API Operation level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594472 = path.getOrDefault("resourceGroupName")
  valid_594472 = validateParameter(valid_594472, JString, required = true,
                                 default = nil)
  if valid_594472 != nil:
    section.add "resourceGroupName", valid_594472
  var valid_594473 = path.getOrDefault("apiId")
  valid_594473 = validateParameter(valid_594473, JString, required = true,
                                 default = nil)
  if valid_594473 != nil:
    section.add "apiId", valid_594473
  var valid_594474 = path.getOrDefault("subscriptionId")
  valid_594474 = validateParameter(valid_594474, JString, required = true,
                                 default = nil)
  if valid_594474 != nil:
    section.add "subscriptionId", valid_594474
  var valid_594475 = path.getOrDefault("serviceName")
  valid_594475 = validateParameter(valid_594475, JString, required = true,
                                 default = nil)
  if valid_594475 != nil:
    section.add "serviceName", valid_594475
  var valid_594476 = path.getOrDefault("operationId")
  valid_594476 = validateParameter(valid_594476, JString, required = true,
                                 default = nil)
  if valid_594476 != nil:
    section.add "operationId", valid_594476
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594477 = query.getOrDefault("api-version")
  valid_594477 = validateParameter(valid_594477, JString, required = true,
                                 default = nil)
  if valid_594477 != nil:
    section.add "api-version", valid_594477
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594478: Call_ApiOperationPolicyListByOperation_594469;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the list of policy configuration at the API Operation level.
  ## 
  let valid = call_594478.validator(path, query, header, formData, body)
  let scheme = call_594478.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594478.url(scheme.get, call_594478.host, call_594478.base,
                         call_594478.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594478, url, valid)

proc call*(call_594479: Call_ApiOperationPolicyListByOperation_594469;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; operationId: string): Recallable =
  ## apiOperationPolicyListByOperation
  ## Get the list of policy configuration at the API Operation level.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_594480 = newJObject()
  var query_594481 = newJObject()
  add(path_594480, "resourceGroupName", newJString(resourceGroupName))
  add(query_594481, "api-version", newJString(apiVersion))
  add(path_594480, "apiId", newJString(apiId))
  add(path_594480, "subscriptionId", newJString(subscriptionId))
  add(path_594480, "serviceName", newJString(serviceName))
  add(path_594480, "operationId", newJString(operationId))
  result = call_594479.call(path_594480, query_594481, nil, nil, nil)

var apiOperationPolicyListByOperation* = Call_ApiOperationPolicyListByOperation_594469(
    name: "apiOperationPolicyListByOperation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/policies",
    validator: validate_ApiOperationPolicyListByOperation_594470, base: "",
    url: url_ApiOperationPolicyListByOperation_594471, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyCreateOrUpdate_594509 = ref object of OpenApiRestCall_593425
proc url_ApiOperationPolicyCreateOrUpdate_594511(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationPolicyCreateOrUpdate_594510(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates policy configuration for the API Operation level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594512 = path.getOrDefault("resourceGroupName")
  valid_594512 = validateParameter(valid_594512, JString, required = true,
                                 default = nil)
  if valid_594512 != nil:
    section.add "resourceGroupName", valid_594512
  var valid_594513 = path.getOrDefault("apiId")
  valid_594513 = validateParameter(valid_594513, JString, required = true,
                                 default = nil)
  if valid_594513 != nil:
    section.add "apiId", valid_594513
  var valid_594514 = path.getOrDefault("subscriptionId")
  valid_594514 = validateParameter(valid_594514, JString, required = true,
                                 default = nil)
  if valid_594514 != nil:
    section.add "subscriptionId", valid_594514
  var valid_594515 = path.getOrDefault("policyId")
  valid_594515 = validateParameter(valid_594515, JString, required = true,
                                 default = newJString("policy"))
  if valid_594515 != nil:
    section.add "policyId", valid_594515
  var valid_594516 = path.getOrDefault("serviceName")
  valid_594516 = validateParameter(valid_594516, JString, required = true,
                                 default = nil)
  if valid_594516 != nil:
    section.add "serviceName", valid_594516
  var valid_594517 = path.getOrDefault("operationId")
  valid_594517 = validateParameter(valid_594517, JString, required = true,
                                 default = nil)
  if valid_594517 != nil:
    section.add "operationId", valid_594517
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594518 = query.getOrDefault("api-version")
  valid_594518 = validateParameter(valid_594518, JString, required = true,
                                 default = nil)
  if valid_594518 != nil:
    section.add "api-version", valid_594518
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_594519 = header.getOrDefault("If-Match")
  valid_594519 = validateParameter(valid_594519, JString, required = false,
                                 default = nil)
  if valid_594519 != nil:
    section.add "If-Match", valid_594519
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The policy contents to apply.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594521: Call_ApiOperationPolicyCreateOrUpdate_594509;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates policy configuration for the API Operation level.
  ## 
  let valid = call_594521.validator(path, query, header, formData, body)
  let scheme = call_594521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594521.url(scheme.get, call_594521.host, call_594521.base,
                         call_594521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594521, url, valid)

proc call*(call_594522: Call_ApiOperationPolicyCreateOrUpdate_594509;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; parameters: JsonNode; serviceName: string;
          operationId: string; policyId: string = "policy"): Recallable =
  ## apiOperationPolicyCreateOrUpdate
  ## Creates or updates policy configuration for the API Operation level.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   parameters: JObject (required)
  ##             : The policy contents to apply.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_594523 = newJObject()
  var query_594524 = newJObject()
  var body_594525 = newJObject()
  add(path_594523, "resourceGroupName", newJString(resourceGroupName))
  add(query_594524, "api-version", newJString(apiVersion))
  add(path_594523, "apiId", newJString(apiId))
  add(path_594523, "subscriptionId", newJString(subscriptionId))
  add(path_594523, "policyId", newJString(policyId))
  if parameters != nil:
    body_594525 = parameters
  add(path_594523, "serviceName", newJString(serviceName))
  add(path_594523, "operationId", newJString(operationId))
  result = call_594522.call(path_594523, query_594524, nil, nil, body_594525)

var apiOperationPolicyCreateOrUpdate* = Call_ApiOperationPolicyCreateOrUpdate_594509(
    name: "apiOperationPolicyCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/policies/{policyId}",
    validator: validate_ApiOperationPolicyCreateOrUpdate_594510, base: "",
    url: url_ApiOperationPolicyCreateOrUpdate_594511, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyGetEntityTag_594541 = ref object of OpenApiRestCall_593425
proc url_ApiOperationPolicyGetEntityTag_594543(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationPolicyGetEntityTag_594542(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the API operation policy specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594544 = path.getOrDefault("resourceGroupName")
  valid_594544 = validateParameter(valid_594544, JString, required = true,
                                 default = nil)
  if valid_594544 != nil:
    section.add "resourceGroupName", valid_594544
  var valid_594545 = path.getOrDefault("apiId")
  valid_594545 = validateParameter(valid_594545, JString, required = true,
                                 default = nil)
  if valid_594545 != nil:
    section.add "apiId", valid_594545
  var valid_594546 = path.getOrDefault("subscriptionId")
  valid_594546 = validateParameter(valid_594546, JString, required = true,
                                 default = nil)
  if valid_594546 != nil:
    section.add "subscriptionId", valid_594546
  var valid_594547 = path.getOrDefault("policyId")
  valid_594547 = validateParameter(valid_594547, JString, required = true,
                                 default = newJString("policy"))
  if valid_594547 != nil:
    section.add "policyId", valid_594547
  var valid_594548 = path.getOrDefault("serviceName")
  valid_594548 = validateParameter(valid_594548, JString, required = true,
                                 default = nil)
  if valid_594548 != nil:
    section.add "serviceName", valid_594548
  var valid_594549 = path.getOrDefault("operationId")
  valid_594549 = validateParameter(valid_594549, JString, required = true,
                                 default = nil)
  if valid_594549 != nil:
    section.add "operationId", valid_594549
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594550 = query.getOrDefault("api-version")
  valid_594550 = validateParameter(valid_594550, JString, required = true,
                                 default = nil)
  if valid_594550 != nil:
    section.add "api-version", valid_594550
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594551: Call_ApiOperationPolicyGetEntityTag_594541; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the API operation policy specified by its identifier.
  ## 
  let valid = call_594551.validator(path, query, header, formData, body)
  let scheme = call_594551.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594551.url(scheme.get, call_594551.host, call_594551.base,
                         call_594551.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594551, url, valid)

proc call*(call_594552: Call_ApiOperationPolicyGetEntityTag_594541;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; operationId: string;
          policyId: string = "policy"): Recallable =
  ## apiOperationPolicyGetEntityTag
  ## Gets the entity state (Etag) version of the API operation policy specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_594553 = newJObject()
  var query_594554 = newJObject()
  add(path_594553, "resourceGroupName", newJString(resourceGroupName))
  add(query_594554, "api-version", newJString(apiVersion))
  add(path_594553, "apiId", newJString(apiId))
  add(path_594553, "subscriptionId", newJString(subscriptionId))
  add(path_594553, "policyId", newJString(policyId))
  add(path_594553, "serviceName", newJString(serviceName))
  add(path_594553, "operationId", newJString(operationId))
  result = call_594552.call(path_594553, query_594554, nil, nil, nil)

var apiOperationPolicyGetEntityTag* = Call_ApiOperationPolicyGetEntityTag_594541(
    name: "apiOperationPolicyGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/policies/{policyId}",
    validator: validate_ApiOperationPolicyGetEntityTag_594542, base: "",
    url: url_ApiOperationPolicyGetEntityTag_594543, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyGet_594482 = ref object of OpenApiRestCall_593425
proc url_ApiOperationPolicyGet_594484(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationPolicyGet_594483(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the policy configuration at the API Operation level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594485 = path.getOrDefault("resourceGroupName")
  valid_594485 = validateParameter(valid_594485, JString, required = true,
                                 default = nil)
  if valid_594485 != nil:
    section.add "resourceGroupName", valid_594485
  var valid_594486 = path.getOrDefault("apiId")
  valid_594486 = validateParameter(valid_594486, JString, required = true,
                                 default = nil)
  if valid_594486 != nil:
    section.add "apiId", valid_594486
  var valid_594487 = path.getOrDefault("subscriptionId")
  valid_594487 = validateParameter(valid_594487, JString, required = true,
                                 default = nil)
  if valid_594487 != nil:
    section.add "subscriptionId", valid_594487
  var valid_594501 = path.getOrDefault("policyId")
  valid_594501 = validateParameter(valid_594501, JString, required = true,
                                 default = newJString("policy"))
  if valid_594501 != nil:
    section.add "policyId", valid_594501
  var valid_594502 = path.getOrDefault("serviceName")
  valid_594502 = validateParameter(valid_594502, JString, required = true,
                                 default = nil)
  if valid_594502 != nil:
    section.add "serviceName", valid_594502
  var valid_594503 = path.getOrDefault("operationId")
  valid_594503 = validateParameter(valid_594503, JString, required = true,
                                 default = nil)
  if valid_594503 != nil:
    section.add "operationId", valid_594503
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594504 = query.getOrDefault("api-version")
  valid_594504 = validateParameter(valid_594504, JString, required = true,
                                 default = nil)
  if valid_594504 != nil:
    section.add "api-version", valid_594504
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594505: Call_ApiOperationPolicyGet_594482; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the API Operation level.
  ## 
  let valid = call_594505.validator(path, query, header, formData, body)
  let scheme = call_594505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594505.url(scheme.get, call_594505.host, call_594505.base,
                         call_594505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594505, url, valid)

proc call*(call_594506: Call_ApiOperationPolicyGet_594482;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; operationId: string;
          policyId: string = "policy"): Recallable =
  ## apiOperationPolicyGet
  ## Get the policy configuration at the API Operation level.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_594507 = newJObject()
  var query_594508 = newJObject()
  add(path_594507, "resourceGroupName", newJString(resourceGroupName))
  add(query_594508, "api-version", newJString(apiVersion))
  add(path_594507, "apiId", newJString(apiId))
  add(path_594507, "subscriptionId", newJString(subscriptionId))
  add(path_594507, "policyId", newJString(policyId))
  add(path_594507, "serviceName", newJString(serviceName))
  add(path_594507, "operationId", newJString(operationId))
  result = call_594506.call(path_594507, query_594508, nil, nil, nil)

var apiOperationPolicyGet* = Call_ApiOperationPolicyGet_594482(
    name: "apiOperationPolicyGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/policies/{policyId}",
    validator: validate_ApiOperationPolicyGet_594483, base: "",
    url: url_ApiOperationPolicyGet_594484, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyDelete_594526 = ref object of OpenApiRestCall_593425
proc url_ApiOperationPolicyDelete_594528(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiOperationPolicyDelete_594527(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the policy configuration at the Api Operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594529 = path.getOrDefault("resourceGroupName")
  valid_594529 = validateParameter(valid_594529, JString, required = true,
                                 default = nil)
  if valid_594529 != nil:
    section.add "resourceGroupName", valid_594529
  var valid_594530 = path.getOrDefault("apiId")
  valid_594530 = validateParameter(valid_594530, JString, required = true,
                                 default = nil)
  if valid_594530 != nil:
    section.add "apiId", valid_594530
  var valid_594531 = path.getOrDefault("subscriptionId")
  valid_594531 = validateParameter(valid_594531, JString, required = true,
                                 default = nil)
  if valid_594531 != nil:
    section.add "subscriptionId", valid_594531
  var valid_594532 = path.getOrDefault("policyId")
  valid_594532 = validateParameter(valid_594532, JString, required = true,
                                 default = newJString("policy"))
  if valid_594532 != nil:
    section.add "policyId", valid_594532
  var valid_594533 = path.getOrDefault("serviceName")
  valid_594533 = validateParameter(valid_594533, JString, required = true,
                                 default = nil)
  if valid_594533 != nil:
    section.add "serviceName", valid_594533
  var valid_594534 = path.getOrDefault("operationId")
  valid_594534 = validateParameter(valid_594534, JString, required = true,
                                 default = nil)
  if valid_594534 != nil:
    section.add "operationId", valid_594534
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594535 = query.getOrDefault("api-version")
  valid_594535 = validateParameter(valid_594535, JString, required = true,
                                 default = nil)
  if valid_594535 != nil:
    section.add "api-version", valid_594535
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594536 = header.getOrDefault("If-Match")
  valid_594536 = validateParameter(valid_594536, JString, required = true,
                                 default = nil)
  if valid_594536 != nil:
    section.add "If-Match", valid_594536
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594537: Call_ApiOperationPolicyDelete_594526; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the policy configuration at the Api Operation.
  ## 
  let valid = call_594537.validator(path, query, header, formData, body)
  let scheme = call_594537.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594537.url(scheme.get, call_594537.host, call_594537.base,
                         call_594537.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594537, url, valid)

proc call*(call_594538: Call_ApiOperationPolicyDelete_594526;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; operationId: string;
          policyId: string = "policy"): Recallable =
  ## apiOperationPolicyDelete
  ## Deletes the policy configuration at the Api Operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_594539 = newJObject()
  var query_594540 = newJObject()
  add(path_594539, "resourceGroupName", newJString(resourceGroupName))
  add(query_594540, "api-version", newJString(apiVersion))
  add(path_594539, "apiId", newJString(apiId))
  add(path_594539, "subscriptionId", newJString(subscriptionId))
  add(path_594539, "policyId", newJString(policyId))
  add(path_594539, "serviceName", newJString(serviceName))
  add(path_594539, "operationId", newJString(operationId))
  result = call_594538.call(path_594539, query_594540, nil, nil, nil)

var apiOperationPolicyDelete* = Call_ApiOperationPolicyDelete_594526(
    name: "apiOperationPolicyDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/policies/{policyId}",
    validator: validate_ApiOperationPolicyDelete_594527, base: "",
    url: url_ApiOperationPolicyDelete_594528, schemes: {Scheme.Https})
type
  Call_TagListByOperation_594555 = ref object of OpenApiRestCall_593425
proc url_TagListByOperation_594557(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/tags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagListByOperation_594556(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists all Tags associated with the Operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594558 = path.getOrDefault("resourceGroupName")
  valid_594558 = validateParameter(valid_594558, JString, required = true,
                                 default = nil)
  if valid_594558 != nil:
    section.add "resourceGroupName", valid_594558
  var valid_594559 = path.getOrDefault("apiId")
  valid_594559 = validateParameter(valid_594559, JString, required = true,
                                 default = nil)
  if valid_594559 != nil:
    section.add "apiId", valid_594559
  var valid_594560 = path.getOrDefault("subscriptionId")
  valid_594560 = validateParameter(valid_594560, JString, required = true,
                                 default = nil)
  if valid_594560 != nil:
    section.add "subscriptionId", valid_594560
  var valid_594561 = path.getOrDefault("serviceName")
  valid_594561 = validateParameter(valid_594561, JString, required = true,
                                 default = nil)
  if valid_594561 != nil:
    section.add "serviceName", valid_594561
  var valid_594562 = path.getOrDefault("operationId")
  valid_594562 = validateParameter(valid_594562, JString, required = true,
                                 default = nil)
  if valid_594562 != nil:
    section.add "operationId", valid_594562
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594563 = query.getOrDefault("api-version")
  valid_594563 = validateParameter(valid_594563, JString, required = true,
                                 default = nil)
  if valid_594563 != nil:
    section.add "api-version", valid_594563
  var valid_594564 = query.getOrDefault("$top")
  valid_594564 = validateParameter(valid_594564, JInt, required = false, default = nil)
  if valid_594564 != nil:
    section.add "$top", valid_594564
  var valid_594565 = query.getOrDefault("$skip")
  valid_594565 = validateParameter(valid_594565, JInt, required = false, default = nil)
  if valid_594565 != nil:
    section.add "$skip", valid_594565
  var valid_594566 = query.getOrDefault("$filter")
  valid_594566 = validateParameter(valid_594566, JString, required = false,
                                 default = nil)
  if valid_594566 != nil:
    section.add "$filter", valid_594566
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594567: Call_TagListByOperation_594555; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Tags associated with the Operation.
  ## 
  let valid = call_594567.validator(path, query, header, formData, body)
  let scheme = call_594567.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594567.url(scheme.get, call_594567.host, call_594567.base,
                         call_594567.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594567, url, valid)

proc call*(call_594568: Call_TagListByOperation_594555; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string; operationId: string; Top: int = 0; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## tagListByOperation
  ## Lists all Tags associated with the Operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  var path_594569 = newJObject()
  var query_594570 = newJObject()
  add(path_594569, "resourceGroupName", newJString(resourceGroupName))
  add(query_594570, "api-version", newJString(apiVersion))
  add(path_594569, "apiId", newJString(apiId))
  add(path_594569, "subscriptionId", newJString(subscriptionId))
  add(query_594570, "$top", newJInt(Top))
  add(query_594570, "$skip", newJInt(Skip))
  add(path_594569, "serviceName", newJString(serviceName))
  add(path_594569, "operationId", newJString(operationId))
  add(query_594570, "$filter", newJString(Filter))
  result = call_594568.call(path_594569, query_594570, nil, nil, nil)

var tagListByOperation* = Call_TagListByOperation_594555(
    name: "tagListByOperation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/tags",
    validator: validate_TagListByOperation_594556, base: "",
    url: url_TagListByOperation_594557, schemes: {Scheme.Https})
type
  Call_TagAssignToOperation_594585 = ref object of OpenApiRestCall_593425
proc url_TagAssignToOperation_594587(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagAssignToOperation_594586(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Assign tag to the Operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594588 = path.getOrDefault("tagId")
  valid_594588 = validateParameter(valid_594588, JString, required = true,
                                 default = nil)
  if valid_594588 != nil:
    section.add "tagId", valid_594588
  var valid_594589 = path.getOrDefault("resourceGroupName")
  valid_594589 = validateParameter(valid_594589, JString, required = true,
                                 default = nil)
  if valid_594589 != nil:
    section.add "resourceGroupName", valid_594589
  var valid_594590 = path.getOrDefault("apiId")
  valid_594590 = validateParameter(valid_594590, JString, required = true,
                                 default = nil)
  if valid_594590 != nil:
    section.add "apiId", valid_594590
  var valid_594591 = path.getOrDefault("subscriptionId")
  valid_594591 = validateParameter(valid_594591, JString, required = true,
                                 default = nil)
  if valid_594591 != nil:
    section.add "subscriptionId", valid_594591
  var valid_594592 = path.getOrDefault("serviceName")
  valid_594592 = validateParameter(valid_594592, JString, required = true,
                                 default = nil)
  if valid_594592 != nil:
    section.add "serviceName", valid_594592
  var valid_594593 = path.getOrDefault("operationId")
  valid_594593 = validateParameter(valid_594593, JString, required = true,
                                 default = nil)
  if valid_594593 != nil:
    section.add "operationId", valid_594593
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594594 = query.getOrDefault("api-version")
  valid_594594 = validateParameter(valid_594594, JString, required = true,
                                 default = nil)
  if valid_594594 != nil:
    section.add "api-version", valid_594594
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594595: Call_TagAssignToOperation_594585; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Assign tag to the Operation.
  ## 
  let valid = call_594595.validator(path, query, header, formData, body)
  let scheme = call_594595.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594595.url(scheme.get, call_594595.host, call_594595.base,
                         call_594595.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594595, url, valid)

proc call*(call_594596: Call_TagAssignToOperation_594585; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; operationId: string): Recallable =
  ## tagAssignToOperation
  ## Assign tag to the Operation.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_594597 = newJObject()
  var query_594598 = newJObject()
  add(path_594597, "tagId", newJString(tagId))
  add(path_594597, "resourceGroupName", newJString(resourceGroupName))
  add(query_594598, "api-version", newJString(apiVersion))
  add(path_594597, "apiId", newJString(apiId))
  add(path_594597, "subscriptionId", newJString(subscriptionId))
  add(path_594597, "serviceName", newJString(serviceName))
  add(path_594597, "operationId", newJString(operationId))
  result = call_594596.call(path_594597, query_594598, nil, nil, nil)

var tagAssignToOperation* = Call_TagAssignToOperation_594585(
    name: "tagAssignToOperation", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/tags/{tagId}",
    validator: validate_TagAssignToOperation_594586, base: "",
    url: url_TagAssignToOperation_594587, schemes: {Scheme.Https})
type
  Call_TagGetEntityStateByOperation_594613 = ref object of OpenApiRestCall_593425
proc url_TagGetEntityStateByOperation_594615(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagGetEntityStateByOperation_594614(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state version of the tag specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594616 = path.getOrDefault("tagId")
  valid_594616 = validateParameter(valid_594616, JString, required = true,
                                 default = nil)
  if valid_594616 != nil:
    section.add "tagId", valid_594616
  var valid_594617 = path.getOrDefault("resourceGroupName")
  valid_594617 = validateParameter(valid_594617, JString, required = true,
                                 default = nil)
  if valid_594617 != nil:
    section.add "resourceGroupName", valid_594617
  var valid_594618 = path.getOrDefault("apiId")
  valid_594618 = validateParameter(valid_594618, JString, required = true,
                                 default = nil)
  if valid_594618 != nil:
    section.add "apiId", valid_594618
  var valid_594619 = path.getOrDefault("subscriptionId")
  valid_594619 = validateParameter(valid_594619, JString, required = true,
                                 default = nil)
  if valid_594619 != nil:
    section.add "subscriptionId", valid_594619
  var valid_594620 = path.getOrDefault("serviceName")
  valid_594620 = validateParameter(valid_594620, JString, required = true,
                                 default = nil)
  if valid_594620 != nil:
    section.add "serviceName", valid_594620
  var valid_594621 = path.getOrDefault("operationId")
  valid_594621 = validateParameter(valid_594621, JString, required = true,
                                 default = nil)
  if valid_594621 != nil:
    section.add "operationId", valid_594621
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594622 = query.getOrDefault("api-version")
  valid_594622 = validateParameter(valid_594622, JString, required = true,
                                 default = nil)
  if valid_594622 != nil:
    section.add "api-version", valid_594622
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594623: Call_TagGetEntityStateByOperation_594613; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state version of the tag specified by its identifier.
  ## 
  let valid = call_594623.validator(path, query, header, formData, body)
  let scheme = call_594623.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594623.url(scheme.get, call_594623.host, call_594623.base,
                         call_594623.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594623, url, valid)

proc call*(call_594624: Call_TagGetEntityStateByOperation_594613; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; operationId: string): Recallable =
  ## tagGetEntityStateByOperation
  ## Gets the entity state version of the tag specified by its identifier.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_594625 = newJObject()
  var query_594626 = newJObject()
  add(path_594625, "tagId", newJString(tagId))
  add(path_594625, "resourceGroupName", newJString(resourceGroupName))
  add(query_594626, "api-version", newJString(apiVersion))
  add(path_594625, "apiId", newJString(apiId))
  add(path_594625, "subscriptionId", newJString(subscriptionId))
  add(path_594625, "serviceName", newJString(serviceName))
  add(path_594625, "operationId", newJString(operationId))
  result = call_594624.call(path_594625, query_594626, nil, nil, nil)

var tagGetEntityStateByOperation* = Call_TagGetEntityStateByOperation_594613(
    name: "tagGetEntityStateByOperation", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/tags/{tagId}",
    validator: validate_TagGetEntityStateByOperation_594614, base: "",
    url: url_TagGetEntityStateByOperation_594615, schemes: {Scheme.Https})
type
  Call_TagGetByOperation_594571 = ref object of OpenApiRestCall_593425
proc url_TagGetByOperation_594573(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagGetByOperation_594572(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get tag associated with the Operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594574 = path.getOrDefault("tagId")
  valid_594574 = validateParameter(valid_594574, JString, required = true,
                                 default = nil)
  if valid_594574 != nil:
    section.add "tagId", valid_594574
  var valid_594575 = path.getOrDefault("resourceGroupName")
  valid_594575 = validateParameter(valid_594575, JString, required = true,
                                 default = nil)
  if valid_594575 != nil:
    section.add "resourceGroupName", valid_594575
  var valid_594576 = path.getOrDefault("apiId")
  valid_594576 = validateParameter(valid_594576, JString, required = true,
                                 default = nil)
  if valid_594576 != nil:
    section.add "apiId", valid_594576
  var valid_594577 = path.getOrDefault("subscriptionId")
  valid_594577 = validateParameter(valid_594577, JString, required = true,
                                 default = nil)
  if valid_594577 != nil:
    section.add "subscriptionId", valid_594577
  var valid_594578 = path.getOrDefault("serviceName")
  valid_594578 = validateParameter(valid_594578, JString, required = true,
                                 default = nil)
  if valid_594578 != nil:
    section.add "serviceName", valid_594578
  var valid_594579 = path.getOrDefault("operationId")
  valid_594579 = validateParameter(valid_594579, JString, required = true,
                                 default = nil)
  if valid_594579 != nil:
    section.add "operationId", valid_594579
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594580 = query.getOrDefault("api-version")
  valid_594580 = validateParameter(valid_594580, JString, required = true,
                                 default = nil)
  if valid_594580 != nil:
    section.add "api-version", valid_594580
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594581: Call_TagGetByOperation_594571; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get tag associated with the Operation.
  ## 
  let valid = call_594581.validator(path, query, header, formData, body)
  let scheme = call_594581.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594581.url(scheme.get, call_594581.host, call_594581.base,
                         call_594581.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594581, url, valid)

proc call*(call_594582: Call_TagGetByOperation_594571; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; operationId: string): Recallable =
  ## tagGetByOperation
  ## Get tag associated with the Operation.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_594583 = newJObject()
  var query_594584 = newJObject()
  add(path_594583, "tagId", newJString(tagId))
  add(path_594583, "resourceGroupName", newJString(resourceGroupName))
  add(query_594584, "api-version", newJString(apiVersion))
  add(path_594583, "apiId", newJString(apiId))
  add(path_594583, "subscriptionId", newJString(subscriptionId))
  add(path_594583, "serviceName", newJString(serviceName))
  add(path_594583, "operationId", newJString(operationId))
  result = call_594582.call(path_594583, query_594584, nil, nil, nil)

var tagGetByOperation* = Call_TagGetByOperation_594571(name: "tagGetByOperation",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/tags/{tagId}",
    validator: validate_TagGetByOperation_594572, base: "",
    url: url_TagGetByOperation_594573, schemes: {Scheme.Https})
type
  Call_TagDetachFromOperation_594599 = ref object of OpenApiRestCall_593425
proc url_TagDetachFromOperation_594601(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDetachFromOperation_594600(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Detach the tag from the Operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594602 = path.getOrDefault("tagId")
  valid_594602 = validateParameter(valid_594602, JString, required = true,
                                 default = nil)
  if valid_594602 != nil:
    section.add "tagId", valid_594602
  var valid_594603 = path.getOrDefault("resourceGroupName")
  valid_594603 = validateParameter(valid_594603, JString, required = true,
                                 default = nil)
  if valid_594603 != nil:
    section.add "resourceGroupName", valid_594603
  var valid_594604 = path.getOrDefault("apiId")
  valid_594604 = validateParameter(valid_594604, JString, required = true,
                                 default = nil)
  if valid_594604 != nil:
    section.add "apiId", valid_594604
  var valid_594605 = path.getOrDefault("subscriptionId")
  valid_594605 = validateParameter(valid_594605, JString, required = true,
                                 default = nil)
  if valid_594605 != nil:
    section.add "subscriptionId", valid_594605
  var valid_594606 = path.getOrDefault("serviceName")
  valid_594606 = validateParameter(valid_594606, JString, required = true,
                                 default = nil)
  if valid_594606 != nil:
    section.add "serviceName", valid_594606
  var valid_594607 = path.getOrDefault("operationId")
  valid_594607 = validateParameter(valid_594607, JString, required = true,
                                 default = nil)
  if valid_594607 != nil:
    section.add "operationId", valid_594607
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594608 = query.getOrDefault("api-version")
  valid_594608 = validateParameter(valid_594608, JString, required = true,
                                 default = nil)
  if valid_594608 != nil:
    section.add "api-version", valid_594608
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594609: Call_TagDetachFromOperation_594599; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detach the tag from the Operation.
  ## 
  let valid = call_594609.validator(path, query, header, formData, body)
  let scheme = call_594609.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594609.url(scheme.get, call_594609.host, call_594609.base,
                         call_594609.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594609, url, valid)

proc call*(call_594610: Call_TagDetachFromOperation_594599; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; operationId: string): Recallable =
  ## tagDetachFromOperation
  ## Detach the tag from the Operation.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  var path_594611 = newJObject()
  var query_594612 = newJObject()
  add(path_594611, "tagId", newJString(tagId))
  add(path_594611, "resourceGroupName", newJString(resourceGroupName))
  add(query_594612, "api-version", newJString(apiVersion))
  add(path_594611, "apiId", newJString(apiId))
  add(path_594611, "subscriptionId", newJString(subscriptionId))
  add(path_594611, "serviceName", newJString(serviceName))
  add(path_594611, "operationId", newJString(operationId))
  result = call_594610.call(path_594611, query_594612, nil, nil, nil)

var tagDetachFromOperation* = Call_TagDetachFromOperation_594599(
    name: "tagDetachFromOperation", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/tags/{tagId}",
    validator: validate_TagDetachFromOperation_594600, base: "",
    url: url_TagDetachFromOperation_594601, schemes: {Scheme.Https})
type
  Call_OperationListByTags_594627 = ref object of OpenApiRestCall_593425
proc url_OperationListByTags_594629(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/operationsByTags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationListByTags_594628(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists a collection of operations associated with tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594630 = path.getOrDefault("resourceGroupName")
  valid_594630 = validateParameter(valid_594630, JString, required = true,
                                 default = nil)
  if valid_594630 != nil:
    section.add "resourceGroupName", valid_594630
  var valid_594631 = path.getOrDefault("apiId")
  valid_594631 = validateParameter(valid_594631, JString, required = true,
                                 default = nil)
  if valid_594631 != nil:
    section.add "apiId", valid_594631
  var valid_594632 = path.getOrDefault("subscriptionId")
  valid_594632 = validateParameter(valid_594632, JString, required = true,
                                 default = nil)
  if valid_594632 != nil:
    section.add "subscriptionId", valid_594632
  var valid_594633 = path.getOrDefault("serviceName")
  valid_594633 = validateParameter(valid_594633, JString, required = true,
                                 default = nil)
  if valid_594633 != nil:
    section.add "serviceName", valid_594633
  result.add "path", section
  ## parameters in `query` object:
  ##   includeNotTaggedOperations: JBool
  ##                             : Include not tagged Operations.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |apiName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |method | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |urlTemplate | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  section = newJObject()
  var valid_594634 = query.getOrDefault("includeNotTaggedOperations")
  valid_594634 = validateParameter(valid_594634, JBool, required = false, default = nil)
  if valid_594634 != nil:
    section.add "includeNotTaggedOperations", valid_594634
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594635 = query.getOrDefault("api-version")
  valid_594635 = validateParameter(valid_594635, JString, required = true,
                                 default = nil)
  if valid_594635 != nil:
    section.add "api-version", valid_594635
  var valid_594636 = query.getOrDefault("$top")
  valid_594636 = validateParameter(valid_594636, JInt, required = false, default = nil)
  if valid_594636 != nil:
    section.add "$top", valid_594636
  var valid_594637 = query.getOrDefault("$skip")
  valid_594637 = validateParameter(valid_594637, JInt, required = false, default = nil)
  if valid_594637 != nil:
    section.add "$skip", valid_594637
  var valid_594638 = query.getOrDefault("$filter")
  valid_594638 = validateParameter(valid_594638, JString, required = false,
                                 default = nil)
  if valid_594638 != nil:
    section.add "$filter", valid_594638
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594639: Call_OperationListByTags_594627; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of operations associated with tags.
  ## 
  let valid = call_594639.validator(path, query, header, formData, body)
  let scheme = call_594639.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594639.url(scheme.get, call_594639.host, call_594639.base,
                         call_594639.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594639, url, valid)

proc call*(call_594640: Call_OperationListByTags_594627; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string; includeNotTaggedOperations: bool = false; Top: int = 0;
          Skip: int = 0; Filter: string = ""): Recallable =
  ## operationListByTags
  ## Lists a collection of operations associated with tags.
  ##   includeNotTaggedOperations: bool
  ##                             : Include not tagged Operations.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |apiName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |method | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |urlTemplate | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  var path_594641 = newJObject()
  var query_594642 = newJObject()
  add(query_594642, "includeNotTaggedOperations",
      newJBool(includeNotTaggedOperations))
  add(path_594641, "resourceGroupName", newJString(resourceGroupName))
  add(query_594642, "api-version", newJString(apiVersion))
  add(path_594641, "apiId", newJString(apiId))
  add(path_594641, "subscriptionId", newJString(subscriptionId))
  add(query_594642, "$top", newJInt(Top))
  add(query_594642, "$skip", newJInt(Skip))
  add(path_594641, "serviceName", newJString(serviceName))
  add(query_594642, "$filter", newJString(Filter))
  result = call_594640.call(path_594641, query_594642, nil, nil, nil)

var operationListByTags* = Call_OperationListByTags_594627(
    name: "operationListByTags", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operationsByTags",
    validator: validate_OperationListByTags_594628, base: "",
    url: url_OperationListByTags_594629, schemes: {Scheme.Https})
type
  Call_ApiPolicyListByApi_594643 = ref object of OpenApiRestCall_593425
proc url_ApiPolicyListByApi_594645(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/policies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiPolicyListByApi_594644(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the policy configuration at the API level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594646 = path.getOrDefault("resourceGroupName")
  valid_594646 = validateParameter(valid_594646, JString, required = true,
                                 default = nil)
  if valid_594646 != nil:
    section.add "resourceGroupName", valid_594646
  var valid_594647 = path.getOrDefault("apiId")
  valid_594647 = validateParameter(valid_594647, JString, required = true,
                                 default = nil)
  if valid_594647 != nil:
    section.add "apiId", valid_594647
  var valid_594648 = path.getOrDefault("subscriptionId")
  valid_594648 = validateParameter(valid_594648, JString, required = true,
                                 default = nil)
  if valid_594648 != nil:
    section.add "subscriptionId", valid_594648
  var valid_594649 = path.getOrDefault("serviceName")
  valid_594649 = validateParameter(valid_594649, JString, required = true,
                                 default = nil)
  if valid_594649 != nil:
    section.add "serviceName", valid_594649
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594650 = query.getOrDefault("api-version")
  valid_594650 = validateParameter(valid_594650, JString, required = true,
                                 default = nil)
  if valid_594650 != nil:
    section.add "api-version", valid_594650
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594651: Call_ApiPolicyListByApi_594643; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the API level.
  ## 
  let valid = call_594651.validator(path, query, header, formData, body)
  let scheme = call_594651.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594651.url(scheme.get, call_594651.host, call_594651.base,
                         call_594651.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594651, url, valid)

proc call*(call_594652: Call_ApiPolicyListByApi_594643; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## apiPolicyListByApi
  ## Get the policy configuration at the API level.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594653 = newJObject()
  var query_594654 = newJObject()
  add(path_594653, "resourceGroupName", newJString(resourceGroupName))
  add(query_594654, "api-version", newJString(apiVersion))
  add(path_594653, "apiId", newJString(apiId))
  add(path_594653, "subscriptionId", newJString(subscriptionId))
  add(path_594653, "serviceName", newJString(serviceName))
  result = call_594652.call(path_594653, query_594654, nil, nil, nil)

var apiPolicyListByApi* = Call_ApiPolicyListByApi_594643(
    name: "apiPolicyListByApi", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies",
    validator: validate_ApiPolicyListByApi_594644, base: "",
    url: url_ApiPolicyListByApi_594645, schemes: {Scheme.Https})
type
  Call_ApiPolicyCreateOrUpdate_594668 = ref object of OpenApiRestCall_593425
proc url_ApiPolicyCreateOrUpdate_594670(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiPolicyCreateOrUpdate_594669(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates policy configuration for the API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594671 = path.getOrDefault("resourceGroupName")
  valid_594671 = validateParameter(valid_594671, JString, required = true,
                                 default = nil)
  if valid_594671 != nil:
    section.add "resourceGroupName", valid_594671
  var valid_594672 = path.getOrDefault("apiId")
  valid_594672 = validateParameter(valid_594672, JString, required = true,
                                 default = nil)
  if valid_594672 != nil:
    section.add "apiId", valid_594672
  var valid_594673 = path.getOrDefault("subscriptionId")
  valid_594673 = validateParameter(valid_594673, JString, required = true,
                                 default = nil)
  if valid_594673 != nil:
    section.add "subscriptionId", valid_594673
  var valid_594674 = path.getOrDefault("policyId")
  valid_594674 = validateParameter(valid_594674, JString, required = true,
                                 default = newJString("policy"))
  if valid_594674 != nil:
    section.add "policyId", valid_594674
  var valid_594675 = path.getOrDefault("serviceName")
  valid_594675 = validateParameter(valid_594675, JString, required = true,
                                 default = nil)
  if valid_594675 != nil:
    section.add "serviceName", valid_594675
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594676 = query.getOrDefault("api-version")
  valid_594676 = validateParameter(valid_594676, JString, required = true,
                                 default = nil)
  if valid_594676 != nil:
    section.add "api-version", valid_594676
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_594677 = header.getOrDefault("If-Match")
  valid_594677 = validateParameter(valid_594677, JString, required = false,
                                 default = nil)
  if valid_594677 != nil:
    section.add "If-Match", valid_594677
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The policy contents to apply.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594679: Call_ApiPolicyCreateOrUpdate_594668; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates policy configuration for the API.
  ## 
  let valid = call_594679.validator(path, query, header, formData, body)
  let scheme = call_594679.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594679.url(scheme.get, call_594679.host, call_594679.base,
                         call_594679.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594679, url, valid)

proc call*(call_594680: Call_ApiPolicyCreateOrUpdate_594668;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; parameters: JsonNode; serviceName: string;
          policyId: string = "policy"): Recallable =
  ## apiPolicyCreateOrUpdate
  ## Creates or updates policy configuration for the API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   parameters: JObject (required)
  ##             : The policy contents to apply.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594681 = newJObject()
  var query_594682 = newJObject()
  var body_594683 = newJObject()
  add(path_594681, "resourceGroupName", newJString(resourceGroupName))
  add(query_594682, "api-version", newJString(apiVersion))
  add(path_594681, "apiId", newJString(apiId))
  add(path_594681, "subscriptionId", newJString(subscriptionId))
  add(path_594681, "policyId", newJString(policyId))
  if parameters != nil:
    body_594683 = parameters
  add(path_594681, "serviceName", newJString(serviceName))
  result = call_594680.call(path_594681, query_594682, nil, nil, body_594683)

var apiPolicyCreateOrUpdate* = Call_ApiPolicyCreateOrUpdate_594668(
    name: "apiPolicyCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}",
    validator: validate_ApiPolicyCreateOrUpdate_594669, base: "",
    url: url_ApiPolicyCreateOrUpdate_594670, schemes: {Scheme.Https})
type
  Call_ApiPolicyGetEntityTag_594698 = ref object of OpenApiRestCall_593425
proc url_ApiPolicyGetEntityTag_594700(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiPolicyGetEntityTag_594699(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the API policy specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594701 = path.getOrDefault("resourceGroupName")
  valid_594701 = validateParameter(valid_594701, JString, required = true,
                                 default = nil)
  if valid_594701 != nil:
    section.add "resourceGroupName", valid_594701
  var valid_594702 = path.getOrDefault("apiId")
  valid_594702 = validateParameter(valid_594702, JString, required = true,
                                 default = nil)
  if valid_594702 != nil:
    section.add "apiId", valid_594702
  var valid_594703 = path.getOrDefault("subscriptionId")
  valid_594703 = validateParameter(valid_594703, JString, required = true,
                                 default = nil)
  if valid_594703 != nil:
    section.add "subscriptionId", valid_594703
  var valid_594704 = path.getOrDefault("policyId")
  valid_594704 = validateParameter(valid_594704, JString, required = true,
                                 default = newJString("policy"))
  if valid_594704 != nil:
    section.add "policyId", valid_594704
  var valid_594705 = path.getOrDefault("serviceName")
  valid_594705 = validateParameter(valid_594705, JString, required = true,
                                 default = nil)
  if valid_594705 != nil:
    section.add "serviceName", valid_594705
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594706 = query.getOrDefault("api-version")
  valid_594706 = validateParameter(valid_594706, JString, required = true,
                                 default = nil)
  if valid_594706 != nil:
    section.add "api-version", valid_594706
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594707: Call_ApiPolicyGetEntityTag_594698; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the API policy specified by its identifier.
  ## 
  let valid = call_594707.validator(path, query, header, formData, body)
  let scheme = call_594707.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594707.url(scheme.get, call_594707.host, call_594707.base,
                         call_594707.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594707, url, valid)

proc call*(call_594708: Call_ApiPolicyGetEntityTag_594698;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; policyId: string = "policy"): Recallable =
  ## apiPolicyGetEntityTag
  ## Gets the entity state (Etag) version of the API policy specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594709 = newJObject()
  var query_594710 = newJObject()
  add(path_594709, "resourceGroupName", newJString(resourceGroupName))
  add(query_594710, "api-version", newJString(apiVersion))
  add(path_594709, "apiId", newJString(apiId))
  add(path_594709, "subscriptionId", newJString(subscriptionId))
  add(path_594709, "policyId", newJString(policyId))
  add(path_594709, "serviceName", newJString(serviceName))
  result = call_594708.call(path_594709, query_594710, nil, nil, nil)

var apiPolicyGetEntityTag* = Call_ApiPolicyGetEntityTag_594698(
    name: "apiPolicyGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}",
    validator: validate_ApiPolicyGetEntityTag_594699, base: "",
    url: url_ApiPolicyGetEntityTag_594700, schemes: {Scheme.Https})
type
  Call_ApiPolicyGet_594655 = ref object of OpenApiRestCall_593425
proc url_ApiPolicyGet_594657(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiPolicyGet_594656(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the policy configuration at the API level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594658 = path.getOrDefault("resourceGroupName")
  valid_594658 = validateParameter(valid_594658, JString, required = true,
                                 default = nil)
  if valid_594658 != nil:
    section.add "resourceGroupName", valid_594658
  var valid_594659 = path.getOrDefault("apiId")
  valid_594659 = validateParameter(valid_594659, JString, required = true,
                                 default = nil)
  if valid_594659 != nil:
    section.add "apiId", valid_594659
  var valid_594660 = path.getOrDefault("subscriptionId")
  valid_594660 = validateParameter(valid_594660, JString, required = true,
                                 default = nil)
  if valid_594660 != nil:
    section.add "subscriptionId", valid_594660
  var valid_594661 = path.getOrDefault("policyId")
  valid_594661 = validateParameter(valid_594661, JString, required = true,
                                 default = newJString("policy"))
  if valid_594661 != nil:
    section.add "policyId", valid_594661
  var valid_594662 = path.getOrDefault("serviceName")
  valid_594662 = validateParameter(valid_594662, JString, required = true,
                                 default = nil)
  if valid_594662 != nil:
    section.add "serviceName", valid_594662
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594663 = query.getOrDefault("api-version")
  valid_594663 = validateParameter(valid_594663, JString, required = true,
                                 default = nil)
  if valid_594663 != nil:
    section.add "api-version", valid_594663
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594664: Call_ApiPolicyGet_594655; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the API level.
  ## 
  let valid = call_594664.validator(path, query, header, formData, body)
  let scheme = call_594664.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594664.url(scheme.get, call_594664.host, call_594664.base,
                         call_594664.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594664, url, valid)

proc call*(call_594665: Call_ApiPolicyGet_594655; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string; policyId: string = "policy"): Recallable =
  ## apiPolicyGet
  ## Get the policy configuration at the API level.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594666 = newJObject()
  var query_594667 = newJObject()
  add(path_594666, "resourceGroupName", newJString(resourceGroupName))
  add(query_594667, "api-version", newJString(apiVersion))
  add(path_594666, "apiId", newJString(apiId))
  add(path_594666, "subscriptionId", newJString(subscriptionId))
  add(path_594666, "policyId", newJString(policyId))
  add(path_594666, "serviceName", newJString(serviceName))
  result = call_594665.call(path_594666, query_594667, nil, nil, nil)

var apiPolicyGet* = Call_ApiPolicyGet_594655(name: "apiPolicyGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}",
    validator: validate_ApiPolicyGet_594656, base: "", url: url_ApiPolicyGet_594657,
    schemes: {Scheme.Https})
type
  Call_ApiPolicyDelete_594684 = ref object of OpenApiRestCall_593425
proc url_ApiPolicyDelete_594686(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "policyId" in path, "`policyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/policies/"),
               (kind: VariableSegment, value: "policyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiPolicyDelete_594685(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes the policy configuration at the Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594687 = path.getOrDefault("resourceGroupName")
  valid_594687 = validateParameter(valid_594687, JString, required = true,
                                 default = nil)
  if valid_594687 != nil:
    section.add "resourceGroupName", valid_594687
  var valid_594688 = path.getOrDefault("apiId")
  valid_594688 = validateParameter(valid_594688, JString, required = true,
                                 default = nil)
  if valid_594688 != nil:
    section.add "apiId", valid_594688
  var valid_594689 = path.getOrDefault("subscriptionId")
  valid_594689 = validateParameter(valid_594689, JString, required = true,
                                 default = nil)
  if valid_594689 != nil:
    section.add "subscriptionId", valid_594689
  var valid_594690 = path.getOrDefault("policyId")
  valid_594690 = validateParameter(valid_594690, JString, required = true,
                                 default = newJString("policy"))
  if valid_594690 != nil:
    section.add "policyId", valid_594690
  var valid_594691 = path.getOrDefault("serviceName")
  valid_594691 = validateParameter(valid_594691, JString, required = true,
                                 default = nil)
  if valid_594691 != nil:
    section.add "serviceName", valid_594691
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594692 = query.getOrDefault("api-version")
  valid_594692 = validateParameter(valid_594692, JString, required = true,
                                 default = nil)
  if valid_594692 != nil:
    section.add "api-version", valid_594692
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594693 = header.getOrDefault("If-Match")
  valid_594693 = validateParameter(valid_594693, JString, required = true,
                                 default = nil)
  if valid_594693 != nil:
    section.add "If-Match", valid_594693
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594694: Call_ApiPolicyDelete_594684; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the policy configuration at the Api.
  ## 
  let valid = call_594694.validator(path, query, header, formData, body)
  let scheme = call_594694.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594694.url(scheme.get, call_594694.host, call_594694.base,
                         call_594694.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594694, url, valid)

proc call*(call_594695: Call_ApiPolicyDelete_594684; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string; policyId: string = "policy"): Recallable =
  ## apiPolicyDelete
  ## Deletes the policy configuration at the Api.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594696 = newJObject()
  var query_594697 = newJObject()
  add(path_594696, "resourceGroupName", newJString(resourceGroupName))
  add(query_594697, "api-version", newJString(apiVersion))
  add(path_594696, "apiId", newJString(apiId))
  add(path_594696, "subscriptionId", newJString(subscriptionId))
  add(path_594696, "policyId", newJString(policyId))
  add(path_594696, "serviceName", newJString(serviceName))
  result = call_594695.call(path_594696, query_594697, nil, nil, nil)

var apiPolicyDelete* = Call_ApiPolicyDelete_594684(name: "apiPolicyDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}",
    validator: validate_ApiPolicyDelete_594685, base: "", url: url_ApiPolicyDelete_594686,
    schemes: {Scheme.Https})
type
  Call_ApiProductListByApis_594711 = ref object of OpenApiRestCall_593425
proc url_ApiProductListByApis_594713(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiProductListByApis_594712(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all Products, which the API is part of.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594714 = path.getOrDefault("resourceGroupName")
  valid_594714 = validateParameter(valid_594714, JString, required = true,
                                 default = nil)
  if valid_594714 != nil:
    section.add "resourceGroupName", valid_594714
  var valid_594715 = path.getOrDefault("apiId")
  valid_594715 = validateParameter(valid_594715, JString, required = true,
                                 default = nil)
  if valid_594715 != nil:
    section.add "apiId", valid_594715
  var valid_594716 = path.getOrDefault("subscriptionId")
  valid_594716 = validateParameter(valid_594716, JString, required = true,
                                 default = nil)
  if valid_594716 != nil:
    section.add "subscriptionId", valid_594716
  var valid_594717 = path.getOrDefault("serviceName")
  valid_594717 = validateParameter(valid_594717, JString, required = true,
                                 default = nil)
  if valid_594717 != nil:
    section.add "serviceName", valid_594717
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594718 = query.getOrDefault("api-version")
  valid_594718 = validateParameter(valid_594718, JString, required = true,
                                 default = nil)
  if valid_594718 != nil:
    section.add "api-version", valid_594718
  var valid_594719 = query.getOrDefault("$top")
  valid_594719 = validateParameter(valid_594719, JInt, required = false, default = nil)
  if valid_594719 != nil:
    section.add "$top", valid_594719
  var valid_594720 = query.getOrDefault("$skip")
  valid_594720 = validateParameter(valid_594720, JInt, required = false, default = nil)
  if valid_594720 != nil:
    section.add "$skip", valid_594720
  var valid_594721 = query.getOrDefault("$filter")
  valid_594721 = validateParameter(valid_594721, JString, required = false,
                                 default = nil)
  if valid_594721 != nil:
    section.add "$filter", valid_594721
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594722: Call_ApiProductListByApis_594711; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Products, which the API is part of.
  ## 
  let valid = call_594722.validator(path, query, header, formData, body)
  let scheme = call_594722.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594722.url(scheme.get, call_594722.host, call_594722.base,
                         call_594722.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594722, url, valid)

proc call*(call_594723: Call_ApiProductListByApis_594711;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; Top: int = 0; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## apiProductListByApis
  ## Lists all Products, which the API is part of.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  var path_594724 = newJObject()
  var query_594725 = newJObject()
  add(path_594724, "resourceGroupName", newJString(resourceGroupName))
  add(query_594725, "api-version", newJString(apiVersion))
  add(path_594724, "apiId", newJString(apiId))
  add(path_594724, "subscriptionId", newJString(subscriptionId))
  add(query_594725, "$top", newJInt(Top))
  add(query_594725, "$skip", newJInt(Skip))
  add(path_594724, "serviceName", newJString(serviceName))
  add(query_594725, "$filter", newJString(Filter))
  result = call_594723.call(path_594724, query_594725, nil, nil, nil)

var apiProductListByApis* = Call_ApiProductListByApis_594711(
    name: "apiProductListByApis", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/products",
    validator: validate_ApiProductListByApis_594712, base: "",
    url: url_ApiProductListByApis_594713, schemes: {Scheme.Https})
type
  Call_ApiReleaseList_594726 = ref object of OpenApiRestCall_593425
proc url_ApiReleaseList_594728(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/releases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiReleaseList_594727(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all releases of an API. An API release is created when making an API Revision current. Releases are also used to rollback to previous revisions. Results will be paged and can be constrained by the $top and $skip parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594729 = path.getOrDefault("resourceGroupName")
  valid_594729 = validateParameter(valid_594729, JString, required = true,
                                 default = nil)
  if valid_594729 != nil:
    section.add "resourceGroupName", valid_594729
  var valid_594730 = path.getOrDefault("apiId")
  valid_594730 = validateParameter(valid_594730, JString, required = true,
                                 default = nil)
  if valid_594730 != nil:
    section.add "apiId", valid_594730
  var valid_594731 = path.getOrDefault("subscriptionId")
  valid_594731 = validateParameter(valid_594731, JString, required = true,
                                 default = nil)
  if valid_594731 != nil:
    section.add "subscriptionId", valid_594731
  var valid_594732 = path.getOrDefault("serviceName")
  valid_594732 = validateParameter(valid_594732, JString, required = true,
                                 default = nil)
  if valid_594732 != nil:
    section.add "serviceName", valid_594732
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |notes | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594733 = query.getOrDefault("api-version")
  valid_594733 = validateParameter(valid_594733, JString, required = true,
                                 default = nil)
  if valid_594733 != nil:
    section.add "api-version", valid_594733
  var valid_594734 = query.getOrDefault("$top")
  valid_594734 = validateParameter(valid_594734, JInt, required = false, default = nil)
  if valid_594734 != nil:
    section.add "$top", valid_594734
  var valid_594735 = query.getOrDefault("$skip")
  valid_594735 = validateParameter(valid_594735, JInt, required = false, default = nil)
  if valid_594735 != nil:
    section.add "$skip", valid_594735
  var valid_594736 = query.getOrDefault("$filter")
  valid_594736 = validateParameter(valid_594736, JString, required = false,
                                 default = nil)
  if valid_594736 != nil:
    section.add "$filter", valid_594736
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594737: Call_ApiReleaseList_594726; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all releases of an API. An API release is created when making an API Revision current. Releases are also used to rollback to previous revisions. Results will be paged and can be constrained by the $top and $skip parameters.
  ## 
  let valid = call_594737.validator(path, query, header, formData, body)
  let scheme = call_594737.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594737.url(scheme.get, call_594737.host, call_594737.base,
                         call_594737.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594737, url, valid)

proc call*(call_594738: Call_ApiReleaseList_594726; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## apiReleaseList
  ## Lists all releases of an API. An API release is created when making an API Revision current. Releases are also used to rollback to previous revisions. Results will be paged and can be constrained by the $top and $skip parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |notes | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  var path_594739 = newJObject()
  var query_594740 = newJObject()
  add(path_594739, "resourceGroupName", newJString(resourceGroupName))
  add(query_594740, "api-version", newJString(apiVersion))
  add(path_594739, "apiId", newJString(apiId))
  add(path_594739, "subscriptionId", newJString(subscriptionId))
  add(query_594740, "$top", newJInt(Top))
  add(query_594740, "$skip", newJInt(Skip))
  add(path_594739, "serviceName", newJString(serviceName))
  add(query_594740, "$filter", newJString(Filter))
  result = call_594738.call(path_594739, query_594740, nil, nil, nil)

var apiReleaseList* = Call_ApiReleaseList_594726(name: "apiReleaseList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/releases",
    validator: validate_ApiReleaseList_594727, base: "", url: url_ApiReleaseList_594728,
    schemes: {Scheme.Https})
type
  Call_ApiReleaseCreate_594754 = ref object of OpenApiRestCall_593425
proc url_ApiReleaseCreate_594756(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "releaseId" in path, "`releaseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/releases/"),
               (kind: VariableSegment, value: "releaseId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiReleaseCreate_594755(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Creates a new Release for the API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   releaseId: JString (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594757 = path.getOrDefault("resourceGroupName")
  valid_594757 = validateParameter(valid_594757, JString, required = true,
                                 default = nil)
  if valid_594757 != nil:
    section.add "resourceGroupName", valid_594757
  var valid_594758 = path.getOrDefault("apiId")
  valid_594758 = validateParameter(valid_594758, JString, required = true,
                                 default = nil)
  if valid_594758 != nil:
    section.add "apiId", valid_594758
  var valid_594759 = path.getOrDefault("subscriptionId")
  valid_594759 = validateParameter(valid_594759, JString, required = true,
                                 default = nil)
  if valid_594759 != nil:
    section.add "subscriptionId", valid_594759
  var valid_594760 = path.getOrDefault("releaseId")
  valid_594760 = validateParameter(valid_594760, JString, required = true,
                                 default = nil)
  if valid_594760 != nil:
    section.add "releaseId", valid_594760
  var valid_594761 = path.getOrDefault("serviceName")
  valid_594761 = validateParameter(valid_594761, JString, required = true,
                                 default = nil)
  if valid_594761 != nil:
    section.add "serviceName", valid_594761
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594762 = query.getOrDefault("api-version")
  valid_594762 = validateParameter(valid_594762, JString, required = true,
                                 default = nil)
  if valid_594762 != nil:
    section.add "api-version", valid_594762
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_594763 = header.getOrDefault("If-Match")
  valid_594763 = validateParameter(valid_594763, JString, required = false,
                                 default = nil)
  if valid_594763 != nil:
    section.add "If-Match", valid_594763
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

proc call*(call_594765: Call_ApiReleaseCreate_594754; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Release for the API.
  ## 
  let valid = call_594765.validator(path, query, header, formData, body)
  let scheme = call_594765.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594765.url(scheme.get, call_594765.host, call_594765.base,
                         call_594765.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594765, url, valid)

proc call*(call_594766: Call_ApiReleaseCreate_594754; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          releaseId: string; parameters: JsonNode; serviceName: string): Recallable =
  ## apiReleaseCreate
  ## Creates a new Release for the API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   releaseId: string (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594767 = newJObject()
  var query_594768 = newJObject()
  var body_594769 = newJObject()
  add(path_594767, "resourceGroupName", newJString(resourceGroupName))
  add(query_594768, "api-version", newJString(apiVersion))
  add(path_594767, "apiId", newJString(apiId))
  add(path_594767, "subscriptionId", newJString(subscriptionId))
  add(path_594767, "releaseId", newJString(releaseId))
  if parameters != nil:
    body_594769 = parameters
  add(path_594767, "serviceName", newJString(serviceName))
  result = call_594766.call(path_594767, query_594768, nil, nil, body_594769)

var apiReleaseCreate* = Call_ApiReleaseCreate_594754(name: "apiReleaseCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/releases/{releaseId}",
    validator: validate_ApiReleaseCreate_594755, base: "",
    url: url_ApiReleaseCreate_594756, schemes: {Scheme.Https})
type
  Call_ApiReleaseGetEntityTag_594784 = ref object of OpenApiRestCall_593425
proc url_ApiReleaseGetEntityTag_594786(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "releaseId" in path, "`releaseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/releases/"),
               (kind: VariableSegment, value: "releaseId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiReleaseGetEntityTag_594785(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the etag of an API release.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   releaseId: JString (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594787 = path.getOrDefault("resourceGroupName")
  valid_594787 = validateParameter(valid_594787, JString, required = true,
                                 default = nil)
  if valid_594787 != nil:
    section.add "resourceGroupName", valid_594787
  var valid_594788 = path.getOrDefault("apiId")
  valid_594788 = validateParameter(valid_594788, JString, required = true,
                                 default = nil)
  if valid_594788 != nil:
    section.add "apiId", valid_594788
  var valid_594789 = path.getOrDefault("subscriptionId")
  valid_594789 = validateParameter(valid_594789, JString, required = true,
                                 default = nil)
  if valid_594789 != nil:
    section.add "subscriptionId", valid_594789
  var valid_594790 = path.getOrDefault("releaseId")
  valid_594790 = validateParameter(valid_594790, JString, required = true,
                                 default = nil)
  if valid_594790 != nil:
    section.add "releaseId", valid_594790
  var valid_594791 = path.getOrDefault("serviceName")
  valid_594791 = validateParameter(valid_594791, JString, required = true,
                                 default = nil)
  if valid_594791 != nil:
    section.add "serviceName", valid_594791
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594792 = query.getOrDefault("api-version")
  valid_594792 = validateParameter(valid_594792, JString, required = true,
                                 default = nil)
  if valid_594792 != nil:
    section.add "api-version", valid_594792
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594793: Call_ApiReleaseGetEntityTag_594784; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the etag of an API release.
  ## 
  let valid = call_594793.validator(path, query, header, formData, body)
  let scheme = call_594793.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594793.url(scheme.get, call_594793.host, call_594793.base,
                         call_594793.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594793, url, valid)

proc call*(call_594794: Call_ApiReleaseGetEntityTag_594784;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; releaseId: string; serviceName: string): Recallable =
  ## apiReleaseGetEntityTag
  ## Returns the etag of an API release.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   releaseId: string (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594795 = newJObject()
  var query_594796 = newJObject()
  add(path_594795, "resourceGroupName", newJString(resourceGroupName))
  add(query_594796, "api-version", newJString(apiVersion))
  add(path_594795, "apiId", newJString(apiId))
  add(path_594795, "subscriptionId", newJString(subscriptionId))
  add(path_594795, "releaseId", newJString(releaseId))
  add(path_594795, "serviceName", newJString(serviceName))
  result = call_594794.call(path_594795, query_594796, nil, nil, nil)

var apiReleaseGetEntityTag* = Call_ApiReleaseGetEntityTag_594784(
    name: "apiReleaseGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/releases/{releaseId}",
    validator: validate_ApiReleaseGetEntityTag_594785, base: "",
    url: url_ApiReleaseGetEntityTag_594786, schemes: {Scheme.Https})
type
  Call_ApiReleaseGet_594741 = ref object of OpenApiRestCall_593425
proc url_ApiReleaseGet_594743(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "releaseId" in path, "`releaseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/releases/"),
               (kind: VariableSegment, value: "releaseId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiReleaseGet_594742(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the details of an API release.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   releaseId: JString (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594744 = path.getOrDefault("resourceGroupName")
  valid_594744 = validateParameter(valid_594744, JString, required = true,
                                 default = nil)
  if valid_594744 != nil:
    section.add "resourceGroupName", valid_594744
  var valid_594745 = path.getOrDefault("apiId")
  valid_594745 = validateParameter(valid_594745, JString, required = true,
                                 default = nil)
  if valid_594745 != nil:
    section.add "apiId", valid_594745
  var valid_594746 = path.getOrDefault("subscriptionId")
  valid_594746 = validateParameter(valid_594746, JString, required = true,
                                 default = nil)
  if valid_594746 != nil:
    section.add "subscriptionId", valid_594746
  var valid_594747 = path.getOrDefault("releaseId")
  valid_594747 = validateParameter(valid_594747, JString, required = true,
                                 default = nil)
  if valid_594747 != nil:
    section.add "releaseId", valid_594747
  var valid_594748 = path.getOrDefault("serviceName")
  valid_594748 = validateParameter(valid_594748, JString, required = true,
                                 default = nil)
  if valid_594748 != nil:
    section.add "serviceName", valid_594748
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594749 = query.getOrDefault("api-version")
  valid_594749 = validateParameter(valid_594749, JString, required = true,
                                 default = nil)
  if valid_594749 != nil:
    section.add "api-version", valid_594749
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594750: Call_ApiReleaseGet_594741; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the details of an API release.
  ## 
  let valid = call_594750.validator(path, query, header, formData, body)
  let scheme = call_594750.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594750.url(scheme.get, call_594750.host, call_594750.base,
                         call_594750.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594750, url, valid)

proc call*(call_594751: Call_ApiReleaseGet_594741; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          releaseId: string; serviceName: string): Recallable =
  ## apiReleaseGet
  ## Returns the details of an API release.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   releaseId: string (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594752 = newJObject()
  var query_594753 = newJObject()
  add(path_594752, "resourceGroupName", newJString(resourceGroupName))
  add(query_594753, "api-version", newJString(apiVersion))
  add(path_594752, "apiId", newJString(apiId))
  add(path_594752, "subscriptionId", newJString(subscriptionId))
  add(path_594752, "releaseId", newJString(releaseId))
  add(path_594752, "serviceName", newJString(serviceName))
  result = call_594751.call(path_594752, query_594753, nil, nil, nil)

var apiReleaseGet* = Call_ApiReleaseGet_594741(name: "apiReleaseGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/releases/{releaseId}",
    validator: validate_ApiReleaseGet_594742, base: "", url: url_ApiReleaseGet_594743,
    schemes: {Scheme.Https})
type
  Call_ApiReleaseUpdate_594797 = ref object of OpenApiRestCall_593425
proc url_ApiReleaseUpdate_594799(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "releaseId" in path, "`releaseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/releases/"),
               (kind: VariableSegment, value: "releaseId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiReleaseUpdate_594798(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates the details of the release of the API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   releaseId: JString (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594800 = path.getOrDefault("resourceGroupName")
  valid_594800 = validateParameter(valid_594800, JString, required = true,
                                 default = nil)
  if valid_594800 != nil:
    section.add "resourceGroupName", valid_594800
  var valid_594801 = path.getOrDefault("apiId")
  valid_594801 = validateParameter(valid_594801, JString, required = true,
                                 default = nil)
  if valid_594801 != nil:
    section.add "apiId", valid_594801
  var valid_594802 = path.getOrDefault("subscriptionId")
  valid_594802 = validateParameter(valid_594802, JString, required = true,
                                 default = nil)
  if valid_594802 != nil:
    section.add "subscriptionId", valid_594802
  var valid_594803 = path.getOrDefault("releaseId")
  valid_594803 = validateParameter(valid_594803, JString, required = true,
                                 default = nil)
  if valid_594803 != nil:
    section.add "releaseId", valid_594803
  var valid_594804 = path.getOrDefault("serviceName")
  valid_594804 = validateParameter(valid_594804, JString, required = true,
                                 default = nil)
  if valid_594804 != nil:
    section.add "serviceName", valid_594804
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594805 = query.getOrDefault("api-version")
  valid_594805 = validateParameter(valid_594805, JString, required = true,
                                 default = nil)
  if valid_594805 != nil:
    section.add "api-version", valid_594805
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594806 = header.getOrDefault("If-Match")
  valid_594806 = validateParameter(valid_594806, JString, required = true,
                                 default = nil)
  if valid_594806 != nil:
    section.add "If-Match", valid_594806
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : API Release Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594808: Call_ApiReleaseUpdate_594797; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the release of the API specified by its identifier.
  ## 
  let valid = call_594808.validator(path, query, header, formData, body)
  let scheme = call_594808.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594808.url(scheme.get, call_594808.host, call_594808.base,
                         call_594808.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594808, url, valid)

proc call*(call_594809: Call_ApiReleaseUpdate_594797; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          releaseId: string; parameters: JsonNode; serviceName: string): Recallable =
  ## apiReleaseUpdate
  ## Updates the details of the release of the API specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   releaseId: string (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   parameters: JObject (required)
  ##             : API Release Update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594810 = newJObject()
  var query_594811 = newJObject()
  var body_594812 = newJObject()
  add(path_594810, "resourceGroupName", newJString(resourceGroupName))
  add(query_594811, "api-version", newJString(apiVersion))
  add(path_594810, "apiId", newJString(apiId))
  add(path_594810, "subscriptionId", newJString(subscriptionId))
  add(path_594810, "releaseId", newJString(releaseId))
  if parameters != nil:
    body_594812 = parameters
  add(path_594810, "serviceName", newJString(serviceName))
  result = call_594809.call(path_594810, query_594811, nil, nil, body_594812)

var apiReleaseUpdate* = Call_ApiReleaseUpdate_594797(name: "apiReleaseUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/releases/{releaseId}",
    validator: validate_ApiReleaseUpdate_594798, base: "",
    url: url_ApiReleaseUpdate_594799, schemes: {Scheme.Https})
type
  Call_ApiReleaseDelete_594770 = ref object of OpenApiRestCall_593425
proc url_ApiReleaseDelete_594772(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "releaseId" in path, "`releaseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/releases/"),
               (kind: VariableSegment, value: "releaseId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiReleaseDelete_594771(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes the specified release in the API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   releaseId: JString (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594773 = path.getOrDefault("resourceGroupName")
  valid_594773 = validateParameter(valid_594773, JString, required = true,
                                 default = nil)
  if valid_594773 != nil:
    section.add "resourceGroupName", valid_594773
  var valid_594774 = path.getOrDefault("apiId")
  valid_594774 = validateParameter(valid_594774, JString, required = true,
                                 default = nil)
  if valid_594774 != nil:
    section.add "apiId", valid_594774
  var valid_594775 = path.getOrDefault("subscriptionId")
  valid_594775 = validateParameter(valid_594775, JString, required = true,
                                 default = nil)
  if valid_594775 != nil:
    section.add "subscriptionId", valid_594775
  var valid_594776 = path.getOrDefault("releaseId")
  valid_594776 = validateParameter(valid_594776, JString, required = true,
                                 default = nil)
  if valid_594776 != nil:
    section.add "releaseId", valid_594776
  var valid_594777 = path.getOrDefault("serviceName")
  valid_594777 = validateParameter(valid_594777, JString, required = true,
                                 default = nil)
  if valid_594777 != nil:
    section.add "serviceName", valid_594777
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594778 = query.getOrDefault("api-version")
  valid_594778 = validateParameter(valid_594778, JString, required = true,
                                 default = nil)
  if valid_594778 != nil:
    section.add "api-version", valid_594778
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594779 = header.getOrDefault("If-Match")
  valid_594779 = validateParameter(valid_594779, JString, required = true,
                                 default = nil)
  if valid_594779 != nil:
    section.add "If-Match", valid_594779
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594780: Call_ApiReleaseDelete_594770; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified release in the API.
  ## 
  let valid = call_594780.validator(path, query, header, formData, body)
  let scheme = call_594780.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594780.url(scheme.get, call_594780.host, call_594780.base,
                         call_594780.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594780, url, valid)

proc call*(call_594781: Call_ApiReleaseDelete_594770; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          releaseId: string; serviceName: string): Recallable =
  ## apiReleaseDelete
  ## Deletes the specified release in the API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   releaseId: string (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594782 = newJObject()
  var query_594783 = newJObject()
  add(path_594782, "resourceGroupName", newJString(resourceGroupName))
  add(query_594783, "api-version", newJString(apiVersion))
  add(path_594782, "apiId", newJString(apiId))
  add(path_594782, "subscriptionId", newJString(subscriptionId))
  add(path_594782, "releaseId", newJString(releaseId))
  add(path_594782, "serviceName", newJString(serviceName))
  result = call_594781.call(path_594782, query_594783, nil, nil, nil)

var apiReleaseDelete* = Call_ApiReleaseDelete_594770(name: "apiReleaseDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/releases/{releaseId}",
    validator: validate_ApiReleaseDelete_594771, base: "",
    url: url_ApiReleaseDelete_594772, schemes: {Scheme.Https})
type
  Call_ApiRevisionsList_594813 = ref object of OpenApiRestCall_593425
proc url_ApiRevisionsList_594815(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/revisions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiRevisionsList_594814(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists all revisions of an API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594816 = path.getOrDefault("resourceGroupName")
  valid_594816 = validateParameter(valid_594816, JString, required = true,
                                 default = nil)
  if valid_594816 != nil:
    section.add "resourceGroupName", valid_594816
  var valid_594817 = path.getOrDefault("apiId")
  valid_594817 = validateParameter(valid_594817, JString, required = true,
                                 default = nil)
  if valid_594817 != nil:
    section.add "apiId", valid_594817
  var valid_594818 = path.getOrDefault("subscriptionId")
  valid_594818 = validateParameter(valid_594818, JString, required = true,
                                 default = nil)
  if valid_594818 != nil:
    section.add "subscriptionId", valid_594818
  var valid_594819 = path.getOrDefault("serviceName")
  valid_594819 = validateParameter(valid_594819, JString, required = true,
                                 default = nil)
  if valid_594819 != nil:
    section.add "serviceName", valid_594819
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |apiRevision | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594820 = query.getOrDefault("api-version")
  valid_594820 = validateParameter(valid_594820, JString, required = true,
                                 default = nil)
  if valid_594820 != nil:
    section.add "api-version", valid_594820
  var valid_594821 = query.getOrDefault("$top")
  valid_594821 = validateParameter(valid_594821, JInt, required = false, default = nil)
  if valid_594821 != nil:
    section.add "$top", valid_594821
  var valid_594822 = query.getOrDefault("$skip")
  valid_594822 = validateParameter(valid_594822, JInt, required = false, default = nil)
  if valid_594822 != nil:
    section.add "$skip", valid_594822
  var valid_594823 = query.getOrDefault("$filter")
  valid_594823 = validateParameter(valid_594823, JString, required = false,
                                 default = nil)
  if valid_594823 != nil:
    section.add "$filter", valid_594823
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594824: Call_ApiRevisionsList_594813; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all revisions of an API.
  ## 
  let valid = call_594824.validator(path, query, header, formData, body)
  let scheme = call_594824.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594824.url(scheme.get, call_594824.host, call_594824.base,
                         call_594824.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594824, url, valid)

proc call*(call_594825: Call_ApiRevisionsList_594813; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## apiRevisionsList
  ## Lists all revisions of an API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |apiRevision | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  var path_594826 = newJObject()
  var query_594827 = newJObject()
  add(path_594826, "resourceGroupName", newJString(resourceGroupName))
  add(query_594827, "api-version", newJString(apiVersion))
  add(path_594826, "apiId", newJString(apiId))
  add(path_594826, "subscriptionId", newJString(subscriptionId))
  add(query_594827, "$top", newJInt(Top))
  add(query_594827, "$skip", newJInt(Skip))
  add(path_594826, "serviceName", newJString(serviceName))
  add(query_594827, "$filter", newJString(Filter))
  result = call_594825.call(path_594826, query_594827, nil, nil, nil)

var apiRevisionsList* = Call_ApiRevisionsList_594813(name: "apiRevisionsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/revisions",
    validator: validate_ApiRevisionsList_594814, base: "",
    url: url_ApiRevisionsList_594815, schemes: {Scheme.Https})
type
  Call_ApiSchemaListByApi_594828 = ref object of OpenApiRestCall_593425
proc url_ApiSchemaListByApi_594830(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/schemas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiSchemaListByApi_594829(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the schema configuration at the API level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594831 = path.getOrDefault("resourceGroupName")
  valid_594831 = validateParameter(valid_594831, JString, required = true,
                                 default = nil)
  if valid_594831 != nil:
    section.add "resourceGroupName", valid_594831
  var valid_594832 = path.getOrDefault("apiId")
  valid_594832 = validateParameter(valid_594832, JString, required = true,
                                 default = nil)
  if valid_594832 != nil:
    section.add "apiId", valid_594832
  var valid_594833 = path.getOrDefault("subscriptionId")
  valid_594833 = validateParameter(valid_594833, JString, required = true,
                                 default = nil)
  if valid_594833 != nil:
    section.add "subscriptionId", valid_594833
  var valid_594834 = path.getOrDefault("serviceName")
  valid_594834 = validateParameter(valid_594834, JString, required = true,
                                 default = nil)
  if valid_594834 != nil:
    section.add "serviceName", valid_594834
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |contentType | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594835 = query.getOrDefault("api-version")
  valid_594835 = validateParameter(valid_594835, JString, required = true,
                                 default = nil)
  if valid_594835 != nil:
    section.add "api-version", valid_594835
  var valid_594836 = query.getOrDefault("$top")
  valid_594836 = validateParameter(valid_594836, JInt, required = false, default = nil)
  if valid_594836 != nil:
    section.add "$top", valid_594836
  var valid_594837 = query.getOrDefault("$skip")
  valid_594837 = validateParameter(valid_594837, JInt, required = false, default = nil)
  if valid_594837 != nil:
    section.add "$skip", valid_594837
  var valid_594838 = query.getOrDefault("$filter")
  valid_594838 = validateParameter(valid_594838, JString, required = false,
                                 default = nil)
  if valid_594838 != nil:
    section.add "$filter", valid_594838
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594839: Call_ApiSchemaListByApi_594828; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the schema configuration at the API level.
  ## 
  let valid = call_594839.validator(path, query, header, formData, body)
  let scheme = call_594839.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594839.url(scheme.get, call_594839.host, call_594839.base,
                         call_594839.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594839, url, valid)

proc call*(call_594840: Call_ApiSchemaListByApi_594828; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## apiSchemaListByApi
  ## Get the schema configuration at the API level.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |contentType | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  var path_594841 = newJObject()
  var query_594842 = newJObject()
  add(path_594841, "resourceGroupName", newJString(resourceGroupName))
  add(query_594842, "api-version", newJString(apiVersion))
  add(path_594841, "apiId", newJString(apiId))
  add(path_594841, "subscriptionId", newJString(subscriptionId))
  add(query_594842, "$top", newJInt(Top))
  add(query_594842, "$skip", newJInt(Skip))
  add(path_594841, "serviceName", newJString(serviceName))
  add(query_594842, "$filter", newJString(Filter))
  result = call_594840.call(path_594841, query_594842, nil, nil, nil)

var apiSchemaListByApi* = Call_ApiSchemaListByApi_594828(
    name: "apiSchemaListByApi", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/schemas",
    validator: validate_ApiSchemaListByApi_594829, base: "",
    url: url_ApiSchemaListByApi_594830, schemes: {Scheme.Https})
type
  Call_ApiSchemaCreateOrUpdate_594856 = ref object of OpenApiRestCall_593425
proc url_ApiSchemaCreateOrUpdate_594858(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "schemaId" in path, "`schemaId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiSchemaCreateOrUpdate_594857(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates schema configuration for the API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   schemaId: JString (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594859 = path.getOrDefault("resourceGroupName")
  valid_594859 = validateParameter(valid_594859, JString, required = true,
                                 default = nil)
  if valid_594859 != nil:
    section.add "resourceGroupName", valid_594859
  var valid_594860 = path.getOrDefault("apiId")
  valid_594860 = validateParameter(valid_594860, JString, required = true,
                                 default = nil)
  if valid_594860 != nil:
    section.add "apiId", valid_594860
  var valid_594861 = path.getOrDefault("subscriptionId")
  valid_594861 = validateParameter(valid_594861, JString, required = true,
                                 default = nil)
  if valid_594861 != nil:
    section.add "subscriptionId", valid_594861
  var valid_594862 = path.getOrDefault("schemaId")
  valid_594862 = validateParameter(valid_594862, JString, required = true,
                                 default = nil)
  if valid_594862 != nil:
    section.add "schemaId", valid_594862
  var valid_594863 = path.getOrDefault("serviceName")
  valid_594863 = validateParameter(valid_594863, JString, required = true,
                                 default = nil)
  if valid_594863 != nil:
    section.add "serviceName", valid_594863
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594864 = query.getOrDefault("api-version")
  valid_594864 = validateParameter(valid_594864, JString, required = true,
                                 default = nil)
  if valid_594864 != nil:
    section.add "api-version", valid_594864
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_594865 = header.getOrDefault("If-Match")
  valid_594865 = validateParameter(valid_594865, JString, required = false,
                                 default = nil)
  if valid_594865 != nil:
    section.add "If-Match", valid_594865
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The schema contents to apply.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594867: Call_ApiSchemaCreateOrUpdate_594856; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates schema configuration for the API.
  ## 
  let valid = call_594867.validator(path, query, header, formData, body)
  let scheme = call_594867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594867.url(scheme.get, call_594867.host, call_594867.base,
                         call_594867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594867, url, valid)

proc call*(call_594868: Call_ApiSchemaCreateOrUpdate_594856;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; schemaId: string; parameters: JsonNode;
          serviceName: string): Recallable =
  ## apiSchemaCreateOrUpdate
  ## Creates or updates schema configuration for the API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   schemaId: string (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  ##   parameters: JObject (required)
  ##             : The schema contents to apply.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594869 = newJObject()
  var query_594870 = newJObject()
  var body_594871 = newJObject()
  add(path_594869, "resourceGroupName", newJString(resourceGroupName))
  add(query_594870, "api-version", newJString(apiVersion))
  add(path_594869, "apiId", newJString(apiId))
  add(path_594869, "subscriptionId", newJString(subscriptionId))
  add(path_594869, "schemaId", newJString(schemaId))
  if parameters != nil:
    body_594871 = parameters
  add(path_594869, "serviceName", newJString(serviceName))
  result = call_594868.call(path_594869, query_594870, nil, nil, body_594871)

var apiSchemaCreateOrUpdate* = Call_ApiSchemaCreateOrUpdate_594856(
    name: "apiSchemaCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/schemas/{schemaId}",
    validator: validate_ApiSchemaCreateOrUpdate_594857, base: "",
    url: url_ApiSchemaCreateOrUpdate_594858, schemes: {Scheme.Https})
type
  Call_ApiSchemaGetEntityTag_594887 = ref object of OpenApiRestCall_593425
proc url_ApiSchemaGetEntityTag_594889(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "schemaId" in path, "`schemaId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiSchemaGetEntityTag_594888(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the schema specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   schemaId: JString (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594890 = path.getOrDefault("resourceGroupName")
  valid_594890 = validateParameter(valid_594890, JString, required = true,
                                 default = nil)
  if valid_594890 != nil:
    section.add "resourceGroupName", valid_594890
  var valid_594891 = path.getOrDefault("apiId")
  valid_594891 = validateParameter(valid_594891, JString, required = true,
                                 default = nil)
  if valid_594891 != nil:
    section.add "apiId", valid_594891
  var valid_594892 = path.getOrDefault("subscriptionId")
  valid_594892 = validateParameter(valid_594892, JString, required = true,
                                 default = nil)
  if valid_594892 != nil:
    section.add "subscriptionId", valid_594892
  var valid_594893 = path.getOrDefault("schemaId")
  valid_594893 = validateParameter(valid_594893, JString, required = true,
                                 default = nil)
  if valid_594893 != nil:
    section.add "schemaId", valid_594893
  var valid_594894 = path.getOrDefault("serviceName")
  valid_594894 = validateParameter(valid_594894, JString, required = true,
                                 default = nil)
  if valid_594894 != nil:
    section.add "serviceName", valid_594894
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594895 = query.getOrDefault("api-version")
  valid_594895 = validateParameter(valid_594895, JString, required = true,
                                 default = nil)
  if valid_594895 != nil:
    section.add "api-version", valid_594895
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594896: Call_ApiSchemaGetEntityTag_594887; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the schema specified by its identifier.
  ## 
  let valid = call_594896.validator(path, query, header, formData, body)
  let scheme = call_594896.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594896.url(scheme.get, call_594896.host, call_594896.base,
                         call_594896.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594896, url, valid)

proc call*(call_594897: Call_ApiSchemaGetEntityTag_594887;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; schemaId: string; serviceName: string): Recallable =
  ## apiSchemaGetEntityTag
  ## Gets the entity state (Etag) version of the schema specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   schemaId: string (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594898 = newJObject()
  var query_594899 = newJObject()
  add(path_594898, "resourceGroupName", newJString(resourceGroupName))
  add(query_594899, "api-version", newJString(apiVersion))
  add(path_594898, "apiId", newJString(apiId))
  add(path_594898, "subscriptionId", newJString(subscriptionId))
  add(path_594898, "schemaId", newJString(schemaId))
  add(path_594898, "serviceName", newJString(serviceName))
  result = call_594897.call(path_594898, query_594899, nil, nil, nil)

var apiSchemaGetEntityTag* = Call_ApiSchemaGetEntityTag_594887(
    name: "apiSchemaGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/schemas/{schemaId}",
    validator: validate_ApiSchemaGetEntityTag_594888, base: "",
    url: url_ApiSchemaGetEntityTag_594889, schemes: {Scheme.Https})
type
  Call_ApiSchemaGet_594843 = ref object of OpenApiRestCall_593425
proc url_ApiSchemaGet_594845(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "schemaId" in path, "`schemaId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiSchemaGet_594844(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the schema configuration at the API level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   schemaId: JString (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594846 = path.getOrDefault("resourceGroupName")
  valid_594846 = validateParameter(valid_594846, JString, required = true,
                                 default = nil)
  if valid_594846 != nil:
    section.add "resourceGroupName", valid_594846
  var valid_594847 = path.getOrDefault("apiId")
  valid_594847 = validateParameter(valid_594847, JString, required = true,
                                 default = nil)
  if valid_594847 != nil:
    section.add "apiId", valid_594847
  var valid_594848 = path.getOrDefault("subscriptionId")
  valid_594848 = validateParameter(valid_594848, JString, required = true,
                                 default = nil)
  if valid_594848 != nil:
    section.add "subscriptionId", valid_594848
  var valid_594849 = path.getOrDefault("schemaId")
  valid_594849 = validateParameter(valid_594849, JString, required = true,
                                 default = nil)
  if valid_594849 != nil:
    section.add "schemaId", valid_594849
  var valid_594850 = path.getOrDefault("serviceName")
  valid_594850 = validateParameter(valid_594850, JString, required = true,
                                 default = nil)
  if valid_594850 != nil:
    section.add "serviceName", valid_594850
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594851 = query.getOrDefault("api-version")
  valid_594851 = validateParameter(valid_594851, JString, required = true,
                                 default = nil)
  if valid_594851 != nil:
    section.add "api-version", valid_594851
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594852: Call_ApiSchemaGet_594843; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the schema configuration at the API level.
  ## 
  let valid = call_594852.validator(path, query, header, formData, body)
  let scheme = call_594852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594852.url(scheme.get, call_594852.host, call_594852.base,
                         call_594852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594852, url, valid)

proc call*(call_594853: Call_ApiSchemaGet_594843; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string; schemaId: string;
          serviceName: string): Recallable =
  ## apiSchemaGet
  ## Get the schema configuration at the API level.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   schemaId: string (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594854 = newJObject()
  var query_594855 = newJObject()
  add(path_594854, "resourceGroupName", newJString(resourceGroupName))
  add(query_594855, "api-version", newJString(apiVersion))
  add(path_594854, "apiId", newJString(apiId))
  add(path_594854, "subscriptionId", newJString(subscriptionId))
  add(path_594854, "schemaId", newJString(schemaId))
  add(path_594854, "serviceName", newJString(serviceName))
  result = call_594853.call(path_594854, query_594855, nil, nil, nil)

var apiSchemaGet* = Call_ApiSchemaGet_594843(name: "apiSchemaGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/schemas/{schemaId}",
    validator: validate_ApiSchemaGet_594844, base: "", url: url_ApiSchemaGet_594845,
    schemes: {Scheme.Https})
type
  Call_ApiSchemaDelete_594872 = ref object of OpenApiRestCall_593425
proc url_ApiSchemaDelete_594874(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "schemaId" in path, "`schemaId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiSchemaDelete_594873(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes the schema configuration at the Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   schemaId: JString (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594875 = path.getOrDefault("resourceGroupName")
  valid_594875 = validateParameter(valid_594875, JString, required = true,
                                 default = nil)
  if valid_594875 != nil:
    section.add "resourceGroupName", valid_594875
  var valid_594876 = path.getOrDefault("apiId")
  valid_594876 = validateParameter(valid_594876, JString, required = true,
                                 default = nil)
  if valid_594876 != nil:
    section.add "apiId", valid_594876
  var valid_594877 = path.getOrDefault("subscriptionId")
  valid_594877 = validateParameter(valid_594877, JString, required = true,
                                 default = nil)
  if valid_594877 != nil:
    section.add "subscriptionId", valid_594877
  var valid_594878 = path.getOrDefault("schemaId")
  valid_594878 = validateParameter(valid_594878, JString, required = true,
                                 default = nil)
  if valid_594878 != nil:
    section.add "schemaId", valid_594878
  var valid_594879 = path.getOrDefault("serviceName")
  valid_594879 = validateParameter(valid_594879, JString, required = true,
                                 default = nil)
  if valid_594879 != nil:
    section.add "serviceName", valid_594879
  result.add "path", section
  ## parameters in `query` object:
  ##   force: JBool
  ##        : If true removes all references to the schema before deleting it.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  var valid_594880 = query.getOrDefault("force")
  valid_594880 = validateParameter(valid_594880, JBool, required = false, default = nil)
  if valid_594880 != nil:
    section.add "force", valid_594880
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594881 = query.getOrDefault("api-version")
  valid_594881 = validateParameter(valid_594881, JString, required = true,
                                 default = nil)
  if valid_594881 != nil:
    section.add "api-version", valid_594881
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594882 = header.getOrDefault("If-Match")
  valid_594882 = validateParameter(valid_594882, JString, required = true,
                                 default = nil)
  if valid_594882 != nil:
    section.add "If-Match", valid_594882
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594883: Call_ApiSchemaDelete_594872; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the schema configuration at the Api.
  ## 
  let valid = call_594883.validator(path, query, header, formData, body)
  let scheme = call_594883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594883.url(scheme.get, call_594883.host, call_594883.base,
                         call_594883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594883, url, valid)

proc call*(call_594884: Call_ApiSchemaDelete_594872; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string; schemaId: string;
          serviceName: string; force: bool = false): Recallable =
  ## apiSchemaDelete
  ## Deletes the schema configuration at the Api.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   force: bool
  ##        : If true removes all references to the schema before deleting it.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   schemaId: string (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594885 = newJObject()
  var query_594886 = newJObject()
  add(path_594885, "resourceGroupName", newJString(resourceGroupName))
  add(query_594886, "force", newJBool(force))
  add(query_594886, "api-version", newJString(apiVersion))
  add(path_594885, "apiId", newJString(apiId))
  add(path_594885, "subscriptionId", newJString(subscriptionId))
  add(path_594885, "schemaId", newJString(schemaId))
  add(path_594885, "serviceName", newJString(serviceName))
  result = call_594884.call(path_594885, query_594886, nil, nil, nil)

var apiSchemaDelete* = Call_ApiSchemaDelete_594872(name: "apiSchemaDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/schemas/{schemaId}",
    validator: validate_ApiSchemaDelete_594873, base: "", url: url_ApiSchemaDelete_594874,
    schemes: {Scheme.Https})
type
  Call_TagDescriptionListByApi_594900 = ref object of OpenApiRestCall_593425
proc url_TagDescriptionListByApi_594902(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/tagDescriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDescriptionListByApi_594901(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all Tags descriptions in scope of API. Model similar to swagger - tagDescription is defined on API level but tag may be assigned to the Operations
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594903 = path.getOrDefault("resourceGroupName")
  valid_594903 = validateParameter(valid_594903, JString, required = true,
                                 default = nil)
  if valid_594903 != nil:
    section.add "resourceGroupName", valid_594903
  var valid_594904 = path.getOrDefault("apiId")
  valid_594904 = validateParameter(valid_594904, JString, required = true,
                                 default = nil)
  if valid_594904 != nil:
    section.add "apiId", valid_594904
  var valid_594905 = path.getOrDefault("subscriptionId")
  valid_594905 = validateParameter(valid_594905, JString, required = true,
                                 default = nil)
  if valid_594905 != nil:
    section.add "subscriptionId", valid_594905
  var valid_594906 = path.getOrDefault("serviceName")
  valid_594906 = validateParameter(valid_594906, JString, required = true,
                                 default = nil)
  if valid_594906 != nil:
    section.add "serviceName", valid_594906
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594907 = query.getOrDefault("api-version")
  valid_594907 = validateParameter(valid_594907, JString, required = true,
                                 default = nil)
  if valid_594907 != nil:
    section.add "api-version", valid_594907
  var valid_594908 = query.getOrDefault("$top")
  valid_594908 = validateParameter(valid_594908, JInt, required = false, default = nil)
  if valid_594908 != nil:
    section.add "$top", valid_594908
  var valid_594909 = query.getOrDefault("$skip")
  valid_594909 = validateParameter(valid_594909, JInt, required = false, default = nil)
  if valid_594909 != nil:
    section.add "$skip", valid_594909
  var valid_594910 = query.getOrDefault("$filter")
  valid_594910 = validateParameter(valid_594910, JString, required = false,
                                 default = nil)
  if valid_594910 != nil:
    section.add "$filter", valid_594910
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594911: Call_TagDescriptionListByApi_594900; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Tags descriptions in scope of API. Model similar to swagger - tagDescription is defined on API level but tag may be assigned to the Operations
  ## 
  let valid = call_594911.validator(path, query, header, formData, body)
  let scheme = call_594911.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594911.url(scheme.get, call_594911.host, call_594911.base,
                         call_594911.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594911, url, valid)

proc call*(call_594912: Call_TagDescriptionListByApi_594900;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; Top: int = 0; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## tagDescriptionListByApi
  ## Lists all Tags descriptions in scope of API. Model similar to swagger - tagDescription is defined on API level but tag may be assigned to the Operations
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  var path_594913 = newJObject()
  var query_594914 = newJObject()
  add(path_594913, "resourceGroupName", newJString(resourceGroupName))
  add(query_594914, "api-version", newJString(apiVersion))
  add(path_594913, "apiId", newJString(apiId))
  add(path_594913, "subscriptionId", newJString(subscriptionId))
  add(query_594914, "$top", newJInt(Top))
  add(query_594914, "$skip", newJInt(Skip))
  add(path_594913, "serviceName", newJString(serviceName))
  add(query_594914, "$filter", newJString(Filter))
  result = call_594912.call(path_594913, query_594914, nil, nil, nil)

var tagDescriptionListByApi* = Call_TagDescriptionListByApi_594900(
    name: "tagDescriptionListByApi", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tagDescriptions",
    validator: validate_TagDescriptionListByApi_594901, base: "",
    url: url_TagDescriptionListByApi_594902, schemes: {Scheme.Https})
type
  Call_TagDescriptionCreateOrUpdate_594928 = ref object of OpenApiRestCall_593425
proc url_TagDescriptionCreateOrUpdate_594930(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/tagDescriptions/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDescriptionCreateOrUpdate_594929(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create/Update tag description in scope of the Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594931 = path.getOrDefault("tagId")
  valid_594931 = validateParameter(valid_594931, JString, required = true,
                                 default = nil)
  if valid_594931 != nil:
    section.add "tagId", valid_594931
  var valid_594932 = path.getOrDefault("resourceGroupName")
  valid_594932 = validateParameter(valid_594932, JString, required = true,
                                 default = nil)
  if valid_594932 != nil:
    section.add "resourceGroupName", valid_594932
  var valid_594933 = path.getOrDefault("apiId")
  valid_594933 = validateParameter(valid_594933, JString, required = true,
                                 default = nil)
  if valid_594933 != nil:
    section.add "apiId", valid_594933
  var valid_594934 = path.getOrDefault("subscriptionId")
  valid_594934 = validateParameter(valid_594934, JString, required = true,
                                 default = nil)
  if valid_594934 != nil:
    section.add "subscriptionId", valid_594934
  var valid_594935 = path.getOrDefault("serviceName")
  valid_594935 = validateParameter(valid_594935, JString, required = true,
                                 default = nil)
  if valid_594935 != nil:
    section.add "serviceName", valid_594935
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594936 = query.getOrDefault("api-version")
  valid_594936 = validateParameter(valid_594936, JString, required = true,
                                 default = nil)
  if valid_594936 != nil:
    section.add "api-version", valid_594936
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_594937 = header.getOrDefault("If-Match")
  valid_594937 = validateParameter(valid_594937, JString, required = false,
                                 default = nil)
  if valid_594937 != nil:
    section.add "If-Match", valid_594937
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

proc call*(call_594939: Call_TagDescriptionCreateOrUpdate_594928; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create/Update tag description in scope of the Api.
  ## 
  let valid = call_594939.validator(path, query, header, formData, body)
  let scheme = call_594939.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594939.url(scheme.get, call_594939.host, call_594939.base,
                         call_594939.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594939, url, valid)

proc call*(call_594940: Call_TagDescriptionCreateOrUpdate_594928; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; parameters: JsonNode; serviceName: string): Recallable =
  ## tagDescriptionCreateOrUpdate
  ## Create/Update tag description in scope of the Api.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594941 = newJObject()
  var query_594942 = newJObject()
  var body_594943 = newJObject()
  add(path_594941, "tagId", newJString(tagId))
  add(path_594941, "resourceGroupName", newJString(resourceGroupName))
  add(query_594942, "api-version", newJString(apiVersion))
  add(path_594941, "apiId", newJString(apiId))
  add(path_594941, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594943 = parameters
  add(path_594941, "serviceName", newJString(serviceName))
  result = call_594940.call(path_594941, query_594942, nil, nil, body_594943)

var tagDescriptionCreateOrUpdate* = Call_TagDescriptionCreateOrUpdate_594928(
    name: "tagDescriptionCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tagDescriptions/{tagId}",
    validator: validate_TagDescriptionCreateOrUpdate_594929, base: "",
    url: url_TagDescriptionCreateOrUpdate_594930, schemes: {Scheme.Https})
type
  Call_TagDescriptionGetEntityState_594958 = ref object of OpenApiRestCall_593425
proc url_TagDescriptionGetEntityState_594960(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/tagDescriptions/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDescriptionGetEntityState_594959(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state version of the tag specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594961 = path.getOrDefault("tagId")
  valid_594961 = validateParameter(valid_594961, JString, required = true,
                                 default = nil)
  if valid_594961 != nil:
    section.add "tagId", valid_594961
  var valid_594962 = path.getOrDefault("resourceGroupName")
  valid_594962 = validateParameter(valid_594962, JString, required = true,
                                 default = nil)
  if valid_594962 != nil:
    section.add "resourceGroupName", valid_594962
  var valid_594963 = path.getOrDefault("apiId")
  valid_594963 = validateParameter(valid_594963, JString, required = true,
                                 default = nil)
  if valid_594963 != nil:
    section.add "apiId", valid_594963
  var valid_594964 = path.getOrDefault("subscriptionId")
  valid_594964 = validateParameter(valid_594964, JString, required = true,
                                 default = nil)
  if valid_594964 != nil:
    section.add "subscriptionId", valid_594964
  var valid_594965 = path.getOrDefault("serviceName")
  valid_594965 = validateParameter(valid_594965, JString, required = true,
                                 default = nil)
  if valid_594965 != nil:
    section.add "serviceName", valid_594965
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594966 = query.getOrDefault("api-version")
  valid_594966 = validateParameter(valid_594966, JString, required = true,
                                 default = nil)
  if valid_594966 != nil:
    section.add "api-version", valid_594966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594967: Call_TagDescriptionGetEntityState_594958; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state version of the tag specified by its identifier.
  ## 
  let valid = call_594967.validator(path, query, header, formData, body)
  let scheme = call_594967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594967.url(scheme.get, call_594967.host, call_594967.base,
                         call_594967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594967, url, valid)

proc call*(call_594968: Call_TagDescriptionGetEntityState_594958; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## tagDescriptionGetEntityState
  ## Gets the entity state version of the tag specified by its identifier.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594969 = newJObject()
  var query_594970 = newJObject()
  add(path_594969, "tagId", newJString(tagId))
  add(path_594969, "resourceGroupName", newJString(resourceGroupName))
  add(query_594970, "api-version", newJString(apiVersion))
  add(path_594969, "apiId", newJString(apiId))
  add(path_594969, "subscriptionId", newJString(subscriptionId))
  add(path_594969, "serviceName", newJString(serviceName))
  result = call_594968.call(path_594969, query_594970, nil, nil, nil)

var tagDescriptionGetEntityState* = Call_TagDescriptionGetEntityState_594958(
    name: "tagDescriptionGetEntityState", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tagDescriptions/{tagId}",
    validator: validate_TagDescriptionGetEntityState_594959, base: "",
    url: url_TagDescriptionGetEntityState_594960, schemes: {Scheme.Https})
type
  Call_TagDescriptionGet_594915 = ref object of OpenApiRestCall_593425
proc url_TagDescriptionGet_594917(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/tagDescriptions/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDescriptionGet_594916(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get Tag description in scope of API
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594918 = path.getOrDefault("tagId")
  valid_594918 = validateParameter(valid_594918, JString, required = true,
                                 default = nil)
  if valid_594918 != nil:
    section.add "tagId", valid_594918
  var valid_594919 = path.getOrDefault("resourceGroupName")
  valid_594919 = validateParameter(valid_594919, JString, required = true,
                                 default = nil)
  if valid_594919 != nil:
    section.add "resourceGroupName", valid_594919
  var valid_594920 = path.getOrDefault("apiId")
  valid_594920 = validateParameter(valid_594920, JString, required = true,
                                 default = nil)
  if valid_594920 != nil:
    section.add "apiId", valid_594920
  var valid_594921 = path.getOrDefault("subscriptionId")
  valid_594921 = validateParameter(valid_594921, JString, required = true,
                                 default = nil)
  if valid_594921 != nil:
    section.add "subscriptionId", valid_594921
  var valid_594922 = path.getOrDefault("serviceName")
  valid_594922 = validateParameter(valid_594922, JString, required = true,
                                 default = nil)
  if valid_594922 != nil:
    section.add "serviceName", valid_594922
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594923 = query.getOrDefault("api-version")
  valid_594923 = validateParameter(valid_594923, JString, required = true,
                                 default = nil)
  if valid_594923 != nil:
    section.add "api-version", valid_594923
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594924: Call_TagDescriptionGet_594915; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Tag description in scope of API
  ## 
  let valid = call_594924.validator(path, query, header, formData, body)
  let scheme = call_594924.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594924.url(scheme.get, call_594924.host, call_594924.base,
                         call_594924.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594924, url, valid)

proc call*(call_594925: Call_TagDescriptionGet_594915; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## tagDescriptionGet
  ## Get Tag description in scope of API
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594926 = newJObject()
  var query_594927 = newJObject()
  add(path_594926, "tagId", newJString(tagId))
  add(path_594926, "resourceGroupName", newJString(resourceGroupName))
  add(query_594927, "api-version", newJString(apiVersion))
  add(path_594926, "apiId", newJString(apiId))
  add(path_594926, "subscriptionId", newJString(subscriptionId))
  add(path_594926, "serviceName", newJString(serviceName))
  result = call_594925.call(path_594926, query_594927, nil, nil, nil)

var tagDescriptionGet* = Call_TagDescriptionGet_594915(name: "tagDescriptionGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tagDescriptions/{tagId}",
    validator: validate_TagDescriptionGet_594916, base: "",
    url: url_TagDescriptionGet_594917, schemes: {Scheme.Https})
type
  Call_TagDescriptionDelete_594944 = ref object of OpenApiRestCall_593425
proc url_TagDescriptionDelete_594946(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/tagDescriptions/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDescriptionDelete_594945(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete tag description for the Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594947 = path.getOrDefault("tagId")
  valid_594947 = validateParameter(valid_594947, JString, required = true,
                                 default = nil)
  if valid_594947 != nil:
    section.add "tagId", valid_594947
  var valid_594948 = path.getOrDefault("resourceGroupName")
  valid_594948 = validateParameter(valid_594948, JString, required = true,
                                 default = nil)
  if valid_594948 != nil:
    section.add "resourceGroupName", valid_594948
  var valid_594949 = path.getOrDefault("apiId")
  valid_594949 = validateParameter(valid_594949, JString, required = true,
                                 default = nil)
  if valid_594949 != nil:
    section.add "apiId", valid_594949
  var valid_594950 = path.getOrDefault("subscriptionId")
  valid_594950 = validateParameter(valid_594950, JString, required = true,
                                 default = nil)
  if valid_594950 != nil:
    section.add "subscriptionId", valid_594950
  var valid_594951 = path.getOrDefault("serviceName")
  valid_594951 = validateParameter(valid_594951, JString, required = true,
                                 default = nil)
  if valid_594951 != nil:
    section.add "serviceName", valid_594951
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594952 = query.getOrDefault("api-version")
  valid_594952 = validateParameter(valid_594952, JString, required = true,
                                 default = nil)
  if valid_594952 != nil:
    section.add "api-version", valid_594952
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594953 = header.getOrDefault("If-Match")
  valid_594953 = validateParameter(valid_594953, JString, required = true,
                                 default = nil)
  if valid_594953 != nil:
    section.add "If-Match", valid_594953
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594954: Call_TagDescriptionDelete_594944; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete tag description for the Api.
  ## 
  let valid = call_594954.validator(path, query, header, formData, body)
  let scheme = call_594954.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594954.url(scheme.get, call_594954.host, call_594954.base,
                         call_594954.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594954, url, valid)

proc call*(call_594955: Call_TagDescriptionDelete_594944; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## tagDescriptionDelete
  ## Delete tag description for the Api.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594956 = newJObject()
  var query_594957 = newJObject()
  add(path_594956, "tagId", newJString(tagId))
  add(path_594956, "resourceGroupName", newJString(resourceGroupName))
  add(query_594957, "api-version", newJString(apiVersion))
  add(path_594956, "apiId", newJString(apiId))
  add(path_594956, "subscriptionId", newJString(subscriptionId))
  add(path_594956, "serviceName", newJString(serviceName))
  result = call_594955.call(path_594956, query_594957, nil, nil, nil)

var tagDescriptionDelete* = Call_TagDescriptionDelete_594944(
    name: "tagDescriptionDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tagDescriptions/{tagId}",
    validator: validate_TagDescriptionDelete_594945, base: "",
    url: url_TagDescriptionDelete_594946, schemes: {Scheme.Https})
type
  Call_TagListByApi_594971 = ref object of OpenApiRestCall_593425
proc url_TagListByApi_594973(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/tags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagListByApi_594972(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all Tags associated with the API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594974 = path.getOrDefault("resourceGroupName")
  valid_594974 = validateParameter(valid_594974, JString, required = true,
                                 default = nil)
  if valid_594974 != nil:
    section.add "resourceGroupName", valid_594974
  var valid_594975 = path.getOrDefault("apiId")
  valid_594975 = validateParameter(valid_594975, JString, required = true,
                                 default = nil)
  if valid_594975 != nil:
    section.add "apiId", valid_594975
  var valid_594976 = path.getOrDefault("subscriptionId")
  valid_594976 = validateParameter(valid_594976, JString, required = true,
                                 default = nil)
  if valid_594976 != nil:
    section.add "subscriptionId", valid_594976
  var valid_594977 = path.getOrDefault("serviceName")
  valid_594977 = validateParameter(valid_594977, JString, required = true,
                                 default = nil)
  if valid_594977 != nil:
    section.add "serviceName", valid_594977
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594978 = query.getOrDefault("api-version")
  valid_594978 = validateParameter(valid_594978, JString, required = true,
                                 default = nil)
  if valid_594978 != nil:
    section.add "api-version", valid_594978
  var valid_594979 = query.getOrDefault("$top")
  valid_594979 = validateParameter(valid_594979, JInt, required = false, default = nil)
  if valid_594979 != nil:
    section.add "$top", valid_594979
  var valid_594980 = query.getOrDefault("$skip")
  valid_594980 = validateParameter(valid_594980, JInt, required = false, default = nil)
  if valid_594980 != nil:
    section.add "$skip", valid_594980
  var valid_594981 = query.getOrDefault("$filter")
  valid_594981 = validateParameter(valid_594981, JString, required = false,
                                 default = nil)
  if valid_594981 != nil:
    section.add "$filter", valid_594981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594982: Call_TagListByApi_594971; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Tags associated with the API.
  ## 
  let valid = call_594982.validator(path, query, header, formData, body)
  let scheme = call_594982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594982.url(scheme.get, call_594982.host, call_594982.base,
                         call_594982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594982, url, valid)

proc call*(call_594983: Call_TagListByApi_594971; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## tagListByApi
  ## Lists all Tags associated with the API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  var path_594984 = newJObject()
  var query_594985 = newJObject()
  add(path_594984, "resourceGroupName", newJString(resourceGroupName))
  add(query_594985, "api-version", newJString(apiVersion))
  add(path_594984, "apiId", newJString(apiId))
  add(path_594984, "subscriptionId", newJString(subscriptionId))
  add(query_594985, "$top", newJInt(Top))
  add(query_594985, "$skip", newJInt(Skip))
  add(path_594984, "serviceName", newJString(serviceName))
  add(query_594985, "$filter", newJString(Filter))
  result = call_594983.call(path_594984, query_594985, nil, nil, nil)

var tagListByApi* = Call_TagListByApi_594971(name: "tagListByApi",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags",
    validator: validate_TagListByApi_594972, base: "", url: url_TagListByApi_594973,
    schemes: {Scheme.Https})
type
  Call_TagAssignToApi_594999 = ref object of OpenApiRestCall_593425
proc url_TagAssignToApi_595001(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagAssignToApi_595000(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Assign tag to the Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_595002 = path.getOrDefault("tagId")
  valid_595002 = validateParameter(valid_595002, JString, required = true,
                                 default = nil)
  if valid_595002 != nil:
    section.add "tagId", valid_595002
  var valid_595003 = path.getOrDefault("resourceGroupName")
  valid_595003 = validateParameter(valid_595003, JString, required = true,
                                 default = nil)
  if valid_595003 != nil:
    section.add "resourceGroupName", valid_595003
  var valid_595004 = path.getOrDefault("apiId")
  valid_595004 = validateParameter(valid_595004, JString, required = true,
                                 default = nil)
  if valid_595004 != nil:
    section.add "apiId", valid_595004
  var valid_595005 = path.getOrDefault("subscriptionId")
  valid_595005 = validateParameter(valid_595005, JString, required = true,
                                 default = nil)
  if valid_595005 != nil:
    section.add "subscriptionId", valid_595005
  var valid_595006 = path.getOrDefault("serviceName")
  valid_595006 = validateParameter(valid_595006, JString, required = true,
                                 default = nil)
  if valid_595006 != nil:
    section.add "serviceName", valid_595006
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595007 = query.getOrDefault("api-version")
  valid_595007 = validateParameter(valid_595007, JString, required = true,
                                 default = nil)
  if valid_595007 != nil:
    section.add "api-version", valid_595007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595008: Call_TagAssignToApi_594999; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Assign tag to the Api.
  ## 
  let valid = call_595008.validator(path, query, header, formData, body)
  let scheme = call_595008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595008.url(scheme.get, call_595008.host, call_595008.base,
                         call_595008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595008, url, valid)

proc call*(call_595009: Call_TagAssignToApi_594999; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## tagAssignToApi
  ## Assign tag to the Api.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_595010 = newJObject()
  var query_595011 = newJObject()
  add(path_595010, "tagId", newJString(tagId))
  add(path_595010, "resourceGroupName", newJString(resourceGroupName))
  add(query_595011, "api-version", newJString(apiVersion))
  add(path_595010, "apiId", newJString(apiId))
  add(path_595010, "subscriptionId", newJString(subscriptionId))
  add(path_595010, "serviceName", newJString(serviceName))
  result = call_595009.call(path_595010, query_595011, nil, nil, nil)

var tagAssignToApi* = Call_TagAssignToApi_594999(name: "tagAssignToApi",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags/{tagId}",
    validator: validate_TagAssignToApi_595000, base: "", url: url_TagAssignToApi_595001,
    schemes: {Scheme.Https})
type
  Call_TagGetEntityStateByApi_595025 = ref object of OpenApiRestCall_593425
proc url_TagGetEntityStateByApi_595027(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagGetEntityStateByApi_595026(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state version of the tag specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_595028 = path.getOrDefault("tagId")
  valid_595028 = validateParameter(valid_595028, JString, required = true,
                                 default = nil)
  if valid_595028 != nil:
    section.add "tagId", valid_595028
  var valid_595029 = path.getOrDefault("resourceGroupName")
  valid_595029 = validateParameter(valid_595029, JString, required = true,
                                 default = nil)
  if valid_595029 != nil:
    section.add "resourceGroupName", valid_595029
  var valid_595030 = path.getOrDefault("apiId")
  valid_595030 = validateParameter(valid_595030, JString, required = true,
                                 default = nil)
  if valid_595030 != nil:
    section.add "apiId", valid_595030
  var valid_595031 = path.getOrDefault("subscriptionId")
  valid_595031 = validateParameter(valid_595031, JString, required = true,
                                 default = nil)
  if valid_595031 != nil:
    section.add "subscriptionId", valid_595031
  var valid_595032 = path.getOrDefault("serviceName")
  valid_595032 = validateParameter(valid_595032, JString, required = true,
                                 default = nil)
  if valid_595032 != nil:
    section.add "serviceName", valid_595032
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595033 = query.getOrDefault("api-version")
  valid_595033 = validateParameter(valid_595033, JString, required = true,
                                 default = nil)
  if valid_595033 != nil:
    section.add "api-version", valid_595033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595034: Call_TagGetEntityStateByApi_595025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state version of the tag specified by its identifier.
  ## 
  let valid = call_595034.validator(path, query, header, formData, body)
  let scheme = call_595034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595034.url(scheme.get, call_595034.host, call_595034.base,
                         call_595034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595034, url, valid)

proc call*(call_595035: Call_TagGetEntityStateByApi_595025; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## tagGetEntityStateByApi
  ## Gets the entity state version of the tag specified by its identifier.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_595036 = newJObject()
  var query_595037 = newJObject()
  add(path_595036, "tagId", newJString(tagId))
  add(path_595036, "resourceGroupName", newJString(resourceGroupName))
  add(query_595037, "api-version", newJString(apiVersion))
  add(path_595036, "apiId", newJString(apiId))
  add(path_595036, "subscriptionId", newJString(subscriptionId))
  add(path_595036, "serviceName", newJString(serviceName))
  result = call_595035.call(path_595036, query_595037, nil, nil, nil)

var tagGetEntityStateByApi* = Call_TagGetEntityStateByApi_595025(
    name: "tagGetEntityStateByApi", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags/{tagId}",
    validator: validate_TagGetEntityStateByApi_595026, base: "",
    url: url_TagGetEntityStateByApi_595027, schemes: {Scheme.Https})
type
  Call_TagGetByApi_594986 = ref object of OpenApiRestCall_593425
proc url_TagGetByApi_594988(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagGetByApi_594987(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get tag associated with the API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_594989 = path.getOrDefault("tagId")
  valid_594989 = validateParameter(valid_594989, JString, required = true,
                                 default = nil)
  if valid_594989 != nil:
    section.add "tagId", valid_594989
  var valid_594990 = path.getOrDefault("resourceGroupName")
  valid_594990 = validateParameter(valid_594990, JString, required = true,
                                 default = nil)
  if valid_594990 != nil:
    section.add "resourceGroupName", valid_594990
  var valid_594991 = path.getOrDefault("apiId")
  valid_594991 = validateParameter(valid_594991, JString, required = true,
                                 default = nil)
  if valid_594991 != nil:
    section.add "apiId", valid_594991
  var valid_594992 = path.getOrDefault("subscriptionId")
  valid_594992 = validateParameter(valid_594992, JString, required = true,
                                 default = nil)
  if valid_594992 != nil:
    section.add "subscriptionId", valid_594992
  var valid_594993 = path.getOrDefault("serviceName")
  valid_594993 = validateParameter(valid_594993, JString, required = true,
                                 default = nil)
  if valid_594993 != nil:
    section.add "serviceName", valid_594993
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594994 = query.getOrDefault("api-version")
  valid_594994 = validateParameter(valid_594994, JString, required = true,
                                 default = nil)
  if valid_594994 != nil:
    section.add "api-version", valid_594994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594995: Call_TagGetByApi_594986; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get tag associated with the API.
  ## 
  let valid = call_594995.validator(path, query, header, formData, body)
  let scheme = call_594995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594995.url(scheme.get, call_594995.host, call_594995.base,
                         call_594995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594995, url, valid)

proc call*(call_594996: Call_TagGetByApi_594986; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## tagGetByApi
  ## Get tag associated with the API.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594997 = newJObject()
  var query_594998 = newJObject()
  add(path_594997, "tagId", newJString(tagId))
  add(path_594997, "resourceGroupName", newJString(resourceGroupName))
  add(query_594998, "api-version", newJString(apiVersion))
  add(path_594997, "apiId", newJString(apiId))
  add(path_594997, "subscriptionId", newJString(subscriptionId))
  add(path_594997, "serviceName", newJString(serviceName))
  result = call_594996.call(path_594997, query_594998, nil, nil, nil)

var tagGetByApi* = Call_TagGetByApi_594986(name: "tagGetByApi",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags/{tagId}",
                                        validator: validate_TagGetByApi_594987,
                                        base: "", url: url_TagGetByApi_594988,
                                        schemes: {Scheme.Https})
type
  Call_TagDetachFromApi_595012 = ref object of OpenApiRestCall_593425
proc url_TagDetachFromApi_595014(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "apiId" in path, "`apiId` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/apis/"),
               (kind: VariableSegment, value: "apiId"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDetachFromApi_595013(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Detach the tag from the Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_595015 = path.getOrDefault("tagId")
  valid_595015 = validateParameter(valid_595015, JString, required = true,
                                 default = nil)
  if valid_595015 != nil:
    section.add "tagId", valid_595015
  var valid_595016 = path.getOrDefault("resourceGroupName")
  valid_595016 = validateParameter(valid_595016, JString, required = true,
                                 default = nil)
  if valid_595016 != nil:
    section.add "resourceGroupName", valid_595016
  var valid_595017 = path.getOrDefault("apiId")
  valid_595017 = validateParameter(valid_595017, JString, required = true,
                                 default = nil)
  if valid_595017 != nil:
    section.add "apiId", valid_595017
  var valid_595018 = path.getOrDefault("subscriptionId")
  valid_595018 = validateParameter(valid_595018, JString, required = true,
                                 default = nil)
  if valid_595018 != nil:
    section.add "subscriptionId", valid_595018
  var valid_595019 = path.getOrDefault("serviceName")
  valid_595019 = validateParameter(valid_595019, JString, required = true,
                                 default = nil)
  if valid_595019 != nil:
    section.add "serviceName", valid_595019
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595020 = query.getOrDefault("api-version")
  valid_595020 = validateParameter(valid_595020, JString, required = true,
                                 default = nil)
  if valid_595020 != nil:
    section.add "api-version", valid_595020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595021: Call_TagDetachFromApi_595012; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detach the tag from the Api.
  ## 
  let valid = call_595021.validator(path, query, header, formData, body)
  let scheme = call_595021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595021.url(scheme.get, call_595021.host, call_595021.base,
                         call_595021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595021, url, valid)

proc call*(call_595022: Call_TagDetachFromApi_595012; tagId: string;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## tagDetachFromApi
  ## Detach the tag from the Api.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_595023 = newJObject()
  var query_595024 = newJObject()
  add(path_595023, "tagId", newJString(tagId))
  add(path_595023, "resourceGroupName", newJString(resourceGroupName))
  add(query_595024, "api-version", newJString(apiVersion))
  add(path_595023, "apiId", newJString(apiId))
  add(path_595023, "subscriptionId", newJString(subscriptionId))
  add(path_595023, "serviceName", newJString(serviceName))
  result = call_595022.call(path_595023, query_595024, nil, nil, nil)

var tagDetachFromApi* = Call_TagDetachFromApi_595012(name: "tagDetachFromApi",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/tags/{tagId}",
    validator: validate_TagDetachFromApi_595013, base: "",
    url: url_TagDetachFromApi_595014, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
