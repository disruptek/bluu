
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2018-01-01
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

  OpenApiRestCall_593438 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593438](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593438): Option[Scheme] {.used.} =
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
  Call_ApiListByService_593660 = ref object of OpenApiRestCall_593438
proc url_ApiListByService_593662(protocol: Scheme; host: string; base: string;
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

proc validate_ApiListByService_593661(path: JsonNode; query: JsonNode;
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
  var valid_593823 = path.getOrDefault("resourceGroupName")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "resourceGroupName", valid_593823
  var valid_593824 = path.getOrDefault("subscriptionId")
  valid_593824 = validateParameter(valid_593824, JString, required = true,
                                 default = nil)
  if valid_593824 != nil:
    section.add "subscriptionId", valid_593824
  var valid_593825 = path.getOrDefault("serviceName")
  valid_593825 = validateParameter(valid_593825, JString, required = true,
                                 default = nil)
  if valid_593825 != nil:
    section.add "serviceName", valid_593825
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
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | serviceUrl  | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | path        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593826 = query.getOrDefault("api-version")
  valid_593826 = validateParameter(valid_593826, JString, required = true,
                                 default = nil)
  if valid_593826 != nil:
    section.add "api-version", valid_593826
  var valid_593840 = query.getOrDefault("expandApiVersionSet")
  valid_593840 = validateParameter(valid_593840, JBool, required = false,
                                 default = newJBool(false))
  if valid_593840 != nil:
    section.add "expandApiVersionSet", valid_593840
  var valid_593841 = query.getOrDefault("$top")
  valid_593841 = validateParameter(valid_593841, JInt, required = false, default = nil)
  if valid_593841 != nil:
    section.add "$top", valid_593841
  var valid_593842 = query.getOrDefault("$skip")
  valid_593842 = validateParameter(valid_593842, JInt, required = false, default = nil)
  if valid_593842 != nil:
    section.add "$skip", valid_593842
  var valid_593843 = query.getOrDefault("$filter")
  valid_593843 = validateParameter(valid_593843, JString, required = false,
                                 default = nil)
  if valid_593843 != nil:
    section.add "$filter", valid_593843
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593870: Call_ApiListByService_593660; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all APIs of the API Management service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-create-apis
  let valid = call_593870.validator(path, query, header, formData, body)
  let scheme = call_593870.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593870.url(scheme.get, call_593870.host, call_593870.base,
                         call_593870.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593870, url, valid)

proc call*(call_593941: Call_ApiListByService_593660; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          expandApiVersionSet: bool = false; Top: int = 0; Skip: int = 0;
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
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | serviceUrl  | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | path        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  var path_593942 = newJObject()
  var query_593944 = newJObject()
  add(path_593942, "resourceGroupName", newJString(resourceGroupName))
  add(query_593944, "api-version", newJString(apiVersion))
  add(path_593942, "subscriptionId", newJString(subscriptionId))
  add(query_593944, "expandApiVersionSet", newJBool(expandApiVersionSet))
  add(query_593944, "$top", newJInt(Top))
  add(query_593944, "$skip", newJInt(Skip))
  add(path_593942, "serviceName", newJString(serviceName))
  add(query_593944, "$filter", newJString(Filter))
  result = call_593941.call(path_593942, query_593944, nil, nil, nil)

var apiListByService* = Call_ApiListByService_593660(name: "apiListByService",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis",
    validator: validate_ApiListByService_593661, base: "",
    url: url_ApiListByService_593662, schemes: {Scheme.Https})
type
  Call_ApiCreateOrUpdate_594004 = ref object of OpenApiRestCall_593438
proc url_ApiCreateOrUpdate_594006(protocol: Scheme; host: string; base: string;
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

proc validate_ApiCreateOrUpdate_594005(path: JsonNode; query: JsonNode;
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
  var valid_594024 = path.getOrDefault("resourceGroupName")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "resourceGroupName", valid_594024
  var valid_594025 = path.getOrDefault("apiId")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "apiId", valid_594025
  var valid_594026 = path.getOrDefault("subscriptionId")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "subscriptionId", valid_594026
  var valid_594027 = path.getOrDefault("serviceName")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "serviceName", valid_594027
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594028 = query.getOrDefault("api-version")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "api-version", valid_594028
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_594029 = header.getOrDefault("If-Match")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "If-Match", valid_594029
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

proc call*(call_594031: Call_ApiCreateOrUpdate_594004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates new or updates existing specified API of the API Management service instance.
  ## 
  let valid = call_594031.validator(path, query, header, formData, body)
  let scheme = call_594031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594031.url(scheme.get, call_594031.host, call_594031.base,
                         call_594031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594031, url, valid)

proc call*(call_594032: Call_ApiCreateOrUpdate_594004; resourceGroupName: string;
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
  var path_594033 = newJObject()
  var query_594034 = newJObject()
  var body_594035 = newJObject()
  add(path_594033, "resourceGroupName", newJString(resourceGroupName))
  add(query_594034, "api-version", newJString(apiVersion))
  add(path_594033, "apiId", newJString(apiId))
  add(path_594033, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594035 = parameters
  add(path_594033, "serviceName", newJString(serviceName))
  result = call_594032.call(path_594033, query_594034, nil, nil, body_594035)

var apiCreateOrUpdate* = Call_ApiCreateOrUpdate_594004(name: "apiCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}",
    validator: validate_ApiCreateOrUpdate_594005, base: "",
    url: url_ApiCreateOrUpdate_594006, schemes: {Scheme.Https})
type
  Call_ApiGetEntityTag_594050 = ref object of OpenApiRestCall_593438
proc url_ApiGetEntityTag_594052(protocol: Scheme; host: string; base: string;
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

proc validate_ApiGetEntityTag_594051(path: JsonNode; query: JsonNode;
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
  var valid_594053 = path.getOrDefault("resourceGroupName")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "resourceGroupName", valid_594053
  var valid_594054 = path.getOrDefault("apiId")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "apiId", valid_594054
  var valid_594055 = path.getOrDefault("subscriptionId")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "subscriptionId", valid_594055
  var valid_594056 = path.getOrDefault("serviceName")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "serviceName", valid_594056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594057 = query.getOrDefault("api-version")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "api-version", valid_594057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594058: Call_ApiGetEntityTag_594050; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the API specified by its identifier.
  ## 
  let valid = call_594058.validator(path, query, header, formData, body)
  let scheme = call_594058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594058.url(scheme.get, call_594058.host, call_594058.base,
                         call_594058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594058, url, valid)

proc call*(call_594059: Call_ApiGetEntityTag_594050; resourceGroupName: string;
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
  var path_594060 = newJObject()
  var query_594061 = newJObject()
  add(path_594060, "resourceGroupName", newJString(resourceGroupName))
  add(query_594061, "api-version", newJString(apiVersion))
  add(path_594060, "apiId", newJString(apiId))
  add(path_594060, "subscriptionId", newJString(subscriptionId))
  add(path_594060, "serviceName", newJString(serviceName))
  result = call_594059.call(path_594060, query_594061, nil, nil, nil)

var apiGetEntityTag* = Call_ApiGetEntityTag_594050(name: "apiGetEntityTag",
    meth: HttpMethod.HttpHead, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}",
    validator: validate_ApiGetEntityTag_594051, base: "", url: url_ApiGetEntityTag_594052,
    schemes: {Scheme.Https})
type
  Call_ApiGet_593983 = ref object of OpenApiRestCall_593438
proc url_ApiGet_593985(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ApiGet_593984(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593995 = path.getOrDefault("resourceGroupName")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "resourceGroupName", valid_593995
  var valid_593996 = path.getOrDefault("apiId")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "apiId", valid_593996
  var valid_593997 = path.getOrDefault("subscriptionId")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "subscriptionId", valid_593997
  var valid_593998 = path.getOrDefault("serviceName")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "serviceName", valid_593998
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593999 = query.getOrDefault("api-version")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "api-version", valid_593999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594000: Call_ApiGet_593983; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the API specified by its identifier.
  ## 
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_ApiGet_593983; resourceGroupName: string;
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
  var path_594002 = newJObject()
  var query_594003 = newJObject()
  add(path_594002, "resourceGroupName", newJString(resourceGroupName))
  add(query_594003, "api-version", newJString(apiVersion))
  add(path_594002, "apiId", newJString(apiId))
  add(path_594002, "subscriptionId", newJString(subscriptionId))
  add(path_594002, "serviceName", newJString(serviceName))
  result = call_594001.call(path_594002, query_594003, nil, nil, nil)

var apiGet* = Call_ApiGet_593983(name: "apiGet", meth: HttpMethod.HttpGet,
                              host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}",
                              validator: validate_ApiGet_593984, base: "",
                              url: url_ApiGet_593985, schemes: {Scheme.Https})
type
  Call_ApiUpdate_594062 = ref object of OpenApiRestCall_593438
proc url_ApiUpdate_594064(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ApiUpdate_594063(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594065 = path.getOrDefault("resourceGroupName")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "resourceGroupName", valid_594065
  var valid_594066 = path.getOrDefault("apiId")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "apiId", valid_594066
  var valid_594067 = path.getOrDefault("subscriptionId")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "subscriptionId", valid_594067
  var valid_594068 = path.getOrDefault("serviceName")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "serviceName", valid_594068
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594069 = query.getOrDefault("api-version")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "api-version", valid_594069
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594070 = header.getOrDefault("If-Match")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "If-Match", valid_594070
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

proc call*(call_594072: Call_ApiUpdate_594062; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified API of the API Management service instance.
  ## 
  let valid = call_594072.validator(path, query, header, formData, body)
  let scheme = call_594072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594072.url(scheme.get, call_594072.host, call_594072.base,
                         call_594072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594072, url, valid)

proc call*(call_594073: Call_ApiUpdate_594062; resourceGroupName: string;
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
  var path_594074 = newJObject()
  var query_594075 = newJObject()
  var body_594076 = newJObject()
  add(path_594074, "resourceGroupName", newJString(resourceGroupName))
  add(query_594075, "api-version", newJString(apiVersion))
  add(path_594074, "apiId", newJString(apiId))
  add(path_594074, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594076 = parameters
  add(path_594074, "serviceName", newJString(serviceName))
  result = call_594073.call(path_594074, query_594075, nil, nil, body_594076)

var apiUpdate* = Call_ApiUpdate_594062(name: "apiUpdate", meth: HttpMethod.HttpPatch,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}",
                                    validator: validate_ApiUpdate_594063,
                                    base: "", url: url_ApiUpdate_594064,
                                    schemes: {Scheme.Https})
type
  Call_ApiDelete_594036 = ref object of OpenApiRestCall_593438
proc url_ApiDelete_594038(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ApiDelete_594037(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594039 = path.getOrDefault("resourceGroupName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "resourceGroupName", valid_594039
  var valid_594040 = path.getOrDefault("apiId")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "apiId", valid_594040
  var valid_594041 = path.getOrDefault("subscriptionId")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "subscriptionId", valid_594041
  var valid_594042 = path.getOrDefault("serviceName")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "serviceName", valid_594042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   deleteRevisions: JBool
  ##                  : Delete all revisions of the Api.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594043 = query.getOrDefault("api-version")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "api-version", valid_594043
  var valid_594044 = query.getOrDefault("deleteRevisions")
  valid_594044 = validateParameter(valid_594044, JBool, required = false, default = nil)
  if valid_594044 != nil:
    section.add "deleteRevisions", valid_594044
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594045 = header.getOrDefault("If-Match")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "If-Match", valid_594045
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594046: Call_ApiDelete_594036; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified API of the API Management service instance.
  ## 
  let valid = call_594046.validator(path, query, header, formData, body)
  let scheme = call_594046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594046.url(scheme.get, call_594046.host, call_594046.base,
                         call_594046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594046, url, valid)

proc call*(call_594047: Call_ApiDelete_594036; resourceGroupName: string;
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
  var path_594048 = newJObject()
  var query_594049 = newJObject()
  add(path_594048, "resourceGroupName", newJString(resourceGroupName))
  add(query_594049, "api-version", newJString(apiVersion))
  add(path_594048, "apiId", newJString(apiId))
  add(path_594048, "subscriptionId", newJString(subscriptionId))
  add(query_594049, "deleteRevisions", newJBool(deleteRevisions))
  add(path_594048, "serviceName", newJString(serviceName))
  result = call_594047.call(path_594048, query_594049, nil, nil, nil)

var apiDelete* = Call_ApiDelete_594036(name: "apiDelete",
                                    meth: HttpMethod.HttpDelete,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}",
                                    validator: validate_ApiDelete_594037,
                                    base: "", url: url_ApiDelete_594038,
                                    schemes: {Scheme.Https})
type
  Call_ApiDiagnosticListByService_594077 = ref object of OpenApiRestCall_593438
proc url_ApiDiagnosticListByService_594079(protocol: Scheme; host: string;
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

proc validate_ApiDiagnosticListByService_594078(path: JsonNode; query: JsonNode;
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
  var valid_594080 = path.getOrDefault("resourceGroupName")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "resourceGroupName", valid_594080
  var valid_594081 = path.getOrDefault("apiId")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "apiId", valid_594081
  var valid_594082 = path.getOrDefault("subscriptionId")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "subscriptionId", valid_594082
  var valid_594083 = path.getOrDefault("serviceName")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "serviceName", valid_594083
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
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594084 = query.getOrDefault("api-version")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "api-version", valid_594084
  var valid_594085 = query.getOrDefault("$top")
  valid_594085 = validateParameter(valid_594085, JInt, required = false, default = nil)
  if valid_594085 != nil:
    section.add "$top", valid_594085
  var valid_594086 = query.getOrDefault("$skip")
  valid_594086 = validateParameter(valid_594086, JInt, required = false, default = nil)
  if valid_594086 != nil:
    section.add "$skip", valid_594086
  var valid_594087 = query.getOrDefault("$filter")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "$filter", valid_594087
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594088: Call_ApiDiagnosticListByService_594077; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all diagnostics of an API.
  ## 
  let valid = call_594088.validator(path, query, header, formData, body)
  let scheme = call_594088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594088.url(scheme.get, call_594088.host, call_594088.base,
                         call_594088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594088, url, valid)

proc call*(call_594089: Call_ApiDiagnosticListByService_594077;
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
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  var path_594090 = newJObject()
  var query_594091 = newJObject()
  add(path_594090, "resourceGroupName", newJString(resourceGroupName))
  add(query_594091, "api-version", newJString(apiVersion))
  add(path_594090, "apiId", newJString(apiId))
  add(path_594090, "subscriptionId", newJString(subscriptionId))
  add(query_594091, "$top", newJInt(Top))
  add(query_594091, "$skip", newJInt(Skip))
  add(path_594090, "serviceName", newJString(serviceName))
  add(query_594091, "$filter", newJString(Filter))
  result = call_594089.call(path_594090, query_594091, nil, nil, nil)

var apiDiagnosticListByService* = Call_ApiDiagnosticListByService_594077(
    name: "apiDiagnosticListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics",
    validator: validate_ApiDiagnosticListByService_594078, base: "",
    url: url_ApiDiagnosticListByService_594079, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticCreateOrUpdate_594105 = ref object of OpenApiRestCall_593438
proc url_ApiDiagnosticCreateOrUpdate_594107(protocol: Scheme; host: string;
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

proc validate_ApiDiagnosticCreateOrUpdate_594106(path: JsonNode; query: JsonNode;
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
  var valid_594108 = path.getOrDefault("resourceGroupName")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "resourceGroupName", valid_594108
  var valid_594109 = path.getOrDefault("apiId")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "apiId", valid_594109
  var valid_594110 = path.getOrDefault("subscriptionId")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "subscriptionId", valid_594110
  var valid_594111 = path.getOrDefault("diagnosticId")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "diagnosticId", valid_594111
  var valid_594112 = path.getOrDefault("serviceName")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "serviceName", valid_594112
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594113 = query.getOrDefault("api-version")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "api-version", valid_594113
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_594114 = header.getOrDefault("If-Match")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "If-Match", valid_594114
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

proc call*(call_594116: Call_ApiDiagnosticCreateOrUpdate_594105; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Diagnostic for an API or updates an existing one.
  ## 
  let valid = call_594116.validator(path, query, header, formData, body)
  let scheme = call_594116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594116.url(scheme.get, call_594116.host, call_594116.base,
                         call_594116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594116, url, valid)

proc call*(call_594117: Call_ApiDiagnosticCreateOrUpdate_594105;
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
  var path_594118 = newJObject()
  var query_594119 = newJObject()
  var body_594120 = newJObject()
  add(path_594118, "resourceGroupName", newJString(resourceGroupName))
  add(query_594119, "api-version", newJString(apiVersion))
  add(path_594118, "apiId", newJString(apiId))
  add(path_594118, "subscriptionId", newJString(subscriptionId))
  add(path_594118, "diagnosticId", newJString(diagnosticId))
  if parameters != nil:
    body_594120 = parameters
  add(path_594118, "serviceName", newJString(serviceName))
  result = call_594117.call(path_594118, query_594119, nil, nil, body_594120)

var apiDiagnosticCreateOrUpdate* = Call_ApiDiagnosticCreateOrUpdate_594105(
    name: "apiDiagnosticCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}",
    validator: validate_ApiDiagnosticCreateOrUpdate_594106, base: "",
    url: url_ApiDiagnosticCreateOrUpdate_594107, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticGetEntityTag_594135 = ref object of OpenApiRestCall_593438
proc url_ApiDiagnosticGetEntityTag_594137(protocol: Scheme; host: string;
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

proc validate_ApiDiagnosticGetEntityTag_594136(path: JsonNode; query: JsonNode;
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
  var valid_594138 = path.getOrDefault("resourceGroupName")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "resourceGroupName", valid_594138
  var valid_594139 = path.getOrDefault("apiId")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "apiId", valid_594139
  var valid_594140 = path.getOrDefault("subscriptionId")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "subscriptionId", valid_594140
  var valid_594141 = path.getOrDefault("diagnosticId")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "diagnosticId", valid_594141
  var valid_594142 = path.getOrDefault("serviceName")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "serviceName", valid_594142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594143 = query.getOrDefault("api-version")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "api-version", valid_594143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594144: Call_ApiDiagnosticGetEntityTag_594135; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the Diagnostic for an API specified by its identifier.
  ## 
  let valid = call_594144.validator(path, query, header, formData, body)
  let scheme = call_594144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594144.url(scheme.get, call_594144.host, call_594144.base,
                         call_594144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594144, url, valid)

proc call*(call_594145: Call_ApiDiagnosticGetEntityTag_594135;
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
  var path_594146 = newJObject()
  var query_594147 = newJObject()
  add(path_594146, "resourceGroupName", newJString(resourceGroupName))
  add(query_594147, "api-version", newJString(apiVersion))
  add(path_594146, "apiId", newJString(apiId))
  add(path_594146, "subscriptionId", newJString(subscriptionId))
  add(path_594146, "diagnosticId", newJString(diagnosticId))
  add(path_594146, "serviceName", newJString(serviceName))
  result = call_594145.call(path_594146, query_594147, nil, nil, nil)

var apiDiagnosticGetEntityTag* = Call_ApiDiagnosticGetEntityTag_594135(
    name: "apiDiagnosticGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}",
    validator: validate_ApiDiagnosticGetEntityTag_594136, base: "",
    url: url_ApiDiagnosticGetEntityTag_594137, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticGet_594092 = ref object of OpenApiRestCall_593438
proc url_ApiDiagnosticGet_594094(protocol: Scheme; host: string; base: string;
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

proc validate_ApiDiagnosticGet_594093(path: JsonNode; query: JsonNode;
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
  var valid_594095 = path.getOrDefault("resourceGroupName")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "resourceGroupName", valid_594095
  var valid_594096 = path.getOrDefault("apiId")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "apiId", valid_594096
  var valid_594097 = path.getOrDefault("subscriptionId")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "subscriptionId", valid_594097
  var valid_594098 = path.getOrDefault("diagnosticId")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "diagnosticId", valid_594098
  var valid_594099 = path.getOrDefault("serviceName")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "serviceName", valid_594099
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594100 = query.getOrDefault("api-version")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "api-version", valid_594100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594101: Call_ApiDiagnosticGet_594092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the Diagnostic for an API specified by its identifier.
  ## 
  let valid = call_594101.validator(path, query, header, formData, body)
  let scheme = call_594101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594101.url(scheme.get, call_594101.host, call_594101.base,
                         call_594101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594101, url, valid)

proc call*(call_594102: Call_ApiDiagnosticGet_594092; resourceGroupName: string;
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
  var path_594103 = newJObject()
  var query_594104 = newJObject()
  add(path_594103, "resourceGroupName", newJString(resourceGroupName))
  add(query_594104, "api-version", newJString(apiVersion))
  add(path_594103, "apiId", newJString(apiId))
  add(path_594103, "subscriptionId", newJString(subscriptionId))
  add(path_594103, "diagnosticId", newJString(diagnosticId))
  add(path_594103, "serviceName", newJString(serviceName))
  result = call_594102.call(path_594103, query_594104, nil, nil, nil)

var apiDiagnosticGet* = Call_ApiDiagnosticGet_594092(name: "apiDiagnosticGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}",
    validator: validate_ApiDiagnosticGet_594093, base: "",
    url: url_ApiDiagnosticGet_594094, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticUpdate_594148 = ref object of OpenApiRestCall_593438
proc url_ApiDiagnosticUpdate_594150(protocol: Scheme; host: string; base: string;
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

proc validate_ApiDiagnosticUpdate_594149(path: JsonNode; query: JsonNode;
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
  var valid_594151 = path.getOrDefault("resourceGroupName")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "resourceGroupName", valid_594151
  var valid_594152 = path.getOrDefault("apiId")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "apiId", valid_594152
  var valid_594153 = path.getOrDefault("subscriptionId")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "subscriptionId", valid_594153
  var valid_594154 = path.getOrDefault("diagnosticId")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "diagnosticId", valid_594154
  var valid_594155 = path.getOrDefault("serviceName")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "serviceName", valid_594155
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594156 = query.getOrDefault("api-version")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "api-version", valid_594156
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594157 = header.getOrDefault("If-Match")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "If-Match", valid_594157
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

proc call*(call_594159: Call_ApiDiagnosticUpdate_594148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the Diagnostic for an API specified by its identifier.
  ## 
  let valid = call_594159.validator(path, query, header, formData, body)
  let scheme = call_594159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594159.url(scheme.get, call_594159.host, call_594159.base,
                         call_594159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594159, url, valid)

proc call*(call_594160: Call_ApiDiagnosticUpdate_594148; resourceGroupName: string;
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
  var path_594161 = newJObject()
  var query_594162 = newJObject()
  var body_594163 = newJObject()
  add(path_594161, "resourceGroupName", newJString(resourceGroupName))
  add(query_594162, "api-version", newJString(apiVersion))
  add(path_594161, "apiId", newJString(apiId))
  add(path_594161, "subscriptionId", newJString(subscriptionId))
  add(path_594161, "diagnosticId", newJString(diagnosticId))
  if parameters != nil:
    body_594163 = parameters
  add(path_594161, "serviceName", newJString(serviceName))
  result = call_594160.call(path_594161, query_594162, nil, nil, body_594163)

var apiDiagnosticUpdate* = Call_ApiDiagnosticUpdate_594148(
    name: "apiDiagnosticUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}",
    validator: validate_ApiDiagnosticUpdate_594149, base: "",
    url: url_ApiDiagnosticUpdate_594150, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticDelete_594121 = ref object of OpenApiRestCall_593438
proc url_ApiDiagnosticDelete_594123(protocol: Scheme; host: string; base: string;
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

proc validate_ApiDiagnosticDelete_594122(path: JsonNode; query: JsonNode;
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
  var valid_594124 = path.getOrDefault("resourceGroupName")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "resourceGroupName", valid_594124
  var valid_594125 = path.getOrDefault("apiId")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "apiId", valid_594125
  var valid_594126 = path.getOrDefault("subscriptionId")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "subscriptionId", valid_594126
  var valid_594127 = path.getOrDefault("diagnosticId")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "diagnosticId", valid_594127
  var valid_594128 = path.getOrDefault("serviceName")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "serviceName", valid_594128
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594129 = query.getOrDefault("api-version")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "api-version", valid_594129
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594130 = header.getOrDefault("If-Match")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "If-Match", valid_594130
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594131: Call_ApiDiagnosticDelete_594121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Diagnostic from an API.
  ## 
  let valid = call_594131.validator(path, query, header, formData, body)
  let scheme = call_594131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594131.url(scheme.get, call_594131.host, call_594131.base,
                         call_594131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594131, url, valid)

proc call*(call_594132: Call_ApiDiagnosticDelete_594121; resourceGroupName: string;
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
  var path_594133 = newJObject()
  var query_594134 = newJObject()
  add(path_594133, "resourceGroupName", newJString(resourceGroupName))
  add(query_594134, "api-version", newJString(apiVersion))
  add(path_594133, "apiId", newJString(apiId))
  add(path_594133, "subscriptionId", newJString(subscriptionId))
  add(path_594133, "diagnosticId", newJString(diagnosticId))
  add(path_594133, "serviceName", newJString(serviceName))
  result = call_594132.call(path_594133, query_594134, nil, nil, nil)

var apiDiagnosticDelete* = Call_ApiDiagnosticDelete_594121(
    name: "apiDiagnosticDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}",
    validator: validate_ApiDiagnosticDelete_594122, base: "",
    url: url_ApiDiagnosticDelete_594123, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticLoggerListByService_594164 = ref object of OpenApiRestCall_593438
proc url_ApiDiagnosticLoggerListByService_594166(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "diagnosticId"),
               (kind: ConstantSegment, value: "/loggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiDiagnosticLoggerListByService_594165(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all loggers associated with the specified Diagnostic of an API.
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
  var valid_594167 = path.getOrDefault("resourceGroupName")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "resourceGroupName", valid_594167
  var valid_594168 = path.getOrDefault("apiId")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "apiId", valid_594168
  var valid_594169 = path.getOrDefault("subscriptionId")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "subscriptionId", valid_594169
  var valid_594170 = path.getOrDefault("diagnosticId")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "diagnosticId", valid_594170
  var valid_594171 = path.getOrDefault("serviceName")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "serviceName", valid_594171
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
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | type        | eq                     |                                   |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594172 = query.getOrDefault("api-version")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "api-version", valid_594172
  var valid_594173 = query.getOrDefault("$top")
  valid_594173 = validateParameter(valid_594173, JInt, required = false, default = nil)
  if valid_594173 != nil:
    section.add "$top", valid_594173
  var valid_594174 = query.getOrDefault("$skip")
  valid_594174 = validateParameter(valid_594174, JInt, required = false, default = nil)
  if valid_594174 != nil:
    section.add "$skip", valid_594174
  var valid_594175 = query.getOrDefault("$filter")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = nil)
  if valid_594175 != nil:
    section.add "$filter", valid_594175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594176: Call_ApiDiagnosticLoggerListByService_594164;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all loggers associated with the specified Diagnostic of an API.
  ## 
  let valid = call_594176.validator(path, query, header, formData, body)
  let scheme = call_594176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594176.url(scheme.get, call_594176.host, call_594176.base,
                         call_594176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594176, url, valid)

proc call*(call_594177: Call_ApiDiagnosticLoggerListByService_594164;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; diagnosticId: string; serviceName: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## apiDiagnosticLoggerListByService
  ## Lists all loggers associated with the specified Diagnostic of an API.
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
  ##   diagnosticId: string (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | type        | eq                     |                                   |
  var path_594178 = newJObject()
  var query_594179 = newJObject()
  add(path_594178, "resourceGroupName", newJString(resourceGroupName))
  add(query_594179, "api-version", newJString(apiVersion))
  add(path_594178, "apiId", newJString(apiId))
  add(path_594178, "subscriptionId", newJString(subscriptionId))
  add(query_594179, "$top", newJInt(Top))
  add(query_594179, "$skip", newJInt(Skip))
  add(path_594178, "diagnosticId", newJString(diagnosticId))
  add(path_594178, "serviceName", newJString(serviceName))
  add(query_594179, "$filter", newJString(Filter))
  result = call_594177.call(path_594178, query_594179, nil, nil, nil)

var apiDiagnosticLoggerListByService* = Call_ApiDiagnosticLoggerListByService_594164(
    name: "apiDiagnosticLoggerListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}/loggers",
    validator: validate_ApiDiagnosticLoggerListByService_594165, base: "",
    url: url_ApiDiagnosticLoggerListByService_594166, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticLoggerCreateOrUpdate_594180 = ref object of OpenApiRestCall_593438
proc url_ApiDiagnosticLoggerCreateOrUpdate_594182(protocol: Scheme; host: string;
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
  assert "loggerid" in path, "`loggerid` is a required path parameter"
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
               (kind: VariableSegment, value: "diagnosticId"),
               (kind: ConstantSegment, value: "/loggers/"),
               (kind: VariableSegment, value: "loggerid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiDiagnosticLoggerCreateOrUpdate_594181(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Attaches a logger to a diagnostic for an API.
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
  ##   loggerid: JString (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594183 = path.getOrDefault("resourceGroupName")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "resourceGroupName", valid_594183
  var valid_594184 = path.getOrDefault("apiId")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "apiId", valid_594184
  var valid_594185 = path.getOrDefault("subscriptionId")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "subscriptionId", valid_594185
  var valid_594186 = path.getOrDefault("loggerid")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "loggerid", valid_594186
  var valid_594187 = path.getOrDefault("diagnosticId")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "diagnosticId", valid_594187
  var valid_594188 = path.getOrDefault("serviceName")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "serviceName", valid_594188
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594189 = query.getOrDefault("api-version")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "api-version", valid_594189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594190: Call_ApiDiagnosticLoggerCreateOrUpdate_594180;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Attaches a logger to a diagnostic for an API.
  ## 
  let valid = call_594190.validator(path, query, header, formData, body)
  let scheme = call_594190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594190.url(scheme.get, call_594190.host, call_594190.base,
                         call_594190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594190, url, valid)

proc call*(call_594191: Call_ApiDiagnosticLoggerCreateOrUpdate_594180;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; loggerid: string; diagnosticId: string;
          serviceName: string): Recallable =
  ## apiDiagnosticLoggerCreateOrUpdate
  ## Attaches a logger to a diagnostic for an API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerid: string (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   diagnosticId: string (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594192 = newJObject()
  var query_594193 = newJObject()
  add(path_594192, "resourceGroupName", newJString(resourceGroupName))
  add(query_594193, "api-version", newJString(apiVersion))
  add(path_594192, "apiId", newJString(apiId))
  add(path_594192, "subscriptionId", newJString(subscriptionId))
  add(path_594192, "loggerid", newJString(loggerid))
  add(path_594192, "diagnosticId", newJString(diagnosticId))
  add(path_594192, "serviceName", newJString(serviceName))
  result = call_594191.call(path_594192, query_594193, nil, nil, nil)

var apiDiagnosticLoggerCreateOrUpdate* = Call_ApiDiagnosticLoggerCreateOrUpdate_594180(
    name: "apiDiagnosticLoggerCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}/loggers/{loggerid}",
    validator: validate_ApiDiagnosticLoggerCreateOrUpdate_594181, base: "",
    url: url_ApiDiagnosticLoggerCreateOrUpdate_594182, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticLoggerCheckEntityExists_594208 = ref object of OpenApiRestCall_593438
proc url_ApiDiagnosticLoggerCheckEntityExists_594210(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
  assert "loggerid" in path, "`loggerid` is a required path parameter"
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
               (kind: VariableSegment, value: "diagnosticId"),
               (kind: ConstantSegment, value: "/loggers/"),
               (kind: VariableSegment, value: "loggerid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiDiagnosticLoggerCheckEntityExists_594209(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks that logger entity specified by identifier is associated with the diagnostics entity.
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
  ##   loggerid: JString (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594211 = path.getOrDefault("resourceGroupName")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "resourceGroupName", valid_594211
  var valid_594212 = path.getOrDefault("apiId")
  valid_594212 = validateParameter(valid_594212, JString, required = true,
                                 default = nil)
  if valid_594212 != nil:
    section.add "apiId", valid_594212
  var valid_594213 = path.getOrDefault("subscriptionId")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "subscriptionId", valid_594213
  var valid_594214 = path.getOrDefault("loggerid")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = nil)
  if valid_594214 != nil:
    section.add "loggerid", valid_594214
  var valid_594215 = path.getOrDefault("diagnosticId")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "diagnosticId", valid_594215
  var valid_594216 = path.getOrDefault("serviceName")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "serviceName", valid_594216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594217 = query.getOrDefault("api-version")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "api-version", valid_594217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594218: Call_ApiDiagnosticLoggerCheckEntityExists_594208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks that logger entity specified by identifier is associated with the diagnostics entity.
  ## 
  let valid = call_594218.validator(path, query, header, formData, body)
  let scheme = call_594218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594218.url(scheme.get, call_594218.host, call_594218.base,
                         call_594218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594218, url, valid)

proc call*(call_594219: Call_ApiDiagnosticLoggerCheckEntityExists_594208;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; loggerid: string; diagnosticId: string;
          serviceName: string): Recallable =
  ## apiDiagnosticLoggerCheckEntityExists
  ## Checks that logger entity specified by identifier is associated with the diagnostics entity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerid: string (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   diagnosticId: string (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594220 = newJObject()
  var query_594221 = newJObject()
  add(path_594220, "resourceGroupName", newJString(resourceGroupName))
  add(query_594221, "api-version", newJString(apiVersion))
  add(path_594220, "apiId", newJString(apiId))
  add(path_594220, "subscriptionId", newJString(subscriptionId))
  add(path_594220, "loggerid", newJString(loggerid))
  add(path_594220, "diagnosticId", newJString(diagnosticId))
  add(path_594220, "serviceName", newJString(serviceName))
  result = call_594219.call(path_594220, query_594221, nil, nil, nil)

var apiDiagnosticLoggerCheckEntityExists* = Call_ApiDiagnosticLoggerCheckEntityExists_594208(
    name: "apiDiagnosticLoggerCheckEntityExists", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}/loggers/{loggerid}",
    validator: validate_ApiDiagnosticLoggerCheckEntityExists_594209, base: "",
    url: url_ApiDiagnosticLoggerCheckEntityExists_594210, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticLoggerDelete_594194 = ref object of OpenApiRestCall_593438
proc url_ApiDiagnosticLoggerDelete_594196(protocol: Scheme; host: string;
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
  assert "loggerid" in path, "`loggerid` is a required path parameter"
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
               (kind: VariableSegment, value: "diagnosticId"),
               (kind: ConstantSegment, value: "/loggers/"),
               (kind: VariableSegment, value: "loggerid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiDiagnosticLoggerDelete_594195(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified Logger from Diagnostic for an API.
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
  ##   loggerid: JString (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594197 = path.getOrDefault("resourceGroupName")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = nil)
  if valid_594197 != nil:
    section.add "resourceGroupName", valid_594197
  var valid_594198 = path.getOrDefault("apiId")
  valid_594198 = validateParameter(valid_594198, JString, required = true,
                                 default = nil)
  if valid_594198 != nil:
    section.add "apiId", valid_594198
  var valid_594199 = path.getOrDefault("subscriptionId")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "subscriptionId", valid_594199
  var valid_594200 = path.getOrDefault("loggerid")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "loggerid", valid_594200
  var valid_594201 = path.getOrDefault("diagnosticId")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "diagnosticId", valid_594201
  var valid_594202 = path.getOrDefault("serviceName")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "serviceName", valid_594202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594203 = query.getOrDefault("api-version")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "api-version", valid_594203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594204: Call_ApiDiagnosticLoggerDelete_594194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Logger from Diagnostic for an API.
  ## 
  let valid = call_594204.validator(path, query, header, formData, body)
  let scheme = call_594204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594204.url(scheme.get, call_594204.host, call_594204.base,
                         call_594204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594204, url, valid)

proc call*(call_594205: Call_ApiDiagnosticLoggerDelete_594194;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; loggerid: string; diagnosticId: string;
          serviceName: string): Recallable =
  ## apiDiagnosticLoggerDelete
  ## Deletes the specified Logger from Diagnostic for an API.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerid: string (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   diagnosticId: string (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594206 = newJObject()
  var query_594207 = newJObject()
  add(path_594206, "resourceGroupName", newJString(resourceGroupName))
  add(query_594207, "api-version", newJString(apiVersion))
  add(path_594206, "apiId", newJString(apiId))
  add(path_594206, "subscriptionId", newJString(subscriptionId))
  add(path_594206, "loggerid", newJString(loggerid))
  add(path_594206, "diagnosticId", newJString(diagnosticId))
  add(path_594206, "serviceName", newJString(serviceName))
  result = call_594205.call(path_594206, query_594207, nil, nil, nil)

var apiDiagnosticLoggerDelete* = Call_ApiDiagnosticLoggerDelete_594194(
    name: "apiDiagnosticLoggerDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}/loggers/{loggerid}",
    validator: validate_ApiDiagnosticLoggerDelete_594195, base: "",
    url: url_ApiDiagnosticLoggerDelete_594196, schemes: {Scheme.Https})
type
  Call_ApiIssueListByService_594222 = ref object of OpenApiRestCall_593438
proc url_ApiIssueListByService_594224(protocol: Scheme; host: string; base: string;
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

proc validate_ApiIssueListByService_594223(path: JsonNode; query: JsonNode;
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
  var valid_594225 = path.getOrDefault("resourceGroupName")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = nil)
  if valid_594225 != nil:
    section.add "resourceGroupName", valid_594225
  var valid_594226 = path.getOrDefault("apiId")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "apiId", valid_594226
  var valid_594227 = path.getOrDefault("subscriptionId")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "subscriptionId", valid_594227
  var valid_594228 = path.getOrDefault("serviceName")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "serviceName", valid_594228
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
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | state        | eq                     |                                   |
  ## | userId          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594229 = query.getOrDefault("api-version")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "api-version", valid_594229
  var valid_594230 = query.getOrDefault("$top")
  valid_594230 = validateParameter(valid_594230, JInt, required = false, default = nil)
  if valid_594230 != nil:
    section.add "$top", valid_594230
  var valid_594231 = query.getOrDefault("$skip")
  valid_594231 = validateParameter(valid_594231, JInt, required = false, default = nil)
  if valid_594231 != nil:
    section.add "$skip", valid_594231
  var valid_594232 = query.getOrDefault("$filter")
  valid_594232 = validateParameter(valid_594232, JString, required = false,
                                 default = nil)
  if valid_594232 != nil:
    section.add "$filter", valid_594232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594233: Call_ApiIssueListByService_594222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all issues associated with the specified API.
  ## 
  let valid = call_594233.validator(path, query, header, formData, body)
  let scheme = call_594233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594233.url(scheme.get, call_594233.host, call_594233.base,
                         call_594233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594233, url, valid)

proc call*(call_594234: Call_ApiIssueListByService_594222;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; Top: int = 0; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## apiIssueListByService
  ## Lists all issues associated with the specified API.
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
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | state        | eq                     |                                   |
  ## | userId          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  var path_594235 = newJObject()
  var query_594236 = newJObject()
  add(path_594235, "resourceGroupName", newJString(resourceGroupName))
  add(query_594236, "api-version", newJString(apiVersion))
  add(path_594235, "apiId", newJString(apiId))
  add(path_594235, "subscriptionId", newJString(subscriptionId))
  add(query_594236, "$top", newJInt(Top))
  add(query_594236, "$skip", newJInt(Skip))
  add(path_594235, "serviceName", newJString(serviceName))
  add(query_594236, "$filter", newJString(Filter))
  result = call_594234.call(path_594235, query_594236, nil, nil, nil)

var apiIssueListByService* = Call_ApiIssueListByService_594222(
    name: "apiIssueListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues",
    validator: validate_ApiIssueListByService_594223, base: "",
    url: url_ApiIssueListByService_594224, schemes: {Scheme.Https})
type
  Call_ApiIssueCreateOrUpdate_594250 = ref object of OpenApiRestCall_593438
proc url_ApiIssueCreateOrUpdate_594252(protocol: Scheme; host: string; base: string;
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

proc validate_ApiIssueCreateOrUpdate_594251(path: JsonNode; query: JsonNode;
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
  var valid_594253 = path.getOrDefault("resourceGroupName")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "resourceGroupName", valid_594253
  var valid_594254 = path.getOrDefault("apiId")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "apiId", valid_594254
  var valid_594255 = path.getOrDefault("issueId")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "issueId", valid_594255
  var valid_594256 = path.getOrDefault("subscriptionId")
  valid_594256 = validateParameter(valid_594256, JString, required = true,
                                 default = nil)
  if valid_594256 != nil:
    section.add "subscriptionId", valid_594256
  var valid_594257 = path.getOrDefault("serviceName")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "serviceName", valid_594257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594258 = query.getOrDefault("api-version")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "api-version", valid_594258
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Issue Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  var valid_594259 = header.getOrDefault("If-Match")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = nil)
  if valid_594259 != nil:
    section.add "If-Match", valid_594259
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

proc call*(call_594261: Call_ApiIssueCreateOrUpdate_594250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Issue for an API or updates an existing one.
  ## 
  let valid = call_594261.validator(path, query, header, formData, body)
  let scheme = call_594261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594261.url(scheme.get, call_594261.host, call_594261.base,
                         call_594261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594261, url, valid)

proc call*(call_594262: Call_ApiIssueCreateOrUpdate_594250;
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
  var path_594263 = newJObject()
  var query_594264 = newJObject()
  var body_594265 = newJObject()
  add(path_594263, "resourceGroupName", newJString(resourceGroupName))
  add(query_594264, "api-version", newJString(apiVersion))
  add(path_594263, "apiId", newJString(apiId))
  add(path_594263, "issueId", newJString(issueId))
  add(path_594263, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594265 = parameters
  add(path_594263, "serviceName", newJString(serviceName))
  result = call_594262.call(path_594263, query_594264, nil, nil, body_594265)

var apiIssueCreateOrUpdate* = Call_ApiIssueCreateOrUpdate_594250(
    name: "apiIssueCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}",
    validator: validate_ApiIssueCreateOrUpdate_594251, base: "",
    url: url_ApiIssueCreateOrUpdate_594252, schemes: {Scheme.Https})
type
  Call_ApiIssueGetEntityTag_594280 = ref object of OpenApiRestCall_593438
proc url_ApiIssueGetEntityTag_594282(protocol: Scheme; host: string; base: string;
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

proc validate_ApiIssueGetEntityTag_594281(path: JsonNode; query: JsonNode;
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
  var valid_594283 = path.getOrDefault("resourceGroupName")
  valid_594283 = validateParameter(valid_594283, JString, required = true,
                                 default = nil)
  if valid_594283 != nil:
    section.add "resourceGroupName", valid_594283
  var valid_594284 = path.getOrDefault("apiId")
  valid_594284 = validateParameter(valid_594284, JString, required = true,
                                 default = nil)
  if valid_594284 != nil:
    section.add "apiId", valid_594284
  var valid_594285 = path.getOrDefault("issueId")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "issueId", valid_594285
  var valid_594286 = path.getOrDefault("subscriptionId")
  valid_594286 = validateParameter(valid_594286, JString, required = true,
                                 default = nil)
  if valid_594286 != nil:
    section.add "subscriptionId", valid_594286
  var valid_594287 = path.getOrDefault("serviceName")
  valid_594287 = validateParameter(valid_594287, JString, required = true,
                                 default = nil)
  if valid_594287 != nil:
    section.add "serviceName", valid_594287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594288 = query.getOrDefault("api-version")
  valid_594288 = validateParameter(valid_594288, JString, required = true,
                                 default = nil)
  if valid_594288 != nil:
    section.add "api-version", valid_594288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594289: Call_ApiIssueGetEntityTag_594280; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the Issue for an API specified by its identifier.
  ## 
  let valid = call_594289.validator(path, query, header, formData, body)
  let scheme = call_594289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594289.url(scheme.get, call_594289.host, call_594289.base,
                         call_594289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594289, url, valid)

proc call*(call_594290: Call_ApiIssueGetEntityTag_594280;
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
  var path_594291 = newJObject()
  var query_594292 = newJObject()
  add(path_594291, "resourceGroupName", newJString(resourceGroupName))
  add(query_594292, "api-version", newJString(apiVersion))
  add(path_594291, "apiId", newJString(apiId))
  add(path_594291, "issueId", newJString(issueId))
  add(path_594291, "subscriptionId", newJString(subscriptionId))
  add(path_594291, "serviceName", newJString(serviceName))
  result = call_594290.call(path_594291, query_594292, nil, nil, nil)

var apiIssueGetEntityTag* = Call_ApiIssueGetEntityTag_594280(
    name: "apiIssueGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}",
    validator: validate_ApiIssueGetEntityTag_594281, base: "",
    url: url_ApiIssueGetEntityTag_594282, schemes: {Scheme.Https})
type
  Call_ApiIssueGet_594237 = ref object of OpenApiRestCall_593438
proc url_ApiIssueGet_594239(protocol: Scheme; host: string; base: string;
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

proc validate_ApiIssueGet_594238(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594240 = path.getOrDefault("resourceGroupName")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "resourceGroupName", valid_594240
  var valid_594241 = path.getOrDefault("apiId")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "apiId", valid_594241
  var valid_594242 = path.getOrDefault("issueId")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "issueId", valid_594242
  var valid_594243 = path.getOrDefault("subscriptionId")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = nil)
  if valid_594243 != nil:
    section.add "subscriptionId", valid_594243
  var valid_594244 = path.getOrDefault("serviceName")
  valid_594244 = validateParameter(valid_594244, JString, required = true,
                                 default = nil)
  if valid_594244 != nil:
    section.add "serviceName", valid_594244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594245 = query.getOrDefault("api-version")
  valid_594245 = validateParameter(valid_594245, JString, required = true,
                                 default = nil)
  if valid_594245 != nil:
    section.add "api-version", valid_594245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594246: Call_ApiIssueGet_594237; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the Issue for an API specified by its identifier.
  ## 
  let valid = call_594246.validator(path, query, header, formData, body)
  let scheme = call_594246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594246.url(scheme.get, call_594246.host, call_594246.base,
                         call_594246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594246, url, valid)

proc call*(call_594247: Call_ApiIssueGet_594237; resourceGroupName: string;
          apiVersion: string; apiId: string; issueId: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## apiIssueGet
  ## Gets the details of the Issue for an API specified by its identifier.
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
  var path_594248 = newJObject()
  var query_594249 = newJObject()
  add(path_594248, "resourceGroupName", newJString(resourceGroupName))
  add(query_594249, "api-version", newJString(apiVersion))
  add(path_594248, "apiId", newJString(apiId))
  add(path_594248, "issueId", newJString(issueId))
  add(path_594248, "subscriptionId", newJString(subscriptionId))
  add(path_594248, "serviceName", newJString(serviceName))
  result = call_594247.call(path_594248, query_594249, nil, nil, nil)

var apiIssueGet* = Call_ApiIssueGet_594237(name: "apiIssueGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}",
                                        validator: validate_ApiIssueGet_594238,
                                        base: "", url: url_ApiIssueGet_594239,
                                        schemes: {Scheme.Https})
type
  Call_ApiIssueUpdate_594293 = ref object of OpenApiRestCall_593438
proc url_ApiIssueUpdate_594295(protocol: Scheme; host: string; base: string;
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

proc validate_ApiIssueUpdate_594294(path: JsonNode; query: JsonNode;
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
  var valid_594296 = path.getOrDefault("resourceGroupName")
  valid_594296 = validateParameter(valid_594296, JString, required = true,
                                 default = nil)
  if valid_594296 != nil:
    section.add "resourceGroupName", valid_594296
  var valid_594297 = path.getOrDefault("apiId")
  valid_594297 = validateParameter(valid_594297, JString, required = true,
                                 default = nil)
  if valid_594297 != nil:
    section.add "apiId", valid_594297
  var valid_594298 = path.getOrDefault("issueId")
  valid_594298 = validateParameter(valid_594298, JString, required = true,
                                 default = nil)
  if valid_594298 != nil:
    section.add "issueId", valid_594298
  var valid_594299 = path.getOrDefault("subscriptionId")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "subscriptionId", valid_594299
  var valid_594300 = path.getOrDefault("serviceName")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "serviceName", valid_594300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594301 = query.getOrDefault("api-version")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "api-version", valid_594301
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Issue Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  var valid_594302 = header.getOrDefault("If-Match")
  valid_594302 = validateParameter(valid_594302, JString, required = false,
                                 default = nil)
  if valid_594302 != nil:
    section.add "If-Match", valid_594302
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

proc call*(call_594304: Call_ApiIssueUpdate_594293; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing issue for an API.
  ## 
  let valid = call_594304.validator(path, query, header, formData, body)
  let scheme = call_594304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594304.url(scheme.get, call_594304.host, call_594304.base,
                         call_594304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594304, url, valid)

proc call*(call_594305: Call_ApiIssueUpdate_594293; resourceGroupName: string;
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
  var path_594306 = newJObject()
  var query_594307 = newJObject()
  var body_594308 = newJObject()
  add(path_594306, "resourceGroupName", newJString(resourceGroupName))
  add(query_594307, "api-version", newJString(apiVersion))
  add(path_594306, "apiId", newJString(apiId))
  add(path_594306, "issueId", newJString(issueId))
  add(path_594306, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594308 = parameters
  add(path_594306, "serviceName", newJString(serviceName))
  result = call_594305.call(path_594306, query_594307, nil, nil, body_594308)

var apiIssueUpdate* = Call_ApiIssueUpdate_594293(name: "apiIssueUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}",
    validator: validate_ApiIssueUpdate_594294, base: "", url: url_ApiIssueUpdate_594295,
    schemes: {Scheme.Https})
type
  Call_ApiIssueDelete_594266 = ref object of OpenApiRestCall_593438
proc url_ApiIssueDelete_594268(protocol: Scheme; host: string; base: string;
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

proc validate_ApiIssueDelete_594267(path: JsonNode; query: JsonNode;
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
  var valid_594269 = path.getOrDefault("resourceGroupName")
  valid_594269 = validateParameter(valid_594269, JString, required = true,
                                 default = nil)
  if valid_594269 != nil:
    section.add "resourceGroupName", valid_594269
  var valid_594270 = path.getOrDefault("apiId")
  valid_594270 = validateParameter(valid_594270, JString, required = true,
                                 default = nil)
  if valid_594270 != nil:
    section.add "apiId", valid_594270
  var valid_594271 = path.getOrDefault("issueId")
  valid_594271 = validateParameter(valid_594271, JString, required = true,
                                 default = nil)
  if valid_594271 != nil:
    section.add "issueId", valid_594271
  var valid_594272 = path.getOrDefault("subscriptionId")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = nil)
  if valid_594272 != nil:
    section.add "subscriptionId", valid_594272
  var valid_594273 = path.getOrDefault("serviceName")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "serviceName", valid_594273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594274 = query.getOrDefault("api-version")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "api-version", valid_594274
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Issue Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594275 = header.getOrDefault("If-Match")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "If-Match", valid_594275
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594276: Call_ApiIssueDelete_594266; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Issue from an API.
  ## 
  let valid = call_594276.validator(path, query, header, formData, body)
  let scheme = call_594276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594276.url(scheme.get, call_594276.host, call_594276.base,
                         call_594276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594276, url, valid)

proc call*(call_594277: Call_ApiIssueDelete_594266; resourceGroupName: string;
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
  var path_594278 = newJObject()
  var query_594279 = newJObject()
  add(path_594278, "resourceGroupName", newJString(resourceGroupName))
  add(query_594279, "api-version", newJString(apiVersion))
  add(path_594278, "apiId", newJString(apiId))
  add(path_594278, "issueId", newJString(issueId))
  add(path_594278, "subscriptionId", newJString(subscriptionId))
  add(path_594278, "serviceName", newJString(serviceName))
  result = call_594277.call(path_594278, query_594279, nil, nil, nil)

var apiIssueDelete* = Call_ApiIssueDelete_594266(name: "apiIssueDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}",
    validator: validate_ApiIssueDelete_594267, base: "", url: url_ApiIssueDelete_594268,
    schemes: {Scheme.Https})
type
  Call_ApiIssueAttachmentListByService_594309 = ref object of OpenApiRestCall_593438
proc url_ApiIssueAttachmentListByService_594311(protocol: Scheme; host: string;
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

proc validate_ApiIssueAttachmentListByService_594310(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_594312 = path.getOrDefault("resourceGroupName")
  valid_594312 = validateParameter(valid_594312, JString, required = true,
                                 default = nil)
  if valid_594312 != nil:
    section.add "resourceGroupName", valid_594312
  var valid_594313 = path.getOrDefault("apiId")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "apiId", valid_594313
  var valid_594314 = path.getOrDefault("issueId")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "issueId", valid_594314
  var valid_594315 = path.getOrDefault("subscriptionId")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "subscriptionId", valid_594315
  var valid_594316 = path.getOrDefault("serviceName")
  valid_594316 = validateParameter(valid_594316, JString, required = true,
                                 default = nil)
  if valid_594316 != nil:
    section.add "serviceName", valid_594316
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
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | userId          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594317 = query.getOrDefault("api-version")
  valid_594317 = validateParameter(valid_594317, JString, required = true,
                                 default = nil)
  if valid_594317 != nil:
    section.add "api-version", valid_594317
  var valid_594318 = query.getOrDefault("$top")
  valid_594318 = validateParameter(valid_594318, JInt, required = false, default = nil)
  if valid_594318 != nil:
    section.add "$top", valid_594318
  var valid_594319 = query.getOrDefault("$skip")
  valid_594319 = validateParameter(valid_594319, JInt, required = false, default = nil)
  if valid_594319 != nil:
    section.add "$skip", valid_594319
  var valid_594320 = query.getOrDefault("$filter")
  valid_594320 = validateParameter(valid_594320, JString, required = false,
                                 default = nil)
  if valid_594320 != nil:
    section.add "$filter", valid_594320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594321: Call_ApiIssueAttachmentListByService_594309;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all comments for the Issue associated with the specified API.
  ## 
  let valid = call_594321.validator(path, query, header, formData, body)
  let scheme = call_594321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594321.url(scheme.get, call_594321.host, call_594321.base,
                         call_594321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594321, url, valid)

proc call*(call_594322: Call_ApiIssueAttachmentListByService_594309;
          resourceGroupName: string; apiVersion: string; apiId: string;
          issueId: string; subscriptionId: string; serviceName: string; Top: int = 0;
          Skip: int = 0; Filter: string = ""): Recallable =
  ## apiIssueAttachmentListByService
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
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | userId          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  var path_594323 = newJObject()
  var query_594324 = newJObject()
  add(path_594323, "resourceGroupName", newJString(resourceGroupName))
  add(query_594324, "api-version", newJString(apiVersion))
  add(path_594323, "apiId", newJString(apiId))
  add(path_594323, "issueId", newJString(issueId))
  add(path_594323, "subscriptionId", newJString(subscriptionId))
  add(query_594324, "$top", newJInt(Top))
  add(query_594324, "$skip", newJInt(Skip))
  add(path_594323, "serviceName", newJString(serviceName))
  add(query_594324, "$filter", newJString(Filter))
  result = call_594322.call(path_594323, query_594324, nil, nil, nil)

var apiIssueAttachmentListByService* = Call_ApiIssueAttachmentListByService_594309(
    name: "apiIssueAttachmentListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/attachments",
    validator: validate_ApiIssueAttachmentListByService_594310, base: "",
    url: url_ApiIssueAttachmentListByService_594311, schemes: {Scheme.Https})
type
  Call_ApiIssueAttachmentCreateOrUpdate_594339 = ref object of OpenApiRestCall_593438
proc url_ApiIssueAttachmentCreateOrUpdate_594341(protocol: Scheme; host: string;
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

proc validate_ApiIssueAttachmentCreateOrUpdate_594340(path: JsonNode;
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
  var valid_594342 = path.getOrDefault("resourceGroupName")
  valid_594342 = validateParameter(valid_594342, JString, required = true,
                                 default = nil)
  if valid_594342 != nil:
    section.add "resourceGroupName", valid_594342
  var valid_594343 = path.getOrDefault("apiId")
  valid_594343 = validateParameter(valid_594343, JString, required = true,
                                 default = nil)
  if valid_594343 != nil:
    section.add "apiId", valid_594343
  var valid_594344 = path.getOrDefault("issueId")
  valid_594344 = validateParameter(valid_594344, JString, required = true,
                                 default = nil)
  if valid_594344 != nil:
    section.add "issueId", valid_594344
  var valid_594345 = path.getOrDefault("subscriptionId")
  valid_594345 = validateParameter(valid_594345, JString, required = true,
                                 default = nil)
  if valid_594345 != nil:
    section.add "subscriptionId", valid_594345
  var valid_594346 = path.getOrDefault("attachmentId")
  valid_594346 = validateParameter(valid_594346, JString, required = true,
                                 default = nil)
  if valid_594346 != nil:
    section.add "attachmentId", valid_594346
  var valid_594347 = path.getOrDefault("serviceName")
  valid_594347 = validateParameter(valid_594347, JString, required = true,
                                 default = nil)
  if valid_594347 != nil:
    section.add "serviceName", valid_594347
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594348 = query.getOrDefault("api-version")
  valid_594348 = validateParameter(valid_594348, JString, required = true,
                                 default = nil)
  if valid_594348 != nil:
    section.add "api-version", valid_594348
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Issue Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  var valid_594349 = header.getOrDefault("If-Match")
  valid_594349 = validateParameter(valid_594349, JString, required = false,
                                 default = nil)
  if valid_594349 != nil:
    section.add "If-Match", valid_594349
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

proc call*(call_594351: Call_ApiIssueAttachmentCreateOrUpdate_594339;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new Attachment for the Issue in an API or updates an existing one.
  ## 
  let valid = call_594351.validator(path, query, header, formData, body)
  let scheme = call_594351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594351.url(scheme.get, call_594351.host, call_594351.base,
                         call_594351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594351, url, valid)

proc call*(call_594352: Call_ApiIssueAttachmentCreateOrUpdate_594339;
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
  var path_594353 = newJObject()
  var query_594354 = newJObject()
  var body_594355 = newJObject()
  add(path_594353, "resourceGroupName", newJString(resourceGroupName))
  add(query_594354, "api-version", newJString(apiVersion))
  add(path_594353, "apiId", newJString(apiId))
  add(path_594353, "issueId", newJString(issueId))
  add(path_594353, "subscriptionId", newJString(subscriptionId))
  add(path_594353, "attachmentId", newJString(attachmentId))
  if parameters != nil:
    body_594355 = parameters
  add(path_594353, "serviceName", newJString(serviceName))
  result = call_594352.call(path_594353, query_594354, nil, nil, body_594355)

var apiIssueAttachmentCreateOrUpdate* = Call_ApiIssueAttachmentCreateOrUpdate_594339(
    name: "apiIssueAttachmentCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/attachments/{attachmentId}",
    validator: validate_ApiIssueAttachmentCreateOrUpdate_594340, base: "",
    url: url_ApiIssueAttachmentCreateOrUpdate_594341, schemes: {Scheme.Https})
type
  Call_ApiIssueAttachmentGetEntityTag_594371 = ref object of OpenApiRestCall_593438
proc url_ApiIssueAttachmentGetEntityTag_594373(protocol: Scheme; host: string;
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

proc validate_ApiIssueAttachmentGetEntityTag_594372(path: JsonNode;
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
  var valid_594374 = path.getOrDefault("resourceGroupName")
  valid_594374 = validateParameter(valid_594374, JString, required = true,
                                 default = nil)
  if valid_594374 != nil:
    section.add "resourceGroupName", valid_594374
  var valid_594375 = path.getOrDefault("apiId")
  valid_594375 = validateParameter(valid_594375, JString, required = true,
                                 default = nil)
  if valid_594375 != nil:
    section.add "apiId", valid_594375
  var valid_594376 = path.getOrDefault("issueId")
  valid_594376 = validateParameter(valid_594376, JString, required = true,
                                 default = nil)
  if valid_594376 != nil:
    section.add "issueId", valid_594376
  var valid_594377 = path.getOrDefault("subscriptionId")
  valid_594377 = validateParameter(valid_594377, JString, required = true,
                                 default = nil)
  if valid_594377 != nil:
    section.add "subscriptionId", valid_594377
  var valid_594378 = path.getOrDefault("attachmentId")
  valid_594378 = validateParameter(valid_594378, JString, required = true,
                                 default = nil)
  if valid_594378 != nil:
    section.add "attachmentId", valid_594378
  var valid_594379 = path.getOrDefault("serviceName")
  valid_594379 = validateParameter(valid_594379, JString, required = true,
                                 default = nil)
  if valid_594379 != nil:
    section.add "serviceName", valid_594379
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594380 = query.getOrDefault("api-version")
  valid_594380 = validateParameter(valid_594380, JString, required = true,
                                 default = nil)
  if valid_594380 != nil:
    section.add "api-version", valid_594380
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594381: Call_ApiIssueAttachmentGetEntityTag_594371; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the issue Attachment for an API specified by its identifier.
  ## 
  let valid = call_594381.validator(path, query, header, formData, body)
  let scheme = call_594381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594381.url(scheme.get, call_594381.host, call_594381.base,
                         call_594381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594381, url, valid)

proc call*(call_594382: Call_ApiIssueAttachmentGetEntityTag_594371;
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
  var path_594383 = newJObject()
  var query_594384 = newJObject()
  add(path_594383, "resourceGroupName", newJString(resourceGroupName))
  add(query_594384, "api-version", newJString(apiVersion))
  add(path_594383, "apiId", newJString(apiId))
  add(path_594383, "issueId", newJString(issueId))
  add(path_594383, "subscriptionId", newJString(subscriptionId))
  add(path_594383, "attachmentId", newJString(attachmentId))
  add(path_594383, "serviceName", newJString(serviceName))
  result = call_594382.call(path_594383, query_594384, nil, nil, nil)

var apiIssueAttachmentGetEntityTag* = Call_ApiIssueAttachmentGetEntityTag_594371(
    name: "apiIssueAttachmentGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/attachments/{attachmentId}",
    validator: validate_ApiIssueAttachmentGetEntityTag_594372, base: "",
    url: url_ApiIssueAttachmentGetEntityTag_594373, schemes: {Scheme.Https})
type
  Call_ApiIssueAttachmentGet_594325 = ref object of OpenApiRestCall_593438
proc url_ApiIssueAttachmentGet_594327(protocol: Scheme; host: string; base: string;
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

proc validate_ApiIssueAttachmentGet_594326(path: JsonNode; query: JsonNode;
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
  var valid_594328 = path.getOrDefault("resourceGroupName")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "resourceGroupName", valid_594328
  var valid_594329 = path.getOrDefault("apiId")
  valid_594329 = validateParameter(valid_594329, JString, required = true,
                                 default = nil)
  if valid_594329 != nil:
    section.add "apiId", valid_594329
  var valid_594330 = path.getOrDefault("issueId")
  valid_594330 = validateParameter(valid_594330, JString, required = true,
                                 default = nil)
  if valid_594330 != nil:
    section.add "issueId", valid_594330
  var valid_594331 = path.getOrDefault("subscriptionId")
  valid_594331 = validateParameter(valid_594331, JString, required = true,
                                 default = nil)
  if valid_594331 != nil:
    section.add "subscriptionId", valid_594331
  var valid_594332 = path.getOrDefault("attachmentId")
  valid_594332 = validateParameter(valid_594332, JString, required = true,
                                 default = nil)
  if valid_594332 != nil:
    section.add "attachmentId", valid_594332
  var valid_594333 = path.getOrDefault("serviceName")
  valid_594333 = validateParameter(valid_594333, JString, required = true,
                                 default = nil)
  if valid_594333 != nil:
    section.add "serviceName", valid_594333
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594334 = query.getOrDefault("api-version")
  valid_594334 = validateParameter(valid_594334, JString, required = true,
                                 default = nil)
  if valid_594334 != nil:
    section.add "api-version", valid_594334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594335: Call_ApiIssueAttachmentGet_594325; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the issue Attachment for an API specified by its identifier.
  ## 
  let valid = call_594335.validator(path, query, header, formData, body)
  let scheme = call_594335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594335.url(scheme.get, call_594335.host, call_594335.base,
                         call_594335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594335, url, valid)

proc call*(call_594336: Call_ApiIssueAttachmentGet_594325;
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
  var path_594337 = newJObject()
  var query_594338 = newJObject()
  add(path_594337, "resourceGroupName", newJString(resourceGroupName))
  add(query_594338, "api-version", newJString(apiVersion))
  add(path_594337, "apiId", newJString(apiId))
  add(path_594337, "issueId", newJString(issueId))
  add(path_594337, "subscriptionId", newJString(subscriptionId))
  add(path_594337, "attachmentId", newJString(attachmentId))
  add(path_594337, "serviceName", newJString(serviceName))
  result = call_594336.call(path_594337, query_594338, nil, nil, nil)

var apiIssueAttachmentGet* = Call_ApiIssueAttachmentGet_594325(
    name: "apiIssueAttachmentGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/attachments/{attachmentId}",
    validator: validate_ApiIssueAttachmentGet_594326, base: "",
    url: url_ApiIssueAttachmentGet_594327, schemes: {Scheme.Https})
type
  Call_ApiIssueAttachmentDelete_594356 = ref object of OpenApiRestCall_593438
proc url_ApiIssueAttachmentDelete_594358(protocol: Scheme; host: string;
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

proc validate_ApiIssueAttachmentDelete_594357(path: JsonNode; query: JsonNode;
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
  var valid_594359 = path.getOrDefault("resourceGroupName")
  valid_594359 = validateParameter(valid_594359, JString, required = true,
                                 default = nil)
  if valid_594359 != nil:
    section.add "resourceGroupName", valid_594359
  var valid_594360 = path.getOrDefault("apiId")
  valid_594360 = validateParameter(valid_594360, JString, required = true,
                                 default = nil)
  if valid_594360 != nil:
    section.add "apiId", valid_594360
  var valid_594361 = path.getOrDefault("issueId")
  valid_594361 = validateParameter(valid_594361, JString, required = true,
                                 default = nil)
  if valid_594361 != nil:
    section.add "issueId", valid_594361
  var valid_594362 = path.getOrDefault("subscriptionId")
  valid_594362 = validateParameter(valid_594362, JString, required = true,
                                 default = nil)
  if valid_594362 != nil:
    section.add "subscriptionId", valid_594362
  var valid_594363 = path.getOrDefault("attachmentId")
  valid_594363 = validateParameter(valid_594363, JString, required = true,
                                 default = nil)
  if valid_594363 != nil:
    section.add "attachmentId", valid_594363
  var valid_594364 = path.getOrDefault("serviceName")
  valid_594364 = validateParameter(valid_594364, JString, required = true,
                                 default = nil)
  if valid_594364 != nil:
    section.add "serviceName", valid_594364
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594365 = query.getOrDefault("api-version")
  valid_594365 = validateParameter(valid_594365, JString, required = true,
                                 default = nil)
  if valid_594365 != nil:
    section.add "api-version", valid_594365
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Issue Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594366 = header.getOrDefault("If-Match")
  valid_594366 = validateParameter(valid_594366, JString, required = true,
                                 default = nil)
  if valid_594366 != nil:
    section.add "If-Match", valid_594366
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594367: Call_ApiIssueAttachmentDelete_594356; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified comment from an Issue.
  ## 
  let valid = call_594367.validator(path, query, header, formData, body)
  let scheme = call_594367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594367.url(scheme.get, call_594367.host, call_594367.base,
                         call_594367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594367, url, valid)

proc call*(call_594368: Call_ApiIssueAttachmentDelete_594356;
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
  var path_594369 = newJObject()
  var query_594370 = newJObject()
  add(path_594369, "resourceGroupName", newJString(resourceGroupName))
  add(query_594370, "api-version", newJString(apiVersion))
  add(path_594369, "apiId", newJString(apiId))
  add(path_594369, "issueId", newJString(issueId))
  add(path_594369, "subscriptionId", newJString(subscriptionId))
  add(path_594369, "attachmentId", newJString(attachmentId))
  add(path_594369, "serviceName", newJString(serviceName))
  result = call_594368.call(path_594369, query_594370, nil, nil, nil)

var apiIssueAttachmentDelete* = Call_ApiIssueAttachmentDelete_594356(
    name: "apiIssueAttachmentDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/attachments/{attachmentId}",
    validator: validate_ApiIssueAttachmentDelete_594357, base: "",
    url: url_ApiIssueAttachmentDelete_594358, schemes: {Scheme.Https})
type
  Call_ApiIssueCommentListByService_594385 = ref object of OpenApiRestCall_593438
proc url_ApiIssueCommentListByService_594387(protocol: Scheme; host: string;
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

proc validate_ApiIssueCommentListByService_594386(path: JsonNode; query: JsonNode;
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
  var valid_594388 = path.getOrDefault("resourceGroupName")
  valid_594388 = validateParameter(valid_594388, JString, required = true,
                                 default = nil)
  if valid_594388 != nil:
    section.add "resourceGroupName", valid_594388
  var valid_594389 = path.getOrDefault("apiId")
  valid_594389 = validateParameter(valid_594389, JString, required = true,
                                 default = nil)
  if valid_594389 != nil:
    section.add "apiId", valid_594389
  var valid_594390 = path.getOrDefault("issueId")
  valid_594390 = validateParameter(valid_594390, JString, required = true,
                                 default = nil)
  if valid_594390 != nil:
    section.add "issueId", valid_594390
  var valid_594391 = path.getOrDefault("subscriptionId")
  valid_594391 = validateParameter(valid_594391, JString, required = true,
                                 default = nil)
  if valid_594391 != nil:
    section.add "subscriptionId", valid_594391
  var valid_594392 = path.getOrDefault("serviceName")
  valid_594392 = validateParameter(valid_594392, JString, required = true,
                                 default = nil)
  if valid_594392 != nil:
    section.add "serviceName", valid_594392
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
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | userId          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594393 = query.getOrDefault("api-version")
  valid_594393 = validateParameter(valid_594393, JString, required = true,
                                 default = nil)
  if valid_594393 != nil:
    section.add "api-version", valid_594393
  var valid_594394 = query.getOrDefault("$top")
  valid_594394 = validateParameter(valid_594394, JInt, required = false, default = nil)
  if valid_594394 != nil:
    section.add "$top", valid_594394
  var valid_594395 = query.getOrDefault("$skip")
  valid_594395 = validateParameter(valid_594395, JInt, required = false, default = nil)
  if valid_594395 != nil:
    section.add "$skip", valid_594395
  var valid_594396 = query.getOrDefault("$filter")
  valid_594396 = validateParameter(valid_594396, JString, required = false,
                                 default = nil)
  if valid_594396 != nil:
    section.add "$filter", valid_594396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594397: Call_ApiIssueCommentListByService_594385; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all comments for the Issue associated with the specified API.
  ## 
  let valid = call_594397.validator(path, query, header, formData, body)
  let scheme = call_594397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594397.url(scheme.get, call_594397.host, call_594397.base,
                         call_594397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594397, url, valid)

proc call*(call_594398: Call_ApiIssueCommentListByService_594385;
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
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | userId          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  var path_594399 = newJObject()
  var query_594400 = newJObject()
  add(path_594399, "resourceGroupName", newJString(resourceGroupName))
  add(query_594400, "api-version", newJString(apiVersion))
  add(path_594399, "apiId", newJString(apiId))
  add(path_594399, "issueId", newJString(issueId))
  add(path_594399, "subscriptionId", newJString(subscriptionId))
  add(query_594400, "$top", newJInt(Top))
  add(query_594400, "$skip", newJInt(Skip))
  add(path_594399, "serviceName", newJString(serviceName))
  add(query_594400, "$filter", newJString(Filter))
  result = call_594398.call(path_594399, query_594400, nil, nil, nil)

var apiIssueCommentListByService* = Call_ApiIssueCommentListByService_594385(
    name: "apiIssueCommentListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/comments",
    validator: validate_ApiIssueCommentListByService_594386, base: "",
    url: url_ApiIssueCommentListByService_594387, schemes: {Scheme.Https})
type
  Call_ApiIssueCommentCreateOrUpdate_594415 = ref object of OpenApiRestCall_593438
proc url_ApiIssueCommentCreateOrUpdate_594417(protocol: Scheme; host: string;
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

proc validate_ApiIssueCommentCreateOrUpdate_594416(path: JsonNode; query: JsonNode;
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
  var valid_594418 = path.getOrDefault("resourceGroupName")
  valid_594418 = validateParameter(valid_594418, JString, required = true,
                                 default = nil)
  if valid_594418 != nil:
    section.add "resourceGroupName", valid_594418
  var valid_594419 = path.getOrDefault("apiId")
  valid_594419 = validateParameter(valid_594419, JString, required = true,
                                 default = nil)
  if valid_594419 != nil:
    section.add "apiId", valid_594419
  var valid_594420 = path.getOrDefault("issueId")
  valid_594420 = validateParameter(valid_594420, JString, required = true,
                                 default = nil)
  if valid_594420 != nil:
    section.add "issueId", valid_594420
  var valid_594421 = path.getOrDefault("subscriptionId")
  valid_594421 = validateParameter(valid_594421, JString, required = true,
                                 default = nil)
  if valid_594421 != nil:
    section.add "subscriptionId", valid_594421
  var valid_594422 = path.getOrDefault("commentId")
  valid_594422 = validateParameter(valid_594422, JString, required = true,
                                 default = nil)
  if valid_594422 != nil:
    section.add "commentId", valid_594422
  var valid_594423 = path.getOrDefault("serviceName")
  valid_594423 = validateParameter(valid_594423, JString, required = true,
                                 default = nil)
  if valid_594423 != nil:
    section.add "serviceName", valid_594423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594424 = query.getOrDefault("api-version")
  valid_594424 = validateParameter(valid_594424, JString, required = true,
                                 default = nil)
  if valid_594424 != nil:
    section.add "api-version", valid_594424
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Issue Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  var valid_594425 = header.getOrDefault("If-Match")
  valid_594425 = validateParameter(valid_594425, JString, required = false,
                                 default = nil)
  if valid_594425 != nil:
    section.add "If-Match", valid_594425
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

proc call*(call_594427: Call_ApiIssueCommentCreateOrUpdate_594415; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Comment for the Issue in an API or updates an existing one.
  ## 
  let valid = call_594427.validator(path, query, header, formData, body)
  let scheme = call_594427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594427.url(scheme.get, call_594427.host, call_594427.base,
                         call_594427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594427, url, valid)

proc call*(call_594428: Call_ApiIssueCommentCreateOrUpdate_594415;
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
  var path_594429 = newJObject()
  var query_594430 = newJObject()
  var body_594431 = newJObject()
  add(path_594429, "resourceGroupName", newJString(resourceGroupName))
  add(query_594430, "api-version", newJString(apiVersion))
  add(path_594429, "apiId", newJString(apiId))
  add(path_594429, "issueId", newJString(issueId))
  add(path_594429, "subscriptionId", newJString(subscriptionId))
  add(path_594429, "commentId", newJString(commentId))
  if parameters != nil:
    body_594431 = parameters
  add(path_594429, "serviceName", newJString(serviceName))
  result = call_594428.call(path_594429, query_594430, nil, nil, body_594431)

var apiIssueCommentCreateOrUpdate* = Call_ApiIssueCommentCreateOrUpdate_594415(
    name: "apiIssueCommentCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/comments/{commentId}",
    validator: validate_ApiIssueCommentCreateOrUpdate_594416, base: "",
    url: url_ApiIssueCommentCreateOrUpdate_594417, schemes: {Scheme.Https})
type
  Call_ApiIssueCommentGetEntityTag_594447 = ref object of OpenApiRestCall_593438
proc url_ApiIssueCommentGetEntityTag_594449(protocol: Scheme; host: string;
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

proc validate_ApiIssueCommentGetEntityTag_594448(path: JsonNode; query: JsonNode;
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
  var valid_594450 = path.getOrDefault("resourceGroupName")
  valid_594450 = validateParameter(valid_594450, JString, required = true,
                                 default = nil)
  if valid_594450 != nil:
    section.add "resourceGroupName", valid_594450
  var valid_594451 = path.getOrDefault("apiId")
  valid_594451 = validateParameter(valid_594451, JString, required = true,
                                 default = nil)
  if valid_594451 != nil:
    section.add "apiId", valid_594451
  var valid_594452 = path.getOrDefault("issueId")
  valid_594452 = validateParameter(valid_594452, JString, required = true,
                                 default = nil)
  if valid_594452 != nil:
    section.add "issueId", valid_594452
  var valid_594453 = path.getOrDefault("subscriptionId")
  valid_594453 = validateParameter(valid_594453, JString, required = true,
                                 default = nil)
  if valid_594453 != nil:
    section.add "subscriptionId", valid_594453
  var valid_594454 = path.getOrDefault("commentId")
  valid_594454 = validateParameter(valid_594454, JString, required = true,
                                 default = nil)
  if valid_594454 != nil:
    section.add "commentId", valid_594454
  var valid_594455 = path.getOrDefault("serviceName")
  valid_594455 = validateParameter(valid_594455, JString, required = true,
                                 default = nil)
  if valid_594455 != nil:
    section.add "serviceName", valid_594455
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594456 = query.getOrDefault("api-version")
  valid_594456 = validateParameter(valid_594456, JString, required = true,
                                 default = nil)
  if valid_594456 != nil:
    section.add "api-version", valid_594456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594457: Call_ApiIssueCommentGetEntityTag_594447; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the issue Comment for an API specified by its identifier.
  ## 
  let valid = call_594457.validator(path, query, header, formData, body)
  let scheme = call_594457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594457.url(scheme.get, call_594457.host, call_594457.base,
                         call_594457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594457, url, valid)

proc call*(call_594458: Call_ApiIssueCommentGetEntityTag_594447;
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
  var path_594459 = newJObject()
  var query_594460 = newJObject()
  add(path_594459, "resourceGroupName", newJString(resourceGroupName))
  add(query_594460, "api-version", newJString(apiVersion))
  add(path_594459, "apiId", newJString(apiId))
  add(path_594459, "issueId", newJString(issueId))
  add(path_594459, "subscriptionId", newJString(subscriptionId))
  add(path_594459, "commentId", newJString(commentId))
  add(path_594459, "serviceName", newJString(serviceName))
  result = call_594458.call(path_594459, query_594460, nil, nil, nil)

var apiIssueCommentGetEntityTag* = Call_ApiIssueCommentGetEntityTag_594447(
    name: "apiIssueCommentGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/comments/{commentId}",
    validator: validate_ApiIssueCommentGetEntityTag_594448, base: "",
    url: url_ApiIssueCommentGetEntityTag_594449, schemes: {Scheme.Https})
type
  Call_ApiIssueCommentGet_594401 = ref object of OpenApiRestCall_593438
proc url_ApiIssueCommentGet_594403(protocol: Scheme; host: string; base: string;
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

proc validate_ApiIssueCommentGet_594402(path: JsonNode; query: JsonNode;
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
  var valid_594404 = path.getOrDefault("resourceGroupName")
  valid_594404 = validateParameter(valid_594404, JString, required = true,
                                 default = nil)
  if valid_594404 != nil:
    section.add "resourceGroupName", valid_594404
  var valid_594405 = path.getOrDefault("apiId")
  valid_594405 = validateParameter(valid_594405, JString, required = true,
                                 default = nil)
  if valid_594405 != nil:
    section.add "apiId", valid_594405
  var valid_594406 = path.getOrDefault("issueId")
  valid_594406 = validateParameter(valid_594406, JString, required = true,
                                 default = nil)
  if valid_594406 != nil:
    section.add "issueId", valid_594406
  var valid_594407 = path.getOrDefault("subscriptionId")
  valid_594407 = validateParameter(valid_594407, JString, required = true,
                                 default = nil)
  if valid_594407 != nil:
    section.add "subscriptionId", valid_594407
  var valid_594408 = path.getOrDefault("commentId")
  valid_594408 = validateParameter(valid_594408, JString, required = true,
                                 default = nil)
  if valid_594408 != nil:
    section.add "commentId", valid_594408
  var valid_594409 = path.getOrDefault("serviceName")
  valid_594409 = validateParameter(valid_594409, JString, required = true,
                                 default = nil)
  if valid_594409 != nil:
    section.add "serviceName", valid_594409
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594410 = query.getOrDefault("api-version")
  valid_594410 = validateParameter(valid_594410, JString, required = true,
                                 default = nil)
  if valid_594410 != nil:
    section.add "api-version", valid_594410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594411: Call_ApiIssueCommentGet_594401; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the issue Comment for an API specified by its identifier.
  ## 
  let valid = call_594411.validator(path, query, header, formData, body)
  let scheme = call_594411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594411.url(scheme.get, call_594411.host, call_594411.base,
                         call_594411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594411, url, valid)

proc call*(call_594412: Call_ApiIssueCommentGet_594401; resourceGroupName: string;
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
  var path_594413 = newJObject()
  var query_594414 = newJObject()
  add(path_594413, "resourceGroupName", newJString(resourceGroupName))
  add(query_594414, "api-version", newJString(apiVersion))
  add(path_594413, "apiId", newJString(apiId))
  add(path_594413, "issueId", newJString(issueId))
  add(path_594413, "subscriptionId", newJString(subscriptionId))
  add(path_594413, "commentId", newJString(commentId))
  add(path_594413, "serviceName", newJString(serviceName))
  result = call_594412.call(path_594413, query_594414, nil, nil, nil)

var apiIssueCommentGet* = Call_ApiIssueCommentGet_594401(
    name: "apiIssueCommentGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/comments/{commentId}",
    validator: validate_ApiIssueCommentGet_594402, base: "",
    url: url_ApiIssueCommentGet_594403, schemes: {Scheme.Https})
type
  Call_ApiIssueCommentDelete_594432 = ref object of OpenApiRestCall_593438
proc url_ApiIssueCommentDelete_594434(protocol: Scheme; host: string; base: string;
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

proc validate_ApiIssueCommentDelete_594433(path: JsonNode; query: JsonNode;
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
  var valid_594435 = path.getOrDefault("resourceGroupName")
  valid_594435 = validateParameter(valid_594435, JString, required = true,
                                 default = nil)
  if valid_594435 != nil:
    section.add "resourceGroupName", valid_594435
  var valid_594436 = path.getOrDefault("apiId")
  valid_594436 = validateParameter(valid_594436, JString, required = true,
                                 default = nil)
  if valid_594436 != nil:
    section.add "apiId", valid_594436
  var valid_594437 = path.getOrDefault("issueId")
  valid_594437 = validateParameter(valid_594437, JString, required = true,
                                 default = nil)
  if valid_594437 != nil:
    section.add "issueId", valid_594437
  var valid_594438 = path.getOrDefault("subscriptionId")
  valid_594438 = validateParameter(valid_594438, JString, required = true,
                                 default = nil)
  if valid_594438 != nil:
    section.add "subscriptionId", valid_594438
  var valid_594439 = path.getOrDefault("commentId")
  valid_594439 = validateParameter(valid_594439, JString, required = true,
                                 default = nil)
  if valid_594439 != nil:
    section.add "commentId", valid_594439
  var valid_594440 = path.getOrDefault("serviceName")
  valid_594440 = validateParameter(valid_594440, JString, required = true,
                                 default = nil)
  if valid_594440 != nil:
    section.add "serviceName", valid_594440
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594441 = query.getOrDefault("api-version")
  valid_594441 = validateParameter(valid_594441, JString, required = true,
                                 default = nil)
  if valid_594441 != nil:
    section.add "api-version", valid_594441
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Issue Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594442 = header.getOrDefault("If-Match")
  valid_594442 = validateParameter(valid_594442, JString, required = true,
                                 default = nil)
  if valid_594442 != nil:
    section.add "If-Match", valid_594442
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594443: Call_ApiIssueCommentDelete_594432; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified comment from an Issue.
  ## 
  let valid = call_594443.validator(path, query, header, formData, body)
  let scheme = call_594443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594443.url(scheme.get, call_594443.host, call_594443.base,
                         call_594443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594443, url, valid)

proc call*(call_594444: Call_ApiIssueCommentDelete_594432;
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
  var path_594445 = newJObject()
  var query_594446 = newJObject()
  add(path_594445, "resourceGroupName", newJString(resourceGroupName))
  add(query_594446, "api-version", newJString(apiVersion))
  add(path_594445, "apiId", newJString(apiId))
  add(path_594445, "issueId", newJString(issueId))
  add(path_594445, "subscriptionId", newJString(subscriptionId))
  add(path_594445, "commentId", newJString(commentId))
  add(path_594445, "serviceName", newJString(serviceName))
  result = call_594444.call(path_594445, query_594446, nil, nil, nil)

var apiIssueCommentDelete* = Call_ApiIssueCommentDelete_594432(
    name: "apiIssueCommentDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/comments/{commentId}",
    validator: validate_ApiIssueCommentDelete_594433, base: "",
    url: url_ApiIssueCommentDelete_594434, schemes: {Scheme.Https})
type
  Call_ApiOperationListByApi_594461 = ref object of OpenApiRestCall_593438
proc url_ApiOperationListByApi_594463(protocol: Scheme; host: string; base: string;
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

proc validate_ApiOperationListByApi_594462(path: JsonNode; query: JsonNode;
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
  var valid_594464 = path.getOrDefault("resourceGroupName")
  valid_594464 = validateParameter(valid_594464, JString, required = true,
                                 default = nil)
  if valid_594464 != nil:
    section.add "resourceGroupName", valid_594464
  var valid_594465 = path.getOrDefault("apiId")
  valid_594465 = validateParameter(valid_594465, JString, required = true,
                                 default = nil)
  if valid_594465 != nil:
    section.add "apiId", valid_594465
  var valid_594466 = path.getOrDefault("subscriptionId")
  valid_594466 = validateParameter(valid_594466, JString, required = true,
                                 default = nil)
  if valid_594466 != nil:
    section.add "subscriptionId", valid_594466
  var valid_594467 = path.getOrDefault("serviceName")
  valid_594467 = validateParameter(valid_594467, JString, required = true,
                                 default = nil)
  if valid_594467 != nil:
    section.add "serviceName", valid_594467
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
  ## | name        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | method      | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | urlTemplate | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594468 = query.getOrDefault("api-version")
  valid_594468 = validateParameter(valid_594468, JString, required = true,
                                 default = nil)
  if valid_594468 != nil:
    section.add "api-version", valid_594468
  var valid_594469 = query.getOrDefault("$top")
  valid_594469 = validateParameter(valid_594469, JInt, required = false, default = nil)
  if valid_594469 != nil:
    section.add "$top", valid_594469
  var valid_594470 = query.getOrDefault("$skip")
  valid_594470 = validateParameter(valid_594470, JInt, required = false, default = nil)
  if valid_594470 != nil:
    section.add "$skip", valid_594470
  var valid_594471 = query.getOrDefault("$filter")
  valid_594471 = validateParameter(valid_594471, JString, required = false,
                                 default = nil)
  if valid_594471 != nil:
    section.add "$filter", valid_594471
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594472: Call_ApiOperationListByApi_594461; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of the operations for the specified API.
  ## 
  let valid = call_594472.validator(path, query, header, formData, body)
  let scheme = call_594472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594472.url(scheme.get, call_594472.host, call_594472.base,
                         call_594472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594472, url, valid)

proc call*(call_594473: Call_ApiOperationListByApi_594461;
          resourceGroupName: string; apiVersion: string; apiId: string;
          subscriptionId: string; serviceName: string; Top: int = 0; Skip: int = 0;
          Filter: string = ""): Recallable =
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
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | name        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | method      | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | urlTemplate | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  var path_594474 = newJObject()
  var query_594475 = newJObject()
  add(path_594474, "resourceGroupName", newJString(resourceGroupName))
  add(query_594475, "api-version", newJString(apiVersion))
  add(path_594474, "apiId", newJString(apiId))
  add(path_594474, "subscriptionId", newJString(subscriptionId))
  add(query_594475, "$top", newJInt(Top))
  add(query_594475, "$skip", newJInt(Skip))
  add(path_594474, "serviceName", newJString(serviceName))
  add(query_594475, "$filter", newJString(Filter))
  result = call_594473.call(path_594474, query_594475, nil, nil, nil)

var apiOperationListByApi* = Call_ApiOperationListByApi_594461(
    name: "apiOperationListByApi", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations",
    validator: validate_ApiOperationListByApi_594462, base: "",
    url: url_ApiOperationListByApi_594463, schemes: {Scheme.Https})
type
  Call_ApiOperationCreateOrUpdate_594489 = ref object of OpenApiRestCall_593438
proc url_ApiOperationCreateOrUpdate_594491(protocol: Scheme; host: string;
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

proc validate_ApiOperationCreateOrUpdate_594490(path: JsonNode; query: JsonNode;
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
  var valid_594492 = path.getOrDefault("resourceGroupName")
  valid_594492 = validateParameter(valid_594492, JString, required = true,
                                 default = nil)
  if valid_594492 != nil:
    section.add "resourceGroupName", valid_594492
  var valid_594493 = path.getOrDefault("apiId")
  valid_594493 = validateParameter(valid_594493, JString, required = true,
                                 default = nil)
  if valid_594493 != nil:
    section.add "apiId", valid_594493
  var valid_594494 = path.getOrDefault("subscriptionId")
  valid_594494 = validateParameter(valid_594494, JString, required = true,
                                 default = nil)
  if valid_594494 != nil:
    section.add "subscriptionId", valid_594494
  var valid_594495 = path.getOrDefault("serviceName")
  valid_594495 = validateParameter(valid_594495, JString, required = true,
                                 default = nil)
  if valid_594495 != nil:
    section.add "serviceName", valid_594495
  var valid_594496 = path.getOrDefault("operationId")
  valid_594496 = validateParameter(valid_594496, JString, required = true,
                                 default = nil)
  if valid_594496 != nil:
    section.add "operationId", valid_594496
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594497 = query.getOrDefault("api-version")
  valid_594497 = validateParameter(valid_594497, JString, required = true,
                                 default = nil)
  if valid_594497 != nil:
    section.add "api-version", valid_594497
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_594498 = header.getOrDefault("If-Match")
  valid_594498 = validateParameter(valid_594498, JString, required = false,
                                 default = nil)
  if valid_594498 != nil:
    section.add "If-Match", valid_594498
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

proc call*(call_594500: Call_ApiOperationCreateOrUpdate_594489; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new operation in the API or updates an existing one.
  ## 
  let valid = call_594500.validator(path, query, header, formData, body)
  let scheme = call_594500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594500.url(scheme.get, call_594500.host, call_594500.base,
                         call_594500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594500, url, valid)

proc call*(call_594501: Call_ApiOperationCreateOrUpdate_594489;
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
  var path_594502 = newJObject()
  var query_594503 = newJObject()
  var body_594504 = newJObject()
  add(path_594502, "resourceGroupName", newJString(resourceGroupName))
  add(query_594503, "api-version", newJString(apiVersion))
  add(path_594502, "apiId", newJString(apiId))
  add(path_594502, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594504 = parameters
  add(path_594502, "serviceName", newJString(serviceName))
  add(path_594502, "operationId", newJString(operationId))
  result = call_594501.call(path_594502, query_594503, nil, nil, body_594504)

var apiOperationCreateOrUpdate* = Call_ApiOperationCreateOrUpdate_594489(
    name: "apiOperationCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationCreateOrUpdate_594490, base: "",
    url: url_ApiOperationCreateOrUpdate_594491, schemes: {Scheme.Https})
type
  Call_ApiOperationGetEntityTag_594519 = ref object of OpenApiRestCall_593438
proc url_ApiOperationGetEntityTag_594521(protocol: Scheme; host: string;
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

proc validate_ApiOperationGetEntityTag_594520(path: JsonNode; query: JsonNode;
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
  var valid_594522 = path.getOrDefault("resourceGroupName")
  valid_594522 = validateParameter(valid_594522, JString, required = true,
                                 default = nil)
  if valid_594522 != nil:
    section.add "resourceGroupName", valid_594522
  var valid_594523 = path.getOrDefault("apiId")
  valid_594523 = validateParameter(valid_594523, JString, required = true,
                                 default = nil)
  if valid_594523 != nil:
    section.add "apiId", valid_594523
  var valid_594524 = path.getOrDefault("subscriptionId")
  valid_594524 = validateParameter(valid_594524, JString, required = true,
                                 default = nil)
  if valid_594524 != nil:
    section.add "subscriptionId", valid_594524
  var valid_594525 = path.getOrDefault("serviceName")
  valid_594525 = validateParameter(valid_594525, JString, required = true,
                                 default = nil)
  if valid_594525 != nil:
    section.add "serviceName", valid_594525
  var valid_594526 = path.getOrDefault("operationId")
  valid_594526 = validateParameter(valid_594526, JString, required = true,
                                 default = nil)
  if valid_594526 != nil:
    section.add "operationId", valid_594526
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594527 = query.getOrDefault("api-version")
  valid_594527 = validateParameter(valid_594527, JString, required = true,
                                 default = nil)
  if valid_594527 != nil:
    section.add "api-version", valid_594527
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594528: Call_ApiOperationGetEntityTag_594519; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the API operation specified by its identifier.
  ## 
  let valid = call_594528.validator(path, query, header, formData, body)
  let scheme = call_594528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594528.url(scheme.get, call_594528.host, call_594528.base,
                         call_594528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594528, url, valid)

proc call*(call_594529: Call_ApiOperationGetEntityTag_594519;
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
  var path_594530 = newJObject()
  var query_594531 = newJObject()
  add(path_594530, "resourceGroupName", newJString(resourceGroupName))
  add(query_594531, "api-version", newJString(apiVersion))
  add(path_594530, "apiId", newJString(apiId))
  add(path_594530, "subscriptionId", newJString(subscriptionId))
  add(path_594530, "serviceName", newJString(serviceName))
  add(path_594530, "operationId", newJString(operationId))
  result = call_594529.call(path_594530, query_594531, nil, nil, nil)

var apiOperationGetEntityTag* = Call_ApiOperationGetEntityTag_594519(
    name: "apiOperationGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationGetEntityTag_594520, base: "",
    url: url_ApiOperationGetEntityTag_594521, schemes: {Scheme.Https})
type
  Call_ApiOperationGet_594476 = ref object of OpenApiRestCall_593438
proc url_ApiOperationGet_594478(protocol: Scheme; host: string; base: string;
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

proc validate_ApiOperationGet_594477(path: JsonNode; query: JsonNode;
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
  var valid_594479 = path.getOrDefault("resourceGroupName")
  valid_594479 = validateParameter(valid_594479, JString, required = true,
                                 default = nil)
  if valid_594479 != nil:
    section.add "resourceGroupName", valid_594479
  var valid_594480 = path.getOrDefault("apiId")
  valid_594480 = validateParameter(valid_594480, JString, required = true,
                                 default = nil)
  if valid_594480 != nil:
    section.add "apiId", valid_594480
  var valid_594481 = path.getOrDefault("subscriptionId")
  valid_594481 = validateParameter(valid_594481, JString, required = true,
                                 default = nil)
  if valid_594481 != nil:
    section.add "subscriptionId", valid_594481
  var valid_594482 = path.getOrDefault("serviceName")
  valid_594482 = validateParameter(valid_594482, JString, required = true,
                                 default = nil)
  if valid_594482 != nil:
    section.add "serviceName", valid_594482
  var valid_594483 = path.getOrDefault("operationId")
  valid_594483 = validateParameter(valid_594483, JString, required = true,
                                 default = nil)
  if valid_594483 != nil:
    section.add "operationId", valid_594483
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594484 = query.getOrDefault("api-version")
  valid_594484 = validateParameter(valid_594484, JString, required = true,
                                 default = nil)
  if valid_594484 != nil:
    section.add "api-version", valid_594484
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594485: Call_ApiOperationGet_594476; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the API Operation specified by its identifier.
  ## 
  let valid = call_594485.validator(path, query, header, formData, body)
  let scheme = call_594485.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594485.url(scheme.get, call_594485.host, call_594485.base,
                         call_594485.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594485, url, valid)

proc call*(call_594486: Call_ApiOperationGet_594476; resourceGroupName: string;
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
  var path_594487 = newJObject()
  var query_594488 = newJObject()
  add(path_594487, "resourceGroupName", newJString(resourceGroupName))
  add(query_594488, "api-version", newJString(apiVersion))
  add(path_594487, "apiId", newJString(apiId))
  add(path_594487, "subscriptionId", newJString(subscriptionId))
  add(path_594487, "serviceName", newJString(serviceName))
  add(path_594487, "operationId", newJString(operationId))
  result = call_594486.call(path_594487, query_594488, nil, nil, nil)

var apiOperationGet* = Call_ApiOperationGet_594476(name: "apiOperationGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationGet_594477, base: "", url: url_ApiOperationGet_594478,
    schemes: {Scheme.Https})
type
  Call_ApiOperationUpdate_594532 = ref object of OpenApiRestCall_593438
proc url_ApiOperationUpdate_594534(protocol: Scheme; host: string; base: string;
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

proc validate_ApiOperationUpdate_594533(path: JsonNode; query: JsonNode;
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
  var valid_594535 = path.getOrDefault("resourceGroupName")
  valid_594535 = validateParameter(valid_594535, JString, required = true,
                                 default = nil)
  if valid_594535 != nil:
    section.add "resourceGroupName", valid_594535
  var valid_594536 = path.getOrDefault("apiId")
  valid_594536 = validateParameter(valid_594536, JString, required = true,
                                 default = nil)
  if valid_594536 != nil:
    section.add "apiId", valid_594536
  var valid_594537 = path.getOrDefault("subscriptionId")
  valid_594537 = validateParameter(valid_594537, JString, required = true,
                                 default = nil)
  if valid_594537 != nil:
    section.add "subscriptionId", valid_594537
  var valid_594538 = path.getOrDefault("serviceName")
  valid_594538 = validateParameter(valid_594538, JString, required = true,
                                 default = nil)
  if valid_594538 != nil:
    section.add "serviceName", valid_594538
  var valid_594539 = path.getOrDefault("operationId")
  valid_594539 = validateParameter(valid_594539, JString, required = true,
                                 default = nil)
  if valid_594539 != nil:
    section.add "operationId", valid_594539
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594540 = query.getOrDefault("api-version")
  valid_594540 = validateParameter(valid_594540, JString, required = true,
                                 default = nil)
  if valid_594540 != nil:
    section.add "api-version", valid_594540
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594541 = header.getOrDefault("If-Match")
  valid_594541 = validateParameter(valid_594541, JString, required = true,
                                 default = nil)
  if valid_594541 != nil:
    section.add "If-Match", valid_594541
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

proc call*(call_594543: Call_ApiOperationUpdate_594532; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the operation in the API specified by its identifier.
  ## 
  let valid = call_594543.validator(path, query, header, formData, body)
  let scheme = call_594543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594543.url(scheme.get, call_594543.host, call_594543.base,
                         call_594543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594543, url, valid)

proc call*(call_594544: Call_ApiOperationUpdate_594532; resourceGroupName: string;
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
  var path_594545 = newJObject()
  var query_594546 = newJObject()
  var body_594547 = newJObject()
  add(path_594545, "resourceGroupName", newJString(resourceGroupName))
  add(query_594546, "api-version", newJString(apiVersion))
  add(path_594545, "apiId", newJString(apiId))
  add(path_594545, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594547 = parameters
  add(path_594545, "serviceName", newJString(serviceName))
  add(path_594545, "operationId", newJString(operationId))
  result = call_594544.call(path_594545, query_594546, nil, nil, body_594547)

var apiOperationUpdate* = Call_ApiOperationUpdate_594532(
    name: "apiOperationUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationUpdate_594533, base: "",
    url: url_ApiOperationUpdate_594534, schemes: {Scheme.Https})
type
  Call_ApiOperationDelete_594505 = ref object of OpenApiRestCall_593438
proc url_ApiOperationDelete_594507(protocol: Scheme; host: string; base: string;
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

proc validate_ApiOperationDelete_594506(path: JsonNode; query: JsonNode;
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
  var valid_594508 = path.getOrDefault("resourceGroupName")
  valid_594508 = validateParameter(valid_594508, JString, required = true,
                                 default = nil)
  if valid_594508 != nil:
    section.add "resourceGroupName", valid_594508
  var valid_594509 = path.getOrDefault("apiId")
  valid_594509 = validateParameter(valid_594509, JString, required = true,
                                 default = nil)
  if valid_594509 != nil:
    section.add "apiId", valid_594509
  var valid_594510 = path.getOrDefault("subscriptionId")
  valid_594510 = validateParameter(valid_594510, JString, required = true,
                                 default = nil)
  if valid_594510 != nil:
    section.add "subscriptionId", valid_594510
  var valid_594511 = path.getOrDefault("serviceName")
  valid_594511 = validateParameter(valid_594511, JString, required = true,
                                 default = nil)
  if valid_594511 != nil:
    section.add "serviceName", valid_594511
  var valid_594512 = path.getOrDefault("operationId")
  valid_594512 = validateParameter(valid_594512, JString, required = true,
                                 default = nil)
  if valid_594512 != nil:
    section.add "operationId", valid_594512
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594513 = query.getOrDefault("api-version")
  valid_594513 = validateParameter(valid_594513, JString, required = true,
                                 default = nil)
  if valid_594513 != nil:
    section.add "api-version", valid_594513
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594514 = header.getOrDefault("If-Match")
  valid_594514 = validateParameter(valid_594514, JString, required = true,
                                 default = nil)
  if valid_594514 != nil:
    section.add "If-Match", valid_594514
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594515: Call_ApiOperationDelete_594505; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified operation in the API.
  ## 
  let valid = call_594515.validator(path, query, header, formData, body)
  let scheme = call_594515.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594515.url(scheme.get, call_594515.host, call_594515.base,
                         call_594515.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594515, url, valid)

proc call*(call_594516: Call_ApiOperationDelete_594505; resourceGroupName: string;
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
  var path_594517 = newJObject()
  var query_594518 = newJObject()
  add(path_594517, "resourceGroupName", newJString(resourceGroupName))
  add(query_594518, "api-version", newJString(apiVersion))
  add(path_594517, "apiId", newJString(apiId))
  add(path_594517, "subscriptionId", newJString(subscriptionId))
  add(path_594517, "serviceName", newJString(serviceName))
  add(path_594517, "operationId", newJString(operationId))
  result = call_594516.call(path_594517, query_594518, nil, nil, nil)

var apiOperationDelete* = Call_ApiOperationDelete_594505(
    name: "apiOperationDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationDelete_594506, base: "",
    url: url_ApiOperationDelete_594507, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyListByOperation_594548 = ref object of OpenApiRestCall_593438
proc url_ApiOperationPolicyListByOperation_594550(protocol: Scheme; host: string;
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

proc validate_ApiOperationPolicyListByOperation_594549(path: JsonNode;
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
  var valid_594551 = path.getOrDefault("resourceGroupName")
  valid_594551 = validateParameter(valid_594551, JString, required = true,
                                 default = nil)
  if valid_594551 != nil:
    section.add "resourceGroupName", valid_594551
  var valid_594552 = path.getOrDefault("apiId")
  valid_594552 = validateParameter(valid_594552, JString, required = true,
                                 default = nil)
  if valid_594552 != nil:
    section.add "apiId", valid_594552
  var valid_594553 = path.getOrDefault("subscriptionId")
  valid_594553 = validateParameter(valid_594553, JString, required = true,
                                 default = nil)
  if valid_594553 != nil:
    section.add "subscriptionId", valid_594553
  var valid_594554 = path.getOrDefault("serviceName")
  valid_594554 = validateParameter(valid_594554, JString, required = true,
                                 default = nil)
  if valid_594554 != nil:
    section.add "serviceName", valid_594554
  var valid_594555 = path.getOrDefault("operationId")
  valid_594555 = validateParameter(valid_594555, JString, required = true,
                                 default = nil)
  if valid_594555 != nil:
    section.add "operationId", valid_594555
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594556 = query.getOrDefault("api-version")
  valid_594556 = validateParameter(valid_594556, JString, required = true,
                                 default = nil)
  if valid_594556 != nil:
    section.add "api-version", valid_594556
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594557: Call_ApiOperationPolicyListByOperation_594548;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the list of policy configuration at the API Operation level.
  ## 
  let valid = call_594557.validator(path, query, header, formData, body)
  let scheme = call_594557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594557.url(scheme.get, call_594557.host, call_594557.base,
                         call_594557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594557, url, valid)

proc call*(call_594558: Call_ApiOperationPolicyListByOperation_594548;
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
  var path_594559 = newJObject()
  var query_594560 = newJObject()
  add(path_594559, "resourceGroupName", newJString(resourceGroupName))
  add(query_594560, "api-version", newJString(apiVersion))
  add(path_594559, "apiId", newJString(apiId))
  add(path_594559, "subscriptionId", newJString(subscriptionId))
  add(path_594559, "serviceName", newJString(serviceName))
  add(path_594559, "operationId", newJString(operationId))
  result = call_594558.call(path_594559, query_594560, nil, nil, nil)

var apiOperationPolicyListByOperation* = Call_ApiOperationPolicyListByOperation_594548(
    name: "apiOperationPolicyListByOperation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/policies",
    validator: validate_ApiOperationPolicyListByOperation_594549, base: "",
    url: url_ApiOperationPolicyListByOperation_594550, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyCreateOrUpdate_594575 = ref object of OpenApiRestCall_593438
proc url_ApiOperationPolicyCreateOrUpdate_594577(protocol: Scheme; host: string;
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

proc validate_ApiOperationPolicyCreateOrUpdate_594576(path: JsonNode;
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
  var valid_594578 = path.getOrDefault("resourceGroupName")
  valid_594578 = validateParameter(valid_594578, JString, required = true,
                                 default = nil)
  if valid_594578 != nil:
    section.add "resourceGroupName", valid_594578
  var valid_594579 = path.getOrDefault("apiId")
  valid_594579 = validateParameter(valid_594579, JString, required = true,
                                 default = nil)
  if valid_594579 != nil:
    section.add "apiId", valid_594579
  var valid_594580 = path.getOrDefault("subscriptionId")
  valid_594580 = validateParameter(valid_594580, JString, required = true,
                                 default = nil)
  if valid_594580 != nil:
    section.add "subscriptionId", valid_594580
  var valid_594581 = path.getOrDefault("policyId")
  valid_594581 = validateParameter(valid_594581, JString, required = true,
                                 default = newJString("policy"))
  if valid_594581 != nil:
    section.add "policyId", valid_594581
  var valid_594582 = path.getOrDefault("serviceName")
  valid_594582 = validateParameter(valid_594582, JString, required = true,
                                 default = nil)
  if valid_594582 != nil:
    section.add "serviceName", valid_594582
  var valid_594583 = path.getOrDefault("operationId")
  valid_594583 = validateParameter(valid_594583, JString, required = true,
                                 default = nil)
  if valid_594583 != nil:
    section.add "operationId", valid_594583
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594584 = query.getOrDefault("api-version")
  valid_594584 = validateParameter(valid_594584, JString, required = true,
                                 default = nil)
  if valid_594584 != nil:
    section.add "api-version", valid_594584
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_594585 = header.getOrDefault("If-Match")
  valid_594585 = validateParameter(valid_594585, JString, required = false,
                                 default = nil)
  if valid_594585 != nil:
    section.add "If-Match", valid_594585
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

proc call*(call_594587: Call_ApiOperationPolicyCreateOrUpdate_594575;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates policy configuration for the API Operation level.
  ## 
  let valid = call_594587.validator(path, query, header, formData, body)
  let scheme = call_594587.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594587.url(scheme.get, call_594587.host, call_594587.base,
                         call_594587.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594587, url, valid)

proc call*(call_594588: Call_ApiOperationPolicyCreateOrUpdate_594575;
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
  var path_594589 = newJObject()
  var query_594590 = newJObject()
  var body_594591 = newJObject()
  add(path_594589, "resourceGroupName", newJString(resourceGroupName))
  add(query_594590, "api-version", newJString(apiVersion))
  add(path_594589, "apiId", newJString(apiId))
  add(path_594589, "subscriptionId", newJString(subscriptionId))
  add(path_594589, "policyId", newJString(policyId))
  if parameters != nil:
    body_594591 = parameters
  add(path_594589, "serviceName", newJString(serviceName))
  add(path_594589, "operationId", newJString(operationId))
  result = call_594588.call(path_594589, query_594590, nil, nil, body_594591)

var apiOperationPolicyCreateOrUpdate* = Call_ApiOperationPolicyCreateOrUpdate_594575(
    name: "apiOperationPolicyCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/policies/{policyId}",
    validator: validate_ApiOperationPolicyCreateOrUpdate_594576, base: "",
    url: url_ApiOperationPolicyCreateOrUpdate_594577, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyGetEntityTag_594607 = ref object of OpenApiRestCall_593438
proc url_ApiOperationPolicyGetEntityTag_594609(protocol: Scheme; host: string;
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

proc validate_ApiOperationPolicyGetEntityTag_594608(path: JsonNode;
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
  var valid_594610 = path.getOrDefault("resourceGroupName")
  valid_594610 = validateParameter(valid_594610, JString, required = true,
                                 default = nil)
  if valid_594610 != nil:
    section.add "resourceGroupName", valid_594610
  var valid_594611 = path.getOrDefault("apiId")
  valid_594611 = validateParameter(valid_594611, JString, required = true,
                                 default = nil)
  if valid_594611 != nil:
    section.add "apiId", valid_594611
  var valid_594612 = path.getOrDefault("subscriptionId")
  valid_594612 = validateParameter(valid_594612, JString, required = true,
                                 default = nil)
  if valid_594612 != nil:
    section.add "subscriptionId", valid_594612
  var valid_594613 = path.getOrDefault("policyId")
  valid_594613 = validateParameter(valid_594613, JString, required = true,
                                 default = newJString("policy"))
  if valid_594613 != nil:
    section.add "policyId", valid_594613
  var valid_594614 = path.getOrDefault("serviceName")
  valid_594614 = validateParameter(valid_594614, JString, required = true,
                                 default = nil)
  if valid_594614 != nil:
    section.add "serviceName", valid_594614
  var valid_594615 = path.getOrDefault("operationId")
  valid_594615 = validateParameter(valid_594615, JString, required = true,
                                 default = nil)
  if valid_594615 != nil:
    section.add "operationId", valid_594615
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594616 = query.getOrDefault("api-version")
  valid_594616 = validateParameter(valid_594616, JString, required = true,
                                 default = nil)
  if valid_594616 != nil:
    section.add "api-version", valid_594616
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594617: Call_ApiOperationPolicyGetEntityTag_594607; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the API operation policy specified by its identifier.
  ## 
  let valid = call_594617.validator(path, query, header, formData, body)
  let scheme = call_594617.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594617.url(scheme.get, call_594617.host, call_594617.base,
                         call_594617.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594617, url, valid)

proc call*(call_594618: Call_ApiOperationPolicyGetEntityTag_594607;
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
  var path_594619 = newJObject()
  var query_594620 = newJObject()
  add(path_594619, "resourceGroupName", newJString(resourceGroupName))
  add(query_594620, "api-version", newJString(apiVersion))
  add(path_594619, "apiId", newJString(apiId))
  add(path_594619, "subscriptionId", newJString(subscriptionId))
  add(path_594619, "policyId", newJString(policyId))
  add(path_594619, "serviceName", newJString(serviceName))
  add(path_594619, "operationId", newJString(operationId))
  result = call_594618.call(path_594619, query_594620, nil, nil, nil)

var apiOperationPolicyGetEntityTag* = Call_ApiOperationPolicyGetEntityTag_594607(
    name: "apiOperationPolicyGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/policies/{policyId}",
    validator: validate_ApiOperationPolicyGetEntityTag_594608, base: "",
    url: url_ApiOperationPolicyGetEntityTag_594609, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyGet_594561 = ref object of OpenApiRestCall_593438
proc url_ApiOperationPolicyGet_594563(protocol: Scheme; host: string; base: string;
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

proc validate_ApiOperationPolicyGet_594562(path: JsonNode; query: JsonNode;
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
  var valid_594564 = path.getOrDefault("resourceGroupName")
  valid_594564 = validateParameter(valid_594564, JString, required = true,
                                 default = nil)
  if valid_594564 != nil:
    section.add "resourceGroupName", valid_594564
  var valid_594565 = path.getOrDefault("apiId")
  valid_594565 = validateParameter(valid_594565, JString, required = true,
                                 default = nil)
  if valid_594565 != nil:
    section.add "apiId", valid_594565
  var valid_594566 = path.getOrDefault("subscriptionId")
  valid_594566 = validateParameter(valid_594566, JString, required = true,
                                 default = nil)
  if valid_594566 != nil:
    section.add "subscriptionId", valid_594566
  var valid_594567 = path.getOrDefault("policyId")
  valid_594567 = validateParameter(valid_594567, JString, required = true,
                                 default = newJString("policy"))
  if valid_594567 != nil:
    section.add "policyId", valid_594567
  var valid_594568 = path.getOrDefault("serviceName")
  valid_594568 = validateParameter(valid_594568, JString, required = true,
                                 default = nil)
  if valid_594568 != nil:
    section.add "serviceName", valid_594568
  var valid_594569 = path.getOrDefault("operationId")
  valid_594569 = validateParameter(valid_594569, JString, required = true,
                                 default = nil)
  if valid_594569 != nil:
    section.add "operationId", valid_594569
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594570 = query.getOrDefault("api-version")
  valid_594570 = validateParameter(valid_594570, JString, required = true,
                                 default = nil)
  if valid_594570 != nil:
    section.add "api-version", valid_594570
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594571: Call_ApiOperationPolicyGet_594561; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the API Operation level.
  ## 
  let valid = call_594571.validator(path, query, header, formData, body)
  let scheme = call_594571.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594571.url(scheme.get, call_594571.host, call_594571.base,
                         call_594571.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594571, url, valid)

proc call*(call_594572: Call_ApiOperationPolicyGet_594561;
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
  var path_594573 = newJObject()
  var query_594574 = newJObject()
  add(path_594573, "resourceGroupName", newJString(resourceGroupName))
  add(query_594574, "api-version", newJString(apiVersion))
  add(path_594573, "apiId", newJString(apiId))
  add(path_594573, "subscriptionId", newJString(subscriptionId))
  add(path_594573, "policyId", newJString(policyId))
  add(path_594573, "serviceName", newJString(serviceName))
  add(path_594573, "operationId", newJString(operationId))
  result = call_594572.call(path_594573, query_594574, nil, nil, nil)

var apiOperationPolicyGet* = Call_ApiOperationPolicyGet_594561(
    name: "apiOperationPolicyGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/policies/{policyId}",
    validator: validate_ApiOperationPolicyGet_594562, base: "",
    url: url_ApiOperationPolicyGet_594563, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyDelete_594592 = ref object of OpenApiRestCall_593438
proc url_ApiOperationPolicyDelete_594594(protocol: Scheme; host: string;
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

proc validate_ApiOperationPolicyDelete_594593(path: JsonNode; query: JsonNode;
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
  var valid_594595 = path.getOrDefault("resourceGroupName")
  valid_594595 = validateParameter(valid_594595, JString, required = true,
                                 default = nil)
  if valid_594595 != nil:
    section.add "resourceGroupName", valid_594595
  var valid_594596 = path.getOrDefault("apiId")
  valid_594596 = validateParameter(valid_594596, JString, required = true,
                                 default = nil)
  if valid_594596 != nil:
    section.add "apiId", valid_594596
  var valid_594597 = path.getOrDefault("subscriptionId")
  valid_594597 = validateParameter(valid_594597, JString, required = true,
                                 default = nil)
  if valid_594597 != nil:
    section.add "subscriptionId", valid_594597
  var valid_594598 = path.getOrDefault("policyId")
  valid_594598 = validateParameter(valid_594598, JString, required = true,
                                 default = newJString("policy"))
  if valid_594598 != nil:
    section.add "policyId", valid_594598
  var valid_594599 = path.getOrDefault("serviceName")
  valid_594599 = validateParameter(valid_594599, JString, required = true,
                                 default = nil)
  if valid_594599 != nil:
    section.add "serviceName", valid_594599
  var valid_594600 = path.getOrDefault("operationId")
  valid_594600 = validateParameter(valid_594600, JString, required = true,
                                 default = nil)
  if valid_594600 != nil:
    section.add "operationId", valid_594600
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594601 = query.getOrDefault("api-version")
  valid_594601 = validateParameter(valid_594601, JString, required = true,
                                 default = nil)
  if valid_594601 != nil:
    section.add "api-version", valid_594601
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594602 = header.getOrDefault("If-Match")
  valid_594602 = validateParameter(valid_594602, JString, required = true,
                                 default = nil)
  if valid_594602 != nil:
    section.add "If-Match", valid_594602
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594603: Call_ApiOperationPolicyDelete_594592; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the policy configuration at the Api Operation.
  ## 
  let valid = call_594603.validator(path, query, header, formData, body)
  let scheme = call_594603.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594603.url(scheme.get, call_594603.host, call_594603.base,
                         call_594603.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594603, url, valid)

proc call*(call_594604: Call_ApiOperationPolicyDelete_594592;
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
  var path_594605 = newJObject()
  var query_594606 = newJObject()
  add(path_594605, "resourceGroupName", newJString(resourceGroupName))
  add(query_594606, "api-version", newJString(apiVersion))
  add(path_594605, "apiId", newJString(apiId))
  add(path_594605, "subscriptionId", newJString(subscriptionId))
  add(path_594605, "policyId", newJString(policyId))
  add(path_594605, "serviceName", newJString(serviceName))
  add(path_594605, "operationId", newJString(operationId))
  result = call_594604.call(path_594605, query_594606, nil, nil, nil)

var apiOperationPolicyDelete* = Call_ApiOperationPolicyDelete_594592(
    name: "apiOperationPolicyDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/policies/{policyId}",
    validator: validate_ApiOperationPolicyDelete_594593, base: "",
    url: url_ApiOperationPolicyDelete_594594, schemes: {Scheme.Https})
type
  Call_ApiPolicyListByApi_594621 = ref object of OpenApiRestCall_593438
proc url_ApiPolicyListByApi_594623(protocol: Scheme; host: string; base: string;
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

proc validate_ApiPolicyListByApi_594622(path: JsonNode; query: JsonNode;
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
  var valid_594624 = path.getOrDefault("resourceGroupName")
  valid_594624 = validateParameter(valid_594624, JString, required = true,
                                 default = nil)
  if valid_594624 != nil:
    section.add "resourceGroupName", valid_594624
  var valid_594625 = path.getOrDefault("apiId")
  valid_594625 = validateParameter(valid_594625, JString, required = true,
                                 default = nil)
  if valid_594625 != nil:
    section.add "apiId", valid_594625
  var valid_594626 = path.getOrDefault("subscriptionId")
  valid_594626 = validateParameter(valid_594626, JString, required = true,
                                 default = nil)
  if valid_594626 != nil:
    section.add "subscriptionId", valid_594626
  var valid_594627 = path.getOrDefault("serviceName")
  valid_594627 = validateParameter(valid_594627, JString, required = true,
                                 default = nil)
  if valid_594627 != nil:
    section.add "serviceName", valid_594627
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594628 = query.getOrDefault("api-version")
  valid_594628 = validateParameter(valid_594628, JString, required = true,
                                 default = nil)
  if valid_594628 != nil:
    section.add "api-version", valid_594628
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594629: Call_ApiPolicyListByApi_594621; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the API level.
  ## 
  let valid = call_594629.validator(path, query, header, formData, body)
  let scheme = call_594629.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594629.url(scheme.get, call_594629.host, call_594629.base,
                         call_594629.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594629, url, valid)

proc call*(call_594630: Call_ApiPolicyListByApi_594621; resourceGroupName: string;
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
  var path_594631 = newJObject()
  var query_594632 = newJObject()
  add(path_594631, "resourceGroupName", newJString(resourceGroupName))
  add(query_594632, "api-version", newJString(apiVersion))
  add(path_594631, "apiId", newJString(apiId))
  add(path_594631, "subscriptionId", newJString(subscriptionId))
  add(path_594631, "serviceName", newJString(serviceName))
  result = call_594630.call(path_594631, query_594632, nil, nil, nil)

var apiPolicyListByApi* = Call_ApiPolicyListByApi_594621(
    name: "apiPolicyListByApi", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies",
    validator: validate_ApiPolicyListByApi_594622, base: "",
    url: url_ApiPolicyListByApi_594623, schemes: {Scheme.Https})
type
  Call_ApiPolicyCreateOrUpdate_594646 = ref object of OpenApiRestCall_593438
proc url_ApiPolicyCreateOrUpdate_594648(protocol: Scheme; host: string; base: string;
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

proc validate_ApiPolicyCreateOrUpdate_594647(path: JsonNode; query: JsonNode;
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
  var valid_594649 = path.getOrDefault("resourceGroupName")
  valid_594649 = validateParameter(valid_594649, JString, required = true,
                                 default = nil)
  if valid_594649 != nil:
    section.add "resourceGroupName", valid_594649
  var valid_594650 = path.getOrDefault("apiId")
  valid_594650 = validateParameter(valid_594650, JString, required = true,
                                 default = nil)
  if valid_594650 != nil:
    section.add "apiId", valid_594650
  var valid_594651 = path.getOrDefault("subscriptionId")
  valid_594651 = validateParameter(valid_594651, JString, required = true,
                                 default = nil)
  if valid_594651 != nil:
    section.add "subscriptionId", valid_594651
  var valid_594652 = path.getOrDefault("policyId")
  valid_594652 = validateParameter(valid_594652, JString, required = true,
                                 default = newJString("policy"))
  if valid_594652 != nil:
    section.add "policyId", valid_594652
  var valid_594653 = path.getOrDefault("serviceName")
  valid_594653 = validateParameter(valid_594653, JString, required = true,
                                 default = nil)
  if valid_594653 != nil:
    section.add "serviceName", valid_594653
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594654 = query.getOrDefault("api-version")
  valid_594654 = validateParameter(valid_594654, JString, required = true,
                                 default = nil)
  if valid_594654 != nil:
    section.add "api-version", valid_594654
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_594655 = header.getOrDefault("If-Match")
  valid_594655 = validateParameter(valid_594655, JString, required = false,
                                 default = nil)
  if valid_594655 != nil:
    section.add "If-Match", valid_594655
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

proc call*(call_594657: Call_ApiPolicyCreateOrUpdate_594646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates policy configuration for the API.
  ## 
  let valid = call_594657.validator(path, query, header, formData, body)
  let scheme = call_594657.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594657.url(scheme.get, call_594657.host, call_594657.base,
                         call_594657.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594657, url, valid)

proc call*(call_594658: Call_ApiPolicyCreateOrUpdate_594646;
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
  var path_594659 = newJObject()
  var query_594660 = newJObject()
  var body_594661 = newJObject()
  add(path_594659, "resourceGroupName", newJString(resourceGroupName))
  add(query_594660, "api-version", newJString(apiVersion))
  add(path_594659, "apiId", newJString(apiId))
  add(path_594659, "subscriptionId", newJString(subscriptionId))
  add(path_594659, "policyId", newJString(policyId))
  if parameters != nil:
    body_594661 = parameters
  add(path_594659, "serviceName", newJString(serviceName))
  result = call_594658.call(path_594659, query_594660, nil, nil, body_594661)

var apiPolicyCreateOrUpdate* = Call_ApiPolicyCreateOrUpdate_594646(
    name: "apiPolicyCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}",
    validator: validate_ApiPolicyCreateOrUpdate_594647, base: "",
    url: url_ApiPolicyCreateOrUpdate_594648, schemes: {Scheme.Https})
type
  Call_ApiPolicyGetEntityTag_594676 = ref object of OpenApiRestCall_593438
proc url_ApiPolicyGetEntityTag_594678(protocol: Scheme; host: string; base: string;
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

proc validate_ApiPolicyGetEntityTag_594677(path: JsonNode; query: JsonNode;
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
  var valid_594679 = path.getOrDefault("resourceGroupName")
  valid_594679 = validateParameter(valid_594679, JString, required = true,
                                 default = nil)
  if valid_594679 != nil:
    section.add "resourceGroupName", valid_594679
  var valid_594680 = path.getOrDefault("apiId")
  valid_594680 = validateParameter(valid_594680, JString, required = true,
                                 default = nil)
  if valid_594680 != nil:
    section.add "apiId", valid_594680
  var valid_594681 = path.getOrDefault("subscriptionId")
  valid_594681 = validateParameter(valid_594681, JString, required = true,
                                 default = nil)
  if valid_594681 != nil:
    section.add "subscriptionId", valid_594681
  var valid_594682 = path.getOrDefault("policyId")
  valid_594682 = validateParameter(valid_594682, JString, required = true,
                                 default = newJString("policy"))
  if valid_594682 != nil:
    section.add "policyId", valid_594682
  var valid_594683 = path.getOrDefault("serviceName")
  valid_594683 = validateParameter(valid_594683, JString, required = true,
                                 default = nil)
  if valid_594683 != nil:
    section.add "serviceName", valid_594683
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594684 = query.getOrDefault("api-version")
  valid_594684 = validateParameter(valid_594684, JString, required = true,
                                 default = nil)
  if valid_594684 != nil:
    section.add "api-version", valid_594684
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594685: Call_ApiPolicyGetEntityTag_594676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the API policy specified by its identifier.
  ## 
  let valid = call_594685.validator(path, query, header, formData, body)
  let scheme = call_594685.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594685.url(scheme.get, call_594685.host, call_594685.base,
                         call_594685.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594685, url, valid)

proc call*(call_594686: Call_ApiPolicyGetEntityTag_594676;
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
  var path_594687 = newJObject()
  var query_594688 = newJObject()
  add(path_594687, "resourceGroupName", newJString(resourceGroupName))
  add(query_594688, "api-version", newJString(apiVersion))
  add(path_594687, "apiId", newJString(apiId))
  add(path_594687, "subscriptionId", newJString(subscriptionId))
  add(path_594687, "policyId", newJString(policyId))
  add(path_594687, "serviceName", newJString(serviceName))
  result = call_594686.call(path_594687, query_594688, nil, nil, nil)

var apiPolicyGetEntityTag* = Call_ApiPolicyGetEntityTag_594676(
    name: "apiPolicyGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}",
    validator: validate_ApiPolicyGetEntityTag_594677, base: "",
    url: url_ApiPolicyGetEntityTag_594678, schemes: {Scheme.Https})
type
  Call_ApiPolicyGet_594633 = ref object of OpenApiRestCall_593438
proc url_ApiPolicyGet_594635(protocol: Scheme; host: string; base: string;
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

proc validate_ApiPolicyGet_594634(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594636 = path.getOrDefault("resourceGroupName")
  valid_594636 = validateParameter(valid_594636, JString, required = true,
                                 default = nil)
  if valid_594636 != nil:
    section.add "resourceGroupName", valid_594636
  var valid_594637 = path.getOrDefault("apiId")
  valid_594637 = validateParameter(valid_594637, JString, required = true,
                                 default = nil)
  if valid_594637 != nil:
    section.add "apiId", valid_594637
  var valid_594638 = path.getOrDefault("subscriptionId")
  valid_594638 = validateParameter(valid_594638, JString, required = true,
                                 default = nil)
  if valid_594638 != nil:
    section.add "subscriptionId", valid_594638
  var valid_594639 = path.getOrDefault("policyId")
  valid_594639 = validateParameter(valid_594639, JString, required = true,
                                 default = newJString("policy"))
  if valid_594639 != nil:
    section.add "policyId", valid_594639
  var valid_594640 = path.getOrDefault("serviceName")
  valid_594640 = validateParameter(valid_594640, JString, required = true,
                                 default = nil)
  if valid_594640 != nil:
    section.add "serviceName", valid_594640
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594641 = query.getOrDefault("api-version")
  valid_594641 = validateParameter(valid_594641, JString, required = true,
                                 default = nil)
  if valid_594641 != nil:
    section.add "api-version", valid_594641
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594642: Call_ApiPolicyGet_594633; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the API level.
  ## 
  let valid = call_594642.validator(path, query, header, formData, body)
  let scheme = call_594642.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594642.url(scheme.get, call_594642.host, call_594642.base,
                         call_594642.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594642, url, valid)

proc call*(call_594643: Call_ApiPolicyGet_594633; resourceGroupName: string;
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
  var path_594644 = newJObject()
  var query_594645 = newJObject()
  add(path_594644, "resourceGroupName", newJString(resourceGroupName))
  add(query_594645, "api-version", newJString(apiVersion))
  add(path_594644, "apiId", newJString(apiId))
  add(path_594644, "subscriptionId", newJString(subscriptionId))
  add(path_594644, "policyId", newJString(policyId))
  add(path_594644, "serviceName", newJString(serviceName))
  result = call_594643.call(path_594644, query_594645, nil, nil, nil)

var apiPolicyGet* = Call_ApiPolicyGet_594633(name: "apiPolicyGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}",
    validator: validate_ApiPolicyGet_594634, base: "", url: url_ApiPolicyGet_594635,
    schemes: {Scheme.Https})
type
  Call_ApiPolicyDelete_594662 = ref object of OpenApiRestCall_593438
proc url_ApiPolicyDelete_594664(protocol: Scheme; host: string; base: string;
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

proc validate_ApiPolicyDelete_594663(path: JsonNode; query: JsonNode;
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
  var valid_594665 = path.getOrDefault("resourceGroupName")
  valid_594665 = validateParameter(valid_594665, JString, required = true,
                                 default = nil)
  if valid_594665 != nil:
    section.add "resourceGroupName", valid_594665
  var valid_594666 = path.getOrDefault("apiId")
  valid_594666 = validateParameter(valid_594666, JString, required = true,
                                 default = nil)
  if valid_594666 != nil:
    section.add "apiId", valid_594666
  var valid_594667 = path.getOrDefault("subscriptionId")
  valid_594667 = validateParameter(valid_594667, JString, required = true,
                                 default = nil)
  if valid_594667 != nil:
    section.add "subscriptionId", valid_594667
  var valid_594668 = path.getOrDefault("policyId")
  valid_594668 = validateParameter(valid_594668, JString, required = true,
                                 default = newJString("policy"))
  if valid_594668 != nil:
    section.add "policyId", valid_594668
  var valid_594669 = path.getOrDefault("serviceName")
  valid_594669 = validateParameter(valid_594669, JString, required = true,
                                 default = nil)
  if valid_594669 != nil:
    section.add "serviceName", valid_594669
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594670 = query.getOrDefault("api-version")
  valid_594670 = validateParameter(valid_594670, JString, required = true,
                                 default = nil)
  if valid_594670 != nil:
    section.add "api-version", valid_594670
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594671 = header.getOrDefault("If-Match")
  valid_594671 = validateParameter(valid_594671, JString, required = true,
                                 default = nil)
  if valid_594671 != nil:
    section.add "If-Match", valid_594671
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594672: Call_ApiPolicyDelete_594662; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the policy configuration at the Api.
  ## 
  let valid = call_594672.validator(path, query, header, formData, body)
  let scheme = call_594672.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594672.url(scheme.get, call_594672.host, call_594672.base,
                         call_594672.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594672, url, valid)

proc call*(call_594673: Call_ApiPolicyDelete_594662; resourceGroupName: string;
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
  var path_594674 = newJObject()
  var query_594675 = newJObject()
  add(path_594674, "resourceGroupName", newJString(resourceGroupName))
  add(query_594675, "api-version", newJString(apiVersion))
  add(path_594674, "apiId", newJString(apiId))
  add(path_594674, "subscriptionId", newJString(subscriptionId))
  add(path_594674, "policyId", newJString(policyId))
  add(path_594674, "serviceName", newJString(serviceName))
  result = call_594673.call(path_594674, query_594675, nil, nil, nil)

var apiPolicyDelete* = Call_ApiPolicyDelete_594662(name: "apiPolicyDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}",
    validator: validate_ApiPolicyDelete_594663, base: "", url: url_ApiPolicyDelete_594664,
    schemes: {Scheme.Https})
type
  Call_ApiProductListByApis_594689 = ref object of OpenApiRestCall_593438
proc url_ApiProductListByApis_594691(protocol: Scheme; host: string; base: string;
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

proc validate_ApiProductListByApis_594690(path: JsonNode; query: JsonNode;
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
  var valid_594692 = path.getOrDefault("resourceGroupName")
  valid_594692 = validateParameter(valid_594692, JString, required = true,
                                 default = nil)
  if valid_594692 != nil:
    section.add "resourceGroupName", valid_594692
  var valid_594693 = path.getOrDefault("apiId")
  valid_594693 = validateParameter(valid_594693, JString, required = true,
                                 default = nil)
  if valid_594693 != nil:
    section.add "apiId", valid_594693
  var valid_594694 = path.getOrDefault("subscriptionId")
  valid_594694 = validateParameter(valid_594694, JString, required = true,
                                 default = nil)
  if valid_594694 != nil:
    section.add "subscriptionId", valid_594694
  var valid_594695 = path.getOrDefault("serviceName")
  valid_594695 = validateParameter(valid_594695, JString, required = true,
                                 default = nil)
  if valid_594695 != nil:
    section.add "serviceName", valid_594695
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594696 = query.getOrDefault("api-version")
  valid_594696 = validateParameter(valid_594696, JString, required = true,
                                 default = nil)
  if valid_594696 != nil:
    section.add "api-version", valid_594696
  var valid_594697 = query.getOrDefault("$top")
  valid_594697 = validateParameter(valid_594697, JInt, required = false, default = nil)
  if valid_594697 != nil:
    section.add "$top", valid_594697
  var valid_594698 = query.getOrDefault("$skip")
  valid_594698 = validateParameter(valid_594698, JInt, required = false, default = nil)
  if valid_594698 != nil:
    section.add "$skip", valid_594698
  var valid_594699 = query.getOrDefault("$filter")
  valid_594699 = validateParameter(valid_594699, JString, required = false,
                                 default = nil)
  if valid_594699 != nil:
    section.add "$filter", valid_594699
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594700: Call_ApiProductListByApis_594689; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Products, which the API is part of.
  ## 
  let valid = call_594700.validator(path, query, header, formData, body)
  let scheme = call_594700.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594700.url(scheme.get, call_594700.host, call_594700.base,
                         call_594700.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594700, url, valid)

proc call*(call_594701: Call_ApiProductListByApis_594689;
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
  ##         : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_594702 = newJObject()
  var query_594703 = newJObject()
  add(path_594702, "resourceGroupName", newJString(resourceGroupName))
  add(query_594703, "api-version", newJString(apiVersion))
  add(path_594702, "apiId", newJString(apiId))
  add(path_594702, "subscriptionId", newJString(subscriptionId))
  add(query_594703, "$top", newJInt(Top))
  add(query_594703, "$skip", newJInt(Skip))
  add(path_594702, "serviceName", newJString(serviceName))
  add(query_594703, "$filter", newJString(Filter))
  result = call_594701.call(path_594702, query_594703, nil, nil, nil)

var apiProductListByApis* = Call_ApiProductListByApis_594689(
    name: "apiProductListByApis", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/products",
    validator: validate_ApiProductListByApis_594690, base: "",
    url: url_ApiProductListByApis_594691, schemes: {Scheme.Https})
type
  Call_ApiReleaseList_594704 = ref object of OpenApiRestCall_593438
proc url_ApiReleaseList_594706(protocol: Scheme; host: string; base: string;
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

proc validate_ApiReleaseList_594705(path: JsonNode; query: JsonNode;
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
  var valid_594707 = path.getOrDefault("resourceGroupName")
  valid_594707 = validateParameter(valid_594707, JString, required = true,
                                 default = nil)
  if valid_594707 != nil:
    section.add "resourceGroupName", valid_594707
  var valid_594708 = path.getOrDefault("apiId")
  valid_594708 = validateParameter(valid_594708, JString, required = true,
                                 default = nil)
  if valid_594708 != nil:
    section.add "apiId", valid_594708
  var valid_594709 = path.getOrDefault("subscriptionId")
  valid_594709 = validateParameter(valid_594709, JString, required = true,
                                 default = nil)
  if valid_594709 != nil:
    section.add "subscriptionId", valid_594709
  var valid_594710 = path.getOrDefault("serviceName")
  valid_594710 = validateParameter(valid_594710, JString, required = true,
                                 default = nil)
  if valid_594710 != nil:
    section.add "serviceName", valid_594710
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## |notes|ge le eq ne gt lt|substringof contains startswith endswith|
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594711 = query.getOrDefault("api-version")
  valid_594711 = validateParameter(valid_594711, JString, required = true,
                                 default = nil)
  if valid_594711 != nil:
    section.add "api-version", valid_594711
  var valid_594712 = query.getOrDefault("$top")
  valid_594712 = validateParameter(valid_594712, JInt, required = false, default = nil)
  if valid_594712 != nil:
    section.add "$top", valid_594712
  var valid_594713 = query.getOrDefault("$skip")
  valid_594713 = validateParameter(valid_594713, JInt, required = false, default = nil)
  if valid_594713 != nil:
    section.add "$skip", valid_594713
  var valid_594714 = query.getOrDefault("$filter")
  valid_594714 = validateParameter(valid_594714, JString, required = false,
                                 default = nil)
  if valid_594714 != nil:
    section.add "$filter", valid_594714
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594715: Call_ApiReleaseList_594704; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all releases of an API. An API release is created when making an API Revision current. Releases are also used to rollback to previous revisions. Results will be paged and can be constrained by the $top and $skip parameters.
  ## 
  let valid = call_594715.validator(path, query, header, formData, body)
  let scheme = call_594715.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594715.url(scheme.get, call_594715.host, call_594715.base,
                         call_594715.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594715, url, valid)

proc call*(call_594716: Call_ApiReleaseList_594704; resourceGroupName: string;
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
  ##         : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## |notes|ge le eq ne gt lt|substringof contains startswith endswith|
  var path_594717 = newJObject()
  var query_594718 = newJObject()
  add(path_594717, "resourceGroupName", newJString(resourceGroupName))
  add(query_594718, "api-version", newJString(apiVersion))
  add(path_594717, "apiId", newJString(apiId))
  add(path_594717, "subscriptionId", newJString(subscriptionId))
  add(query_594718, "$top", newJInt(Top))
  add(query_594718, "$skip", newJInt(Skip))
  add(path_594717, "serviceName", newJString(serviceName))
  add(query_594718, "$filter", newJString(Filter))
  result = call_594716.call(path_594717, query_594718, nil, nil, nil)

var apiReleaseList* = Call_ApiReleaseList_594704(name: "apiReleaseList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/releases",
    validator: validate_ApiReleaseList_594705, base: "", url: url_ApiReleaseList_594706,
    schemes: {Scheme.Https})
type
  Call_ApiReleaseCreate_594732 = ref object of OpenApiRestCall_593438
proc url_ApiReleaseCreate_594734(protocol: Scheme; host: string; base: string;
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

proc validate_ApiReleaseCreate_594733(path: JsonNode; query: JsonNode;
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
  var valid_594735 = path.getOrDefault("resourceGroupName")
  valid_594735 = validateParameter(valid_594735, JString, required = true,
                                 default = nil)
  if valid_594735 != nil:
    section.add "resourceGroupName", valid_594735
  var valid_594736 = path.getOrDefault("apiId")
  valid_594736 = validateParameter(valid_594736, JString, required = true,
                                 default = nil)
  if valid_594736 != nil:
    section.add "apiId", valid_594736
  var valid_594737 = path.getOrDefault("subscriptionId")
  valid_594737 = validateParameter(valid_594737, JString, required = true,
                                 default = nil)
  if valid_594737 != nil:
    section.add "subscriptionId", valid_594737
  var valid_594738 = path.getOrDefault("releaseId")
  valid_594738 = validateParameter(valid_594738, JString, required = true,
                                 default = nil)
  if valid_594738 != nil:
    section.add "releaseId", valid_594738
  var valid_594739 = path.getOrDefault("serviceName")
  valid_594739 = validateParameter(valid_594739, JString, required = true,
                                 default = nil)
  if valid_594739 != nil:
    section.add "serviceName", valid_594739
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594740 = query.getOrDefault("api-version")
  valid_594740 = validateParameter(valid_594740, JString, required = true,
                                 default = nil)
  if valid_594740 != nil:
    section.add "api-version", valid_594740
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

proc call*(call_594742: Call_ApiReleaseCreate_594732; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Release for the API.
  ## 
  let valid = call_594742.validator(path, query, header, formData, body)
  let scheme = call_594742.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594742.url(scheme.get, call_594742.host, call_594742.base,
                         call_594742.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594742, url, valid)

proc call*(call_594743: Call_ApiReleaseCreate_594732; resourceGroupName: string;
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
  var path_594744 = newJObject()
  var query_594745 = newJObject()
  var body_594746 = newJObject()
  add(path_594744, "resourceGroupName", newJString(resourceGroupName))
  add(query_594745, "api-version", newJString(apiVersion))
  add(path_594744, "apiId", newJString(apiId))
  add(path_594744, "subscriptionId", newJString(subscriptionId))
  add(path_594744, "releaseId", newJString(releaseId))
  if parameters != nil:
    body_594746 = parameters
  add(path_594744, "serviceName", newJString(serviceName))
  result = call_594743.call(path_594744, query_594745, nil, nil, body_594746)

var apiReleaseCreate* = Call_ApiReleaseCreate_594732(name: "apiReleaseCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/releases/{releaseId}",
    validator: validate_ApiReleaseCreate_594733, base: "",
    url: url_ApiReleaseCreate_594734, schemes: {Scheme.Https})
type
  Call_ApiReleaseGetEntityTag_594761 = ref object of OpenApiRestCall_593438
proc url_ApiReleaseGetEntityTag_594763(protocol: Scheme; host: string; base: string;
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

proc validate_ApiReleaseGetEntityTag_594762(path: JsonNode; query: JsonNode;
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
  var valid_594764 = path.getOrDefault("resourceGroupName")
  valid_594764 = validateParameter(valid_594764, JString, required = true,
                                 default = nil)
  if valid_594764 != nil:
    section.add "resourceGroupName", valid_594764
  var valid_594765 = path.getOrDefault("apiId")
  valid_594765 = validateParameter(valid_594765, JString, required = true,
                                 default = nil)
  if valid_594765 != nil:
    section.add "apiId", valid_594765
  var valid_594766 = path.getOrDefault("subscriptionId")
  valid_594766 = validateParameter(valid_594766, JString, required = true,
                                 default = nil)
  if valid_594766 != nil:
    section.add "subscriptionId", valid_594766
  var valid_594767 = path.getOrDefault("releaseId")
  valid_594767 = validateParameter(valid_594767, JString, required = true,
                                 default = nil)
  if valid_594767 != nil:
    section.add "releaseId", valid_594767
  var valid_594768 = path.getOrDefault("serviceName")
  valid_594768 = validateParameter(valid_594768, JString, required = true,
                                 default = nil)
  if valid_594768 != nil:
    section.add "serviceName", valid_594768
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594769 = query.getOrDefault("api-version")
  valid_594769 = validateParameter(valid_594769, JString, required = true,
                                 default = nil)
  if valid_594769 != nil:
    section.add "api-version", valid_594769
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594770: Call_ApiReleaseGetEntityTag_594761; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the etag of an API release.
  ## 
  let valid = call_594770.validator(path, query, header, formData, body)
  let scheme = call_594770.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594770.url(scheme.get, call_594770.host, call_594770.base,
                         call_594770.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594770, url, valid)

proc call*(call_594771: Call_ApiReleaseGetEntityTag_594761;
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
  var path_594772 = newJObject()
  var query_594773 = newJObject()
  add(path_594772, "resourceGroupName", newJString(resourceGroupName))
  add(query_594773, "api-version", newJString(apiVersion))
  add(path_594772, "apiId", newJString(apiId))
  add(path_594772, "subscriptionId", newJString(subscriptionId))
  add(path_594772, "releaseId", newJString(releaseId))
  add(path_594772, "serviceName", newJString(serviceName))
  result = call_594771.call(path_594772, query_594773, nil, nil, nil)

var apiReleaseGetEntityTag* = Call_ApiReleaseGetEntityTag_594761(
    name: "apiReleaseGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/releases/{releaseId}",
    validator: validate_ApiReleaseGetEntityTag_594762, base: "",
    url: url_ApiReleaseGetEntityTag_594763, schemes: {Scheme.Https})
type
  Call_ApiReleaseGet_594719 = ref object of OpenApiRestCall_593438
proc url_ApiReleaseGet_594721(protocol: Scheme; host: string; base: string;
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

proc validate_ApiReleaseGet_594720(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594722 = path.getOrDefault("resourceGroupName")
  valid_594722 = validateParameter(valid_594722, JString, required = true,
                                 default = nil)
  if valid_594722 != nil:
    section.add "resourceGroupName", valid_594722
  var valid_594723 = path.getOrDefault("apiId")
  valid_594723 = validateParameter(valid_594723, JString, required = true,
                                 default = nil)
  if valid_594723 != nil:
    section.add "apiId", valid_594723
  var valid_594724 = path.getOrDefault("subscriptionId")
  valid_594724 = validateParameter(valid_594724, JString, required = true,
                                 default = nil)
  if valid_594724 != nil:
    section.add "subscriptionId", valid_594724
  var valid_594725 = path.getOrDefault("releaseId")
  valid_594725 = validateParameter(valid_594725, JString, required = true,
                                 default = nil)
  if valid_594725 != nil:
    section.add "releaseId", valid_594725
  var valid_594726 = path.getOrDefault("serviceName")
  valid_594726 = validateParameter(valid_594726, JString, required = true,
                                 default = nil)
  if valid_594726 != nil:
    section.add "serviceName", valid_594726
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594727 = query.getOrDefault("api-version")
  valid_594727 = validateParameter(valid_594727, JString, required = true,
                                 default = nil)
  if valid_594727 != nil:
    section.add "api-version", valid_594727
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594728: Call_ApiReleaseGet_594719; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the details of an API release.
  ## 
  let valid = call_594728.validator(path, query, header, formData, body)
  let scheme = call_594728.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594728.url(scheme.get, call_594728.host, call_594728.base,
                         call_594728.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594728, url, valid)

proc call*(call_594729: Call_ApiReleaseGet_594719; resourceGroupName: string;
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
  var path_594730 = newJObject()
  var query_594731 = newJObject()
  add(path_594730, "resourceGroupName", newJString(resourceGroupName))
  add(query_594731, "api-version", newJString(apiVersion))
  add(path_594730, "apiId", newJString(apiId))
  add(path_594730, "subscriptionId", newJString(subscriptionId))
  add(path_594730, "releaseId", newJString(releaseId))
  add(path_594730, "serviceName", newJString(serviceName))
  result = call_594729.call(path_594730, query_594731, nil, nil, nil)

var apiReleaseGet* = Call_ApiReleaseGet_594719(name: "apiReleaseGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/releases/{releaseId}",
    validator: validate_ApiReleaseGet_594720, base: "", url: url_ApiReleaseGet_594721,
    schemes: {Scheme.Https})
type
  Call_ApiReleaseUpdate_594774 = ref object of OpenApiRestCall_593438
proc url_ApiReleaseUpdate_594776(protocol: Scheme; host: string; base: string;
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

proc validate_ApiReleaseUpdate_594775(path: JsonNode; query: JsonNode;
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
  var valid_594777 = path.getOrDefault("resourceGroupName")
  valid_594777 = validateParameter(valid_594777, JString, required = true,
                                 default = nil)
  if valid_594777 != nil:
    section.add "resourceGroupName", valid_594777
  var valid_594778 = path.getOrDefault("apiId")
  valid_594778 = validateParameter(valid_594778, JString, required = true,
                                 default = nil)
  if valid_594778 != nil:
    section.add "apiId", valid_594778
  var valid_594779 = path.getOrDefault("subscriptionId")
  valid_594779 = validateParameter(valid_594779, JString, required = true,
                                 default = nil)
  if valid_594779 != nil:
    section.add "subscriptionId", valid_594779
  var valid_594780 = path.getOrDefault("releaseId")
  valid_594780 = validateParameter(valid_594780, JString, required = true,
                                 default = nil)
  if valid_594780 != nil:
    section.add "releaseId", valid_594780
  var valid_594781 = path.getOrDefault("serviceName")
  valid_594781 = validateParameter(valid_594781, JString, required = true,
                                 default = nil)
  if valid_594781 != nil:
    section.add "serviceName", valid_594781
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594782 = query.getOrDefault("api-version")
  valid_594782 = validateParameter(valid_594782, JString, required = true,
                                 default = nil)
  if valid_594782 != nil:
    section.add "api-version", valid_594782
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594783 = header.getOrDefault("If-Match")
  valid_594783 = validateParameter(valid_594783, JString, required = true,
                                 default = nil)
  if valid_594783 != nil:
    section.add "If-Match", valid_594783
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

proc call*(call_594785: Call_ApiReleaseUpdate_594774; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the release of the API specified by its identifier.
  ## 
  let valid = call_594785.validator(path, query, header, formData, body)
  let scheme = call_594785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594785.url(scheme.get, call_594785.host, call_594785.base,
                         call_594785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594785, url, valid)

proc call*(call_594786: Call_ApiReleaseUpdate_594774; resourceGroupName: string;
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
  var path_594787 = newJObject()
  var query_594788 = newJObject()
  var body_594789 = newJObject()
  add(path_594787, "resourceGroupName", newJString(resourceGroupName))
  add(query_594788, "api-version", newJString(apiVersion))
  add(path_594787, "apiId", newJString(apiId))
  add(path_594787, "subscriptionId", newJString(subscriptionId))
  add(path_594787, "releaseId", newJString(releaseId))
  if parameters != nil:
    body_594789 = parameters
  add(path_594787, "serviceName", newJString(serviceName))
  result = call_594786.call(path_594787, query_594788, nil, nil, body_594789)

var apiReleaseUpdate* = Call_ApiReleaseUpdate_594774(name: "apiReleaseUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/releases/{releaseId}",
    validator: validate_ApiReleaseUpdate_594775, base: "",
    url: url_ApiReleaseUpdate_594776, schemes: {Scheme.Https})
type
  Call_ApiReleaseDelete_594747 = ref object of OpenApiRestCall_593438
proc url_ApiReleaseDelete_594749(protocol: Scheme; host: string; base: string;
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

proc validate_ApiReleaseDelete_594748(path: JsonNode; query: JsonNode;
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
  var valid_594750 = path.getOrDefault("resourceGroupName")
  valid_594750 = validateParameter(valid_594750, JString, required = true,
                                 default = nil)
  if valid_594750 != nil:
    section.add "resourceGroupName", valid_594750
  var valid_594751 = path.getOrDefault("apiId")
  valid_594751 = validateParameter(valid_594751, JString, required = true,
                                 default = nil)
  if valid_594751 != nil:
    section.add "apiId", valid_594751
  var valid_594752 = path.getOrDefault("subscriptionId")
  valid_594752 = validateParameter(valid_594752, JString, required = true,
                                 default = nil)
  if valid_594752 != nil:
    section.add "subscriptionId", valid_594752
  var valid_594753 = path.getOrDefault("releaseId")
  valid_594753 = validateParameter(valid_594753, JString, required = true,
                                 default = nil)
  if valid_594753 != nil:
    section.add "releaseId", valid_594753
  var valid_594754 = path.getOrDefault("serviceName")
  valid_594754 = validateParameter(valid_594754, JString, required = true,
                                 default = nil)
  if valid_594754 != nil:
    section.add "serviceName", valid_594754
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594755 = query.getOrDefault("api-version")
  valid_594755 = validateParameter(valid_594755, JString, required = true,
                                 default = nil)
  if valid_594755 != nil:
    section.add "api-version", valid_594755
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594756 = header.getOrDefault("If-Match")
  valid_594756 = validateParameter(valid_594756, JString, required = true,
                                 default = nil)
  if valid_594756 != nil:
    section.add "If-Match", valid_594756
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594757: Call_ApiReleaseDelete_594747; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified release in the API.
  ## 
  let valid = call_594757.validator(path, query, header, formData, body)
  let scheme = call_594757.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594757.url(scheme.get, call_594757.host, call_594757.base,
                         call_594757.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594757, url, valid)

proc call*(call_594758: Call_ApiReleaseDelete_594747; resourceGroupName: string;
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
  var path_594759 = newJObject()
  var query_594760 = newJObject()
  add(path_594759, "resourceGroupName", newJString(resourceGroupName))
  add(query_594760, "api-version", newJString(apiVersion))
  add(path_594759, "apiId", newJString(apiId))
  add(path_594759, "subscriptionId", newJString(subscriptionId))
  add(path_594759, "releaseId", newJString(releaseId))
  add(path_594759, "serviceName", newJString(serviceName))
  result = call_594758.call(path_594759, query_594760, nil, nil, nil)

var apiReleaseDelete* = Call_ApiReleaseDelete_594747(name: "apiReleaseDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/releases/{releaseId}",
    validator: validate_ApiReleaseDelete_594748, base: "",
    url: url_ApiReleaseDelete_594749, schemes: {Scheme.Https})
type
  Call_ApiRevisionsList_594790 = ref object of OpenApiRestCall_593438
proc url_ApiRevisionsList_594792(protocol: Scheme; host: string; base: string;
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

proc validate_ApiRevisionsList_594791(path: JsonNode; query: JsonNode;
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
  var valid_594793 = path.getOrDefault("resourceGroupName")
  valid_594793 = validateParameter(valid_594793, JString, required = true,
                                 default = nil)
  if valid_594793 != nil:
    section.add "resourceGroupName", valid_594793
  var valid_594794 = path.getOrDefault("apiId")
  valid_594794 = validateParameter(valid_594794, JString, required = true,
                                 default = nil)
  if valid_594794 != nil:
    section.add "apiId", valid_594794
  var valid_594795 = path.getOrDefault("subscriptionId")
  valid_594795 = validateParameter(valid_594795, JString, required = true,
                                 default = nil)
  if valid_594795 != nil:
    section.add "subscriptionId", valid_594795
  var valid_594796 = path.getOrDefault("serviceName")
  valid_594796 = validateParameter(valid_594796, JString, required = true,
                                 default = nil)
  if valid_594796 != nil:
    section.add "serviceName", valid_594796
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
  var valid_594797 = query.getOrDefault("api-version")
  valid_594797 = validateParameter(valid_594797, JString, required = true,
                                 default = nil)
  if valid_594797 != nil:
    section.add "api-version", valid_594797
  var valid_594798 = query.getOrDefault("$top")
  valid_594798 = validateParameter(valid_594798, JInt, required = false, default = nil)
  if valid_594798 != nil:
    section.add "$top", valid_594798
  var valid_594799 = query.getOrDefault("$skip")
  valid_594799 = validateParameter(valid_594799, JInt, required = false, default = nil)
  if valid_594799 != nil:
    section.add "$skip", valid_594799
  var valid_594800 = query.getOrDefault("$filter")
  valid_594800 = validateParameter(valid_594800, JString, required = false,
                                 default = nil)
  if valid_594800 != nil:
    section.add "$filter", valid_594800
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594801: Call_ApiRevisionsList_594790; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all revisions of an API.
  ## 
  let valid = call_594801.validator(path, query, header, formData, body)
  let scheme = call_594801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594801.url(scheme.get, call_594801.host, call_594801.base,
                         call_594801.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594801, url, valid)

proc call*(call_594802: Call_ApiRevisionsList_594790; resourceGroupName: string;
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
  var path_594803 = newJObject()
  var query_594804 = newJObject()
  add(path_594803, "resourceGroupName", newJString(resourceGroupName))
  add(query_594804, "api-version", newJString(apiVersion))
  add(path_594803, "apiId", newJString(apiId))
  add(path_594803, "subscriptionId", newJString(subscriptionId))
  add(query_594804, "$top", newJInt(Top))
  add(query_594804, "$skip", newJInt(Skip))
  add(path_594803, "serviceName", newJString(serviceName))
  add(query_594804, "$filter", newJString(Filter))
  result = call_594802.call(path_594803, query_594804, nil, nil, nil)

var apiRevisionsList* = Call_ApiRevisionsList_594790(name: "apiRevisionsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/revisions",
    validator: validate_ApiRevisionsList_594791, base: "",
    url: url_ApiRevisionsList_594792, schemes: {Scheme.Https})
type
  Call_ApiSchemaListByApi_594805 = ref object of OpenApiRestCall_593438
proc url_ApiSchemaListByApi_594807(protocol: Scheme; host: string; base: string;
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

proc validate_ApiSchemaListByApi_594806(path: JsonNode; query: JsonNode;
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
  var valid_594808 = path.getOrDefault("resourceGroupName")
  valid_594808 = validateParameter(valid_594808, JString, required = true,
                                 default = nil)
  if valid_594808 != nil:
    section.add "resourceGroupName", valid_594808
  var valid_594809 = path.getOrDefault("apiId")
  valid_594809 = validateParameter(valid_594809, JString, required = true,
                                 default = nil)
  if valid_594809 != nil:
    section.add "apiId", valid_594809
  var valid_594810 = path.getOrDefault("subscriptionId")
  valid_594810 = validateParameter(valid_594810, JString, required = true,
                                 default = nil)
  if valid_594810 != nil:
    section.add "subscriptionId", valid_594810
  var valid_594811 = path.getOrDefault("serviceName")
  valid_594811 = validateParameter(valid_594811, JString, required = true,
                                 default = nil)
  if valid_594811 != nil:
    section.add "serviceName", valid_594811
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594812 = query.getOrDefault("api-version")
  valid_594812 = validateParameter(valid_594812, JString, required = true,
                                 default = nil)
  if valid_594812 != nil:
    section.add "api-version", valid_594812
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594813: Call_ApiSchemaListByApi_594805; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the schema configuration at the API level.
  ## 
  let valid = call_594813.validator(path, query, header, formData, body)
  let scheme = call_594813.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594813.url(scheme.get, call_594813.host, call_594813.base,
                         call_594813.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594813, url, valid)

proc call*(call_594814: Call_ApiSchemaListByApi_594805; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          serviceName: string): Recallable =
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
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_594815 = newJObject()
  var query_594816 = newJObject()
  add(path_594815, "resourceGroupName", newJString(resourceGroupName))
  add(query_594816, "api-version", newJString(apiVersion))
  add(path_594815, "apiId", newJString(apiId))
  add(path_594815, "subscriptionId", newJString(subscriptionId))
  add(path_594815, "serviceName", newJString(serviceName))
  result = call_594814.call(path_594815, query_594816, nil, nil, nil)

var apiSchemaListByApi* = Call_ApiSchemaListByApi_594805(
    name: "apiSchemaListByApi", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/schemas",
    validator: validate_ApiSchemaListByApi_594806, base: "",
    url: url_ApiSchemaListByApi_594807, schemes: {Scheme.Https})
type
  Call_ApiSchemaCreateOrUpdate_594830 = ref object of OpenApiRestCall_593438
proc url_ApiSchemaCreateOrUpdate_594832(protocol: Scheme; host: string; base: string;
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

proc validate_ApiSchemaCreateOrUpdate_594831(path: JsonNode; query: JsonNode;
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
  var valid_594833 = path.getOrDefault("resourceGroupName")
  valid_594833 = validateParameter(valid_594833, JString, required = true,
                                 default = nil)
  if valid_594833 != nil:
    section.add "resourceGroupName", valid_594833
  var valid_594834 = path.getOrDefault("apiId")
  valid_594834 = validateParameter(valid_594834, JString, required = true,
                                 default = nil)
  if valid_594834 != nil:
    section.add "apiId", valid_594834
  var valid_594835 = path.getOrDefault("subscriptionId")
  valid_594835 = validateParameter(valid_594835, JString, required = true,
                                 default = nil)
  if valid_594835 != nil:
    section.add "subscriptionId", valid_594835
  var valid_594836 = path.getOrDefault("schemaId")
  valid_594836 = validateParameter(valid_594836, JString, required = true,
                                 default = nil)
  if valid_594836 != nil:
    section.add "schemaId", valid_594836
  var valid_594837 = path.getOrDefault("serviceName")
  valid_594837 = validateParameter(valid_594837, JString, required = true,
                                 default = nil)
  if valid_594837 != nil:
    section.add "serviceName", valid_594837
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594838 = query.getOrDefault("api-version")
  valid_594838 = validateParameter(valid_594838, JString, required = true,
                                 default = nil)
  if valid_594838 != nil:
    section.add "api-version", valid_594838
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_594839 = header.getOrDefault("If-Match")
  valid_594839 = validateParameter(valid_594839, JString, required = false,
                                 default = nil)
  if valid_594839 != nil:
    section.add "If-Match", valid_594839
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

proc call*(call_594841: Call_ApiSchemaCreateOrUpdate_594830; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates schema configuration for the API.
  ## 
  let valid = call_594841.validator(path, query, header, formData, body)
  let scheme = call_594841.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594841.url(scheme.get, call_594841.host, call_594841.base,
                         call_594841.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594841, url, valid)

proc call*(call_594842: Call_ApiSchemaCreateOrUpdate_594830;
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
  var path_594843 = newJObject()
  var query_594844 = newJObject()
  var body_594845 = newJObject()
  add(path_594843, "resourceGroupName", newJString(resourceGroupName))
  add(query_594844, "api-version", newJString(apiVersion))
  add(path_594843, "apiId", newJString(apiId))
  add(path_594843, "subscriptionId", newJString(subscriptionId))
  add(path_594843, "schemaId", newJString(schemaId))
  if parameters != nil:
    body_594845 = parameters
  add(path_594843, "serviceName", newJString(serviceName))
  result = call_594842.call(path_594843, query_594844, nil, nil, body_594845)

var apiSchemaCreateOrUpdate* = Call_ApiSchemaCreateOrUpdate_594830(
    name: "apiSchemaCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/schemas/{schemaId}",
    validator: validate_ApiSchemaCreateOrUpdate_594831, base: "",
    url: url_ApiSchemaCreateOrUpdate_594832, schemes: {Scheme.Https})
type
  Call_ApiSchemaGetEntityTag_594860 = ref object of OpenApiRestCall_593438
proc url_ApiSchemaGetEntityTag_594862(protocol: Scheme; host: string; base: string;
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

proc validate_ApiSchemaGetEntityTag_594861(path: JsonNode; query: JsonNode;
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
  var valid_594863 = path.getOrDefault("resourceGroupName")
  valid_594863 = validateParameter(valid_594863, JString, required = true,
                                 default = nil)
  if valid_594863 != nil:
    section.add "resourceGroupName", valid_594863
  var valid_594864 = path.getOrDefault("apiId")
  valid_594864 = validateParameter(valid_594864, JString, required = true,
                                 default = nil)
  if valid_594864 != nil:
    section.add "apiId", valid_594864
  var valid_594865 = path.getOrDefault("subscriptionId")
  valid_594865 = validateParameter(valid_594865, JString, required = true,
                                 default = nil)
  if valid_594865 != nil:
    section.add "subscriptionId", valid_594865
  var valid_594866 = path.getOrDefault("schemaId")
  valid_594866 = validateParameter(valid_594866, JString, required = true,
                                 default = nil)
  if valid_594866 != nil:
    section.add "schemaId", valid_594866
  var valid_594867 = path.getOrDefault("serviceName")
  valid_594867 = validateParameter(valid_594867, JString, required = true,
                                 default = nil)
  if valid_594867 != nil:
    section.add "serviceName", valid_594867
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594868 = query.getOrDefault("api-version")
  valid_594868 = validateParameter(valid_594868, JString, required = true,
                                 default = nil)
  if valid_594868 != nil:
    section.add "api-version", valid_594868
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594869: Call_ApiSchemaGetEntityTag_594860; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the schema specified by its identifier.
  ## 
  let valid = call_594869.validator(path, query, header, formData, body)
  let scheme = call_594869.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594869.url(scheme.get, call_594869.host, call_594869.base,
                         call_594869.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594869, url, valid)

proc call*(call_594870: Call_ApiSchemaGetEntityTag_594860;
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
  var path_594871 = newJObject()
  var query_594872 = newJObject()
  add(path_594871, "resourceGroupName", newJString(resourceGroupName))
  add(query_594872, "api-version", newJString(apiVersion))
  add(path_594871, "apiId", newJString(apiId))
  add(path_594871, "subscriptionId", newJString(subscriptionId))
  add(path_594871, "schemaId", newJString(schemaId))
  add(path_594871, "serviceName", newJString(serviceName))
  result = call_594870.call(path_594871, query_594872, nil, nil, nil)

var apiSchemaGetEntityTag* = Call_ApiSchemaGetEntityTag_594860(
    name: "apiSchemaGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/schemas/{schemaId}",
    validator: validate_ApiSchemaGetEntityTag_594861, base: "",
    url: url_ApiSchemaGetEntityTag_594862, schemes: {Scheme.Https})
type
  Call_ApiSchemaGet_594817 = ref object of OpenApiRestCall_593438
proc url_ApiSchemaGet_594819(protocol: Scheme; host: string; base: string;
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

proc validate_ApiSchemaGet_594818(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594820 = path.getOrDefault("resourceGroupName")
  valid_594820 = validateParameter(valid_594820, JString, required = true,
                                 default = nil)
  if valid_594820 != nil:
    section.add "resourceGroupName", valid_594820
  var valid_594821 = path.getOrDefault("apiId")
  valid_594821 = validateParameter(valid_594821, JString, required = true,
                                 default = nil)
  if valid_594821 != nil:
    section.add "apiId", valid_594821
  var valid_594822 = path.getOrDefault("subscriptionId")
  valid_594822 = validateParameter(valid_594822, JString, required = true,
                                 default = nil)
  if valid_594822 != nil:
    section.add "subscriptionId", valid_594822
  var valid_594823 = path.getOrDefault("schemaId")
  valid_594823 = validateParameter(valid_594823, JString, required = true,
                                 default = nil)
  if valid_594823 != nil:
    section.add "schemaId", valid_594823
  var valid_594824 = path.getOrDefault("serviceName")
  valid_594824 = validateParameter(valid_594824, JString, required = true,
                                 default = nil)
  if valid_594824 != nil:
    section.add "serviceName", valid_594824
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594825 = query.getOrDefault("api-version")
  valid_594825 = validateParameter(valid_594825, JString, required = true,
                                 default = nil)
  if valid_594825 != nil:
    section.add "api-version", valid_594825
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594826: Call_ApiSchemaGet_594817; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the schema configuration at the API level.
  ## 
  let valid = call_594826.validator(path, query, header, formData, body)
  let scheme = call_594826.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594826.url(scheme.get, call_594826.host, call_594826.base,
                         call_594826.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594826, url, valid)

proc call*(call_594827: Call_ApiSchemaGet_594817; resourceGroupName: string;
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
  var path_594828 = newJObject()
  var query_594829 = newJObject()
  add(path_594828, "resourceGroupName", newJString(resourceGroupName))
  add(query_594829, "api-version", newJString(apiVersion))
  add(path_594828, "apiId", newJString(apiId))
  add(path_594828, "subscriptionId", newJString(subscriptionId))
  add(path_594828, "schemaId", newJString(schemaId))
  add(path_594828, "serviceName", newJString(serviceName))
  result = call_594827.call(path_594828, query_594829, nil, nil, nil)

var apiSchemaGet* = Call_ApiSchemaGet_594817(name: "apiSchemaGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/schemas/{schemaId}",
    validator: validate_ApiSchemaGet_594818, base: "", url: url_ApiSchemaGet_594819,
    schemes: {Scheme.Https})
type
  Call_ApiSchemaDelete_594846 = ref object of OpenApiRestCall_593438
proc url_ApiSchemaDelete_594848(protocol: Scheme; host: string; base: string;
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

proc validate_ApiSchemaDelete_594847(path: JsonNode; query: JsonNode;
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
  var valid_594849 = path.getOrDefault("resourceGroupName")
  valid_594849 = validateParameter(valid_594849, JString, required = true,
                                 default = nil)
  if valid_594849 != nil:
    section.add "resourceGroupName", valid_594849
  var valid_594850 = path.getOrDefault("apiId")
  valid_594850 = validateParameter(valid_594850, JString, required = true,
                                 default = nil)
  if valid_594850 != nil:
    section.add "apiId", valid_594850
  var valid_594851 = path.getOrDefault("subscriptionId")
  valid_594851 = validateParameter(valid_594851, JString, required = true,
                                 default = nil)
  if valid_594851 != nil:
    section.add "subscriptionId", valid_594851
  var valid_594852 = path.getOrDefault("schemaId")
  valid_594852 = validateParameter(valid_594852, JString, required = true,
                                 default = nil)
  if valid_594852 != nil:
    section.add "schemaId", valid_594852
  var valid_594853 = path.getOrDefault("serviceName")
  valid_594853 = validateParameter(valid_594853, JString, required = true,
                                 default = nil)
  if valid_594853 != nil:
    section.add "serviceName", valid_594853
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594854 = query.getOrDefault("api-version")
  valid_594854 = validateParameter(valid_594854, JString, required = true,
                                 default = nil)
  if valid_594854 != nil:
    section.add "api-version", valid_594854
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594855 = header.getOrDefault("If-Match")
  valid_594855 = validateParameter(valid_594855, JString, required = true,
                                 default = nil)
  if valid_594855 != nil:
    section.add "If-Match", valid_594855
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594856: Call_ApiSchemaDelete_594846; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the schema configuration at the Api.
  ## 
  let valid = call_594856.validator(path, query, header, formData, body)
  let scheme = call_594856.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594856.url(scheme.get, call_594856.host, call_594856.base,
                         call_594856.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594856, url, valid)

proc call*(call_594857: Call_ApiSchemaDelete_594846; resourceGroupName: string;
          apiVersion: string; apiId: string; subscriptionId: string; schemaId: string;
          serviceName: string): Recallable =
  ## apiSchemaDelete
  ## Deletes the schema configuration at the Api.
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
  var path_594858 = newJObject()
  var query_594859 = newJObject()
  add(path_594858, "resourceGroupName", newJString(resourceGroupName))
  add(query_594859, "api-version", newJString(apiVersion))
  add(path_594858, "apiId", newJString(apiId))
  add(path_594858, "subscriptionId", newJString(subscriptionId))
  add(path_594858, "schemaId", newJString(schemaId))
  add(path_594858, "serviceName", newJString(serviceName))
  result = call_594857.call(path_594858, query_594859, nil, nil, nil)

var apiSchemaDelete* = Call_ApiSchemaDelete_594846(name: "apiSchemaDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/schemas/{schemaId}",
    validator: validate_ApiSchemaDelete_594847, base: "", url: url_ApiSchemaDelete_594848,
    schemes: {Scheme.Https})
type
  Call_ApiListByTags_594873 = ref object of OpenApiRestCall_593438
proc url_ApiListByTags_594875(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/apisByTags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApiListByTags_594874(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of apis associated with tags.
  ## 
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
  var valid_594876 = path.getOrDefault("resourceGroupName")
  valid_594876 = validateParameter(valid_594876, JString, required = true,
                                 default = nil)
  if valid_594876 != nil:
    section.add "resourceGroupName", valid_594876
  var valid_594877 = path.getOrDefault("subscriptionId")
  valid_594877 = validateParameter(valid_594877, JString, required = true,
                                 default = nil)
  if valid_594877 != nil:
    section.add "subscriptionId", valid_594877
  var valid_594878 = path.getOrDefault("serviceName")
  valid_594878 = validateParameter(valid_594878, JString, required = true,
                                 default = nil)
  if valid_594878 != nil:
    section.add "serviceName", valid_594878
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | aid         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | apiRevision | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | path        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | serviceUrl  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | isCurrent   | eq                     | substringof, contains, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594879 = query.getOrDefault("api-version")
  valid_594879 = validateParameter(valid_594879, JString, required = true,
                                 default = nil)
  if valid_594879 != nil:
    section.add "api-version", valid_594879
  var valid_594880 = query.getOrDefault("$top")
  valid_594880 = validateParameter(valid_594880, JInt, required = false, default = nil)
  if valid_594880 != nil:
    section.add "$top", valid_594880
  var valid_594881 = query.getOrDefault("$skip")
  valid_594881 = validateParameter(valid_594881, JInt, required = false, default = nil)
  if valid_594881 != nil:
    section.add "$skip", valid_594881
  var valid_594882 = query.getOrDefault("$filter")
  valid_594882 = validateParameter(valid_594882, JString, required = false,
                                 default = nil)
  if valid_594882 != nil:
    section.add "$filter", valid_594882
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594883: Call_ApiListByTags_594873; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of apis associated with tags.
  ## 
  let valid = call_594883.validator(path, query, header, formData, body)
  let scheme = call_594883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594883.url(scheme.get, call_594883.host, call_594883.base,
                         call_594883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594883, url, valid)

proc call*(call_594884: Call_ApiListByTags_594873; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## apiListByTags
  ## Lists a collection of apis associated with tags.
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
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | aid         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | apiRevision | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | path        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | serviceUrl  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | isCurrent   | eq                     | substringof, contains, startswith, endswith |
  var path_594885 = newJObject()
  var query_594886 = newJObject()
  add(path_594885, "resourceGroupName", newJString(resourceGroupName))
  add(query_594886, "api-version", newJString(apiVersion))
  add(path_594885, "subscriptionId", newJString(subscriptionId))
  add(query_594886, "$top", newJInt(Top))
  add(query_594886, "$skip", newJInt(Skip))
  add(path_594885, "serviceName", newJString(serviceName))
  add(query_594886, "$filter", newJString(Filter))
  result = call_594884.call(path_594885, query_594886, nil, nil, nil)

var apiListByTags* = Call_ApiListByTags_594873(name: "apiListByTags",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apisByTags",
    validator: validate_ApiListByTags_594874, base: "", url: url_ApiListByTags_594875,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
