
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563565 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563565](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563565): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement-apimapis"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ApiListByService_563787 = ref object of OpenApiRestCall_563565
proc url_ApiListByService_563789(protocol: Scheme; host: string; base: string;
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

proc validate_ApiListByService_563788(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists all APIs of the API Management service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-create-apis
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_563952 = path.getOrDefault("serviceName")
  valid_563952 = validateParameter(valid_563952, JString, required = true,
                                 default = nil)
  if valid_563952 != nil:
    section.add "serviceName", valid_563952
  var valid_563953 = path.getOrDefault("subscriptionId")
  valid_563953 = validateParameter(valid_563953, JString, required = true,
                                 default = nil)
  if valid_563953 != nil:
    section.add "subscriptionId", valid_563953
  var valid_563954 = path.getOrDefault("resourceGroupName")
  valid_563954 = validateParameter(valid_563954, JString, required = true,
                                 default = nil)
  if valid_563954 != nil:
    section.add "resourceGroupName", valid_563954
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Number of records to return.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   expandApiVersionSet: JBool
  ##                      : Include full ApiVersionSet resource in response
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | serviceUrl  | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | path        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  section = newJObject()
  var valid_563955 = query.getOrDefault("$top")
  valid_563955 = validateParameter(valid_563955, JInt, required = false, default = nil)
  if valid_563955 != nil:
    section.add "$top", valid_563955
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563956 = query.getOrDefault("api-version")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "api-version", valid_563956
  var valid_563957 = query.getOrDefault("$skip")
  valid_563957 = validateParameter(valid_563957, JInt, required = false, default = nil)
  if valid_563957 != nil:
    section.add "$skip", valid_563957
  var valid_563971 = query.getOrDefault("expandApiVersionSet")
  valid_563971 = validateParameter(valid_563971, JBool, required = false,
                                 default = newJBool(false))
  if valid_563971 != nil:
    section.add "expandApiVersionSet", valid_563971
  var valid_563972 = query.getOrDefault("$filter")
  valid_563972 = validateParameter(valid_563972, JString, required = false,
                                 default = nil)
  if valid_563972 != nil:
    section.add "$filter", valid_563972
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563999: Call_ApiListByService_563787; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all APIs of the API Management service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-create-apis
  let valid = call_563999.validator(path, query, header, formData, body)
  let scheme = call_563999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563999.url(scheme.get, call_563999.host, call_563999.base,
                         call_563999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563999, url, valid)

proc call*(call_564070: Call_ApiListByService_563787; serviceName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0; Skip: int = 0; expandApiVersionSet: bool = false;
          Filter: string = ""): Recallable =
  ## apiListByService
  ## Lists all APIs of the API Management service instance.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-create-apis
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Top: int
  ##      : Number of records to return.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   expandApiVersionSet: bool
  ##                      : Include full ApiVersionSet resource in response
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | serviceUrl  | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | path        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  var path_564071 = newJObject()
  var query_564073 = newJObject()
  add(path_564071, "serviceName", newJString(serviceName))
  add(query_564073, "$top", newJInt(Top))
  add(query_564073, "api-version", newJString(apiVersion))
  add(path_564071, "subscriptionId", newJString(subscriptionId))
  add(query_564073, "$skip", newJInt(Skip))
  add(path_564071, "resourceGroupName", newJString(resourceGroupName))
  add(query_564073, "expandApiVersionSet", newJBool(expandApiVersionSet))
  add(query_564073, "$filter", newJString(Filter))
  result = call_564070.call(path_564071, query_564073, nil, nil, nil)

var apiListByService* = Call_ApiListByService_563787(name: "apiListByService",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis",
    validator: validate_ApiListByService_563788, base: "",
    url: url_ApiListByService_563789, schemes: {Scheme.Https})
type
  Call_ApiCreateOrUpdate_564133 = ref object of OpenApiRestCall_563565
proc url_ApiCreateOrUpdate_564135(protocol: Scheme; host: string; base: string;
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

proc validate_ApiCreateOrUpdate_564134(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates new or updates existing specified API of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564153 = path.getOrDefault("serviceName")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "serviceName", valid_564153
  var valid_564154 = path.getOrDefault("apiId")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "apiId", valid_564154
  var valid_564155 = path.getOrDefault("subscriptionId")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "subscriptionId", valid_564155
  var valid_564156 = path.getOrDefault("resourceGroupName")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "resourceGroupName", valid_564156
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564157 = query.getOrDefault("api-version")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "api-version", valid_564157
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_564158 = header.getOrDefault("If-Match")
  valid_564158 = validateParameter(valid_564158, JString, required = false,
                                 default = nil)
  if valid_564158 != nil:
    section.add "If-Match", valid_564158
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

proc call*(call_564160: Call_ApiCreateOrUpdate_564133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates new or updates existing specified API of the API Management service instance.
  ## 
  let valid = call_564160.validator(path, query, header, formData, body)
  let scheme = call_564160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564160.url(scheme.get, call_564160.host, call_564160.base,
                         call_564160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564160, url, valid)

proc call*(call_564161: Call_ApiCreateOrUpdate_564133; serviceName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## apiCreateOrUpdate
  ## Creates new or updates existing specified API of the API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Create or update parameters.
  var path_564162 = newJObject()
  var query_564163 = newJObject()
  var body_564164 = newJObject()
  add(path_564162, "serviceName", newJString(serviceName))
  add(query_564163, "api-version", newJString(apiVersion))
  add(path_564162, "apiId", newJString(apiId))
  add(path_564162, "subscriptionId", newJString(subscriptionId))
  add(path_564162, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564164 = parameters
  result = call_564161.call(path_564162, query_564163, nil, nil, body_564164)

var apiCreateOrUpdate* = Call_ApiCreateOrUpdate_564133(name: "apiCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}",
    validator: validate_ApiCreateOrUpdate_564134, base: "",
    url: url_ApiCreateOrUpdate_564135, schemes: {Scheme.Https})
type
  Call_ApiGetEntityTag_564179 = ref object of OpenApiRestCall_563565
proc url_ApiGetEntityTag_564181(protocol: Scheme; host: string; base: string;
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

proc validate_ApiGetEntityTag_564180(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564182 = path.getOrDefault("serviceName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "serviceName", valid_564182
  var valid_564183 = path.getOrDefault("apiId")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "apiId", valid_564183
  var valid_564184 = path.getOrDefault("subscriptionId")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "subscriptionId", valid_564184
  var valid_564185 = path.getOrDefault("resourceGroupName")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "resourceGroupName", valid_564185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564186 = query.getOrDefault("api-version")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "api-version", valid_564186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564187: Call_ApiGetEntityTag_564179; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the API specified by its identifier.
  ## 
  let valid = call_564187.validator(path, query, header, formData, body)
  let scheme = call_564187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564187.url(scheme.get, call_564187.host, call_564187.base,
                         call_564187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564187, url, valid)

proc call*(call_564188: Call_ApiGetEntityTag_564179; serviceName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## apiGetEntityTag
  ## Gets the entity state (Etag) version of the API specified by its identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564189 = newJObject()
  var query_564190 = newJObject()
  add(path_564189, "serviceName", newJString(serviceName))
  add(query_564190, "api-version", newJString(apiVersion))
  add(path_564189, "apiId", newJString(apiId))
  add(path_564189, "subscriptionId", newJString(subscriptionId))
  add(path_564189, "resourceGroupName", newJString(resourceGroupName))
  result = call_564188.call(path_564189, query_564190, nil, nil, nil)

var apiGetEntityTag* = Call_ApiGetEntityTag_564179(name: "apiGetEntityTag",
    meth: HttpMethod.HttpHead, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}",
    validator: validate_ApiGetEntityTag_564180, base: "", url: url_ApiGetEntityTag_564181,
    schemes: {Scheme.Https})
type
  Call_ApiGet_564112 = ref object of OpenApiRestCall_563565
proc url_ApiGet_564114(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ApiGet_564113(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564124 = path.getOrDefault("serviceName")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "serviceName", valid_564124
  var valid_564125 = path.getOrDefault("apiId")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "apiId", valid_564125
  var valid_564126 = path.getOrDefault("subscriptionId")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "subscriptionId", valid_564126
  var valid_564127 = path.getOrDefault("resourceGroupName")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "resourceGroupName", valid_564127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564128 = query.getOrDefault("api-version")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "api-version", valid_564128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564129: Call_ApiGet_564112; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the API specified by its identifier.
  ## 
  let valid = call_564129.validator(path, query, header, formData, body)
  let scheme = call_564129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564129.url(scheme.get, call_564129.host, call_564129.base,
                         call_564129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564129, url, valid)

proc call*(call_564130: Call_ApiGet_564112; serviceName: string; apiVersion: string;
          apiId: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## apiGet
  ## Gets the details of the API specified by its identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564131 = newJObject()
  var query_564132 = newJObject()
  add(path_564131, "serviceName", newJString(serviceName))
  add(query_564132, "api-version", newJString(apiVersion))
  add(path_564131, "apiId", newJString(apiId))
  add(path_564131, "subscriptionId", newJString(subscriptionId))
  add(path_564131, "resourceGroupName", newJString(resourceGroupName))
  result = call_564130.call(path_564131, query_564132, nil, nil, nil)

var apiGet* = Call_ApiGet_564112(name: "apiGet", meth: HttpMethod.HttpGet,
                              host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}",
                              validator: validate_ApiGet_564113, base: "",
                              url: url_ApiGet_564114, schemes: {Scheme.Https})
type
  Call_ApiUpdate_564191 = ref object of OpenApiRestCall_563565
proc url_ApiUpdate_564193(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ApiUpdate_564192(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified API of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564194 = path.getOrDefault("serviceName")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "serviceName", valid_564194
  var valid_564195 = path.getOrDefault("apiId")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "apiId", valid_564195
  var valid_564196 = path.getOrDefault("subscriptionId")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "subscriptionId", valid_564196
  var valid_564197 = path.getOrDefault("resourceGroupName")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "resourceGroupName", valid_564197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564198 = query.getOrDefault("api-version")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "api-version", valid_564198
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564199 = header.getOrDefault("If-Match")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "If-Match", valid_564199
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

proc call*(call_564201: Call_ApiUpdate_564191; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified API of the API Management service instance.
  ## 
  let valid = call_564201.validator(path, query, header, formData, body)
  let scheme = call_564201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564201.url(scheme.get, call_564201.host, call_564201.base,
                         call_564201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564201, url, valid)

proc call*(call_564202: Call_ApiUpdate_564191; serviceName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## apiUpdate
  ## Updates the specified API of the API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : API Update Contract parameters.
  var path_564203 = newJObject()
  var query_564204 = newJObject()
  var body_564205 = newJObject()
  add(path_564203, "serviceName", newJString(serviceName))
  add(query_564204, "api-version", newJString(apiVersion))
  add(path_564203, "apiId", newJString(apiId))
  add(path_564203, "subscriptionId", newJString(subscriptionId))
  add(path_564203, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564205 = parameters
  result = call_564202.call(path_564203, query_564204, nil, nil, body_564205)

var apiUpdate* = Call_ApiUpdate_564191(name: "apiUpdate", meth: HttpMethod.HttpPatch,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}",
                                    validator: validate_ApiUpdate_564192,
                                    base: "", url: url_ApiUpdate_564193,
                                    schemes: {Scheme.Https})
type
  Call_ApiDelete_564165 = ref object of OpenApiRestCall_563565
proc url_ApiDelete_564167(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ApiDelete_564166(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified API of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564168 = path.getOrDefault("serviceName")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "serviceName", valid_564168
  var valid_564169 = path.getOrDefault("apiId")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "apiId", valid_564169
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
  ##              : Version of the API to be used with the client request.
  ##   deleteRevisions: JBool
  ##                  : Delete all revisions of the Api.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564172 = query.getOrDefault("api-version")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "api-version", valid_564172
  var valid_564173 = query.getOrDefault("deleteRevisions")
  valid_564173 = validateParameter(valid_564173, JBool, required = false, default = nil)
  if valid_564173 != nil:
    section.add "deleteRevisions", valid_564173
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564174 = header.getOrDefault("If-Match")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "If-Match", valid_564174
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564175: Call_ApiDelete_564165; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified API of the API Management service instance.
  ## 
  let valid = call_564175.validator(path, query, header, formData, body)
  let scheme = call_564175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564175.url(scheme.get, call_564175.host, call_564175.base,
                         call_564175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564175, url, valid)

proc call*(call_564176: Call_ApiDelete_564165; serviceName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          resourceGroupName: string; deleteRevisions: bool = false): Recallable =
  ## apiDelete
  ## Deletes the specified API of the API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   deleteRevisions: bool
  ##                  : Delete all revisions of the Api.
  var path_564177 = newJObject()
  var query_564178 = newJObject()
  add(path_564177, "serviceName", newJString(serviceName))
  add(query_564178, "api-version", newJString(apiVersion))
  add(path_564177, "apiId", newJString(apiId))
  add(path_564177, "subscriptionId", newJString(subscriptionId))
  add(path_564177, "resourceGroupName", newJString(resourceGroupName))
  add(query_564178, "deleteRevisions", newJBool(deleteRevisions))
  result = call_564176.call(path_564177, query_564178, nil, nil, nil)

var apiDelete* = Call_ApiDelete_564165(name: "apiDelete",
                                    meth: HttpMethod.HttpDelete,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}",
                                    validator: validate_ApiDelete_564166,
                                    base: "", url: url_ApiDelete_564167,
                                    schemes: {Scheme.Https})
type
  Call_ApiDiagnosticListByService_564206 = ref object of OpenApiRestCall_563565
proc url_ApiDiagnosticListByService_564208(protocol: Scheme; host: string;
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

proc validate_ApiDiagnosticListByService_564207(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all diagnostics of an API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564209 = path.getOrDefault("serviceName")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "serviceName", valid_564209
  var valid_564210 = path.getOrDefault("apiId")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "apiId", valid_564210
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
  var valid_564213 = query.getOrDefault("api-version")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "api-version", valid_564213
  var valid_564214 = query.getOrDefault("$top")
  valid_564214 = validateParameter(valid_564214, JInt, required = false, default = nil)
  if valid_564214 != nil:
    section.add "$top", valid_564214
  var valid_564215 = query.getOrDefault("$skip")
  valid_564215 = validateParameter(valid_564215, JInt, required = false, default = nil)
  if valid_564215 != nil:
    section.add "$skip", valid_564215
  var valid_564216 = query.getOrDefault("$filter")
  valid_564216 = validateParameter(valid_564216, JString, required = false,
                                 default = nil)
  if valid_564216 != nil:
    section.add "$filter", valid_564216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564217: Call_ApiDiagnosticListByService_564206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all diagnostics of an API.
  ## 
  let valid = call_564217.validator(path, query, header, formData, body)
  let scheme = call_564217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564217.url(scheme.get, call_564217.host, call_564217.base,
                         call_564217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564217, url, valid)

proc call*(call_564218: Call_ApiDiagnosticListByService_564206;
          serviceName: string; apiVersion: string; apiId: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          Skip: int = 0; Filter: string = ""): Recallable =
  ## apiDiagnosticListByService
  ## Lists all diagnostics of an API.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  var path_564219 = newJObject()
  var query_564220 = newJObject()
  add(path_564219, "serviceName", newJString(serviceName))
  add(query_564220, "api-version", newJString(apiVersion))
  add(query_564220, "$top", newJInt(Top))
  add(path_564219, "apiId", newJString(apiId))
  add(path_564219, "subscriptionId", newJString(subscriptionId))
  add(query_564220, "$skip", newJInt(Skip))
  add(path_564219, "resourceGroupName", newJString(resourceGroupName))
  add(query_564220, "$filter", newJString(Filter))
  result = call_564218.call(path_564219, query_564220, nil, nil, nil)

var apiDiagnosticListByService* = Call_ApiDiagnosticListByService_564206(
    name: "apiDiagnosticListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics",
    validator: validate_ApiDiagnosticListByService_564207, base: "",
    url: url_ApiDiagnosticListByService_564208, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticCreateOrUpdate_564234 = ref object of OpenApiRestCall_563565
proc url_ApiDiagnosticCreateOrUpdate_564236(protocol: Scheme; host: string;
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

proc validate_ApiDiagnosticCreateOrUpdate_564235(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Diagnostic for an API or updates an existing one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564237 = path.getOrDefault("serviceName")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "serviceName", valid_564237
  var valid_564238 = path.getOrDefault("apiId")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "apiId", valid_564238
  var valid_564239 = path.getOrDefault("subscriptionId")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "subscriptionId", valid_564239
  var valid_564240 = path.getOrDefault("diagnosticId")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "diagnosticId", valid_564240
  var valid_564241 = path.getOrDefault("resourceGroupName")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "resourceGroupName", valid_564241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564242 = query.getOrDefault("api-version")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "api-version", valid_564242
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_564243 = header.getOrDefault("If-Match")
  valid_564243 = validateParameter(valid_564243, JString, required = false,
                                 default = nil)
  if valid_564243 != nil:
    section.add "If-Match", valid_564243
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

proc call*(call_564245: Call_ApiDiagnosticCreateOrUpdate_564234; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Diagnostic for an API or updates an existing one.
  ## 
  let valid = call_564245.validator(path, query, header, formData, body)
  let scheme = call_564245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564245.url(scheme.get, call_564245.host, call_564245.base,
                         call_564245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564245, url, valid)

proc call*(call_564246: Call_ApiDiagnosticCreateOrUpdate_564234;
          serviceName: string; apiVersion: string; apiId: string;
          subscriptionId: string; diagnosticId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## apiDiagnosticCreateOrUpdate
  ## Creates a new Diagnostic for an API or updates an existing one.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: string (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  var path_564247 = newJObject()
  var query_564248 = newJObject()
  var body_564249 = newJObject()
  add(path_564247, "serviceName", newJString(serviceName))
  add(query_564248, "api-version", newJString(apiVersion))
  add(path_564247, "apiId", newJString(apiId))
  add(path_564247, "subscriptionId", newJString(subscriptionId))
  add(path_564247, "diagnosticId", newJString(diagnosticId))
  add(path_564247, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564249 = parameters
  result = call_564246.call(path_564247, query_564248, nil, nil, body_564249)

var apiDiagnosticCreateOrUpdate* = Call_ApiDiagnosticCreateOrUpdate_564234(
    name: "apiDiagnosticCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}",
    validator: validate_ApiDiagnosticCreateOrUpdate_564235, base: "",
    url: url_ApiDiagnosticCreateOrUpdate_564236, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticGetEntityTag_564264 = ref object of OpenApiRestCall_563565
proc url_ApiDiagnosticGetEntityTag_564266(protocol: Scheme; host: string;
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

proc validate_ApiDiagnosticGetEntityTag_564265(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the Diagnostic for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564267 = path.getOrDefault("serviceName")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "serviceName", valid_564267
  var valid_564268 = path.getOrDefault("apiId")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "apiId", valid_564268
  var valid_564269 = path.getOrDefault("subscriptionId")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "subscriptionId", valid_564269
  var valid_564270 = path.getOrDefault("diagnosticId")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "diagnosticId", valid_564270
  var valid_564271 = path.getOrDefault("resourceGroupName")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "resourceGroupName", valid_564271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564272 = query.getOrDefault("api-version")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "api-version", valid_564272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564273: Call_ApiDiagnosticGetEntityTag_564264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the Diagnostic for an API specified by its identifier.
  ## 
  let valid = call_564273.validator(path, query, header, formData, body)
  let scheme = call_564273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564273.url(scheme.get, call_564273.host, call_564273.base,
                         call_564273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564273, url, valid)

proc call*(call_564274: Call_ApiDiagnosticGetEntityTag_564264; serviceName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          diagnosticId: string; resourceGroupName: string): Recallable =
  ## apiDiagnosticGetEntityTag
  ## Gets the entity state (Etag) version of the Diagnostic for an API specified by its identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: string (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564275 = newJObject()
  var query_564276 = newJObject()
  add(path_564275, "serviceName", newJString(serviceName))
  add(query_564276, "api-version", newJString(apiVersion))
  add(path_564275, "apiId", newJString(apiId))
  add(path_564275, "subscriptionId", newJString(subscriptionId))
  add(path_564275, "diagnosticId", newJString(diagnosticId))
  add(path_564275, "resourceGroupName", newJString(resourceGroupName))
  result = call_564274.call(path_564275, query_564276, nil, nil, nil)

var apiDiagnosticGetEntityTag* = Call_ApiDiagnosticGetEntityTag_564264(
    name: "apiDiagnosticGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}",
    validator: validate_ApiDiagnosticGetEntityTag_564265, base: "",
    url: url_ApiDiagnosticGetEntityTag_564266, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticGet_564221 = ref object of OpenApiRestCall_563565
proc url_ApiDiagnosticGet_564223(protocol: Scheme; host: string; base: string;
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

proc validate_ApiDiagnosticGet_564222(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the details of the Diagnostic for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564224 = path.getOrDefault("serviceName")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "serviceName", valid_564224
  var valid_564225 = path.getOrDefault("apiId")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "apiId", valid_564225
  var valid_564226 = path.getOrDefault("subscriptionId")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "subscriptionId", valid_564226
  var valid_564227 = path.getOrDefault("diagnosticId")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "diagnosticId", valid_564227
  var valid_564228 = path.getOrDefault("resourceGroupName")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "resourceGroupName", valid_564228
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564229 = query.getOrDefault("api-version")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "api-version", valid_564229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564230: Call_ApiDiagnosticGet_564221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the Diagnostic for an API specified by its identifier.
  ## 
  let valid = call_564230.validator(path, query, header, formData, body)
  let scheme = call_564230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564230.url(scheme.get, call_564230.host, call_564230.base,
                         call_564230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564230, url, valid)

proc call*(call_564231: Call_ApiDiagnosticGet_564221; serviceName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          diagnosticId: string; resourceGroupName: string): Recallable =
  ## apiDiagnosticGet
  ## Gets the details of the Diagnostic for an API specified by its identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: string (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564232 = newJObject()
  var query_564233 = newJObject()
  add(path_564232, "serviceName", newJString(serviceName))
  add(query_564233, "api-version", newJString(apiVersion))
  add(path_564232, "apiId", newJString(apiId))
  add(path_564232, "subscriptionId", newJString(subscriptionId))
  add(path_564232, "diagnosticId", newJString(diagnosticId))
  add(path_564232, "resourceGroupName", newJString(resourceGroupName))
  result = call_564231.call(path_564232, query_564233, nil, nil, nil)

var apiDiagnosticGet* = Call_ApiDiagnosticGet_564221(name: "apiDiagnosticGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}",
    validator: validate_ApiDiagnosticGet_564222, base: "",
    url: url_ApiDiagnosticGet_564223, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticUpdate_564277 = ref object of OpenApiRestCall_563565
proc url_ApiDiagnosticUpdate_564279(protocol: Scheme; host: string; base: string;
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

proc validate_ApiDiagnosticUpdate_564278(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates the details of the Diagnostic for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564280 = path.getOrDefault("serviceName")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "serviceName", valid_564280
  var valid_564281 = path.getOrDefault("apiId")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "apiId", valid_564281
  var valid_564282 = path.getOrDefault("subscriptionId")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "subscriptionId", valid_564282
  var valid_564283 = path.getOrDefault("diagnosticId")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "diagnosticId", valid_564283
  var valid_564284 = path.getOrDefault("resourceGroupName")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "resourceGroupName", valid_564284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564285 = query.getOrDefault("api-version")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "api-version", valid_564285
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564286 = header.getOrDefault("If-Match")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "If-Match", valid_564286
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

proc call*(call_564288: Call_ApiDiagnosticUpdate_564277; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the Diagnostic for an API specified by its identifier.
  ## 
  let valid = call_564288.validator(path, query, header, formData, body)
  let scheme = call_564288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564288.url(scheme.get, call_564288.host, call_564288.base,
                         call_564288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564288, url, valid)

proc call*(call_564289: Call_ApiDiagnosticUpdate_564277; serviceName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          diagnosticId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## apiDiagnosticUpdate
  ## Updates the details of the Diagnostic for an API specified by its identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: string (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Diagnostic Update parameters.
  var path_564290 = newJObject()
  var query_564291 = newJObject()
  var body_564292 = newJObject()
  add(path_564290, "serviceName", newJString(serviceName))
  add(query_564291, "api-version", newJString(apiVersion))
  add(path_564290, "apiId", newJString(apiId))
  add(path_564290, "subscriptionId", newJString(subscriptionId))
  add(path_564290, "diagnosticId", newJString(diagnosticId))
  add(path_564290, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564292 = parameters
  result = call_564289.call(path_564290, query_564291, nil, nil, body_564292)

var apiDiagnosticUpdate* = Call_ApiDiagnosticUpdate_564277(
    name: "apiDiagnosticUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}",
    validator: validate_ApiDiagnosticUpdate_564278, base: "",
    url: url_ApiDiagnosticUpdate_564279, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticDelete_564250 = ref object of OpenApiRestCall_563565
proc url_ApiDiagnosticDelete_564252(protocol: Scheme; host: string; base: string;
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

proc validate_ApiDiagnosticDelete_564251(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes the specified Diagnostic from an API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564253 = path.getOrDefault("serviceName")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "serviceName", valid_564253
  var valid_564254 = path.getOrDefault("apiId")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "apiId", valid_564254
  var valid_564255 = path.getOrDefault("subscriptionId")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "subscriptionId", valid_564255
  var valid_564256 = path.getOrDefault("diagnosticId")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "diagnosticId", valid_564256
  var valid_564257 = path.getOrDefault("resourceGroupName")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "resourceGroupName", valid_564257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564258 = query.getOrDefault("api-version")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "api-version", valid_564258
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564259 = header.getOrDefault("If-Match")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "If-Match", valid_564259
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564260: Call_ApiDiagnosticDelete_564250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Diagnostic from an API.
  ## 
  let valid = call_564260.validator(path, query, header, formData, body)
  let scheme = call_564260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564260.url(scheme.get, call_564260.host, call_564260.base,
                         call_564260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564260, url, valid)

proc call*(call_564261: Call_ApiDiagnosticDelete_564250; serviceName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          diagnosticId: string; resourceGroupName: string): Recallable =
  ## apiDiagnosticDelete
  ## Deletes the specified Diagnostic from an API.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: string (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564262 = newJObject()
  var query_564263 = newJObject()
  add(path_564262, "serviceName", newJString(serviceName))
  add(query_564263, "api-version", newJString(apiVersion))
  add(path_564262, "apiId", newJString(apiId))
  add(path_564262, "subscriptionId", newJString(subscriptionId))
  add(path_564262, "diagnosticId", newJString(diagnosticId))
  add(path_564262, "resourceGroupName", newJString(resourceGroupName))
  result = call_564261.call(path_564262, query_564263, nil, nil, nil)

var apiDiagnosticDelete* = Call_ApiDiagnosticDelete_564250(
    name: "apiDiagnosticDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}",
    validator: validate_ApiDiagnosticDelete_564251, base: "",
    url: url_ApiDiagnosticDelete_564252, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticLoggerListByService_564293 = ref object of OpenApiRestCall_563565
proc url_ApiDiagnosticLoggerListByService_564295(protocol: Scheme; host: string;
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

proc validate_ApiDiagnosticLoggerListByService_564294(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all loggers associated with the specified Diagnostic of an API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564296 = path.getOrDefault("serviceName")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "serviceName", valid_564296
  var valid_564297 = path.getOrDefault("apiId")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "apiId", valid_564297
  var valid_564298 = path.getOrDefault("subscriptionId")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "subscriptionId", valid_564298
  var valid_564299 = path.getOrDefault("diagnosticId")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "diagnosticId", valid_564299
  var valid_564300 = path.getOrDefault("resourceGroupName")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "resourceGroupName", valid_564300
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
  var valid_564301 = query.getOrDefault("api-version")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "api-version", valid_564301
  var valid_564302 = query.getOrDefault("$top")
  valid_564302 = validateParameter(valid_564302, JInt, required = false, default = nil)
  if valid_564302 != nil:
    section.add "$top", valid_564302
  var valid_564303 = query.getOrDefault("$skip")
  valid_564303 = validateParameter(valid_564303, JInt, required = false, default = nil)
  if valid_564303 != nil:
    section.add "$skip", valid_564303
  var valid_564304 = query.getOrDefault("$filter")
  valid_564304 = validateParameter(valid_564304, JString, required = false,
                                 default = nil)
  if valid_564304 != nil:
    section.add "$filter", valid_564304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564305: Call_ApiDiagnosticLoggerListByService_564293;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all loggers associated with the specified Diagnostic of an API.
  ## 
  let valid = call_564305.validator(path, query, header, formData, body)
  let scheme = call_564305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564305.url(scheme.get, call_564305.host, call_564305.base,
                         call_564305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564305, url, valid)

proc call*(call_564306: Call_ApiDiagnosticLoggerListByService_564293;
          serviceName: string; apiVersion: string; apiId: string;
          subscriptionId: string; diagnosticId: string; resourceGroupName: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## apiDiagnosticLoggerListByService
  ## Lists all loggers associated with the specified Diagnostic of an API.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   diagnosticId: string (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | type        | eq                     |                                   |
  var path_564307 = newJObject()
  var query_564308 = newJObject()
  add(path_564307, "serviceName", newJString(serviceName))
  add(query_564308, "api-version", newJString(apiVersion))
  add(query_564308, "$top", newJInt(Top))
  add(path_564307, "apiId", newJString(apiId))
  add(path_564307, "subscriptionId", newJString(subscriptionId))
  add(path_564307, "diagnosticId", newJString(diagnosticId))
  add(query_564308, "$skip", newJInt(Skip))
  add(path_564307, "resourceGroupName", newJString(resourceGroupName))
  add(query_564308, "$filter", newJString(Filter))
  result = call_564306.call(path_564307, query_564308, nil, nil, nil)

var apiDiagnosticLoggerListByService* = Call_ApiDiagnosticLoggerListByService_564293(
    name: "apiDiagnosticLoggerListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}/loggers",
    validator: validate_ApiDiagnosticLoggerListByService_564294, base: "",
    url: url_ApiDiagnosticLoggerListByService_564295, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticLoggerCreateOrUpdate_564309 = ref object of OpenApiRestCall_563565
proc url_ApiDiagnosticLoggerCreateOrUpdate_564311(protocol: Scheme; host: string;
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

proc validate_ApiDiagnosticLoggerCreateOrUpdate_564310(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Attaches a logger to a diagnostic for an API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerid: JString (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564312 = path.getOrDefault("serviceName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "serviceName", valid_564312
  var valid_564313 = path.getOrDefault("apiId")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "apiId", valid_564313
  var valid_564314 = path.getOrDefault("subscriptionId")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "subscriptionId", valid_564314
  var valid_564315 = path.getOrDefault("loggerid")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "loggerid", valid_564315
  var valid_564316 = path.getOrDefault("diagnosticId")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "diagnosticId", valid_564316
  var valid_564317 = path.getOrDefault("resourceGroupName")
  valid_564317 = validateParameter(valid_564317, JString, required = true,
                                 default = nil)
  if valid_564317 != nil:
    section.add "resourceGroupName", valid_564317
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564318 = query.getOrDefault("api-version")
  valid_564318 = validateParameter(valid_564318, JString, required = true,
                                 default = nil)
  if valid_564318 != nil:
    section.add "api-version", valid_564318
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564319: Call_ApiDiagnosticLoggerCreateOrUpdate_564309;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Attaches a logger to a diagnostic for an API.
  ## 
  let valid = call_564319.validator(path, query, header, formData, body)
  let scheme = call_564319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564319.url(scheme.get, call_564319.host, call_564319.base,
                         call_564319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564319, url, valid)

proc call*(call_564320: Call_ApiDiagnosticLoggerCreateOrUpdate_564309;
          serviceName: string; apiVersion: string; apiId: string;
          subscriptionId: string; loggerid: string; diagnosticId: string;
          resourceGroupName: string): Recallable =
  ## apiDiagnosticLoggerCreateOrUpdate
  ## Attaches a logger to a diagnostic for an API.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
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
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564321 = newJObject()
  var query_564322 = newJObject()
  add(path_564321, "serviceName", newJString(serviceName))
  add(query_564322, "api-version", newJString(apiVersion))
  add(path_564321, "apiId", newJString(apiId))
  add(path_564321, "subscriptionId", newJString(subscriptionId))
  add(path_564321, "loggerid", newJString(loggerid))
  add(path_564321, "diagnosticId", newJString(diagnosticId))
  add(path_564321, "resourceGroupName", newJString(resourceGroupName))
  result = call_564320.call(path_564321, query_564322, nil, nil, nil)

var apiDiagnosticLoggerCreateOrUpdate* = Call_ApiDiagnosticLoggerCreateOrUpdate_564309(
    name: "apiDiagnosticLoggerCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}/loggers/{loggerid}",
    validator: validate_ApiDiagnosticLoggerCreateOrUpdate_564310, base: "",
    url: url_ApiDiagnosticLoggerCreateOrUpdate_564311, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticLoggerCheckEntityExists_564337 = ref object of OpenApiRestCall_563565
proc url_ApiDiagnosticLoggerCheckEntityExists_564339(protocol: Scheme;
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

proc validate_ApiDiagnosticLoggerCheckEntityExists_564338(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks that logger entity specified by identifier is associated with the diagnostics entity.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerid: JString (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564340 = path.getOrDefault("serviceName")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "serviceName", valid_564340
  var valid_564341 = path.getOrDefault("apiId")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "apiId", valid_564341
  var valid_564342 = path.getOrDefault("subscriptionId")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "subscriptionId", valid_564342
  var valid_564343 = path.getOrDefault("loggerid")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = nil)
  if valid_564343 != nil:
    section.add "loggerid", valid_564343
  var valid_564344 = path.getOrDefault("diagnosticId")
  valid_564344 = validateParameter(valid_564344, JString, required = true,
                                 default = nil)
  if valid_564344 != nil:
    section.add "diagnosticId", valid_564344
  var valid_564345 = path.getOrDefault("resourceGroupName")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "resourceGroupName", valid_564345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564346 = query.getOrDefault("api-version")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "api-version", valid_564346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564347: Call_ApiDiagnosticLoggerCheckEntityExists_564337;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks that logger entity specified by identifier is associated with the diagnostics entity.
  ## 
  let valid = call_564347.validator(path, query, header, formData, body)
  let scheme = call_564347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564347.url(scheme.get, call_564347.host, call_564347.base,
                         call_564347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564347, url, valid)

proc call*(call_564348: Call_ApiDiagnosticLoggerCheckEntityExists_564337;
          serviceName: string; apiVersion: string; apiId: string;
          subscriptionId: string; loggerid: string; diagnosticId: string;
          resourceGroupName: string): Recallable =
  ## apiDiagnosticLoggerCheckEntityExists
  ## Checks that logger entity specified by identifier is associated with the diagnostics entity.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
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
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564349 = newJObject()
  var query_564350 = newJObject()
  add(path_564349, "serviceName", newJString(serviceName))
  add(query_564350, "api-version", newJString(apiVersion))
  add(path_564349, "apiId", newJString(apiId))
  add(path_564349, "subscriptionId", newJString(subscriptionId))
  add(path_564349, "loggerid", newJString(loggerid))
  add(path_564349, "diagnosticId", newJString(diagnosticId))
  add(path_564349, "resourceGroupName", newJString(resourceGroupName))
  result = call_564348.call(path_564349, query_564350, nil, nil, nil)

var apiDiagnosticLoggerCheckEntityExists* = Call_ApiDiagnosticLoggerCheckEntityExists_564337(
    name: "apiDiagnosticLoggerCheckEntityExists", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}/loggers/{loggerid}",
    validator: validate_ApiDiagnosticLoggerCheckEntityExists_564338, base: "",
    url: url_ApiDiagnosticLoggerCheckEntityExists_564339, schemes: {Scheme.Https})
type
  Call_ApiDiagnosticLoggerDelete_564323 = ref object of OpenApiRestCall_563565
proc url_ApiDiagnosticLoggerDelete_564325(protocol: Scheme; host: string;
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

proc validate_ApiDiagnosticLoggerDelete_564324(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified Logger from Diagnostic for an API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   loggerid: JString (required)
  ##           : Logger identifier. Must be unique in the API Management service instance.
  ##   diagnosticId: JString (required)
  ##               : Diagnostic identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564326 = path.getOrDefault("serviceName")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "serviceName", valid_564326
  var valid_564327 = path.getOrDefault("apiId")
  valid_564327 = validateParameter(valid_564327, JString, required = true,
                                 default = nil)
  if valid_564327 != nil:
    section.add "apiId", valid_564327
  var valid_564328 = path.getOrDefault("subscriptionId")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "subscriptionId", valid_564328
  var valid_564329 = path.getOrDefault("loggerid")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "loggerid", valid_564329
  var valid_564330 = path.getOrDefault("diagnosticId")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "diagnosticId", valid_564330
  var valid_564331 = path.getOrDefault("resourceGroupName")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "resourceGroupName", valid_564331
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564332 = query.getOrDefault("api-version")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "api-version", valid_564332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564333: Call_ApiDiagnosticLoggerDelete_564323; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Logger from Diagnostic for an API.
  ## 
  let valid = call_564333.validator(path, query, header, formData, body)
  let scheme = call_564333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564333.url(scheme.get, call_564333.host, call_564333.base,
                         call_564333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564333, url, valid)

proc call*(call_564334: Call_ApiDiagnosticLoggerDelete_564323; serviceName: string;
          apiVersion: string; apiId: string; subscriptionId: string; loggerid: string;
          diagnosticId: string; resourceGroupName: string): Recallable =
  ## apiDiagnosticLoggerDelete
  ## Deletes the specified Logger from Diagnostic for an API.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
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
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564335 = newJObject()
  var query_564336 = newJObject()
  add(path_564335, "serviceName", newJString(serviceName))
  add(query_564336, "api-version", newJString(apiVersion))
  add(path_564335, "apiId", newJString(apiId))
  add(path_564335, "subscriptionId", newJString(subscriptionId))
  add(path_564335, "loggerid", newJString(loggerid))
  add(path_564335, "diagnosticId", newJString(diagnosticId))
  add(path_564335, "resourceGroupName", newJString(resourceGroupName))
  result = call_564334.call(path_564335, query_564336, nil, nil, nil)

var apiDiagnosticLoggerDelete* = Call_ApiDiagnosticLoggerDelete_564323(
    name: "apiDiagnosticLoggerDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/diagnostics/{diagnosticId}/loggers/{loggerid}",
    validator: validate_ApiDiagnosticLoggerDelete_564324, base: "",
    url: url_ApiDiagnosticLoggerDelete_564325, schemes: {Scheme.Https})
type
  Call_ApiIssueListByService_564351 = ref object of OpenApiRestCall_563565
proc url_ApiIssueListByService_564353(protocol: Scheme; host: string; base: string;
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

proc validate_ApiIssueListByService_564352(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all issues associated with the specified API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564354 = path.getOrDefault("serviceName")
  valid_564354 = validateParameter(valid_564354, JString, required = true,
                                 default = nil)
  if valid_564354 != nil:
    section.add "serviceName", valid_564354
  var valid_564355 = path.getOrDefault("apiId")
  valid_564355 = validateParameter(valid_564355, JString, required = true,
                                 default = nil)
  if valid_564355 != nil:
    section.add "apiId", valid_564355
  var valid_564356 = path.getOrDefault("subscriptionId")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "subscriptionId", valid_564356
  var valid_564357 = path.getOrDefault("resourceGroupName")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "resourceGroupName", valid_564357
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
  var valid_564358 = query.getOrDefault("api-version")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "api-version", valid_564358
  var valid_564359 = query.getOrDefault("$top")
  valid_564359 = validateParameter(valid_564359, JInt, required = false, default = nil)
  if valid_564359 != nil:
    section.add "$top", valid_564359
  var valid_564360 = query.getOrDefault("$skip")
  valid_564360 = validateParameter(valid_564360, JInt, required = false, default = nil)
  if valid_564360 != nil:
    section.add "$skip", valid_564360
  var valid_564361 = query.getOrDefault("$filter")
  valid_564361 = validateParameter(valid_564361, JString, required = false,
                                 default = nil)
  if valid_564361 != nil:
    section.add "$filter", valid_564361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564362: Call_ApiIssueListByService_564351; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all issues associated with the specified API.
  ## 
  let valid = call_564362.validator(path, query, header, formData, body)
  let scheme = call_564362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564362.url(scheme.get, call_564362.host, call_564362.base,
                         call_564362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564362, url, valid)

proc call*(call_564363: Call_ApiIssueListByService_564351; serviceName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          resourceGroupName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## apiIssueListByService
  ## Lists all issues associated with the specified API.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | state        | eq                     |                                   |
  ## | userId          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  var path_564364 = newJObject()
  var query_564365 = newJObject()
  add(path_564364, "serviceName", newJString(serviceName))
  add(query_564365, "api-version", newJString(apiVersion))
  add(query_564365, "$top", newJInt(Top))
  add(path_564364, "apiId", newJString(apiId))
  add(path_564364, "subscriptionId", newJString(subscriptionId))
  add(query_564365, "$skip", newJInt(Skip))
  add(path_564364, "resourceGroupName", newJString(resourceGroupName))
  add(query_564365, "$filter", newJString(Filter))
  result = call_564363.call(path_564364, query_564365, nil, nil, nil)

var apiIssueListByService* = Call_ApiIssueListByService_564351(
    name: "apiIssueListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues",
    validator: validate_ApiIssueListByService_564352, base: "",
    url: url_ApiIssueListByService_564353, schemes: {Scheme.Https})
type
  Call_ApiIssueCreateOrUpdate_564379 = ref object of OpenApiRestCall_563565
proc url_ApiIssueCreateOrUpdate_564381(protocol: Scheme; host: string; base: string;
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

proc validate_ApiIssueCreateOrUpdate_564380(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Issue for an API or updates an existing one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564382 = path.getOrDefault("serviceName")
  valid_564382 = validateParameter(valid_564382, JString, required = true,
                                 default = nil)
  if valid_564382 != nil:
    section.add "serviceName", valid_564382
  var valid_564383 = path.getOrDefault("apiId")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "apiId", valid_564383
  var valid_564384 = path.getOrDefault("issueId")
  valid_564384 = validateParameter(valid_564384, JString, required = true,
                                 default = nil)
  if valid_564384 != nil:
    section.add "issueId", valid_564384
  var valid_564385 = path.getOrDefault("subscriptionId")
  valid_564385 = validateParameter(valid_564385, JString, required = true,
                                 default = nil)
  if valid_564385 != nil:
    section.add "subscriptionId", valid_564385
  var valid_564386 = path.getOrDefault("resourceGroupName")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "resourceGroupName", valid_564386
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564387 = query.getOrDefault("api-version")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "api-version", valid_564387
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Issue Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  var valid_564388 = header.getOrDefault("If-Match")
  valid_564388 = validateParameter(valid_564388, JString, required = false,
                                 default = nil)
  if valid_564388 != nil:
    section.add "If-Match", valid_564388
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

proc call*(call_564390: Call_ApiIssueCreateOrUpdate_564379; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Issue for an API or updates an existing one.
  ## 
  let valid = call_564390.validator(path, query, header, formData, body)
  let scheme = call_564390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564390.url(scheme.get, call_564390.host, call_564390.base,
                         call_564390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564390, url, valid)

proc call*(call_564391: Call_ApiIssueCreateOrUpdate_564379; serviceName: string;
          apiVersion: string; apiId: string; issueId: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## apiIssueCreateOrUpdate
  ## Creates a new Issue for an API or updates an existing one.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  var path_564392 = newJObject()
  var query_564393 = newJObject()
  var body_564394 = newJObject()
  add(path_564392, "serviceName", newJString(serviceName))
  add(query_564393, "api-version", newJString(apiVersion))
  add(path_564392, "apiId", newJString(apiId))
  add(path_564392, "issueId", newJString(issueId))
  add(path_564392, "subscriptionId", newJString(subscriptionId))
  add(path_564392, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564394 = parameters
  result = call_564391.call(path_564392, query_564393, nil, nil, body_564394)

var apiIssueCreateOrUpdate* = Call_ApiIssueCreateOrUpdate_564379(
    name: "apiIssueCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}",
    validator: validate_ApiIssueCreateOrUpdate_564380, base: "",
    url: url_ApiIssueCreateOrUpdate_564381, schemes: {Scheme.Https})
type
  Call_ApiIssueGetEntityTag_564409 = ref object of OpenApiRestCall_563565
proc url_ApiIssueGetEntityTag_564411(protocol: Scheme; host: string; base: string;
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

proc validate_ApiIssueGetEntityTag_564410(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the Issue for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564412 = path.getOrDefault("serviceName")
  valid_564412 = validateParameter(valid_564412, JString, required = true,
                                 default = nil)
  if valid_564412 != nil:
    section.add "serviceName", valid_564412
  var valid_564413 = path.getOrDefault("apiId")
  valid_564413 = validateParameter(valid_564413, JString, required = true,
                                 default = nil)
  if valid_564413 != nil:
    section.add "apiId", valid_564413
  var valid_564414 = path.getOrDefault("issueId")
  valid_564414 = validateParameter(valid_564414, JString, required = true,
                                 default = nil)
  if valid_564414 != nil:
    section.add "issueId", valid_564414
  var valid_564415 = path.getOrDefault("subscriptionId")
  valid_564415 = validateParameter(valid_564415, JString, required = true,
                                 default = nil)
  if valid_564415 != nil:
    section.add "subscriptionId", valid_564415
  var valid_564416 = path.getOrDefault("resourceGroupName")
  valid_564416 = validateParameter(valid_564416, JString, required = true,
                                 default = nil)
  if valid_564416 != nil:
    section.add "resourceGroupName", valid_564416
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564417 = query.getOrDefault("api-version")
  valid_564417 = validateParameter(valid_564417, JString, required = true,
                                 default = nil)
  if valid_564417 != nil:
    section.add "api-version", valid_564417
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564418: Call_ApiIssueGetEntityTag_564409; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the Issue for an API specified by its identifier.
  ## 
  let valid = call_564418.validator(path, query, header, formData, body)
  let scheme = call_564418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564418.url(scheme.get, call_564418.host, call_564418.base,
                         call_564418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564418, url, valid)

proc call*(call_564419: Call_ApiIssueGetEntityTag_564409; serviceName: string;
          apiVersion: string; apiId: string; issueId: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## apiIssueGetEntityTag
  ## Gets the entity state (Etag) version of the Issue for an API specified by its identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564420 = newJObject()
  var query_564421 = newJObject()
  add(path_564420, "serviceName", newJString(serviceName))
  add(query_564421, "api-version", newJString(apiVersion))
  add(path_564420, "apiId", newJString(apiId))
  add(path_564420, "issueId", newJString(issueId))
  add(path_564420, "subscriptionId", newJString(subscriptionId))
  add(path_564420, "resourceGroupName", newJString(resourceGroupName))
  result = call_564419.call(path_564420, query_564421, nil, nil, nil)

var apiIssueGetEntityTag* = Call_ApiIssueGetEntityTag_564409(
    name: "apiIssueGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}",
    validator: validate_ApiIssueGetEntityTag_564410, base: "",
    url: url_ApiIssueGetEntityTag_564411, schemes: {Scheme.Https})
type
  Call_ApiIssueGet_564366 = ref object of OpenApiRestCall_563565
proc url_ApiIssueGet_564368(protocol: Scheme; host: string; base: string;
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

proc validate_ApiIssueGet_564367(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the Issue for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564369 = path.getOrDefault("serviceName")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "serviceName", valid_564369
  var valid_564370 = path.getOrDefault("apiId")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "apiId", valid_564370
  var valid_564371 = path.getOrDefault("issueId")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = nil)
  if valid_564371 != nil:
    section.add "issueId", valid_564371
  var valid_564372 = path.getOrDefault("subscriptionId")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "subscriptionId", valid_564372
  var valid_564373 = path.getOrDefault("resourceGroupName")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "resourceGroupName", valid_564373
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564374 = query.getOrDefault("api-version")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "api-version", valid_564374
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564375: Call_ApiIssueGet_564366; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the Issue for an API specified by its identifier.
  ## 
  let valid = call_564375.validator(path, query, header, formData, body)
  let scheme = call_564375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564375.url(scheme.get, call_564375.host, call_564375.base,
                         call_564375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564375, url, valid)

proc call*(call_564376: Call_ApiIssueGet_564366; serviceName: string;
          apiVersion: string; apiId: string; issueId: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## apiIssueGet
  ## Gets the details of the Issue for an API specified by its identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564377 = newJObject()
  var query_564378 = newJObject()
  add(path_564377, "serviceName", newJString(serviceName))
  add(query_564378, "api-version", newJString(apiVersion))
  add(path_564377, "apiId", newJString(apiId))
  add(path_564377, "issueId", newJString(issueId))
  add(path_564377, "subscriptionId", newJString(subscriptionId))
  add(path_564377, "resourceGroupName", newJString(resourceGroupName))
  result = call_564376.call(path_564377, query_564378, nil, nil, nil)

var apiIssueGet* = Call_ApiIssueGet_564366(name: "apiIssueGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}",
                                        validator: validate_ApiIssueGet_564367,
                                        base: "", url: url_ApiIssueGet_564368,
                                        schemes: {Scheme.Https})
type
  Call_ApiIssueUpdate_564422 = ref object of OpenApiRestCall_563565
proc url_ApiIssueUpdate_564424(protocol: Scheme; host: string; base: string;
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

proc validate_ApiIssueUpdate_564423(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates an existing issue for an API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564425 = path.getOrDefault("serviceName")
  valid_564425 = validateParameter(valid_564425, JString, required = true,
                                 default = nil)
  if valid_564425 != nil:
    section.add "serviceName", valid_564425
  var valid_564426 = path.getOrDefault("apiId")
  valid_564426 = validateParameter(valid_564426, JString, required = true,
                                 default = nil)
  if valid_564426 != nil:
    section.add "apiId", valid_564426
  var valid_564427 = path.getOrDefault("issueId")
  valid_564427 = validateParameter(valid_564427, JString, required = true,
                                 default = nil)
  if valid_564427 != nil:
    section.add "issueId", valid_564427
  var valid_564428 = path.getOrDefault("subscriptionId")
  valid_564428 = validateParameter(valid_564428, JString, required = true,
                                 default = nil)
  if valid_564428 != nil:
    section.add "subscriptionId", valid_564428
  var valid_564429 = path.getOrDefault("resourceGroupName")
  valid_564429 = validateParameter(valid_564429, JString, required = true,
                                 default = nil)
  if valid_564429 != nil:
    section.add "resourceGroupName", valid_564429
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564430 = query.getOrDefault("api-version")
  valid_564430 = validateParameter(valid_564430, JString, required = true,
                                 default = nil)
  if valid_564430 != nil:
    section.add "api-version", valid_564430
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Issue Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  var valid_564431 = header.getOrDefault("If-Match")
  valid_564431 = validateParameter(valid_564431, JString, required = false,
                                 default = nil)
  if valid_564431 != nil:
    section.add "If-Match", valid_564431
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

proc call*(call_564433: Call_ApiIssueUpdate_564422; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing issue for an API.
  ## 
  let valid = call_564433.validator(path, query, header, formData, body)
  let scheme = call_564433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564433.url(scheme.get, call_564433.host, call_564433.base,
                         call_564433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564433, url, valid)

proc call*(call_564434: Call_ApiIssueUpdate_564422; serviceName: string;
          apiVersion: string; apiId: string; issueId: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## apiIssueUpdate
  ## Updates an existing issue for an API.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  var path_564435 = newJObject()
  var query_564436 = newJObject()
  var body_564437 = newJObject()
  add(path_564435, "serviceName", newJString(serviceName))
  add(query_564436, "api-version", newJString(apiVersion))
  add(path_564435, "apiId", newJString(apiId))
  add(path_564435, "issueId", newJString(issueId))
  add(path_564435, "subscriptionId", newJString(subscriptionId))
  add(path_564435, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564437 = parameters
  result = call_564434.call(path_564435, query_564436, nil, nil, body_564437)

var apiIssueUpdate* = Call_ApiIssueUpdate_564422(name: "apiIssueUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}",
    validator: validate_ApiIssueUpdate_564423, base: "", url: url_ApiIssueUpdate_564424,
    schemes: {Scheme.Https})
type
  Call_ApiIssueDelete_564395 = ref object of OpenApiRestCall_563565
proc url_ApiIssueDelete_564397(protocol: Scheme; host: string; base: string;
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

proc validate_ApiIssueDelete_564396(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes the specified Issue from an API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564398 = path.getOrDefault("serviceName")
  valid_564398 = validateParameter(valid_564398, JString, required = true,
                                 default = nil)
  if valid_564398 != nil:
    section.add "serviceName", valid_564398
  var valid_564399 = path.getOrDefault("apiId")
  valid_564399 = validateParameter(valid_564399, JString, required = true,
                                 default = nil)
  if valid_564399 != nil:
    section.add "apiId", valid_564399
  var valid_564400 = path.getOrDefault("issueId")
  valid_564400 = validateParameter(valid_564400, JString, required = true,
                                 default = nil)
  if valid_564400 != nil:
    section.add "issueId", valid_564400
  var valid_564401 = path.getOrDefault("subscriptionId")
  valid_564401 = validateParameter(valid_564401, JString, required = true,
                                 default = nil)
  if valid_564401 != nil:
    section.add "subscriptionId", valid_564401
  var valid_564402 = path.getOrDefault("resourceGroupName")
  valid_564402 = validateParameter(valid_564402, JString, required = true,
                                 default = nil)
  if valid_564402 != nil:
    section.add "resourceGroupName", valid_564402
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564403 = query.getOrDefault("api-version")
  valid_564403 = validateParameter(valid_564403, JString, required = true,
                                 default = nil)
  if valid_564403 != nil:
    section.add "api-version", valid_564403
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Issue Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564404 = header.getOrDefault("If-Match")
  valid_564404 = validateParameter(valid_564404, JString, required = true,
                                 default = nil)
  if valid_564404 != nil:
    section.add "If-Match", valid_564404
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564405: Call_ApiIssueDelete_564395; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified Issue from an API.
  ## 
  let valid = call_564405.validator(path, query, header, formData, body)
  let scheme = call_564405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564405.url(scheme.get, call_564405.host, call_564405.base,
                         call_564405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564405, url, valid)

proc call*(call_564406: Call_ApiIssueDelete_564395; serviceName: string;
          apiVersion: string; apiId: string; issueId: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## apiIssueDelete
  ## Deletes the specified Issue from an API.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564407 = newJObject()
  var query_564408 = newJObject()
  add(path_564407, "serviceName", newJString(serviceName))
  add(query_564408, "api-version", newJString(apiVersion))
  add(path_564407, "apiId", newJString(apiId))
  add(path_564407, "issueId", newJString(issueId))
  add(path_564407, "subscriptionId", newJString(subscriptionId))
  add(path_564407, "resourceGroupName", newJString(resourceGroupName))
  result = call_564406.call(path_564407, query_564408, nil, nil, nil)

var apiIssueDelete* = Call_ApiIssueDelete_564395(name: "apiIssueDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}",
    validator: validate_ApiIssueDelete_564396, base: "", url: url_ApiIssueDelete_564397,
    schemes: {Scheme.Https})
type
  Call_ApiIssueAttachmentListByService_564438 = ref object of OpenApiRestCall_563565
proc url_ApiIssueAttachmentListByService_564440(protocol: Scheme; host: string;
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

proc validate_ApiIssueAttachmentListByService_564439(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all comments for the Issue associated with the specified API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564441 = path.getOrDefault("serviceName")
  valid_564441 = validateParameter(valid_564441, JString, required = true,
                                 default = nil)
  if valid_564441 != nil:
    section.add "serviceName", valid_564441
  var valid_564442 = path.getOrDefault("apiId")
  valid_564442 = validateParameter(valid_564442, JString, required = true,
                                 default = nil)
  if valid_564442 != nil:
    section.add "apiId", valid_564442
  var valid_564443 = path.getOrDefault("issueId")
  valid_564443 = validateParameter(valid_564443, JString, required = true,
                                 default = nil)
  if valid_564443 != nil:
    section.add "issueId", valid_564443
  var valid_564444 = path.getOrDefault("subscriptionId")
  valid_564444 = validateParameter(valid_564444, JString, required = true,
                                 default = nil)
  if valid_564444 != nil:
    section.add "subscriptionId", valid_564444
  var valid_564445 = path.getOrDefault("resourceGroupName")
  valid_564445 = validateParameter(valid_564445, JString, required = true,
                                 default = nil)
  if valid_564445 != nil:
    section.add "resourceGroupName", valid_564445
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
  var valid_564446 = query.getOrDefault("api-version")
  valid_564446 = validateParameter(valid_564446, JString, required = true,
                                 default = nil)
  if valid_564446 != nil:
    section.add "api-version", valid_564446
  var valid_564447 = query.getOrDefault("$top")
  valid_564447 = validateParameter(valid_564447, JInt, required = false, default = nil)
  if valid_564447 != nil:
    section.add "$top", valid_564447
  var valid_564448 = query.getOrDefault("$skip")
  valid_564448 = validateParameter(valid_564448, JInt, required = false, default = nil)
  if valid_564448 != nil:
    section.add "$skip", valid_564448
  var valid_564449 = query.getOrDefault("$filter")
  valid_564449 = validateParameter(valid_564449, JString, required = false,
                                 default = nil)
  if valid_564449 != nil:
    section.add "$filter", valid_564449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564450: Call_ApiIssueAttachmentListByService_564438;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all comments for the Issue associated with the specified API.
  ## 
  let valid = call_564450.validator(path, query, header, formData, body)
  let scheme = call_564450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564450.url(scheme.get, call_564450.host, call_564450.base,
                         call_564450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564450, url, valid)

proc call*(call_564451: Call_ApiIssueAttachmentListByService_564438;
          serviceName: string; apiVersion: string; apiId: string; issueId: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          Skip: int = 0; Filter: string = ""): Recallable =
  ## apiIssueAttachmentListByService
  ## Lists all comments for the Issue associated with the specified API.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | userId          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  var path_564452 = newJObject()
  var query_564453 = newJObject()
  add(path_564452, "serviceName", newJString(serviceName))
  add(query_564453, "api-version", newJString(apiVersion))
  add(query_564453, "$top", newJInt(Top))
  add(path_564452, "apiId", newJString(apiId))
  add(path_564452, "issueId", newJString(issueId))
  add(path_564452, "subscriptionId", newJString(subscriptionId))
  add(query_564453, "$skip", newJInt(Skip))
  add(path_564452, "resourceGroupName", newJString(resourceGroupName))
  add(query_564453, "$filter", newJString(Filter))
  result = call_564451.call(path_564452, query_564453, nil, nil, nil)

var apiIssueAttachmentListByService* = Call_ApiIssueAttachmentListByService_564438(
    name: "apiIssueAttachmentListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/attachments",
    validator: validate_ApiIssueAttachmentListByService_564439, base: "",
    url: url_ApiIssueAttachmentListByService_564440, schemes: {Scheme.Https})
type
  Call_ApiIssueAttachmentCreateOrUpdate_564468 = ref object of OpenApiRestCall_563565
proc url_ApiIssueAttachmentCreateOrUpdate_564470(protocol: Scheme; host: string;
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

proc validate_ApiIssueAttachmentCreateOrUpdate_564469(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Attachment for the Issue in an API or updates an existing one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   attachmentId: JString (required)
  ##               : Attachment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `attachmentId` field"
  var valid_564471 = path.getOrDefault("attachmentId")
  valid_564471 = validateParameter(valid_564471, JString, required = true,
                                 default = nil)
  if valid_564471 != nil:
    section.add "attachmentId", valid_564471
  var valid_564472 = path.getOrDefault("serviceName")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = nil)
  if valid_564472 != nil:
    section.add "serviceName", valid_564472
  var valid_564473 = path.getOrDefault("apiId")
  valid_564473 = validateParameter(valid_564473, JString, required = true,
                                 default = nil)
  if valid_564473 != nil:
    section.add "apiId", valid_564473
  var valid_564474 = path.getOrDefault("issueId")
  valid_564474 = validateParameter(valid_564474, JString, required = true,
                                 default = nil)
  if valid_564474 != nil:
    section.add "issueId", valid_564474
  var valid_564475 = path.getOrDefault("subscriptionId")
  valid_564475 = validateParameter(valid_564475, JString, required = true,
                                 default = nil)
  if valid_564475 != nil:
    section.add "subscriptionId", valid_564475
  var valid_564476 = path.getOrDefault("resourceGroupName")
  valid_564476 = validateParameter(valid_564476, JString, required = true,
                                 default = nil)
  if valid_564476 != nil:
    section.add "resourceGroupName", valid_564476
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564477 = query.getOrDefault("api-version")
  valid_564477 = validateParameter(valid_564477, JString, required = true,
                                 default = nil)
  if valid_564477 != nil:
    section.add "api-version", valid_564477
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Issue Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  var valid_564478 = header.getOrDefault("If-Match")
  valid_564478 = validateParameter(valid_564478, JString, required = false,
                                 default = nil)
  if valid_564478 != nil:
    section.add "If-Match", valid_564478
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

proc call*(call_564480: Call_ApiIssueAttachmentCreateOrUpdate_564468;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new Attachment for the Issue in an API or updates an existing one.
  ## 
  let valid = call_564480.validator(path, query, header, formData, body)
  let scheme = call_564480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564480.url(scheme.get, call_564480.host, call_564480.base,
                         call_564480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564480, url, valid)

proc call*(call_564481: Call_ApiIssueAttachmentCreateOrUpdate_564468;
          attachmentId: string; serviceName: string; apiVersion: string;
          apiId: string; issueId: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## apiIssueAttachmentCreateOrUpdate
  ## Creates a new Attachment for the Issue in an API or updates an existing one.
  ##   attachmentId: string (required)
  ##               : Attachment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  var path_564482 = newJObject()
  var query_564483 = newJObject()
  var body_564484 = newJObject()
  add(path_564482, "attachmentId", newJString(attachmentId))
  add(path_564482, "serviceName", newJString(serviceName))
  add(query_564483, "api-version", newJString(apiVersion))
  add(path_564482, "apiId", newJString(apiId))
  add(path_564482, "issueId", newJString(issueId))
  add(path_564482, "subscriptionId", newJString(subscriptionId))
  add(path_564482, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564484 = parameters
  result = call_564481.call(path_564482, query_564483, nil, nil, body_564484)

var apiIssueAttachmentCreateOrUpdate* = Call_ApiIssueAttachmentCreateOrUpdate_564468(
    name: "apiIssueAttachmentCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/attachments/{attachmentId}",
    validator: validate_ApiIssueAttachmentCreateOrUpdate_564469, base: "",
    url: url_ApiIssueAttachmentCreateOrUpdate_564470, schemes: {Scheme.Https})
type
  Call_ApiIssueAttachmentGetEntityTag_564500 = ref object of OpenApiRestCall_563565
proc url_ApiIssueAttachmentGetEntityTag_564502(protocol: Scheme; host: string;
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

proc validate_ApiIssueAttachmentGetEntityTag_564501(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the issue Attachment for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   attachmentId: JString (required)
  ##               : Attachment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `attachmentId` field"
  var valid_564503 = path.getOrDefault("attachmentId")
  valid_564503 = validateParameter(valid_564503, JString, required = true,
                                 default = nil)
  if valid_564503 != nil:
    section.add "attachmentId", valid_564503
  var valid_564504 = path.getOrDefault("serviceName")
  valid_564504 = validateParameter(valid_564504, JString, required = true,
                                 default = nil)
  if valid_564504 != nil:
    section.add "serviceName", valid_564504
  var valid_564505 = path.getOrDefault("apiId")
  valid_564505 = validateParameter(valid_564505, JString, required = true,
                                 default = nil)
  if valid_564505 != nil:
    section.add "apiId", valid_564505
  var valid_564506 = path.getOrDefault("issueId")
  valid_564506 = validateParameter(valid_564506, JString, required = true,
                                 default = nil)
  if valid_564506 != nil:
    section.add "issueId", valid_564506
  var valid_564507 = path.getOrDefault("subscriptionId")
  valid_564507 = validateParameter(valid_564507, JString, required = true,
                                 default = nil)
  if valid_564507 != nil:
    section.add "subscriptionId", valid_564507
  var valid_564508 = path.getOrDefault("resourceGroupName")
  valid_564508 = validateParameter(valid_564508, JString, required = true,
                                 default = nil)
  if valid_564508 != nil:
    section.add "resourceGroupName", valid_564508
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564509 = query.getOrDefault("api-version")
  valid_564509 = validateParameter(valid_564509, JString, required = true,
                                 default = nil)
  if valid_564509 != nil:
    section.add "api-version", valid_564509
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564510: Call_ApiIssueAttachmentGetEntityTag_564500; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the issue Attachment for an API specified by its identifier.
  ## 
  let valid = call_564510.validator(path, query, header, formData, body)
  let scheme = call_564510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564510.url(scheme.get, call_564510.host, call_564510.base,
                         call_564510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564510, url, valid)

proc call*(call_564511: Call_ApiIssueAttachmentGetEntityTag_564500;
          attachmentId: string; serviceName: string; apiVersion: string;
          apiId: string; issueId: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## apiIssueAttachmentGetEntityTag
  ## Gets the entity state (Etag) version of the issue Attachment for an API specified by its identifier.
  ##   attachmentId: string (required)
  ##               : Attachment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564512 = newJObject()
  var query_564513 = newJObject()
  add(path_564512, "attachmentId", newJString(attachmentId))
  add(path_564512, "serviceName", newJString(serviceName))
  add(query_564513, "api-version", newJString(apiVersion))
  add(path_564512, "apiId", newJString(apiId))
  add(path_564512, "issueId", newJString(issueId))
  add(path_564512, "subscriptionId", newJString(subscriptionId))
  add(path_564512, "resourceGroupName", newJString(resourceGroupName))
  result = call_564511.call(path_564512, query_564513, nil, nil, nil)

var apiIssueAttachmentGetEntityTag* = Call_ApiIssueAttachmentGetEntityTag_564500(
    name: "apiIssueAttachmentGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/attachments/{attachmentId}",
    validator: validate_ApiIssueAttachmentGetEntityTag_564501, base: "",
    url: url_ApiIssueAttachmentGetEntityTag_564502, schemes: {Scheme.Https})
type
  Call_ApiIssueAttachmentGet_564454 = ref object of OpenApiRestCall_563565
proc url_ApiIssueAttachmentGet_564456(protocol: Scheme; host: string; base: string;
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

proc validate_ApiIssueAttachmentGet_564455(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the issue Attachment for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   attachmentId: JString (required)
  ##               : Attachment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `attachmentId` field"
  var valid_564457 = path.getOrDefault("attachmentId")
  valid_564457 = validateParameter(valid_564457, JString, required = true,
                                 default = nil)
  if valid_564457 != nil:
    section.add "attachmentId", valid_564457
  var valid_564458 = path.getOrDefault("serviceName")
  valid_564458 = validateParameter(valid_564458, JString, required = true,
                                 default = nil)
  if valid_564458 != nil:
    section.add "serviceName", valid_564458
  var valid_564459 = path.getOrDefault("apiId")
  valid_564459 = validateParameter(valid_564459, JString, required = true,
                                 default = nil)
  if valid_564459 != nil:
    section.add "apiId", valid_564459
  var valid_564460 = path.getOrDefault("issueId")
  valid_564460 = validateParameter(valid_564460, JString, required = true,
                                 default = nil)
  if valid_564460 != nil:
    section.add "issueId", valid_564460
  var valid_564461 = path.getOrDefault("subscriptionId")
  valid_564461 = validateParameter(valid_564461, JString, required = true,
                                 default = nil)
  if valid_564461 != nil:
    section.add "subscriptionId", valid_564461
  var valid_564462 = path.getOrDefault("resourceGroupName")
  valid_564462 = validateParameter(valid_564462, JString, required = true,
                                 default = nil)
  if valid_564462 != nil:
    section.add "resourceGroupName", valid_564462
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564463 = query.getOrDefault("api-version")
  valid_564463 = validateParameter(valid_564463, JString, required = true,
                                 default = nil)
  if valid_564463 != nil:
    section.add "api-version", valid_564463
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564464: Call_ApiIssueAttachmentGet_564454; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the issue Attachment for an API specified by its identifier.
  ## 
  let valid = call_564464.validator(path, query, header, formData, body)
  let scheme = call_564464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564464.url(scheme.get, call_564464.host, call_564464.base,
                         call_564464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564464, url, valid)

proc call*(call_564465: Call_ApiIssueAttachmentGet_564454; attachmentId: string;
          serviceName: string; apiVersion: string; apiId: string; issueId: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## apiIssueAttachmentGet
  ## Gets the details of the issue Attachment for an API specified by its identifier.
  ##   attachmentId: string (required)
  ##               : Attachment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564466 = newJObject()
  var query_564467 = newJObject()
  add(path_564466, "attachmentId", newJString(attachmentId))
  add(path_564466, "serviceName", newJString(serviceName))
  add(query_564467, "api-version", newJString(apiVersion))
  add(path_564466, "apiId", newJString(apiId))
  add(path_564466, "issueId", newJString(issueId))
  add(path_564466, "subscriptionId", newJString(subscriptionId))
  add(path_564466, "resourceGroupName", newJString(resourceGroupName))
  result = call_564465.call(path_564466, query_564467, nil, nil, nil)

var apiIssueAttachmentGet* = Call_ApiIssueAttachmentGet_564454(
    name: "apiIssueAttachmentGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/attachments/{attachmentId}",
    validator: validate_ApiIssueAttachmentGet_564455, base: "",
    url: url_ApiIssueAttachmentGet_564456, schemes: {Scheme.Https})
type
  Call_ApiIssueAttachmentDelete_564485 = ref object of OpenApiRestCall_563565
proc url_ApiIssueAttachmentDelete_564487(protocol: Scheme; host: string;
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

proc validate_ApiIssueAttachmentDelete_564486(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified comment from an Issue.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   attachmentId: JString (required)
  ##               : Attachment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `attachmentId` field"
  var valid_564488 = path.getOrDefault("attachmentId")
  valid_564488 = validateParameter(valid_564488, JString, required = true,
                                 default = nil)
  if valid_564488 != nil:
    section.add "attachmentId", valid_564488
  var valid_564489 = path.getOrDefault("serviceName")
  valid_564489 = validateParameter(valid_564489, JString, required = true,
                                 default = nil)
  if valid_564489 != nil:
    section.add "serviceName", valid_564489
  var valid_564490 = path.getOrDefault("apiId")
  valid_564490 = validateParameter(valid_564490, JString, required = true,
                                 default = nil)
  if valid_564490 != nil:
    section.add "apiId", valid_564490
  var valid_564491 = path.getOrDefault("issueId")
  valid_564491 = validateParameter(valid_564491, JString, required = true,
                                 default = nil)
  if valid_564491 != nil:
    section.add "issueId", valid_564491
  var valid_564492 = path.getOrDefault("subscriptionId")
  valid_564492 = validateParameter(valid_564492, JString, required = true,
                                 default = nil)
  if valid_564492 != nil:
    section.add "subscriptionId", valid_564492
  var valid_564493 = path.getOrDefault("resourceGroupName")
  valid_564493 = validateParameter(valid_564493, JString, required = true,
                                 default = nil)
  if valid_564493 != nil:
    section.add "resourceGroupName", valid_564493
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564494 = query.getOrDefault("api-version")
  valid_564494 = validateParameter(valid_564494, JString, required = true,
                                 default = nil)
  if valid_564494 != nil:
    section.add "api-version", valid_564494
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Issue Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564495 = header.getOrDefault("If-Match")
  valid_564495 = validateParameter(valid_564495, JString, required = true,
                                 default = nil)
  if valid_564495 != nil:
    section.add "If-Match", valid_564495
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564496: Call_ApiIssueAttachmentDelete_564485; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified comment from an Issue.
  ## 
  let valid = call_564496.validator(path, query, header, formData, body)
  let scheme = call_564496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564496.url(scheme.get, call_564496.host, call_564496.base,
                         call_564496.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564496, url, valid)

proc call*(call_564497: Call_ApiIssueAttachmentDelete_564485; attachmentId: string;
          serviceName: string; apiVersion: string; apiId: string; issueId: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## apiIssueAttachmentDelete
  ## Deletes the specified comment from an Issue.
  ##   attachmentId: string (required)
  ##               : Attachment identifier within an Issue. Must be unique in the current Issue.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564498 = newJObject()
  var query_564499 = newJObject()
  add(path_564498, "attachmentId", newJString(attachmentId))
  add(path_564498, "serviceName", newJString(serviceName))
  add(query_564499, "api-version", newJString(apiVersion))
  add(path_564498, "apiId", newJString(apiId))
  add(path_564498, "issueId", newJString(issueId))
  add(path_564498, "subscriptionId", newJString(subscriptionId))
  add(path_564498, "resourceGroupName", newJString(resourceGroupName))
  result = call_564497.call(path_564498, query_564499, nil, nil, nil)

var apiIssueAttachmentDelete* = Call_ApiIssueAttachmentDelete_564485(
    name: "apiIssueAttachmentDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/attachments/{attachmentId}",
    validator: validate_ApiIssueAttachmentDelete_564486, base: "",
    url: url_ApiIssueAttachmentDelete_564487, schemes: {Scheme.Https})
type
  Call_ApiIssueCommentListByService_564514 = ref object of OpenApiRestCall_563565
proc url_ApiIssueCommentListByService_564516(protocol: Scheme; host: string;
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

proc validate_ApiIssueCommentListByService_564515(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all comments for the Issue associated with the specified API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564517 = path.getOrDefault("serviceName")
  valid_564517 = validateParameter(valid_564517, JString, required = true,
                                 default = nil)
  if valid_564517 != nil:
    section.add "serviceName", valid_564517
  var valid_564518 = path.getOrDefault("apiId")
  valid_564518 = validateParameter(valid_564518, JString, required = true,
                                 default = nil)
  if valid_564518 != nil:
    section.add "apiId", valid_564518
  var valid_564519 = path.getOrDefault("issueId")
  valid_564519 = validateParameter(valid_564519, JString, required = true,
                                 default = nil)
  if valid_564519 != nil:
    section.add "issueId", valid_564519
  var valid_564520 = path.getOrDefault("subscriptionId")
  valid_564520 = validateParameter(valid_564520, JString, required = true,
                                 default = nil)
  if valid_564520 != nil:
    section.add "subscriptionId", valid_564520
  var valid_564521 = path.getOrDefault("resourceGroupName")
  valid_564521 = validateParameter(valid_564521, JString, required = true,
                                 default = nil)
  if valid_564521 != nil:
    section.add "resourceGroupName", valid_564521
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
  var valid_564522 = query.getOrDefault("api-version")
  valid_564522 = validateParameter(valid_564522, JString, required = true,
                                 default = nil)
  if valid_564522 != nil:
    section.add "api-version", valid_564522
  var valid_564523 = query.getOrDefault("$top")
  valid_564523 = validateParameter(valid_564523, JInt, required = false, default = nil)
  if valid_564523 != nil:
    section.add "$top", valid_564523
  var valid_564524 = query.getOrDefault("$skip")
  valid_564524 = validateParameter(valid_564524, JInt, required = false, default = nil)
  if valid_564524 != nil:
    section.add "$skip", valid_564524
  var valid_564525 = query.getOrDefault("$filter")
  valid_564525 = validateParameter(valid_564525, JString, required = false,
                                 default = nil)
  if valid_564525 != nil:
    section.add "$filter", valid_564525
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564526: Call_ApiIssueCommentListByService_564514; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all comments for the Issue associated with the specified API.
  ## 
  let valid = call_564526.validator(path, query, header, formData, body)
  let scheme = call_564526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564526.url(scheme.get, call_564526.host, call_564526.base,
                         call_564526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564526, url, valid)

proc call*(call_564527: Call_ApiIssueCommentListByService_564514;
          serviceName: string; apiVersion: string; apiId: string; issueId: string;
          subscriptionId: string; resourceGroupName: string; Top: int = 0;
          Skip: int = 0; Filter: string = ""): Recallable =
  ## apiIssueCommentListByService
  ## Lists all comments for the Issue associated with the specified API.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: string (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | userId          | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  var path_564528 = newJObject()
  var query_564529 = newJObject()
  add(path_564528, "serviceName", newJString(serviceName))
  add(query_564529, "api-version", newJString(apiVersion))
  add(query_564529, "$top", newJInt(Top))
  add(path_564528, "apiId", newJString(apiId))
  add(path_564528, "issueId", newJString(issueId))
  add(path_564528, "subscriptionId", newJString(subscriptionId))
  add(query_564529, "$skip", newJInt(Skip))
  add(path_564528, "resourceGroupName", newJString(resourceGroupName))
  add(query_564529, "$filter", newJString(Filter))
  result = call_564527.call(path_564528, query_564529, nil, nil, nil)

var apiIssueCommentListByService* = Call_ApiIssueCommentListByService_564514(
    name: "apiIssueCommentListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/comments",
    validator: validate_ApiIssueCommentListByService_564515, base: "",
    url: url_ApiIssueCommentListByService_564516, schemes: {Scheme.Https})
type
  Call_ApiIssueCommentCreateOrUpdate_564544 = ref object of OpenApiRestCall_563565
proc url_ApiIssueCommentCreateOrUpdate_564546(protocol: Scheme; host: string;
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

proc validate_ApiIssueCommentCreateOrUpdate_564545(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Comment for the Issue in an API or updates an existing one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   commentId: JString (required)
  ##            : Comment identifier within an Issue. Must be unique in the current Issue.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564547 = path.getOrDefault("serviceName")
  valid_564547 = validateParameter(valid_564547, JString, required = true,
                                 default = nil)
  if valid_564547 != nil:
    section.add "serviceName", valid_564547
  var valid_564548 = path.getOrDefault("apiId")
  valid_564548 = validateParameter(valid_564548, JString, required = true,
                                 default = nil)
  if valid_564548 != nil:
    section.add "apiId", valid_564548
  var valid_564549 = path.getOrDefault("issueId")
  valid_564549 = validateParameter(valid_564549, JString, required = true,
                                 default = nil)
  if valid_564549 != nil:
    section.add "issueId", valid_564549
  var valid_564550 = path.getOrDefault("subscriptionId")
  valid_564550 = validateParameter(valid_564550, JString, required = true,
                                 default = nil)
  if valid_564550 != nil:
    section.add "subscriptionId", valid_564550
  var valid_564551 = path.getOrDefault("commentId")
  valid_564551 = validateParameter(valid_564551, JString, required = true,
                                 default = nil)
  if valid_564551 != nil:
    section.add "commentId", valid_564551
  var valid_564552 = path.getOrDefault("resourceGroupName")
  valid_564552 = validateParameter(valid_564552, JString, required = true,
                                 default = nil)
  if valid_564552 != nil:
    section.add "resourceGroupName", valid_564552
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564553 = query.getOrDefault("api-version")
  valid_564553 = validateParameter(valid_564553, JString, required = true,
                                 default = nil)
  if valid_564553 != nil:
    section.add "api-version", valid_564553
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Issue Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  var valid_564554 = header.getOrDefault("If-Match")
  valid_564554 = validateParameter(valid_564554, JString, required = false,
                                 default = nil)
  if valid_564554 != nil:
    section.add "If-Match", valid_564554
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

proc call*(call_564556: Call_ApiIssueCommentCreateOrUpdate_564544; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Comment for the Issue in an API or updates an existing one.
  ## 
  let valid = call_564556.validator(path, query, header, formData, body)
  let scheme = call_564556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564556.url(scheme.get, call_564556.host, call_564556.base,
                         call_564556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564556, url, valid)

proc call*(call_564557: Call_ApiIssueCommentCreateOrUpdate_564544;
          serviceName: string; apiVersion: string; apiId: string; issueId: string;
          subscriptionId: string; commentId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## apiIssueCommentCreateOrUpdate
  ## Creates a new Comment for the Issue in an API or updates an existing one.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
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
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  var path_564558 = newJObject()
  var query_564559 = newJObject()
  var body_564560 = newJObject()
  add(path_564558, "serviceName", newJString(serviceName))
  add(query_564559, "api-version", newJString(apiVersion))
  add(path_564558, "apiId", newJString(apiId))
  add(path_564558, "issueId", newJString(issueId))
  add(path_564558, "subscriptionId", newJString(subscriptionId))
  add(path_564558, "commentId", newJString(commentId))
  add(path_564558, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564560 = parameters
  result = call_564557.call(path_564558, query_564559, nil, nil, body_564560)

var apiIssueCommentCreateOrUpdate* = Call_ApiIssueCommentCreateOrUpdate_564544(
    name: "apiIssueCommentCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/comments/{commentId}",
    validator: validate_ApiIssueCommentCreateOrUpdate_564545, base: "",
    url: url_ApiIssueCommentCreateOrUpdate_564546, schemes: {Scheme.Https})
type
  Call_ApiIssueCommentGetEntityTag_564576 = ref object of OpenApiRestCall_563565
proc url_ApiIssueCommentGetEntityTag_564578(protocol: Scheme; host: string;
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

proc validate_ApiIssueCommentGetEntityTag_564577(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the issue Comment for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   commentId: JString (required)
  ##            : Comment identifier within an Issue. Must be unique in the current Issue.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564579 = path.getOrDefault("serviceName")
  valid_564579 = validateParameter(valid_564579, JString, required = true,
                                 default = nil)
  if valid_564579 != nil:
    section.add "serviceName", valid_564579
  var valid_564580 = path.getOrDefault("apiId")
  valid_564580 = validateParameter(valid_564580, JString, required = true,
                                 default = nil)
  if valid_564580 != nil:
    section.add "apiId", valid_564580
  var valid_564581 = path.getOrDefault("issueId")
  valid_564581 = validateParameter(valid_564581, JString, required = true,
                                 default = nil)
  if valid_564581 != nil:
    section.add "issueId", valid_564581
  var valid_564582 = path.getOrDefault("subscriptionId")
  valid_564582 = validateParameter(valid_564582, JString, required = true,
                                 default = nil)
  if valid_564582 != nil:
    section.add "subscriptionId", valid_564582
  var valid_564583 = path.getOrDefault("commentId")
  valid_564583 = validateParameter(valid_564583, JString, required = true,
                                 default = nil)
  if valid_564583 != nil:
    section.add "commentId", valid_564583
  var valid_564584 = path.getOrDefault("resourceGroupName")
  valid_564584 = validateParameter(valid_564584, JString, required = true,
                                 default = nil)
  if valid_564584 != nil:
    section.add "resourceGroupName", valid_564584
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564585 = query.getOrDefault("api-version")
  valid_564585 = validateParameter(valid_564585, JString, required = true,
                                 default = nil)
  if valid_564585 != nil:
    section.add "api-version", valid_564585
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564586: Call_ApiIssueCommentGetEntityTag_564576; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the issue Comment for an API specified by its identifier.
  ## 
  let valid = call_564586.validator(path, query, header, formData, body)
  let scheme = call_564586.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564586.url(scheme.get, call_564586.host, call_564586.base,
                         call_564586.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564586, url, valid)

proc call*(call_564587: Call_ApiIssueCommentGetEntityTag_564576;
          serviceName: string; apiVersion: string; apiId: string; issueId: string;
          subscriptionId: string; commentId: string; resourceGroupName: string): Recallable =
  ## apiIssueCommentGetEntityTag
  ## Gets the entity state (Etag) version of the issue Comment for an API specified by its identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
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
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564588 = newJObject()
  var query_564589 = newJObject()
  add(path_564588, "serviceName", newJString(serviceName))
  add(query_564589, "api-version", newJString(apiVersion))
  add(path_564588, "apiId", newJString(apiId))
  add(path_564588, "issueId", newJString(issueId))
  add(path_564588, "subscriptionId", newJString(subscriptionId))
  add(path_564588, "commentId", newJString(commentId))
  add(path_564588, "resourceGroupName", newJString(resourceGroupName))
  result = call_564587.call(path_564588, query_564589, nil, nil, nil)

var apiIssueCommentGetEntityTag* = Call_ApiIssueCommentGetEntityTag_564576(
    name: "apiIssueCommentGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/comments/{commentId}",
    validator: validate_ApiIssueCommentGetEntityTag_564577, base: "",
    url: url_ApiIssueCommentGetEntityTag_564578, schemes: {Scheme.Https})
type
  Call_ApiIssueCommentGet_564530 = ref object of OpenApiRestCall_563565
proc url_ApiIssueCommentGet_564532(protocol: Scheme; host: string; base: string;
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

proc validate_ApiIssueCommentGet_564531(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the details of the issue Comment for an API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   commentId: JString (required)
  ##            : Comment identifier within an Issue. Must be unique in the current Issue.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564533 = path.getOrDefault("serviceName")
  valid_564533 = validateParameter(valid_564533, JString, required = true,
                                 default = nil)
  if valid_564533 != nil:
    section.add "serviceName", valid_564533
  var valid_564534 = path.getOrDefault("apiId")
  valid_564534 = validateParameter(valid_564534, JString, required = true,
                                 default = nil)
  if valid_564534 != nil:
    section.add "apiId", valid_564534
  var valid_564535 = path.getOrDefault("issueId")
  valid_564535 = validateParameter(valid_564535, JString, required = true,
                                 default = nil)
  if valid_564535 != nil:
    section.add "issueId", valid_564535
  var valid_564536 = path.getOrDefault("subscriptionId")
  valid_564536 = validateParameter(valid_564536, JString, required = true,
                                 default = nil)
  if valid_564536 != nil:
    section.add "subscriptionId", valid_564536
  var valid_564537 = path.getOrDefault("commentId")
  valid_564537 = validateParameter(valid_564537, JString, required = true,
                                 default = nil)
  if valid_564537 != nil:
    section.add "commentId", valid_564537
  var valid_564538 = path.getOrDefault("resourceGroupName")
  valid_564538 = validateParameter(valid_564538, JString, required = true,
                                 default = nil)
  if valid_564538 != nil:
    section.add "resourceGroupName", valid_564538
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564539 = query.getOrDefault("api-version")
  valid_564539 = validateParameter(valid_564539, JString, required = true,
                                 default = nil)
  if valid_564539 != nil:
    section.add "api-version", valid_564539
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564540: Call_ApiIssueCommentGet_564530; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the issue Comment for an API specified by its identifier.
  ## 
  let valid = call_564540.validator(path, query, header, formData, body)
  let scheme = call_564540.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564540.url(scheme.get, call_564540.host, call_564540.base,
                         call_564540.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564540, url, valid)

proc call*(call_564541: Call_ApiIssueCommentGet_564530; serviceName: string;
          apiVersion: string; apiId: string; issueId: string; subscriptionId: string;
          commentId: string; resourceGroupName: string): Recallable =
  ## apiIssueCommentGet
  ## Gets the details of the issue Comment for an API specified by its identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
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
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564542 = newJObject()
  var query_564543 = newJObject()
  add(path_564542, "serviceName", newJString(serviceName))
  add(query_564543, "api-version", newJString(apiVersion))
  add(path_564542, "apiId", newJString(apiId))
  add(path_564542, "issueId", newJString(issueId))
  add(path_564542, "subscriptionId", newJString(subscriptionId))
  add(path_564542, "commentId", newJString(commentId))
  add(path_564542, "resourceGroupName", newJString(resourceGroupName))
  result = call_564541.call(path_564542, query_564543, nil, nil, nil)

var apiIssueCommentGet* = Call_ApiIssueCommentGet_564530(
    name: "apiIssueCommentGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/comments/{commentId}",
    validator: validate_ApiIssueCommentGet_564531, base: "",
    url: url_ApiIssueCommentGet_564532, schemes: {Scheme.Https})
type
  Call_ApiIssueCommentDelete_564561 = ref object of OpenApiRestCall_563565
proc url_ApiIssueCommentDelete_564563(protocol: Scheme; host: string; base: string;
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

proc validate_ApiIssueCommentDelete_564562(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified comment from an Issue.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   issueId: JString (required)
  ##          : Issue identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   commentId: JString (required)
  ##            : Comment identifier within an Issue. Must be unique in the current Issue.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564564 = path.getOrDefault("serviceName")
  valid_564564 = validateParameter(valid_564564, JString, required = true,
                                 default = nil)
  if valid_564564 != nil:
    section.add "serviceName", valid_564564
  var valid_564565 = path.getOrDefault("apiId")
  valid_564565 = validateParameter(valid_564565, JString, required = true,
                                 default = nil)
  if valid_564565 != nil:
    section.add "apiId", valid_564565
  var valid_564566 = path.getOrDefault("issueId")
  valid_564566 = validateParameter(valid_564566, JString, required = true,
                                 default = nil)
  if valid_564566 != nil:
    section.add "issueId", valid_564566
  var valid_564567 = path.getOrDefault("subscriptionId")
  valid_564567 = validateParameter(valid_564567, JString, required = true,
                                 default = nil)
  if valid_564567 != nil:
    section.add "subscriptionId", valid_564567
  var valid_564568 = path.getOrDefault("commentId")
  valid_564568 = validateParameter(valid_564568, JString, required = true,
                                 default = nil)
  if valid_564568 != nil:
    section.add "commentId", valid_564568
  var valid_564569 = path.getOrDefault("resourceGroupName")
  valid_564569 = validateParameter(valid_564569, JString, required = true,
                                 default = nil)
  if valid_564569 != nil:
    section.add "resourceGroupName", valid_564569
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564570 = query.getOrDefault("api-version")
  valid_564570 = validateParameter(valid_564570, JString, required = true,
                                 default = nil)
  if valid_564570 != nil:
    section.add "api-version", valid_564570
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Issue Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564571 = header.getOrDefault("If-Match")
  valid_564571 = validateParameter(valid_564571, JString, required = true,
                                 default = nil)
  if valid_564571 != nil:
    section.add "If-Match", valid_564571
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564572: Call_ApiIssueCommentDelete_564561; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified comment from an Issue.
  ## 
  let valid = call_564572.validator(path, query, header, formData, body)
  let scheme = call_564572.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564572.url(scheme.get, call_564572.host, call_564572.base,
                         call_564572.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564572, url, valid)

proc call*(call_564573: Call_ApiIssueCommentDelete_564561; serviceName: string;
          apiVersion: string; apiId: string; issueId: string; subscriptionId: string;
          commentId: string; resourceGroupName: string): Recallable =
  ## apiIssueCommentDelete
  ## Deletes the specified comment from an Issue.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
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
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564574 = newJObject()
  var query_564575 = newJObject()
  add(path_564574, "serviceName", newJString(serviceName))
  add(query_564575, "api-version", newJString(apiVersion))
  add(path_564574, "apiId", newJString(apiId))
  add(path_564574, "issueId", newJString(issueId))
  add(path_564574, "subscriptionId", newJString(subscriptionId))
  add(path_564574, "commentId", newJString(commentId))
  add(path_564574, "resourceGroupName", newJString(resourceGroupName))
  result = call_564573.call(path_564574, query_564575, nil, nil, nil)

var apiIssueCommentDelete* = Call_ApiIssueCommentDelete_564561(
    name: "apiIssueCommentDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/issues/{issueId}/comments/{commentId}",
    validator: validate_ApiIssueCommentDelete_564562, base: "",
    url: url_ApiIssueCommentDelete_564563, schemes: {Scheme.Https})
type
  Call_ApiOperationListByApi_564590 = ref object of OpenApiRestCall_563565
proc url_ApiOperationListByApi_564592(protocol: Scheme; host: string; base: string;
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

proc validate_ApiOperationListByApi_564591(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of the operations for the specified API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564593 = path.getOrDefault("serviceName")
  valid_564593 = validateParameter(valid_564593, JString, required = true,
                                 default = nil)
  if valid_564593 != nil:
    section.add "serviceName", valid_564593
  var valid_564594 = path.getOrDefault("apiId")
  valid_564594 = validateParameter(valid_564594, JString, required = true,
                                 default = nil)
  if valid_564594 != nil:
    section.add "apiId", valid_564594
  var valid_564595 = path.getOrDefault("subscriptionId")
  valid_564595 = validateParameter(valid_564595, JString, required = true,
                                 default = nil)
  if valid_564595 != nil:
    section.add "subscriptionId", valid_564595
  var valid_564596 = path.getOrDefault("resourceGroupName")
  valid_564596 = validateParameter(valid_564596, JString, required = true,
                                 default = nil)
  if valid_564596 != nil:
    section.add "resourceGroupName", valid_564596
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Number of records to return.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
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
  var valid_564597 = query.getOrDefault("$top")
  valid_564597 = validateParameter(valid_564597, JInt, required = false, default = nil)
  if valid_564597 != nil:
    section.add "$top", valid_564597
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564598 = query.getOrDefault("api-version")
  valid_564598 = validateParameter(valid_564598, JString, required = true,
                                 default = nil)
  if valid_564598 != nil:
    section.add "api-version", valid_564598
  var valid_564599 = query.getOrDefault("$skip")
  valid_564599 = validateParameter(valid_564599, JInt, required = false, default = nil)
  if valid_564599 != nil:
    section.add "$skip", valid_564599
  var valid_564600 = query.getOrDefault("$filter")
  valid_564600 = validateParameter(valid_564600, JString, required = false,
                                 default = nil)
  if valid_564600 != nil:
    section.add "$filter", valid_564600
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564601: Call_ApiOperationListByApi_564590; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of the operations for the specified API.
  ## 
  let valid = call_564601.validator(path, query, header, formData, body)
  let scheme = call_564601.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564601.url(scheme.get, call_564601.host, call_564601.base,
                         call_564601.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564601, url, valid)

proc call*(call_564602: Call_ApiOperationListByApi_564590; serviceName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          resourceGroupName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## apiOperationListByApi
  ## Lists a collection of the operations for the specified API.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Top: int
  ##      : Number of records to return.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## | name        | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | method      | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  ## | urlTemplate | ge, le, eq, ne, gt, lt | substringof, startswith, endswith |
  var path_564603 = newJObject()
  var query_564604 = newJObject()
  add(path_564603, "serviceName", newJString(serviceName))
  add(query_564604, "$top", newJInt(Top))
  add(query_564604, "api-version", newJString(apiVersion))
  add(path_564603, "apiId", newJString(apiId))
  add(path_564603, "subscriptionId", newJString(subscriptionId))
  add(query_564604, "$skip", newJInt(Skip))
  add(path_564603, "resourceGroupName", newJString(resourceGroupName))
  add(query_564604, "$filter", newJString(Filter))
  result = call_564602.call(path_564603, query_564604, nil, nil, nil)

var apiOperationListByApi* = Call_ApiOperationListByApi_564590(
    name: "apiOperationListByApi", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations",
    validator: validate_ApiOperationListByApi_564591, base: "",
    url: url_ApiOperationListByApi_564592, schemes: {Scheme.Https})
type
  Call_ApiOperationCreateOrUpdate_564618 = ref object of OpenApiRestCall_563565
proc url_ApiOperationCreateOrUpdate_564620(protocol: Scheme; host: string;
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

proc validate_ApiOperationCreateOrUpdate_564619(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new operation in the API or updates an existing one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564621 = path.getOrDefault("serviceName")
  valid_564621 = validateParameter(valid_564621, JString, required = true,
                                 default = nil)
  if valid_564621 != nil:
    section.add "serviceName", valid_564621
  var valid_564622 = path.getOrDefault("operationId")
  valid_564622 = validateParameter(valid_564622, JString, required = true,
                                 default = nil)
  if valid_564622 != nil:
    section.add "operationId", valid_564622
  var valid_564623 = path.getOrDefault("apiId")
  valid_564623 = validateParameter(valid_564623, JString, required = true,
                                 default = nil)
  if valid_564623 != nil:
    section.add "apiId", valid_564623
  var valid_564624 = path.getOrDefault("subscriptionId")
  valid_564624 = validateParameter(valid_564624, JString, required = true,
                                 default = nil)
  if valid_564624 != nil:
    section.add "subscriptionId", valid_564624
  var valid_564625 = path.getOrDefault("resourceGroupName")
  valid_564625 = validateParameter(valid_564625, JString, required = true,
                                 default = nil)
  if valid_564625 != nil:
    section.add "resourceGroupName", valid_564625
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564626 = query.getOrDefault("api-version")
  valid_564626 = validateParameter(valid_564626, JString, required = true,
                                 default = nil)
  if valid_564626 != nil:
    section.add "api-version", valid_564626
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_564627 = header.getOrDefault("If-Match")
  valid_564627 = validateParameter(valid_564627, JString, required = false,
                                 default = nil)
  if valid_564627 != nil:
    section.add "If-Match", valid_564627
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

proc call*(call_564629: Call_ApiOperationCreateOrUpdate_564618; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new operation in the API or updates an existing one.
  ## 
  let valid = call_564629.validator(path, query, header, formData, body)
  let scheme = call_564629.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564629.url(scheme.get, call_564629.host, call_564629.base,
                         call_564629.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564629, url, valid)

proc call*(call_564630: Call_ApiOperationCreateOrUpdate_564618;
          serviceName: string; apiVersion: string; operationId: string; apiId: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## apiOperationCreateOrUpdate
  ## Creates a new operation in the API or updates an existing one.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  var path_564631 = newJObject()
  var query_564632 = newJObject()
  var body_564633 = newJObject()
  add(path_564631, "serviceName", newJString(serviceName))
  add(query_564632, "api-version", newJString(apiVersion))
  add(path_564631, "operationId", newJString(operationId))
  add(path_564631, "apiId", newJString(apiId))
  add(path_564631, "subscriptionId", newJString(subscriptionId))
  add(path_564631, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564633 = parameters
  result = call_564630.call(path_564631, query_564632, nil, nil, body_564633)

var apiOperationCreateOrUpdate* = Call_ApiOperationCreateOrUpdate_564618(
    name: "apiOperationCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationCreateOrUpdate_564619, base: "",
    url: url_ApiOperationCreateOrUpdate_564620, schemes: {Scheme.Https})
type
  Call_ApiOperationGetEntityTag_564648 = ref object of OpenApiRestCall_563565
proc url_ApiOperationGetEntityTag_564650(protocol: Scheme; host: string;
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

proc validate_ApiOperationGetEntityTag_564649(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the API operation specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564651 = path.getOrDefault("serviceName")
  valid_564651 = validateParameter(valid_564651, JString, required = true,
                                 default = nil)
  if valid_564651 != nil:
    section.add "serviceName", valid_564651
  var valid_564652 = path.getOrDefault("operationId")
  valid_564652 = validateParameter(valid_564652, JString, required = true,
                                 default = nil)
  if valid_564652 != nil:
    section.add "operationId", valid_564652
  var valid_564653 = path.getOrDefault("apiId")
  valid_564653 = validateParameter(valid_564653, JString, required = true,
                                 default = nil)
  if valid_564653 != nil:
    section.add "apiId", valid_564653
  var valid_564654 = path.getOrDefault("subscriptionId")
  valid_564654 = validateParameter(valid_564654, JString, required = true,
                                 default = nil)
  if valid_564654 != nil:
    section.add "subscriptionId", valid_564654
  var valid_564655 = path.getOrDefault("resourceGroupName")
  valid_564655 = validateParameter(valid_564655, JString, required = true,
                                 default = nil)
  if valid_564655 != nil:
    section.add "resourceGroupName", valid_564655
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564656 = query.getOrDefault("api-version")
  valid_564656 = validateParameter(valid_564656, JString, required = true,
                                 default = nil)
  if valid_564656 != nil:
    section.add "api-version", valid_564656
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564657: Call_ApiOperationGetEntityTag_564648; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the API operation specified by its identifier.
  ## 
  let valid = call_564657.validator(path, query, header, formData, body)
  let scheme = call_564657.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564657.url(scheme.get, call_564657.host, call_564657.base,
                         call_564657.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564657, url, valid)

proc call*(call_564658: Call_ApiOperationGetEntityTag_564648; serviceName: string;
          apiVersion: string; operationId: string; apiId: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## apiOperationGetEntityTag
  ## Gets the entity state (Etag) version of the API operation specified by its identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564659 = newJObject()
  var query_564660 = newJObject()
  add(path_564659, "serviceName", newJString(serviceName))
  add(query_564660, "api-version", newJString(apiVersion))
  add(path_564659, "operationId", newJString(operationId))
  add(path_564659, "apiId", newJString(apiId))
  add(path_564659, "subscriptionId", newJString(subscriptionId))
  add(path_564659, "resourceGroupName", newJString(resourceGroupName))
  result = call_564658.call(path_564659, query_564660, nil, nil, nil)

var apiOperationGetEntityTag* = Call_ApiOperationGetEntityTag_564648(
    name: "apiOperationGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationGetEntityTag_564649, base: "",
    url: url_ApiOperationGetEntityTag_564650, schemes: {Scheme.Https})
type
  Call_ApiOperationGet_564605 = ref object of OpenApiRestCall_563565
proc url_ApiOperationGet_564607(protocol: Scheme; host: string; base: string;
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

proc validate_ApiOperationGet_564606(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the details of the API Operation specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564608 = path.getOrDefault("serviceName")
  valid_564608 = validateParameter(valid_564608, JString, required = true,
                                 default = nil)
  if valid_564608 != nil:
    section.add "serviceName", valid_564608
  var valid_564609 = path.getOrDefault("operationId")
  valid_564609 = validateParameter(valid_564609, JString, required = true,
                                 default = nil)
  if valid_564609 != nil:
    section.add "operationId", valid_564609
  var valid_564610 = path.getOrDefault("apiId")
  valid_564610 = validateParameter(valid_564610, JString, required = true,
                                 default = nil)
  if valid_564610 != nil:
    section.add "apiId", valid_564610
  var valid_564611 = path.getOrDefault("subscriptionId")
  valid_564611 = validateParameter(valid_564611, JString, required = true,
                                 default = nil)
  if valid_564611 != nil:
    section.add "subscriptionId", valid_564611
  var valid_564612 = path.getOrDefault("resourceGroupName")
  valid_564612 = validateParameter(valid_564612, JString, required = true,
                                 default = nil)
  if valid_564612 != nil:
    section.add "resourceGroupName", valid_564612
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564613 = query.getOrDefault("api-version")
  valid_564613 = validateParameter(valid_564613, JString, required = true,
                                 default = nil)
  if valid_564613 != nil:
    section.add "api-version", valid_564613
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564614: Call_ApiOperationGet_564605; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the API Operation specified by its identifier.
  ## 
  let valid = call_564614.validator(path, query, header, formData, body)
  let scheme = call_564614.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564614.url(scheme.get, call_564614.host, call_564614.base,
                         call_564614.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564614, url, valid)

proc call*(call_564615: Call_ApiOperationGet_564605; serviceName: string;
          apiVersion: string; operationId: string; apiId: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## apiOperationGet
  ## Gets the details of the API Operation specified by its identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564616 = newJObject()
  var query_564617 = newJObject()
  add(path_564616, "serviceName", newJString(serviceName))
  add(query_564617, "api-version", newJString(apiVersion))
  add(path_564616, "operationId", newJString(operationId))
  add(path_564616, "apiId", newJString(apiId))
  add(path_564616, "subscriptionId", newJString(subscriptionId))
  add(path_564616, "resourceGroupName", newJString(resourceGroupName))
  result = call_564615.call(path_564616, query_564617, nil, nil, nil)

var apiOperationGet* = Call_ApiOperationGet_564605(name: "apiOperationGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationGet_564606, base: "", url: url_ApiOperationGet_564607,
    schemes: {Scheme.Https})
type
  Call_ApiOperationUpdate_564661 = ref object of OpenApiRestCall_563565
proc url_ApiOperationUpdate_564663(protocol: Scheme; host: string; base: string;
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

proc validate_ApiOperationUpdate_564662(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the details of the operation in the API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564664 = path.getOrDefault("serviceName")
  valid_564664 = validateParameter(valid_564664, JString, required = true,
                                 default = nil)
  if valid_564664 != nil:
    section.add "serviceName", valid_564664
  var valid_564665 = path.getOrDefault("operationId")
  valid_564665 = validateParameter(valid_564665, JString, required = true,
                                 default = nil)
  if valid_564665 != nil:
    section.add "operationId", valid_564665
  var valid_564666 = path.getOrDefault("apiId")
  valid_564666 = validateParameter(valid_564666, JString, required = true,
                                 default = nil)
  if valid_564666 != nil:
    section.add "apiId", valid_564666
  var valid_564667 = path.getOrDefault("subscriptionId")
  valid_564667 = validateParameter(valid_564667, JString, required = true,
                                 default = nil)
  if valid_564667 != nil:
    section.add "subscriptionId", valid_564667
  var valid_564668 = path.getOrDefault("resourceGroupName")
  valid_564668 = validateParameter(valid_564668, JString, required = true,
                                 default = nil)
  if valid_564668 != nil:
    section.add "resourceGroupName", valid_564668
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564669 = query.getOrDefault("api-version")
  valid_564669 = validateParameter(valid_564669, JString, required = true,
                                 default = nil)
  if valid_564669 != nil:
    section.add "api-version", valid_564669
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564670 = header.getOrDefault("If-Match")
  valid_564670 = validateParameter(valid_564670, JString, required = true,
                                 default = nil)
  if valid_564670 != nil:
    section.add "If-Match", valid_564670
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

proc call*(call_564672: Call_ApiOperationUpdate_564661; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the operation in the API specified by its identifier.
  ## 
  let valid = call_564672.validator(path, query, header, formData, body)
  let scheme = call_564672.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564672.url(scheme.get, call_564672.host, call_564672.base,
                         call_564672.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564672, url, valid)

proc call*(call_564673: Call_ApiOperationUpdate_564661; serviceName: string;
          apiVersion: string; operationId: string; apiId: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## apiOperationUpdate
  ## Updates the details of the operation in the API specified by its identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : API Operation Update parameters.
  var path_564674 = newJObject()
  var query_564675 = newJObject()
  var body_564676 = newJObject()
  add(path_564674, "serviceName", newJString(serviceName))
  add(query_564675, "api-version", newJString(apiVersion))
  add(path_564674, "operationId", newJString(operationId))
  add(path_564674, "apiId", newJString(apiId))
  add(path_564674, "subscriptionId", newJString(subscriptionId))
  add(path_564674, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564676 = parameters
  result = call_564673.call(path_564674, query_564675, nil, nil, body_564676)

var apiOperationUpdate* = Call_ApiOperationUpdate_564661(
    name: "apiOperationUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationUpdate_564662, base: "",
    url: url_ApiOperationUpdate_564663, schemes: {Scheme.Https})
type
  Call_ApiOperationDelete_564634 = ref object of OpenApiRestCall_563565
proc url_ApiOperationDelete_564636(protocol: Scheme; host: string; base: string;
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

proc validate_ApiOperationDelete_564635(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the specified operation in the API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564637 = path.getOrDefault("serviceName")
  valid_564637 = validateParameter(valid_564637, JString, required = true,
                                 default = nil)
  if valid_564637 != nil:
    section.add "serviceName", valid_564637
  var valid_564638 = path.getOrDefault("operationId")
  valid_564638 = validateParameter(valid_564638, JString, required = true,
                                 default = nil)
  if valid_564638 != nil:
    section.add "operationId", valid_564638
  var valid_564639 = path.getOrDefault("apiId")
  valid_564639 = validateParameter(valid_564639, JString, required = true,
                                 default = nil)
  if valid_564639 != nil:
    section.add "apiId", valid_564639
  var valid_564640 = path.getOrDefault("subscriptionId")
  valid_564640 = validateParameter(valid_564640, JString, required = true,
                                 default = nil)
  if valid_564640 != nil:
    section.add "subscriptionId", valid_564640
  var valid_564641 = path.getOrDefault("resourceGroupName")
  valid_564641 = validateParameter(valid_564641, JString, required = true,
                                 default = nil)
  if valid_564641 != nil:
    section.add "resourceGroupName", valid_564641
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564642 = query.getOrDefault("api-version")
  valid_564642 = validateParameter(valid_564642, JString, required = true,
                                 default = nil)
  if valid_564642 != nil:
    section.add "api-version", valid_564642
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564643 = header.getOrDefault("If-Match")
  valid_564643 = validateParameter(valid_564643, JString, required = true,
                                 default = nil)
  if valid_564643 != nil:
    section.add "If-Match", valid_564643
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564644: Call_ApiOperationDelete_564634; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified operation in the API.
  ## 
  let valid = call_564644.validator(path, query, header, formData, body)
  let scheme = call_564644.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564644.url(scheme.get, call_564644.host, call_564644.base,
                         call_564644.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564644, url, valid)

proc call*(call_564645: Call_ApiOperationDelete_564634; serviceName: string;
          apiVersion: string; operationId: string; apiId: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## apiOperationDelete
  ## Deletes the specified operation in the API.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564646 = newJObject()
  var query_564647 = newJObject()
  add(path_564646, "serviceName", newJString(serviceName))
  add(query_564647, "api-version", newJString(apiVersion))
  add(path_564646, "operationId", newJString(operationId))
  add(path_564646, "apiId", newJString(apiId))
  add(path_564646, "subscriptionId", newJString(subscriptionId))
  add(path_564646, "resourceGroupName", newJString(resourceGroupName))
  result = call_564645.call(path_564646, query_564647, nil, nil, nil)

var apiOperationDelete* = Call_ApiOperationDelete_564634(
    name: "apiOperationDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}",
    validator: validate_ApiOperationDelete_564635, base: "",
    url: url_ApiOperationDelete_564636, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyListByOperation_564677 = ref object of OpenApiRestCall_563565
proc url_ApiOperationPolicyListByOperation_564679(protocol: Scheme; host: string;
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

proc validate_ApiOperationPolicyListByOperation_564678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of policy configuration at the API Operation level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564680 = path.getOrDefault("serviceName")
  valid_564680 = validateParameter(valid_564680, JString, required = true,
                                 default = nil)
  if valid_564680 != nil:
    section.add "serviceName", valid_564680
  var valid_564681 = path.getOrDefault("operationId")
  valid_564681 = validateParameter(valid_564681, JString, required = true,
                                 default = nil)
  if valid_564681 != nil:
    section.add "operationId", valid_564681
  var valid_564682 = path.getOrDefault("apiId")
  valid_564682 = validateParameter(valid_564682, JString, required = true,
                                 default = nil)
  if valid_564682 != nil:
    section.add "apiId", valid_564682
  var valid_564683 = path.getOrDefault("subscriptionId")
  valid_564683 = validateParameter(valid_564683, JString, required = true,
                                 default = nil)
  if valid_564683 != nil:
    section.add "subscriptionId", valid_564683
  var valid_564684 = path.getOrDefault("resourceGroupName")
  valid_564684 = validateParameter(valid_564684, JString, required = true,
                                 default = nil)
  if valid_564684 != nil:
    section.add "resourceGroupName", valid_564684
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564685 = query.getOrDefault("api-version")
  valid_564685 = validateParameter(valid_564685, JString, required = true,
                                 default = nil)
  if valid_564685 != nil:
    section.add "api-version", valid_564685
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564686: Call_ApiOperationPolicyListByOperation_564677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the list of policy configuration at the API Operation level.
  ## 
  let valid = call_564686.validator(path, query, header, formData, body)
  let scheme = call_564686.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564686.url(scheme.get, call_564686.host, call_564686.base,
                         call_564686.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564686, url, valid)

proc call*(call_564687: Call_ApiOperationPolicyListByOperation_564677;
          serviceName: string; apiVersion: string; operationId: string; apiId: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## apiOperationPolicyListByOperation
  ## Get the list of policy configuration at the API Operation level.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564688 = newJObject()
  var query_564689 = newJObject()
  add(path_564688, "serviceName", newJString(serviceName))
  add(query_564689, "api-version", newJString(apiVersion))
  add(path_564688, "operationId", newJString(operationId))
  add(path_564688, "apiId", newJString(apiId))
  add(path_564688, "subscriptionId", newJString(subscriptionId))
  add(path_564688, "resourceGroupName", newJString(resourceGroupName))
  result = call_564687.call(path_564688, query_564689, nil, nil, nil)

var apiOperationPolicyListByOperation* = Call_ApiOperationPolicyListByOperation_564677(
    name: "apiOperationPolicyListByOperation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/policies",
    validator: validate_ApiOperationPolicyListByOperation_564678, base: "",
    url: url_ApiOperationPolicyListByOperation_564679, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyCreateOrUpdate_564704 = ref object of OpenApiRestCall_563565
proc url_ApiOperationPolicyCreateOrUpdate_564706(protocol: Scheme; host: string;
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

proc validate_ApiOperationPolicyCreateOrUpdate_564705(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates policy configuration for the API Operation level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564707 = path.getOrDefault("serviceName")
  valid_564707 = validateParameter(valid_564707, JString, required = true,
                                 default = nil)
  if valid_564707 != nil:
    section.add "serviceName", valid_564707
  var valid_564708 = path.getOrDefault("operationId")
  valid_564708 = validateParameter(valid_564708, JString, required = true,
                                 default = nil)
  if valid_564708 != nil:
    section.add "operationId", valid_564708
  var valid_564709 = path.getOrDefault("apiId")
  valid_564709 = validateParameter(valid_564709, JString, required = true,
                                 default = nil)
  if valid_564709 != nil:
    section.add "apiId", valid_564709
  var valid_564710 = path.getOrDefault("subscriptionId")
  valid_564710 = validateParameter(valid_564710, JString, required = true,
                                 default = nil)
  if valid_564710 != nil:
    section.add "subscriptionId", valid_564710
  var valid_564711 = path.getOrDefault("policyId")
  valid_564711 = validateParameter(valid_564711, JString, required = true,
                                 default = newJString("policy"))
  if valid_564711 != nil:
    section.add "policyId", valid_564711
  var valid_564712 = path.getOrDefault("resourceGroupName")
  valid_564712 = validateParameter(valid_564712, JString, required = true,
                                 default = nil)
  if valid_564712 != nil:
    section.add "resourceGroupName", valid_564712
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564713 = query.getOrDefault("api-version")
  valid_564713 = validateParameter(valid_564713, JString, required = true,
                                 default = nil)
  if valid_564713 != nil:
    section.add "api-version", valid_564713
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_564714 = header.getOrDefault("If-Match")
  valid_564714 = validateParameter(valid_564714, JString, required = false,
                                 default = nil)
  if valid_564714 != nil:
    section.add "If-Match", valid_564714
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

proc call*(call_564716: Call_ApiOperationPolicyCreateOrUpdate_564704;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates policy configuration for the API Operation level.
  ## 
  let valid = call_564716.validator(path, query, header, formData, body)
  let scheme = call_564716.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564716.url(scheme.get, call_564716.host, call_564716.base,
                         call_564716.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564716, url, valid)

proc call*(call_564717: Call_ApiOperationPolicyCreateOrUpdate_564704;
          serviceName: string; apiVersion: string; operationId: string; apiId: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode;
          policyId: string = "policy"): Recallable =
  ## apiOperationPolicyCreateOrUpdate
  ## Creates or updates policy configuration for the API Operation level.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : The policy contents to apply.
  var path_564718 = newJObject()
  var query_564719 = newJObject()
  var body_564720 = newJObject()
  add(path_564718, "serviceName", newJString(serviceName))
  add(query_564719, "api-version", newJString(apiVersion))
  add(path_564718, "operationId", newJString(operationId))
  add(path_564718, "apiId", newJString(apiId))
  add(path_564718, "subscriptionId", newJString(subscriptionId))
  add(path_564718, "policyId", newJString(policyId))
  add(path_564718, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564720 = parameters
  result = call_564717.call(path_564718, query_564719, nil, nil, body_564720)

var apiOperationPolicyCreateOrUpdate* = Call_ApiOperationPolicyCreateOrUpdate_564704(
    name: "apiOperationPolicyCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/policies/{policyId}",
    validator: validate_ApiOperationPolicyCreateOrUpdate_564705, base: "",
    url: url_ApiOperationPolicyCreateOrUpdate_564706, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyGetEntityTag_564736 = ref object of OpenApiRestCall_563565
proc url_ApiOperationPolicyGetEntityTag_564738(protocol: Scheme; host: string;
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

proc validate_ApiOperationPolicyGetEntityTag_564737(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the API operation policy specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564739 = path.getOrDefault("serviceName")
  valid_564739 = validateParameter(valid_564739, JString, required = true,
                                 default = nil)
  if valid_564739 != nil:
    section.add "serviceName", valid_564739
  var valid_564740 = path.getOrDefault("operationId")
  valid_564740 = validateParameter(valid_564740, JString, required = true,
                                 default = nil)
  if valid_564740 != nil:
    section.add "operationId", valid_564740
  var valid_564741 = path.getOrDefault("apiId")
  valid_564741 = validateParameter(valid_564741, JString, required = true,
                                 default = nil)
  if valid_564741 != nil:
    section.add "apiId", valid_564741
  var valid_564742 = path.getOrDefault("subscriptionId")
  valid_564742 = validateParameter(valid_564742, JString, required = true,
                                 default = nil)
  if valid_564742 != nil:
    section.add "subscriptionId", valid_564742
  var valid_564743 = path.getOrDefault("policyId")
  valid_564743 = validateParameter(valid_564743, JString, required = true,
                                 default = newJString("policy"))
  if valid_564743 != nil:
    section.add "policyId", valid_564743
  var valid_564744 = path.getOrDefault("resourceGroupName")
  valid_564744 = validateParameter(valid_564744, JString, required = true,
                                 default = nil)
  if valid_564744 != nil:
    section.add "resourceGroupName", valid_564744
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564745 = query.getOrDefault("api-version")
  valid_564745 = validateParameter(valid_564745, JString, required = true,
                                 default = nil)
  if valid_564745 != nil:
    section.add "api-version", valid_564745
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564746: Call_ApiOperationPolicyGetEntityTag_564736; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the API operation policy specified by its identifier.
  ## 
  let valid = call_564746.validator(path, query, header, formData, body)
  let scheme = call_564746.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564746.url(scheme.get, call_564746.host, call_564746.base,
                         call_564746.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564746, url, valid)

proc call*(call_564747: Call_ApiOperationPolicyGetEntityTag_564736;
          serviceName: string; apiVersion: string; operationId: string; apiId: string;
          subscriptionId: string; resourceGroupName: string;
          policyId: string = "policy"): Recallable =
  ## apiOperationPolicyGetEntityTag
  ## Gets the entity state (Etag) version of the API operation policy specified by its identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564748 = newJObject()
  var query_564749 = newJObject()
  add(path_564748, "serviceName", newJString(serviceName))
  add(query_564749, "api-version", newJString(apiVersion))
  add(path_564748, "operationId", newJString(operationId))
  add(path_564748, "apiId", newJString(apiId))
  add(path_564748, "subscriptionId", newJString(subscriptionId))
  add(path_564748, "policyId", newJString(policyId))
  add(path_564748, "resourceGroupName", newJString(resourceGroupName))
  result = call_564747.call(path_564748, query_564749, nil, nil, nil)

var apiOperationPolicyGetEntityTag* = Call_ApiOperationPolicyGetEntityTag_564736(
    name: "apiOperationPolicyGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/policies/{policyId}",
    validator: validate_ApiOperationPolicyGetEntityTag_564737, base: "",
    url: url_ApiOperationPolicyGetEntityTag_564738, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyGet_564690 = ref object of OpenApiRestCall_563565
proc url_ApiOperationPolicyGet_564692(protocol: Scheme; host: string; base: string;
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

proc validate_ApiOperationPolicyGet_564691(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the policy configuration at the API Operation level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564693 = path.getOrDefault("serviceName")
  valid_564693 = validateParameter(valid_564693, JString, required = true,
                                 default = nil)
  if valid_564693 != nil:
    section.add "serviceName", valid_564693
  var valid_564694 = path.getOrDefault("operationId")
  valid_564694 = validateParameter(valid_564694, JString, required = true,
                                 default = nil)
  if valid_564694 != nil:
    section.add "operationId", valid_564694
  var valid_564695 = path.getOrDefault("apiId")
  valid_564695 = validateParameter(valid_564695, JString, required = true,
                                 default = nil)
  if valid_564695 != nil:
    section.add "apiId", valid_564695
  var valid_564696 = path.getOrDefault("subscriptionId")
  valid_564696 = validateParameter(valid_564696, JString, required = true,
                                 default = nil)
  if valid_564696 != nil:
    section.add "subscriptionId", valid_564696
  var valid_564697 = path.getOrDefault("policyId")
  valid_564697 = validateParameter(valid_564697, JString, required = true,
                                 default = newJString("policy"))
  if valid_564697 != nil:
    section.add "policyId", valid_564697
  var valid_564698 = path.getOrDefault("resourceGroupName")
  valid_564698 = validateParameter(valid_564698, JString, required = true,
                                 default = nil)
  if valid_564698 != nil:
    section.add "resourceGroupName", valid_564698
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564699 = query.getOrDefault("api-version")
  valid_564699 = validateParameter(valid_564699, JString, required = true,
                                 default = nil)
  if valid_564699 != nil:
    section.add "api-version", valid_564699
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564700: Call_ApiOperationPolicyGet_564690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the API Operation level.
  ## 
  let valid = call_564700.validator(path, query, header, formData, body)
  let scheme = call_564700.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564700.url(scheme.get, call_564700.host, call_564700.base,
                         call_564700.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564700, url, valid)

proc call*(call_564701: Call_ApiOperationPolicyGet_564690; serviceName: string;
          apiVersion: string; operationId: string; apiId: string;
          subscriptionId: string; resourceGroupName: string;
          policyId: string = "policy"): Recallable =
  ## apiOperationPolicyGet
  ## Get the policy configuration at the API Operation level.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564702 = newJObject()
  var query_564703 = newJObject()
  add(path_564702, "serviceName", newJString(serviceName))
  add(query_564703, "api-version", newJString(apiVersion))
  add(path_564702, "operationId", newJString(operationId))
  add(path_564702, "apiId", newJString(apiId))
  add(path_564702, "subscriptionId", newJString(subscriptionId))
  add(path_564702, "policyId", newJString(policyId))
  add(path_564702, "resourceGroupName", newJString(resourceGroupName))
  result = call_564701.call(path_564702, query_564703, nil, nil, nil)

var apiOperationPolicyGet* = Call_ApiOperationPolicyGet_564690(
    name: "apiOperationPolicyGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/policies/{policyId}",
    validator: validate_ApiOperationPolicyGet_564691, base: "",
    url: url_ApiOperationPolicyGet_564692, schemes: {Scheme.Https})
type
  Call_ApiOperationPolicyDelete_564721 = ref object of OpenApiRestCall_563565
proc url_ApiOperationPolicyDelete_564723(protocol: Scheme; host: string;
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

proc validate_ApiOperationPolicyDelete_564722(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the policy configuration at the Api Operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   operationId: JString (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564724 = path.getOrDefault("serviceName")
  valid_564724 = validateParameter(valid_564724, JString, required = true,
                                 default = nil)
  if valid_564724 != nil:
    section.add "serviceName", valid_564724
  var valid_564725 = path.getOrDefault("operationId")
  valid_564725 = validateParameter(valid_564725, JString, required = true,
                                 default = nil)
  if valid_564725 != nil:
    section.add "operationId", valid_564725
  var valid_564726 = path.getOrDefault("apiId")
  valid_564726 = validateParameter(valid_564726, JString, required = true,
                                 default = nil)
  if valid_564726 != nil:
    section.add "apiId", valid_564726
  var valid_564727 = path.getOrDefault("subscriptionId")
  valid_564727 = validateParameter(valid_564727, JString, required = true,
                                 default = nil)
  if valid_564727 != nil:
    section.add "subscriptionId", valid_564727
  var valid_564728 = path.getOrDefault("policyId")
  valid_564728 = validateParameter(valid_564728, JString, required = true,
                                 default = newJString("policy"))
  if valid_564728 != nil:
    section.add "policyId", valid_564728
  var valid_564729 = path.getOrDefault("resourceGroupName")
  valid_564729 = validateParameter(valid_564729, JString, required = true,
                                 default = nil)
  if valid_564729 != nil:
    section.add "resourceGroupName", valid_564729
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564730 = query.getOrDefault("api-version")
  valid_564730 = validateParameter(valid_564730, JString, required = true,
                                 default = nil)
  if valid_564730 != nil:
    section.add "api-version", valid_564730
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564731 = header.getOrDefault("If-Match")
  valid_564731 = validateParameter(valid_564731, JString, required = true,
                                 default = nil)
  if valid_564731 != nil:
    section.add "If-Match", valid_564731
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564732: Call_ApiOperationPolicyDelete_564721; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the policy configuration at the Api Operation.
  ## 
  let valid = call_564732.validator(path, query, header, formData, body)
  let scheme = call_564732.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564732.url(scheme.get, call_564732.host, call_564732.base,
                         call_564732.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564732, url, valid)

proc call*(call_564733: Call_ApiOperationPolicyDelete_564721; serviceName: string;
          apiVersion: string; operationId: string; apiId: string;
          subscriptionId: string; resourceGroupName: string;
          policyId: string = "policy"): Recallable =
  ## apiOperationPolicyDelete
  ## Deletes the policy configuration at the Api Operation.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   operationId: string (required)
  ##              : Operation identifier within an API. Must be unique in the current API Management service instance.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564734 = newJObject()
  var query_564735 = newJObject()
  add(path_564734, "serviceName", newJString(serviceName))
  add(query_564735, "api-version", newJString(apiVersion))
  add(path_564734, "operationId", newJString(operationId))
  add(path_564734, "apiId", newJString(apiId))
  add(path_564734, "subscriptionId", newJString(subscriptionId))
  add(path_564734, "policyId", newJString(policyId))
  add(path_564734, "resourceGroupName", newJString(resourceGroupName))
  result = call_564733.call(path_564734, query_564735, nil, nil, nil)

var apiOperationPolicyDelete* = Call_ApiOperationPolicyDelete_564721(
    name: "apiOperationPolicyDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/operations/{operationId}/policies/{policyId}",
    validator: validate_ApiOperationPolicyDelete_564722, base: "",
    url: url_ApiOperationPolicyDelete_564723, schemes: {Scheme.Https})
type
  Call_ApiPolicyListByApi_564750 = ref object of OpenApiRestCall_563565
proc url_ApiPolicyListByApi_564752(protocol: Scheme; host: string; base: string;
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

proc validate_ApiPolicyListByApi_564751(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the policy configuration at the API level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564753 = path.getOrDefault("serviceName")
  valid_564753 = validateParameter(valid_564753, JString, required = true,
                                 default = nil)
  if valid_564753 != nil:
    section.add "serviceName", valid_564753
  var valid_564754 = path.getOrDefault("apiId")
  valid_564754 = validateParameter(valid_564754, JString, required = true,
                                 default = nil)
  if valid_564754 != nil:
    section.add "apiId", valid_564754
  var valid_564755 = path.getOrDefault("subscriptionId")
  valid_564755 = validateParameter(valid_564755, JString, required = true,
                                 default = nil)
  if valid_564755 != nil:
    section.add "subscriptionId", valid_564755
  var valid_564756 = path.getOrDefault("resourceGroupName")
  valid_564756 = validateParameter(valid_564756, JString, required = true,
                                 default = nil)
  if valid_564756 != nil:
    section.add "resourceGroupName", valid_564756
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564757 = query.getOrDefault("api-version")
  valid_564757 = validateParameter(valid_564757, JString, required = true,
                                 default = nil)
  if valid_564757 != nil:
    section.add "api-version", valid_564757
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564758: Call_ApiPolicyListByApi_564750; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the API level.
  ## 
  let valid = call_564758.validator(path, query, header, formData, body)
  let scheme = call_564758.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564758.url(scheme.get, call_564758.host, call_564758.base,
                         call_564758.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564758, url, valid)

proc call*(call_564759: Call_ApiPolicyListByApi_564750; serviceName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## apiPolicyListByApi
  ## Get the policy configuration at the API level.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564760 = newJObject()
  var query_564761 = newJObject()
  add(path_564760, "serviceName", newJString(serviceName))
  add(query_564761, "api-version", newJString(apiVersion))
  add(path_564760, "apiId", newJString(apiId))
  add(path_564760, "subscriptionId", newJString(subscriptionId))
  add(path_564760, "resourceGroupName", newJString(resourceGroupName))
  result = call_564759.call(path_564760, query_564761, nil, nil, nil)

var apiPolicyListByApi* = Call_ApiPolicyListByApi_564750(
    name: "apiPolicyListByApi", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies",
    validator: validate_ApiPolicyListByApi_564751, base: "",
    url: url_ApiPolicyListByApi_564752, schemes: {Scheme.Https})
type
  Call_ApiPolicyCreateOrUpdate_564775 = ref object of OpenApiRestCall_563565
proc url_ApiPolicyCreateOrUpdate_564777(protocol: Scheme; host: string; base: string;
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

proc validate_ApiPolicyCreateOrUpdate_564776(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates policy configuration for the API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564778 = path.getOrDefault("serviceName")
  valid_564778 = validateParameter(valid_564778, JString, required = true,
                                 default = nil)
  if valid_564778 != nil:
    section.add "serviceName", valid_564778
  var valid_564779 = path.getOrDefault("apiId")
  valid_564779 = validateParameter(valid_564779, JString, required = true,
                                 default = nil)
  if valid_564779 != nil:
    section.add "apiId", valid_564779
  var valid_564780 = path.getOrDefault("subscriptionId")
  valid_564780 = validateParameter(valid_564780, JString, required = true,
                                 default = nil)
  if valid_564780 != nil:
    section.add "subscriptionId", valid_564780
  var valid_564781 = path.getOrDefault("policyId")
  valid_564781 = validateParameter(valid_564781, JString, required = true,
                                 default = newJString("policy"))
  if valid_564781 != nil:
    section.add "policyId", valid_564781
  var valid_564782 = path.getOrDefault("resourceGroupName")
  valid_564782 = validateParameter(valid_564782, JString, required = true,
                                 default = nil)
  if valid_564782 != nil:
    section.add "resourceGroupName", valid_564782
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564783 = query.getOrDefault("api-version")
  valid_564783 = validateParameter(valid_564783, JString, required = true,
                                 default = nil)
  if valid_564783 != nil:
    section.add "api-version", valid_564783
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_564784 = header.getOrDefault("If-Match")
  valid_564784 = validateParameter(valid_564784, JString, required = false,
                                 default = nil)
  if valid_564784 != nil:
    section.add "If-Match", valid_564784
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

proc call*(call_564786: Call_ApiPolicyCreateOrUpdate_564775; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates policy configuration for the API.
  ## 
  let valid = call_564786.validator(path, query, header, formData, body)
  let scheme = call_564786.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564786.url(scheme.get, call_564786.host, call_564786.base,
                         call_564786.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564786, url, valid)

proc call*(call_564787: Call_ApiPolicyCreateOrUpdate_564775; serviceName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode;
          policyId: string = "policy"): Recallable =
  ## apiPolicyCreateOrUpdate
  ## Creates or updates policy configuration for the API.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : The policy contents to apply.
  var path_564788 = newJObject()
  var query_564789 = newJObject()
  var body_564790 = newJObject()
  add(path_564788, "serviceName", newJString(serviceName))
  add(query_564789, "api-version", newJString(apiVersion))
  add(path_564788, "apiId", newJString(apiId))
  add(path_564788, "subscriptionId", newJString(subscriptionId))
  add(path_564788, "policyId", newJString(policyId))
  add(path_564788, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564790 = parameters
  result = call_564787.call(path_564788, query_564789, nil, nil, body_564790)

var apiPolicyCreateOrUpdate* = Call_ApiPolicyCreateOrUpdate_564775(
    name: "apiPolicyCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}",
    validator: validate_ApiPolicyCreateOrUpdate_564776, base: "",
    url: url_ApiPolicyCreateOrUpdate_564777, schemes: {Scheme.Https})
type
  Call_ApiPolicyGetEntityTag_564805 = ref object of OpenApiRestCall_563565
proc url_ApiPolicyGetEntityTag_564807(protocol: Scheme; host: string; base: string;
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

proc validate_ApiPolicyGetEntityTag_564806(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the API policy specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564808 = path.getOrDefault("serviceName")
  valid_564808 = validateParameter(valid_564808, JString, required = true,
                                 default = nil)
  if valid_564808 != nil:
    section.add "serviceName", valid_564808
  var valid_564809 = path.getOrDefault("apiId")
  valid_564809 = validateParameter(valid_564809, JString, required = true,
                                 default = nil)
  if valid_564809 != nil:
    section.add "apiId", valid_564809
  var valid_564810 = path.getOrDefault("subscriptionId")
  valid_564810 = validateParameter(valid_564810, JString, required = true,
                                 default = nil)
  if valid_564810 != nil:
    section.add "subscriptionId", valid_564810
  var valid_564811 = path.getOrDefault("policyId")
  valid_564811 = validateParameter(valid_564811, JString, required = true,
                                 default = newJString("policy"))
  if valid_564811 != nil:
    section.add "policyId", valid_564811
  var valid_564812 = path.getOrDefault("resourceGroupName")
  valid_564812 = validateParameter(valid_564812, JString, required = true,
                                 default = nil)
  if valid_564812 != nil:
    section.add "resourceGroupName", valid_564812
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564813 = query.getOrDefault("api-version")
  valid_564813 = validateParameter(valid_564813, JString, required = true,
                                 default = nil)
  if valid_564813 != nil:
    section.add "api-version", valid_564813
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564814: Call_ApiPolicyGetEntityTag_564805; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the API policy specified by its identifier.
  ## 
  let valid = call_564814.validator(path, query, header, formData, body)
  let scheme = call_564814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564814.url(scheme.get, call_564814.host, call_564814.base,
                         call_564814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564814, url, valid)

proc call*(call_564815: Call_ApiPolicyGetEntityTag_564805; serviceName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          resourceGroupName: string; policyId: string = "policy"): Recallable =
  ## apiPolicyGetEntityTag
  ## Gets the entity state (Etag) version of the API policy specified by its identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564816 = newJObject()
  var query_564817 = newJObject()
  add(path_564816, "serviceName", newJString(serviceName))
  add(query_564817, "api-version", newJString(apiVersion))
  add(path_564816, "apiId", newJString(apiId))
  add(path_564816, "subscriptionId", newJString(subscriptionId))
  add(path_564816, "policyId", newJString(policyId))
  add(path_564816, "resourceGroupName", newJString(resourceGroupName))
  result = call_564815.call(path_564816, query_564817, nil, nil, nil)

var apiPolicyGetEntityTag* = Call_ApiPolicyGetEntityTag_564805(
    name: "apiPolicyGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}",
    validator: validate_ApiPolicyGetEntityTag_564806, base: "",
    url: url_ApiPolicyGetEntityTag_564807, schemes: {Scheme.Https})
type
  Call_ApiPolicyGet_564762 = ref object of OpenApiRestCall_563565
proc url_ApiPolicyGet_564764(protocol: Scheme; host: string; base: string;
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

proc validate_ApiPolicyGet_564763(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the policy configuration at the API level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564765 = path.getOrDefault("serviceName")
  valid_564765 = validateParameter(valid_564765, JString, required = true,
                                 default = nil)
  if valid_564765 != nil:
    section.add "serviceName", valid_564765
  var valid_564766 = path.getOrDefault("apiId")
  valid_564766 = validateParameter(valid_564766, JString, required = true,
                                 default = nil)
  if valid_564766 != nil:
    section.add "apiId", valid_564766
  var valid_564767 = path.getOrDefault("subscriptionId")
  valid_564767 = validateParameter(valid_564767, JString, required = true,
                                 default = nil)
  if valid_564767 != nil:
    section.add "subscriptionId", valid_564767
  var valid_564768 = path.getOrDefault("policyId")
  valid_564768 = validateParameter(valid_564768, JString, required = true,
                                 default = newJString("policy"))
  if valid_564768 != nil:
    section.add "policyId", valid_564768
  var valid_564769 = path.getOrDefault("resourceGroupName")
  valid_564769 = validateParameter(valid_564769, JString, required = true,
                                 default = nil)
  if valid_564769 != nil:
    section.add "resourceGroupName", valid_564769
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564770 = query.getOrDefault("api-version")
  valid_564770 = validateParameter(valid_564770, JString, required = true,
                                 default = nil)
  if valid_564770 != nil:
    section.add "api-version", valid_564770
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564771: Call_ApiPolicyGet_564762; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the policy configuration at the API level.
  ## 
  let valid = call_564771.validator(path, query, header, formData, body)
  let scheme = call_564771.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564771.url(scheme.get, call_564771.host, call_564771.base,
                         call_564771.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564771, url, valid)

proc call*(call_564772: Call_ApiPolicyGet_564762; serviceName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          resourceGroupName: string; policyId: string = "policy"): Recallable =
  ## apiPolicyGet
  ## Get the policy configuration at the API level.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564773 = newJObject()
  var query_564774 = newJObject()
  add(path_564773, "serviceName", newJString(serviceName))
  add(query_564774, "api-version", newJString(apiVersion))
  add(path_564773, "apiId", newJString(apiId))
  add(path_564773, "subscriptionId", newJString(subscriptionId))
  add(path_564773, "policyId", newJString(policyId))
  add(path_564773, "resourceGroupName", newJString(resourceGroupName))
  result = call_564772.call(path_564773, query_564774, nil, nil, nil)

var apiPolicyGet* = Call_ApiPolicyGet_564762(name: "apiPolicyGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}",
    validator: validate_ApiPolicyGet_564763, base: "", url: url_ApiPolicyGet_564764,
    schemes: {Scheme.Https})
type
  Call_ApiPolicyDelete_564791 = ref object of OpenApiRestCall_563565
proc url_ApiPolicyDelete_564793(protocol: Scheme; host: string; base: string;
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

proc validate_ApiPolicyDelete_564792(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes the policy configuration at the Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: JString (required)
  ##           : The identifier of the Policy.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564794 = path.getOrDefault("serviceName")
  valid_564794 = validateParameter(valid_564794, JString, required = true,
                                 default = nil)
  if valid_564794 != nil:
    section.add "serviceName", valid_564794
  var valid_564795 = path.getOrDefault("apiId")
  valid_564795 = validateParameter(valid_564795, JString, required = true,
                                 default = nil)
  if valid_564795 != nil:
    section.add "apiId", valid_564795
  var valid_564796 = path.getOrDefault("subscriptionId")
  valid_564796 = validateParameter(valid_564796, JString, required = true,
                                 default = nil)
  if valid_564796 != nil:
    section.add "subscriptionId", valid_564796
  var valid_564797 = path.getOrDefault("policyId")
  valid_564797 = validateParameter(valid_564797, JString, required = true,
                                 default = newJString("policy"))
  if valid_564797 != nil:
    section.add "policyId", valid_564797
  var valid_564798 = path.getOrDefault("resourceGroupName")
  valid_564798 = validateParameter(valid_564798, JString, required = true,
                                 default = nil)
  if valid_564798 != nil:
    section.add "resourceGroupName", valid_564798
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564799 = query.getOrDefault("api-version")
  valid_564799 = validateParameter(valid_564799, JString, required = true,
                                 default = nil)
  if valid_564799 != nil:
    section.add "api-version", valid_564799
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564800 = header.getOrDefault("If-Match")
  valid_564800 = validateParameter(valid_564800, JString, required = true,
                                 default = nil)
  if valid_564800 != nil:
    section.add "If-Match", valid_564800
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564801: Call_ApiPolicyDelete_564791; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the policy configuration at the Api.
  ## 
  let valid = call_564801.validator(path, query, header, formData, body)
  let scheme = call_564801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564801.url(scheme.get, call_564801.host, call_564801.base,
                         call_564801.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564801, url, valid)

proc call*(call_564802: Call_ApiPolicyDelete_564791; serviceName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          resourceGroupName: string; policyId: string = "policy"): Recallable =
  ## apiPolicyDelete
  ## Deletes the policy configuration at the Api.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   policyId: string (required)
  ##           : The identifier of the Policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564803 = newJObject()
  var query_564804 = newJObject()
  add(path_564803, "serviceName", newJString(serviceName))
  add(query_564804, "api-version", newJString(apiVersion))
  add(path_564803, "apiId", newJString(apiId))
  add(path_564803, "subscriptionId", newJString(subscriptionId))
  add(path_564803, "policyId", newJString(policyId))
  add(path_564803, "resourceGroupName", newJString(resourceGroupName))
  result = call_564802.call(path_564803, query_564804, nil, nil, nil)

var apiPolicyDelete* = Call_ApiPolicyDelete_564791(name: "apiPolicyDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/policies/{policyId}",
    validator: validate_ApiPolicyDelete_564792, base: "", url: url_ApiPolicyDelete_564793,
    schemes: {Scheme.Https})
type
  Call_ApiProductListByApis_564818 = ref object of OpenApiRestCall_563565
proc url_ApiProductListByApis_564820(protocol: Scheme; host: string; base: string;
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

proc validate_ApiProductListByApis_564819(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all Products, which the API is part of.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564821 = path.getOrDefault("serviceName")
  valid_564821 = validateParameter(valid_564821, JString, required = true,
                                 default = nil)
  if valid_564821 != nil:
    section.add "serviceName", valid_564821
  var valid_564822 = path.getOrDefault("apiId")
  valid_564822 = validateParameter(valid_564822, JString, required = true,
                                 default = nil)
  if valid_564822 != nil:
    section.add "apiId", valid_564822
  var valid_564823 = path.getOrDefault("subscriptionId")
  valid_564823 = validateParameter(valid_564823, JString, required = true,
                                 default = nil)
  if valid_564823 != nil:
    section.add "subscriptionId", valid_564823
  var valid_564824 = path.getOrDefault("resourceGroupName")
  valid_564824 = validateParameter(valid_564824, JString, required = true,
                                 default = nil)
  if valid_564824 != nil:
    section.add "resourceGroupName", valid_564824
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Number of records to return.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  var valid_564825 = query.getOrDefault("$top")
  valid_564825 = validateParameter(valid_564825, JInt, required = false, default = nil)
  if valid_564825 != nil:
    section.add "$top", valid_564825
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564826 = query.getOrDefault("api-version")
  valid_564826 = validateParameter(valid_564826, JString, required = true,
                                 default = nil)
  if valid_564826 != nil:
    section.add "api-version", valid_564826
  var valid_564827 = query.getOrDefault("$skip")
  valid_564827 = validateParameter(valid_564827, JInt, required = false, default = nil)
  if valid_564827 != nil:
    section.add "$skip", valid_564827
  var valid_564828 = query.getOrDefault("$filter")
  valid_564828 = validateParameter(valid_564828, JString, required = false,
                                 default = nil)
  if valid_564828 != nil:
    section.add "$filter", valid_564828
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564829: Call_ApiProductListByApis_564818; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all Products, which the API is part of.
  ## 
  let valid = call_564829.validator(path, query, header, formData, body)
  let scheme = call_564829.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564829.url(scheme.get, call_564829.host, call_564829.base,
                         call_564829.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564829, url, valid)

proc call*(call_564830: Call_ApiProductListByApis_564818; serviceName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          resourceGroupName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## apiProductListByApis
  ## Lists all Products, which the API is part of.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Top: int
  ##      : Number of records to return.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_564831 = newJObject()
  var query_564832 = newJObject()
  add(path_564831, "serviceName", newJString(serviceName))
  add(query_564832, "$top", newJInt(Top))
  add(query_564832, "api-version", newJString(apiVersion))
  add(path_564831, "apiId", newJString(apiId))
  add(path_564831, "subscriptionId", newJString(subscriptionId))
  add(query_564832, "$skip", newJInt(Skip))
  add(path_564831, "resourceGroupName", newJString(resourceGroupName))
  add(query_564832, "$filter", newJString(Filter))
  result = call_564830.call(path_564831, query_564832, nil, nil, nil)

var apiProductListByApis* = Call_ApiProductListByApis_564818(
    name: "apiProductListByApis", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/products",
    validator: validate_ApiProductListByApis_564819, base: "",
    url: url_ApiProductListByApis_564820, schemes: {Scheme.Https})
type
  Call_ApiReleaseList_564833 = ref object of OpenApiRestCall_563565
proc url_ApiReleaseList_564835(protocol: Scheme; host: string; base: string;
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

proc validate_ApiReleaseList_564834(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all releases of an API. An API release is created when making an API Revision current. Releases are also used to rollback to previous revisions. Results will be paged and can be constrained by the $top and $skip parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564836 = path.getOrDefault("serviceName")
  valid_564836 = validateParameter(valid_564836, JString, required = true,
                                 default = nil)
  if valid_564836 != nil:
    section.add "serviceName", valid_564836
  var valid_564837 = path.getOrDefault("apiId")
  valid_564837 = validateParameter(valid_564837, JString, required = true,
                                 default = nil)
  if valid_564837 != nil:
    section.add "apiId", valid_564837
  var valid_564838 = path.getOrDefault("subscriptionId")
  valid_564838 = validateParameter(valid_564838, JString, required = true,
                                 default = nil)
  if valid_564838 != nil:
    section.add "subscriptionId", valid_564838
  var valid_564839 = path.getOrDefault("resourceGroupName")
  valid_564839 = validateParameter(valid_564839, JString, required = true,
                                 default = nil)
  if valid_564839 != nil:
    section.add "resourceGroupName", valid_564839
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
  var valid_564840 = query.getOrDefault("api-version")
  valid_564840 = validateParameter(valid_564840, JString, required = true,
                                 default = nil)
  if valid_564840 != nil:
    section.add "api-version", valid_564840
  var valid_564841 = query.getOrDefault("$top")
  valid_564841 = validateParameter(valid_564841, JInt, required = false, default = nil)
  if valid_564841 != nil:
    section.add "$top", valid_564841
  var valid_564842 = query.getOrDefault("$skip")
  valid_564842 = validateParameter(valid_564842, JInt, required = false, default = nil)
  if valid_564842 != nil:
    section.add "$skip", valid_564842
  var valid_564843 = query.getOrDefault("$filter")
  valid_564843 = validateParameter(valid_564843, JString, required = false,
                                 default = nil)
  if valid_564843 != nil:
    section.add "$filter", valid_564843
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564844: Call_ApiReleaseList_564833; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all releases of an API. An API release is created when making an API Revision current. Releases are also used to rollback to previous revisions. Results will be paged and can be constrained by the $top and $skip parameters.
  ## 
  let valid = call_564844.validator(path, query, header, formData, body)
  let scheme = call_564844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564844.url(scheme.get, call_564844.host, call_564844.base,
                         call_564844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564844, url, valid)

proc call*(call_564845: Call_ApiReleaseList_564833; serviceName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          resourceGroupName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## apiReleaseList
  ## Lists all releases of an API. An API release is created when making an API Revision current. Releases are also used to rollback to previous revisions. Results will be paged and can be constrained by the $top and $skip parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## |notes|ge le eq ne gt lt|substringof contains startswith endswith|
  var path_564846 = newJObject()
  var query_564847 = newJObject()
  add(path_564846, "serviceName", newJString(serviceName))
  add(query_564847, "api-version", newJString(apiVersion))
  add(query_564847, "$top", newJInt(Top))
  add(path_564846, "apiId", newJString(apiId))
  add(path_564846, "subscriptionId", newJString(subscriptionId))
  add(query_564847, "$skip", newJInt(Skip))
  add(path_564846, "resourceGroupName", newJString(resourceGroupName))
  add(query_564847, "$filter", newJString(Filter))
  result = call_564845.call(path_564846, query_564847, nil, nil, nil)

var apiReleaseList* = Call_ApiReleaseList_564833(name: "apiReleaseList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/releases",
    validator: validate_ApiReleaseList_564834, base: "", url: url_ApiReleaseList_564835,
    schemes: {Scheme.Https})
type
  Call_ApiReleaseCreate_564861 = ref object of OpenApiRestCall_563565
proc url_ApiReleaseCreate_564863(protocol: Scheme; host: string; base: string;
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

proc validate_ApiReleaseCreate_564862(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Creates a new Release for the API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   releaseId: JString (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `releaseId` field"
  var valid_564864 = path.getOrDefault("releaseId")
  valid_564864 = validateParameter(valid_564864, JString, required = true,
                                 default = nil)
  if valid_564864 != nil:
    section.add "releaseId", valid_564864
  var valid_564865 = path.getOrDefault("serviceName")
  valid_564865 = validateParameter(valid_564865, JString, required = true,
                                 default = nil)
  if valid_564865 != nil:
    section.add "serviceName", valid_564865
  var valid_564866 = path.getOrDefault("apiId")
  valid_564866 = validateParameter(valid_564866, JString, required = true,
                                 default = nil)
  if valid_564866 != nil:
    section.add "apiId", valid_564866
  var valid_564867 = path.getOrDefault("subscriptionId")
  valid_564867 = validateParameter(valid_564867, JString, required = true,
                                 default = nil)
  if valid_564867 != nil:
    section.add "subscriptionId", valid_564867
  var valid_564868 = path.getOrDefault("resourceGroupName")
  valid_564868 = validateParameter(valid_564868, JString, required = true,
                                 default = nil)
  if valid_564868 != nil:
    section.add "resourceGroupName", valid_564868
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564869 = query.getOrDefault("api-version")
  valid_564869 = validateParameter(valid_564869, JString, required = true,
                                 default = nil)
  if valid_564869 != nil:
    section.add "api-version", valid_564869
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

proc call*(call_564871: Call_ApiReleaseCreate_564861; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Release for the API.
  ## 
  let valid = call_564871.validator(path, query, header, formData, body)
  let scheme = call_564871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564871.url(scheme.get, call_564871.host, call_564871.base,
                         call_564871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564871, url, valid)

proc call*(call_564872: Call_ApiReleaseCreate_564861; releaseId: string;
          serviceName: string; apiVersion: string; apiId: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## apiReleaseCreate
  ## Creates a new Release for the API.
  ##   releaseId: string (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  var path_564873 = newJObject()
  var query_564874 = newJObject()
  var body_564875 = newJObject()
  add(path_564873, "releaseId", newJString(releaseId))
  add(path_564873, "serviceName", newJString(serviceName))
  add(query_564874, "api-version", newJString(apiVersion))
  add(path_564873, "apiId", newJString(apiId))
  add(path_564873, "subscriptionId", newJString(subscriptionId))
  add(path_564873, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564875 = parameters
  result = call_564872.call(path_564873, query_564874, nil, nil, body_564875)

var apiReleaseCreate* = Call_ApiReleaseCreate_564861(name: "apiReleaseCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/releases/{releaseId}",
    validator: validate_ApiReleaseCreate_564862, base: "",
    url: url_ApiReleaseCreate_564863, schemes: {Scheme.Https})
type
  Call_ApiReleaseGetEntityTag_564890 = ref object of OpenApiRestCall_563565
proc url_ApiReleaseGetEntityTag_564892(protocol: Scheme; host: string; base: string;
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

proc validate_ApiReleaseGetEntityTag_564891(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the etag of an API release.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   releaseId: JString (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `releaseId` field"
  var valid_564893 = path.getOrDefault("releaseId")
  valid_564893 = validateParameter(valid_564893, JString, required = true,
                                 default = nil)
  if valid_564893 != nil:
    section.add "releaseId", valid_564893
  var valid_564894 = path.getOrDefault("serviceName")
  valid_564894 = validateParameter(valid_564894, JString, required = true,
                                 default = nil)
  if valid_564894 != nil:
    section.add "serviceName", valid_564894
  var valid_564895 = path.getOrDefault("apiId")
  valid_564895 = validateParameter(valid_564895, JString, required = true,
                                 default = nil)
  if valid_564895 != nil:
    section.add "apiId", valid_564895
  var valid_564896 = path.getOrDefault("subscriptionId")
  valid_564896 = validateParameter(valid_564896, JString, required = true,
                                 default = nil)
  if valid_564896 != nil:
    section.add "subscriptionId", valid_564896
  var valid_564897 = path.getOrDefault("resourceGroupName")
  valid_564897 = validateParameter(valid_564897, JString, required = true,
                                 default = nil)
  if valid_564897 != nil:
    section.add "resourceGroupName", valid_564897
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564898 = query.getOrDefault("api-version")
  valid_564898 = validateParameter(valid_564898, JString, required = true,
                                 default = nil)
  if valid_564898 != nil:
    section.add "api-version", valid_564898
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564899: Call_ApiReleaseGetEntityTag_564890; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the etag of an API release.
  ## 
  let valid = call_564899.validator(path, query, header, formData, body)
  let scheme = call_564899.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564899.url(scheme.get, call_564899.host, call_564899.base,
                         call_564899.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564899, url, valid)

proc call*(call_564900: Call_ApiReleaseGetEntityTag_564890; releaseId: string;
          serviceName: string; apiVersion: string; apiId: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## apiReleaseGetEntityTag
  ## Returns the etag of an API release.
  ##   releaseId: string (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564901 = newJObject()
  var query_564902 = newJObject()
  add(path_564901, "releaseId", newJString(releaseId))
  add(path_564901, "serviceName", newJString(serviceName))
  add(query_564902, "api-version", newJString(apiVersion))
  add(path_564901, "apiId", newJString(apiId))
  add(path_564901, "subscriptionId", newJString(subscriptionId))
  add(path_564901, "resourceGroupName", newJString(resourceGroupName))
  result = call_564900.call(path_564901, query_564902, nil, nil, nil)

var apiReleaseGetEntityTag* = Call_ApiReleaseGetEntityTag_564890(
    name: "apiReleaseGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/releases/{releaseId}",
    validator: validate_ApiReleaseGetEntityTag_564891, base: "",
    url: url_ApiReleaseGetEntityTag_564892, schemes: {Scheme.Https})
type
  Call_ApiReleaseGet_564848 = ref object of OpenApiRestCall_563565
proc url_ApiReleaseGet_564850(protocol: Scheme; host: string; base: string;
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

proc validate_ApiReleaseGet_564849(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the details of an API release.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   releaseId: JString (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `releaseId` field"
  var valid_564851 = path.getOrDefault("releaseId")
  valid_564851 = validateParameter(valid_564851, JString, required = true,
                                 default = nil)
  if valid_564851 != nil:
    section.add "releaseId", valid_564851
  var valid_564852 = path.getOrDefault("serviceName")
  valid_564852 = validateParameter(valid_564852, JString, required = true,
                                 default = nil)
  if valid_564852 != nil:
    section.add "serviceName", valid_564852
  var valid_564853 = path.getOrDefault("apiId")
  valid_564853 = validateParameter(valid_564853, JString, required = true,
                                 default = nil)
  if valid_564853 != nil:
    section.add "apiId", valid_564853
  var valid_564854 = path.getOrDefault("subscriptionId")
  valid_564854 = validateParameter(valid_564854, JString, required = true,
                                 default = nil)
  if valid_564854 != nil:
    section.add "subscriptionId", valid_564854
  var valid_564855 = path.getOrDefault("resourceGroupName")
  valid_564855 = validateParameter(valid_564855, JString, required = true,
                                 default = nil)
  if valid_564855 != nil:
    section.add "resourceGroupName", valid_564855
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564856 = query.getOrDefault("api-version")
  valid_564856 = validateParameter(valid_564856, JString, required = true,
                                 default = nil)
  if valid_564856 != nil:
    section.add "api-version", valid_564856
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564857: Call_ApiReleaseGet_564848; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the details of an API release.
  ## 
  let valid = call_564857.validator(path, query, header, formData, body)
  let scheme = call_564857.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564857.url(scheme.get, call_564857.host, call_564857.base,
                         call_564857.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564857, url, valid)

proc call*(call_564858: Call_ApiReleaseGet_564848; releaseId: string;
          serviceName: string; apiVersion: string; apiId: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## apiReleaseGet
  ## Returns the details of an API release.
  ##   releaseId: string (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564859 = newJObject()
  var query_564860 = newJObject()
  add(path_564859, "releaseId", newJString(releaseId))
  add(path_564859, "serviceName", newJString(serviceName))
  add(query_564860, "api-version", newJString(apiVersion))
  add(path_564859, "apiId", newJString(apiId))
  add(path_564859, "subscriptionId", newJString(subscriptionId))
  add(path_564859, "resourceGroupName", newJString(resourceGroupName))
  result = call_564858.call(path_564859, query_564860, nil, nil, nil)

var apiReleaseGet* = Call_ApiReleaseGet_564848(name: "apiReleaseGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/releases/{releaseId}",
    validator: validate_ApiReleaseGet_564849, base: "", url: url_ApiReleaseGet_564850,
    schemes: {Scheme.Https})
type
  Call_ApiReleaseUpdate_564903 = ref object of OpenApiRestCall_563565
proc url_ApiReleaseUpdate_564905(protocol: Scheme; host: string; base: string;
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

proc validate_ApiReleaseUpdate_564904(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates the details of the release of the API specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   releaseId: JString (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `releaseId` field"
  var valid_564906 = path.getOrDefault("releaseId")
  valid_564906 = validateParameter(valid_564906, JString, required = true,
                                 default = nil)
  if valid_564906 != nil:
    section.add "releaseId", valid_564906
  var valid_564907 = path.getOrDefault("serviceName")
  valid_564907 = validateParameter(valid_564907, JString, required = true,
                                 default = nil)
  if valid_564907 != nil:
    section.add "serviceName", valid_564907
  var valid_564908 = path.getOrDefault("apiId")
  valid_564908 = validateParameter(valid_564908, JString, required = true,
                                 default = nil)
  if valid_564908 != nil:
    section.add "apiId", valid_564908
  var valid_564909 = path.getOrDefault("subscriptionId")
  valid_564909 = validateParameter(valid_564909, JString, required = true,
                                 default = nil)
  if valid_564909 != nil:
    section.add "subscriptionId", valid_564909
  var valid_564910 = path.getOrDefault("resourceGroupName")
  valid_564910 = validateParameter(valid_564910, JString, required = true,
                                 default = nil)
  if valid_564910 != nil:
    section.add "resourceGroupName", valid_564910
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564911 = query.getOrDefault("api-version")
  valid_564911 = validateParameter(valid_564911, JString, required = true,
                                 default = nil)
  if valid_564911 != nil:
    section.add "api-version", valid_564911
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564912 = header.getOrDefault("If-Match")
  valid_564912 = validateParameter(valid_564912, JString, required = true,
                                 default = nil)
  if valid_564912 != nil:
    section.add "If-Match", valid_564912
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

proc call*(call_564914: Call_ApiReleaseUpdate_564903; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the release of the API specified by its identifier.
  ## 
  let valid = call_564914.validator(path, query, header, formData, body)
  let scheme = call_564914.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564914.url(scheme.get, call_564914.host, call_564914.base,
                         call_564914.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564914, url, valid)

proc call*(call_564915: Call_ApiReleaseUpdate_564903; releaseId: string;
          serviceName: string; apiVersion: string; apiId: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## apiReleaseUpdate
  ## Updates the details of the release of the API specified by its identifier.
  ##   releaseId: string (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : API Release Update parameters.
  var path_564916 = newJObject()
  var query_564917 = newJObject()
  var body_564918 = newJObject()
  add(path_564916, "releaseId", newJString(releaseId))
  add(path_564916, "serviceName", newJString(serviceName))
  add(query_564917, "api-version", newJString(apiVersion))
  add(path_564916, "apiId", newJString(apiId))
  add(path_564916, "subscriptionId", newJString(subscriptionId))
  add(path_564916, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564918 = parameters
  result = call_564915.call(path_564916, query_564917, nil, nil, body_564918)

var apiReleaseUpdate* = Call_ApiReleaseUpdate_564903(name: "apiReleaseUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/releases/{releaseId}",
    validator: validate_ApiReleaseUpdate_564904, base: "",
    url: url_ApiReleaseUpdate_564905, schemes: {Scheme.Https})
type
  Call_ApiReleaseDelete_564876 = ref object of OpenApiRestCall_563565
proc url_ApiReleaseDelete_564878(protocol: Scheme; host: string; base: string;
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

proc validate_ApiReleaseDelete_564877(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes the specified release in the API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   releaseId: JString (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `releaseId` field"
  var valid_564879 = path.getOrDefault("releaseId")
  valid_564879 = validateParameter(valid_564879, JString, required = true,
                                 default = nil)
  if valid_564879 != nil:
    section.add "releaseId", valid_564879
  var valid_564880 = path.getOrDefault("serviceName")
  valid_564880 = validateParameter(valid_564880, JString, required = true,
                                 default = nil)
  if valid_564880 != nil:
    section.add "serviceName", valid_564880
  var valid_564881 = path.getOrDefault("apiId")
  valid_564881 = validateParameter(valid_564881, JString, required = true,
                                 default = nil)
  if valid_564881 != nil:
    section.add "apiId", valid_564881
  var valid_564882 = path.getOrDefault("subscriptionId")
  valid_564882 = validateParameter(valid_564882, JString, required = true,
                                 default = nil)
  if valid_564882 != nil:
    section.add "subscriptionId", valid_564882
  var valid_564883 = path.getOrDefault("resourceGroupName")
  valid_564883 = validateParameter(valid_564883, JString, required = true,
                                 default = nil)
  if valid_564883 != nil:
    section.add "resourceGroupName", valid_564883
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564884 = query.getOrDefault("api-version")
  valid_564884 = validateParameter(valid_564884, JString, required = true,
                                 default = nil)
  if valid_564884 != nil:
    section.add "api-version", valid_564884
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564885 = header.getOrDefault("If-Match")
  valid_564885 = validateParameter(valid_564885, JString, required = true,
                                 default = nil)
  if valid_564885 != nil:
    section.add "If-Match", valid_564885
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564886: Call_ApiReleaseDelete_564876; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified release in the API.
  ## 
  let valid = call_564886.validator(path, query, header, formData, body)
  let scheme = call_564886.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564886.url(scheme.get, call_564886.host, call_564886.base,
                         call_564886.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564886, url, valid)

proc call*(call_564887: Call_ApiReleaseDelete_564876; releaseId: string;
          serviceName: string; apiVersion: string; apiId: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## apiReleaseDelete
  ## Deletes the specified release in the API.
  ##   releaseId: string (required)
  ##            : Release identifier within an API. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564888 = newJObject()
  var query_564889 = newJObject()
  add(path_564888, "releaseId", newJString(releaseId))
  add(path_564888, "serviceName", newJString(serviceName))
  add(query_564889, "api-version", newJString(apiVersion))
  add(path_564888, "apiId", newJString(apiId))
  add(path_564888, "subscriptionId", newJString(subscriptionId))
  add(path_564888, "resourceGroupName", newJString(resourceGroupName))
  result = call_564887.call(path_564888, query_564889, nil, nil, nil)

var apiReleaseDelete* = Call_ApiReleaseDelete_564876(name: "apiReleaseDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/releases/{releaseId}",
    validator: validate_ApiReleaseDelete_564877, base: "",
    url: url_ApiReleaseDelete_564878, schemes: {Scheme.Https})
type
  Call_ApiRevisionsList_564919 = ref object of OpenApiRestCall_563565
proc url_ApiRevisionsList_564921(protocol: Scheme; host: string; base: string;
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

proc validate_ApiRevisionsList_564920(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists all revisions of an API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564922 = path.getOrDefault("serviceName")
  valid_564922 = validateParameter(valid_564922, JString, required = true,
                                 default = nil)
  if valid_564922 != nil:
    section.add "serviceName", valid_564922
  var valid_564923 = path.getOrDefault("apiId")
  valid_564923 = validateParameter(valid_564923, JString, required = true,
                                 default = nil)
  if valid_564923 != nil:
    section.add "apiId", valid_564923
  var valid_564924 = path.getOrDefault("subscriptionId")
  valid_564924 = validateParameter(valid_564924, JString, required = true,
                                 default = nil)
  if valid_564924 != nil:
    section.add "subscriptionId", valid_564924
  var valid_564925 = path.getOrDefault("resourceGroupName")
  valid_564925 = validateParameter(valid_564925, JString, required = true,
                                 default = nil)
  if valid_564925 != nil:
    section.add "resourceGroupName", valid_564925
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
  var valid_564926 = query.getOrDefault("api-version")
  valid_564926 = validateParameter(valid_564926, JString, required = true,
                                 default = nil)
  if valid_564926 != nil:
    section.add "api-version", valid_564926
  var valid_564927 = query.getOrDefault("$top")
  valid_564927 = validateParameter(valid_564927, JInt, required = false, default = nil)
  if valid_564927 != nil:
    section.add "$top", valid_564927
  var valid_564928 = query.getOrDefault("$skip")
  valid_564928 = validateParameter(valid_564928, JInt, required = false, default = nil)
  if valid_564928 != nil:
    section.add "$skip", valid_564928
  var valid_564929 = query.getOrDefault("$filter")
  valid_564929 = validateParameter(valid_564929, JString, required = false,
                                 default = nil)
  if valid_564929 != nil:
    section.add "$filter", valid_564929
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564930: Call_ApiRevisionsList_564919; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all revisions of an API.
  ## 
  let valid = call_564930.validator(path, query, header, formData, body)
  let scheme = call_564930.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564930.url(scheme.get, call_564930.host, call_564930.base,
                         call_564930.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564930, url, valid)

proc call*(call_564931: Call_ApiRevisionsList_564919; serviceName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          resourceGroupName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## apiRevisionsList
  ## Lists all revisions of an API.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   apiId: string (required)
  ##        : API identifier. Must be unique in the current API Management service instance.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |apiRevision | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  var path_564932 = newJObject()
  var query_564933 = newJObject()
  add(path_564932, "serviceName", newJString(serviceName))
  add(query_564933, "api-version", newJString(apiVersion))
  add(query_564933, "$top", newJInt(Top))
  add(path_564932, "apiId", newJString(apiId))
  add(path_564932, "subscriptionId", newJString(subscriptionId))
  add(query_564933, "$skip", newJInt(Skip))
  add(path_564932, "resourceGroupName", newJString(resourceGroupName))
  add(query_564933, "$filter", newJString(Filter))
  result = call_564931.call(path_564932, query_564933, nil, nil, nil)

var apiRevisionsList* = Call_ApiRevisionsList_564919(name: "apiRevisionsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/revisions",
    validator: validate_ApiRevisionsList_564920, base: "",
    url: url_ApiRevisionsList_564921, schemes: {Scheme.Https})
type
  Call_ApiSchemaListByApi_564934 = ref object of OpenApiRestCall_563565
proc url_ApiSchemaListByApi_564936(protocol: Scheme; host: string; base: string;
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

proc validate_ApiSchemaListByApi_564935(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the schema configuration at the API level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564937 = path.getOrDefault("serviceName")
  valid_564937 = validateParameter(valid_564937, JString, required = true,
                                 default = nil)
  if valid_564937 != nil:
    section.add "serviceName", valid_564937
  var valid_564938 = path.getOrDefault("apiId")
  valid_564938 = validateParameter(valid_564938, JString, required = true,
                                 default = nil)
  if valid_564938 != nil:
    section.add "apiId", valid_564938
  var valid_564939 = path.getOrDefault("subscriptionId")
  valid_564939 = validateParameter(valid_564939, JString, required = true,
                                 default = nil)
  if valid_564939 != nil:
    section.add "subscriptionId", valid_564939
  var valid_564940 = path.getOrDefault("resourceGroupName")
  valid_564940 = validateParameter(valid_564940, JString, required = true,
                                 default = nil)
  if valid_564940 != nil:
    section.add "resourceGroupName", valid_564940
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564941 = query.getOrDefault("api-version")
  valid_564941 = validateParameter(valid_564941, JString, required = true,
                                 default = nil)
  if valid_564941 != nil:
    section.add "api-version", valid_564941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564942: Call_ApiSchemaListByApi_564934; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the schema configuration at the API level.
  ## 
  let valid = call_564942.validator(path, query, header, formData, body)
  let scheme = call_564942.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564942.url(scheme.get, call_564942.host, call_564942.base,
                         call_564942.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564942, url, valid)

proc call*(call_564943: Call_ApiSchemaListByApi_564934; serviceName: string;
          apiVersion: string; apiId: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## apiSchemaListByApi
  ## Get the schema configuration at the API level.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564944 = newJObject()
  var query_564945 = newJObject()
  add(path_564944, "serviceName", newJString(serviceName))
  add(query_564945, "api-version", newJString(apiVersion))
  add(path_564944, "apiId", newJString(apiId))
  add(path_564944, "subscriptionId", newJString(subscriptionId))
  add(path_564944, "resourceGroupName", newJString(resourceGroupName))
  result = call_564943.call(path_564944, query_564945, nil, nil, nil)

var apiSchemaListByApi* = Call_ApiSchemaListByApi_564934(
    name: "apiSchemaListByApi", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/schemas",
    validator: validate_ApiSchemaListByApi_564935, base: "",
    url: url_ApiSchemaListByApi_564936, schemes: {Scheme.Https})
type
  Call_ApiSchemaCreateOrUpdate_564959 = ref object of OpenApiRestCall_563565
proc url_ApiSchemaCreateOrUpdate_564961(protocol: Scheme; host: string; base: string;
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

proc validate_ApiSchemaCreateOrUpdate_564960(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates schema configuration for the API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   schemaId: JString (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564962 = path.getOrDefault("serviceName")
  valid_564962 = validateParameter(valid_564962, JString, required = true,
                                 default = nil)
  if valid_564962 != nil:
    section.add "serviceName", valid_564962
  var valid_564963 = path.getOrDefault("apiId")
  valid_564963 = validateParameter(valid_564963, JString, required = true,
                                 default = nil)
  if valid_564963 != nil:
    section.add "apiId", valid_564963
  var valid_564964 = path.getOrDefault("subscriptionId")
  valid_564964 = validateParameter(valid_564964, JString, required = true,
                                 default = nil)
  if valid_564964 != nil:
    section.add "subscriptionId", valid_564964
  var valid_564965 = path.getOrDefault("schemaId")
  valid_564965 = validateParameter(valid_564965, JString, required = true,
                                 default = nil)
  if valid_564965 != nil:
    section.add "schemaId", valid_564965
  var valid_564966 = path.getOrDefault("resourceGroupName")
  valid_564966 = validateParameter(valid_564966, JString, required = true,
                                 default = nil)
  if valid_564966 != nil:
    section.add "resourceGroupName", valid_564966
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564967 = query.getOrDefault("api-version")
  valid_564967 = validateParameter(valid_564967, JString, required = true,
                                 default = nil)
  if valid_564967 != nil:
    section.add "api-version", valid_564967
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_564968 = header.getOrDefault("If-Match")
  valid_564968 = validateParameter(valid_564968, JString, required = false,
                                 default = nil)
  if valid_564968 != nil:
    section.add "If-Match", valid_564968
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

proc call*(call_564970: Call_ApiSchemaCreateOrUpdate_564959; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates schema configuration for the API.
  ## 
  let valid = call_564970.validator(path, query, header, formData, body)
  let scheme = call_564970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564970.url(scheme.get, call_564970.host, call_564970.base,
                         call_564970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564970, url, valid)

proc call*(call_564971: Call_ApiSchemaCreateOrUpdate_564959; serviceName: string;
          apiVersion: string; apiId: string; subscriptionId: string; schemaId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## apiSchemaCreateOrUpdate
  ## Creates or updates schema configuration for the API.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   schemaId: string (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : The schema contents to apply.
  var path_564972 = newJObject()
  var query_564973 = newJObject()
  var body_564974 = newJObject()
  add(path_564972, "serviceName", newJString(serviceName))
  add(query_564973, "api-version", newJString(apiVersion))
  add(path_564972, "apiId", newJString(apiId))
  add(path_564972, "subscriptionId", newJString(subscriptionId))
  add(path_564972, "schemaId", newJString(schemaId))
  add(path_564972, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564974 = parameters
  result = call_564971.call(path_564972, query_564973, nil, nil, body_564974)

var apiSchemaCreateOrUpdate* = Call_ApiSchemaCreateOrUpdate_564959(
    name: "apiSchemaCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/schemas/{schemaId}",
    validator: validate_ApiSchemaCreateOrUpdate_564960, base: "",
    url: url_ApiSchemaCreateOrUpdate_564961, schemes: {Scheme.Https})
type
  Call_ApiSchemaGetEntityTag_564989 = ref object of OpenApiRestCall_563565
proc url_ApiSchemaGetEntityTag_564991(protocol: Scheme; host: string; base: string;
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

proc validate_ApiSchemaGetEntityTag_564990(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the schema specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   schemaId: JString (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564992 = path.getOrDefault("serviceName")
  valid_564992 = validateParameter(valid_564992, JString, required = true,
                                 default = nil)
  if valid_564992 != nil:
    section.add "serviceName", valid_564992
  var valid_564993 = path.getOrDefault("apiId")
  valid_564993 = validateParameter(valid_564993, JString, required = true,
                                 default = nil)
  if valid_564993 != nil:
    section.add "apiId", valid_564993
  var valid_564994 = path.getOrDefault("subscriptionId")
  valid_564994 = validateParameter(valid_564994, JString, required = true,
                                 default = nil)
  if valid_564994 != nil:
    section.add "subscriptionId", valid_564994
  var valid_564995 = path.getOrDefault("schemaId")
  valid_564995 = validateParameter(valid_564995, JString, required = true,
                                 default = nil)
  if valid_564995 != nil:
    section.add "schemaId", valid_564995
  var valid_564996 = path.getOrDefault("resourceGroupName")
  valid_564996 = validateParameter(valid_564996, JString, required = true,
                                 default = nil)
  if valid_564996 != nil:
    section.add "resourceGroupName", valid_564996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564997 = query.getOrDefault("api-version")
  valid_564997 = validateParameter(valid_564997, JString, required = true,
                                 default = nil)
  if valid_564997 != nil:
    section.add "api-version", valid_564997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564998: Call_ApiSchemaGetEntityTag_564989; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the schema specified by its identifier.
  ## 
  let valid = call_564998.validator(path, query, header, formData, body)
  let scheme = call_564998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564998.url(scheme.get, call_564998.host, call_564998.base,
                         call_564998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564998, url, valid)

proc call*(call_564999: Call_ApiSchemaGetEntityTag_564989; serviceName: string;
          apiVersion: string; apiId: string; subscriptionId: string; schemaId: string;
          resourceGroupName: string): Recallable =
  ## apiSchemaGetEntityTag
  ## Gets the entity state (Etag) version of the schema specified by its identifier.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   schemaId: string (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565000 = newJObject()
  var query_565001 = newJObject()
  add(path_565000, "serviceName", newJString(serviceName))
  add(query_565001, "api-version", newJString(apiVersion))
  add(path_565000, "apiId", newJString(apiId))
  add(path_565000, "subscriptionId", newJString(subscriptionId))
  add(path_565000, "schemaId", newJString(schemaId))
  add(path_565000, "resourceGroupName", newJString(resourceGroupName))
  result = call_564999.call(path_565000, query_565001, nil, nil, nil)

var apiSchemaGetEntityTag* = Call_ApiSchemaGetEntityTag_564989(
    name: "apiSchemaGetEntityTag", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/schemas/{schemaId}",
    validator: validate_ApiSchemaGetEntityTag_564990, base: "",
    url: url_ApiSchemaGetEntityTag_564991, schemes: {Scheme.Https})
type
  Call_ApiSchemaGet_564946 = ref object of OpenApiRestCall_563565
proc url_ApiSchemaGet_564948(protocol: Scheme; host: string; base: string;
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

proc validate_ApiSchemaGet_564947(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the schema configuration at the API level.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   schemaId: JString (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564949 = path.getOrDefault("serviceName")
  valid_564949 = validateParameter(valid_564949, JString, required = true,
                                 default = nil)
  if valid_564949 != nil:
    section.add "serviceName", valid_564949
  var valid_564950 = path.getOrDefault("apiId")
  valid_564950 = validateParameter(valid_564950, JString, required = true,
                                 default = nil)
  if valid_564950 != nil:
    section.add "apiId", valid_564950
  var valid_564951 = path.getOrDefault("subscriptionId")
  valid_564951 = validateParameter(valid_564951, JString, required = true,
                                 default = nil)
  if valid_564951 != nil:
    section.add "subscriptionId", valid_564951
  var valid_564952 = path.getOrDefault("schemaId")
  valid_564952 = validateParameter(valid_564952, JString, required = true,
                                 default = nil)
  if valid_564952 != nil:
    section.add "schemaId", valid_564952
  var valid_564953 = path.getOrDefault("resourceGroupName")
  valid_564953 = validateParameter(valid_564953, JString, required = true,
                                 default = nil)
  if valid_564953 != nil:
    section.add "resourceGroupName", valid_564953
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564954 = query.getOrDefault("api-version")
  valid_564954 = validateParameter(valid_564954, JString, required = true,
                                 default = nil)
  if valid_564954 != nil:
    section.add "api-version", valid_564954
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564955: Call_ApiSchemaGet_564946; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the schema configuration at the API level.
  ## 
  let valid = call_564955.validator(path, query, header, formData, body)
  let scheme = call_564955.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564955.url(scheme.get, call_564955.host, call_564955.base,
                         call_564955.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564955, url, valid)

proc call*(call_564956: Call_ApiSchemaGet_564946; serviceName: string;
          apiVersion: string; apiId: string; subscriptionId: string; schemaId: string;
          resourceGroupName: string): Recallable =
  ## apiSchemaGet
  ## Get the schema configuration at the API level.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   schemaId: string (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564957 = newJObject()
  var query_564958 = newJObject()
  add(path_564957, "serviceName", newJString(serviceName))
  add(query_564958, "api-version", newJString(apiVersion))
  add(path_564957, "apiId", newJString(apiId))
  add(path_564957, "subscriptionId", newJString(subscriptionId))
  add(path_564957, "schemaId", newJString(schemaId))
  add(path_564957, "resourceGroupName", newJString(resourceGroupName))
  result = call_564956.call(path_564957, query_564958, nil, nil, nil)

var apiSchemaGet* = Call_ApiSchemaGet_564946(name: "apiSchemaGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/schemas/{schemaId}",
    validator: validate_ApiSchemaGet_564947, base: "", url: url_ApiSchemaGet_564948,
    schemes: {Scheme.Https})
type
  Call_ApiSchemaDelete_564975 = ref object of OpenApiRestCall_563565
proc url_ApiSchemaDelete_564977(protocol: Scheme; host: string; base: string;
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

proc validate_ApiSchemaDelete_564976(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes the schema configuration at the Api.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   apiId: JString (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   schemaId: JString (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564978 = path.getOrDefault("serviceName")
  valid_564978 = validateParameter(valid_564978, JString, required = true,
                                 default = nil)
  if valid_564978 != nil:
    section.add "serviceName", valid_564978
  var valid_564979 = path.getOrDefault("apiId")
  valid_564979 = validateParameter(valid_564979, JString, required = true,
                                 default = nil)
  if valid_564979 != nil:
    section.add "apiId", valid_564979
  var valid_564980 = path.getOrDefault("subscriptionId")
  valid_564980 = validateParameter(valid_564980, JString, required = true,
                                 default = nil)
  if valid_564980 != nil:
    section.add "subscriptionId", valid_564980
  var valid_564981 = path.getOrDefault("schemaId")
  valid_564981 = validateParameter(valid_564981, JString, required = true,
                                 default = nil)
  if valid_564981 != nil:
    section.add "schemaId", valid_564981
  var valid_564982 = path.getOrDefault("resourceGroupName")
  valid_564982 = validateParameter(valid_564982, JString, required = true,
                                 default = nil)
  if valid_564982 != nil:
    section.add "resourceGroupName", valid_564982
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564983 = query.getOrDefault("api-version")
  valid_564983 = validateParameter(valid_564983, JString, required = true,
                                 default = nil)
  if valid_564983 != nil:
    section.add "api-version", valid_564983
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564984 = header.getOrDefault("If-Match")
  valid_564984 = validateParameter(valid_564984, JString, required = true,
                                 default = nil)
  if valid_564984 != nil:
    section.add "If-Match", valid_564984
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564985: Call_ApiSchemaDelete_564975; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the schema configuration at the Api.
  ## 
  let valid = call_564985.validator(path, query, header, formData, body)
  let scheme = call_564985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564985.url(scheme.get, call_564985.host, call_564985.base,
                         call_564985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564985, url, valid)

proc call*(call_564986: Call_ApiSchemaDelete_564975; serviceName: string;
          apiVersion: string; apiId: string; subscriptionId: string; schemaId: string;
          resourceGroupName: string): Recallable =
  ## apiSchemaDelete
  ## Deletes the schema configuration at the Api.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   apiId: string (required)
  ##        : API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   schemaId: string (required)
  ##           : Schema identifier within an API. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564987 = newJObject()
  var query_564988 = newJObject()
  add(path_564987, "serviceName", newJString(serviceName))
  add(query_564988, "api-version", newJString(apiVersion))
  add(path_564987, "apiId", newJString(apiId))
  add(path_564987, "subscriptionId", newJString(subscriptionId))
  add(path_564987, "schemaId", newJString(schemaId))
  add(path_564987, "resourceGroupName", newJString(resourceGroupName))
  result = call_564986.call(path_564987, query_564988, nil, nil, nil)

var apiSchemaDelete* = Call_ApiSchemaDelete_564975(name: "apiSchemaDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}/schemas/{schemaId}",
    validator: validate_ApiSchemaDelete_564976, base: "", url: url_ApiSchemaDelete_564977,
    schemes: {Scheme.Https})
type
  Call_ApiListByTags_565002 = ref object of OpenApiRestCall_563565
proc url_ApiListByTags_565004(protocol: Scheme; host: string; base: string;
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

proc validate_ApiListByTags_565003(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of apis associated with tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_565005 = path.getOrDefault("serviceName")
  valid_565005 = validateParameter(valid_565005, JString, required = true,
                                 default = nil)
  if valid_565005 != nil:
    section.add "serviceName", valid_565005
  var valid_565006 = path.getOrDefault("subscriptionId")
  valid_565006 = validateParameter(valid_565006, JString, required = true,
                                 default = nil)
  if valid_565006 != nil:
    section.add "subscriptionId", valid_565006
  var valid_565007 = path.getOrDefault("resourceGroupName")
  valid_565007 = validateParameter(valid_565007, JString, required = true,
                                 default = nil)
  if valid_565007 != nil:
    section.add "resourceGroupName", valid_565007
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Number of records to return.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
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
  var valid_565008 = query.getOrDefault("$top")
  valid_565008 = validateParameter(valid_565008, JInt, required = false, default = nil)
  if valid_565008 != nil:
    section.add "$top", valid_565008
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565009 = query.getOrDefault("api-version")
  valid_565009 = validateParameter(valid_565009, JString, required = true,
                                 default = nil)
  if valid_565009 != nil:
    section.add "api-version", valid_565009
  var valid_565010 = query.getOrDefault("$skip")
  valid_565010 = validateParameter(valid_565010, JInt, required = false, default = nil)
  if valid_565010 != nil:
    section.add "$skip", valid_565010
  var valid_565011 = query.getOrDefault("$filter")
  valid_565011 = validateParameter(valid_565011, JString, required = false,
                                 default = nil)
  if valid_565011 != nil:
    section.add "$filter", valid_565011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565012: Call_ApiListByTags_565002; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of apis associated with tags.
  ## 
  let valid = call_565012.validator(path, query, header, formData, body)
  let scheme = call_565012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565012.url(scheme.get, call_565012.host, call_565012.base,
                         call_565012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565012, url, valid)

proc call*(call_565013: Call_ApiListByTags_565002; serviceName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## apiListByTags
  ## Lists a collection of apis associated with tags.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Top: int
  ##      : Number of records to return.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
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
  var path_565014 = newJObject()
  var query_565015 = newJObject()
  add(path_565014, "serviceName", newJString(serviceName))
  add(query_565015, "$top", newJInt(Top))
  add(query_565015, "api-version", newJString(apiVersion))
  add(path_565014, "subscriptionId", newJString(subscriptionId))
  add(query_565015, "$skip", newJInt(Skip))
  add(path_565014, "resourceGroupName", newJString(resourceGroupName))
  add(query_565015, "$filter", newJString(Filter))
  result = call_565013.call(path_565014, query_565015, nil, nil, nil)

var apiListByTags* = Call_ApiListByTags_565002(name: "apiListByTags",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apisByTags",
    validator: validate_ApiListByTags_565003, base: "", url: url_ApiListByTags_565004,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
