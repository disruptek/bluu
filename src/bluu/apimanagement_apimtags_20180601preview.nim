
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2018-06-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on Tag entity in your Azure API Management deployment. Tags can be assigned to APIs, Operations and Products.
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
  macServiceName = "apimanagement-apimtags"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TagListByService_596679 = ref object of OpenApiRestCall_596457
proc url_TagListByService_596681(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/tags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagListByService_596680(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists a collection of tags defined within a service instance.
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
  ##   scope: JString
  ##        : Scope like 'apis', 'products' or 'apis/{apiId}
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
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596845 = query.getOrDefault("api-version")
  valid_596845 = validateParameter(valid_596845, JString, required = true,
                                 default = nil)
  if valid_596845 != nil:
    section.add "api-version", valid_596845
  var valid_596846 = query.getOrDefault("scope")
  valid_596846 = validateParameter(valid_596846, JString, required = false,
                                 default = nil)
  if valid_596846 != nil:
    section.add "scope", valid_596846
  var valid_596847 = query.getOrDefault("$top")
  valid_596847 = validateParameter(valid_596847, JInt, required = false, default = nil)
  if valid_596847 != nil:
    section.add "$top", valid_596847
  var valid_596848 = query.getOrDefault("$skip")
  valid_596848 = validateParameter(valid_596848, JInt, required = false, default = nil)
  if valid_596848 != nil:
    section.add "$skip", valid_596848
  var valid_596849 = query.getOrDefault("$filter")
  valid_596849 = validateParameter(valid_596849, JString, required = false,
                                 default = nil)
  if valid_596849 != nil:
    section.add "$filter", valid_596849
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596876: Call_TagListByService_596679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of tags defined within a service instance.
  ## 
  let valid = call_596876.validator(path, query, header, formData, body)
  let scheme = call_596876.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596876.url(scheme.get, call_596876.host, call_596876.base,
                         call_596876.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596876, url, valid)

proc call*(call_596947: Call_TagListByService_596679; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          scope: string = ""; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## tagListByService
  ## Lists a collection of tags defined within a service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   scope: string
  ##        : Scope like 'apis', 'products' or 'apis/{apiId}
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
  ## 
  var path_596948 = newJObject()
  var query_596950 = newJObject()
  add(path_596948, "resourceGroupName", newJString(resourceGroupName))
  add(query_596950, "api-version", newJString(apiVersion))
  add(query_596950, "scope", newJString(scope))
  add(path_596948, "subscriptionId", newJString(subscriptionId))
  add(query_596950, "$top", newJInt(Top))
  add(query_596950, "$skip", newJInt(Skip))
  add(path_596948, "serviceName", newJString(serviceName))
  add(query_596950, "$filter", newJString(Filter))
  result = call_596947.call(path_596948, query_596950, nil, nil, nil)

var tagListByService* = Call_TagListByService_596679(name: "tagListByService",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags",
    validator: validate_TagListByService_596680, base: "",
    url: url_TagListByService_596681, schemes: {Scheme.Https})
type
  Call_TagCreateOrUpdate_597001 = ref object of OpenApiRestCall_596457
proc url_TagCreateOrUpdate_597003(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagCreateOrUpdate_597002(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a tag.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_597031 = path.getOrDefault("tagId")
  valid_597031 = validateParameter(valid_597031, JString, required = true,
                                 default = nil)
  if valid_597031 != nil:
    section.add "tagId", valid_597031
  var valid_597032 = path.getOrDefault("resourceGroupName")
  valid_597032 = validateParameter(valid_597032, JString, required = true,
                                 default = nil)
  if valid_597032 != nil:
    section.add "resourceGroupName", valid_597032
  var valid_597033 = path.getOrDefault("subscriptionId")
  valid_597033 = validateParameter(valid_597033, JString, required = true,
                                 default = nil)
  if valid_597033 != nil:
    section.add "subscriptionId", valid_597033
  var valid_597034 = path.getOrDefault("serviceName")
  valid_597034 = validateParameter(valid_597034, JString, required = true,
                                 default = nil)
  if valid_597034 != nil:
    section.add "serviceName", valid_597034
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597035 = query.getOrDefault("api-version")
  valid_597035 = validateParameter(valid_597035, JString, required = true,
                                 default = nil)
  if valid_597035 != nil:
    section.add "api-version", valid_597035
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_597036 = header.getOrDefault("If-Match")
  valid_597036 = validateParameter(valid_597036, JString, required = false,
                                 default = nil)
  if valid_597036 != nil:
    section.add "If-Match", valid_597036
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

proc call*(call_597038: Call_TagCreateOrUpdate_597001; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a tag.
  ## 
  let valid = call_597038.validator(path, query, header, formData, body)
  let scheme = call_597038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597038.url(scheme.get, call_597038.host, call_597038.base,
                         call_597038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597038, url, valid)

proc call*(call_597039: Call_TagCreateOrUpdate_597001; tagId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## tagCreateOrUpdate
  ## Creates a tag.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597040 = newJObject()
  var query_597041 = newJObject()
  var body_597042 = newJObject()
  add(path_597040, "tagId", newJString(tagId))
  add(path_597040, "resourceGroupName", newJString(resourceGroupName))
  add(query_597041, "api-version", newJString(apiVersion))
  add(path_597040, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597042 = parameters
  add(path_597040, "serviceName", newJString(serviceName))
  result = call_597039.call(path_597040, query_597041, nil, nil, body_597042)

var tagCreateOrUpdate* = Call_TagCreateOrUpdate_597001(name: "tagCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}",
    validator: validate_TagCreateOrUpdate_597002, base: "",
    url: url_TagCreateOrUpdate_597003, schemes: {Scheme.Https})
type
  Call_TagGetEntityState_597056 = ref object of OpenApiRestCall_596457
proc url_TagGetEntityState_597058(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagGetEntityState_597057(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the entity state version of the tag specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_597059 = path.getOrDefault("tagId")
  valid_597059 = validateParameter(valid_597059, JString, required = true,
                                 default = nil)
  if valid_597059 != nil:
    section.add "tagId", valid_597059
  var valid_597060 = path.getOrDefault("resourceGroupName")
  valid_597060 = validateParameter(valid_597060, JString, required = true,
                                 default = nil)
  if valid_597060 != nil:
    section.add "resourceGroupName", valid_597060
  var valid_597061 = path.getOrDefault("subscriptionId")
  valid_597061 = validateParameter(valid_597061, JString, required = true,
                                 default = nil)
  if valid_597061 != nil:
    section.add "subscriptionId", valid_597061
  var valid_597062 = path.getOrDefault("serviceName")
  valid_597062 = validateParameter(valid_597062, JString, required = true,
                                 default = nil)
  if valid_597062 != nil:
    section.add "serviceName", valid_597062
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597063 = query.getOrDefault("api-version")
  valid_597063 = validateParameter(valid_597063, JString, required = true,
                                 default = nil)
  if valid_597063 != nil:
    section.add "api-version", valid_597063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597064: Call_TagGetEntityState_597056; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state version of the tag specified by its identifier.
  ## 
  let valid = call_597064.validator(path, query, header, formData, body)
  let scheme = call_597064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597064.url(scheme.get, call_597064.host, call_597064.base,
                         call_597064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597064, url, valid)

proc call*(call_597065: Call_TagGetEntityState_597056; tagId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## tagGetEntityState
  ## Gets the entity state version of the tag specified by its identifier.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597066 = newJObject()
  var query_597067 = newJObject()
  add(path_597066, "tagId", newJString(tagId))
  add(path_597066, "resourceGroupName", newJString(resourceGroupName))
  add(query_597067, "api-version", newJString(apiVersion))
  add(path_597066, "subscriptionId", newJString(subscriptionId))
  add(path_597066, "serviceName", newJString(serviceName))
  result = call_597065.call(path_597066, query_597067, nil, nil, nil)

var tagGetEntityState* = Call_TagGetEntityState_597056(name: "tagGetEntityState",
    meth: HttpMethod.HttpHead, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}",
    validator: validate_TagGetEntityState_597057, base: "",
    url: url_TagGetEntityState_597058, schemes: {Scheme.Https})
type
  Call_TagGet_596989 = ref object of OpenApiRestCall_596457
proc url_TagGet_596991(protocol: Scheme; host: string; base: string; route: string;
                      path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagGet_596990(path: JsonNode; query: JsonNode; header: JsonNode;
                           formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the tag specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_596992 = path.getOrDefault("tagId")
  valid_596992 = validateParameter(valid_596992, JString, required = true,
                                 default = nil)
  if valid_596992 != nil:
    section.add "tagId", valid_596992
  var valid_596993 = path.getOrDefault("resourceGroupName")
  valid_596993 = validateParameter(valid_596993, JString, required = true,
                                 default = nil)
  if valid_596993 != nil:
    section.add "resourceGroupName", valid_596993
  var valid_596994 = path.getOrDefault("subscriptionId")
  valid_596994 = validateParameter(valid_596994, JString, required = true,
                                 default = nil)
  if valid_596994 != nil:
    section.add "subscriptionId", valid_596994
  var valid_596995 = path.getOrDefault("serviceName")
  valid_596995 = validateParameter(valid_596995, JString, required = true,
                                 default = nil)
  if valid_596995 != nil:
    section.add "serviceName", valid_596995
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596996 = query.getOrDefault("api-version")
  valid_596996 = validateParameter(valid_596996, JString, required = true,
                                 default = nil)
  if valid_596996 != nil:
    section.add "api-version", valid_596996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596997: Call_TagGet_596989; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the tag specified by its identifier.
  ## 
  let valid = call_596997.validator(path, query, header, formData, body)
  let scheme = call_596997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596997.url(scheme.get, call_596997.host, call_596997.base,
                         call_596997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596997, url, valid)

proc call*(call_596998: Call_TagGet_596989; tagId: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string): Recallable =
  ## tagGet
  ## Gets the details of the tag specified by its identifier.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_596999 = newJObject()
  var query_597000 = newJObject()
  add(path_596999, "tagId", newJString(tagId))
  add(path_596999, "resourceGroupName", newJString(resourceGroupName))
  add(query_597000, "api-version", newJString(apiVersion))
  add(path_596999, "subscriptionId", newJString(subscriptionId))
  add(path_596999, "serviceName", newJString(serviceName))
  result = call_596998.call(path_596999, query_597000, nil, nil, nil)

var tagGet* = Call_TagGet_596989(name: "tagGet", meth: HttpMethod.HttpGet,
                              host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}",
                              validator: validate_TagGet_596990, base: "",
                              url: url_TagGet_596991, schemes: {Scheme.Https})
type
  Call_TagUpdate_597068 = ref object of OpenApiRestCall_596457
proc url_TagUpdate_597070(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagUpdate_597069(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the details of the tag specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_597071 = path.getOrDefault("tagId")
  valid_597071 = validateParameter(valid_597071, JString, required = true,
                                 default = nil)
  if valid_597071 != nil:
    section.add "tagId", valid_597071
  var valid_597072 = path.getOrDefault("resourceGroupName")
  valid_597072 = validateParameter(valid_597072, JString, required = true,
                                 default = nil)
  if valid_597072 != nil:
    section.add "resourceGroupName", valid_597072
  var valid_597073 = path.getOrDefault("subscriptionId")
  valid_597073 = validateParameter(valid_597073, JString, required = true,
                                 default = nil)
  if valid_597073 != nil:
    section.add "subscriptionId", valid_597073
  var valid_597074 = path.getOrDefault("serviceName")
  valid_597074 = validateParameter(valid_597074, JString, required = true,
                                 default = nil)
  if valid_597074 != nil:
    section.add "serviceName", valid_597074
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597075 = query.getOrDefault("api-version")
  valid_597075 = validateParameter(valid_597075, JString, required = true,
                                 default = nil)
  if valid_597075 != nil:
    section.add "api-version", valid_597075
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597076 = header.getOrDefault("If-Match")
  valid_597076 = validateParameter(valid_597076, JString, required = true,
                                 default = nil)
  if valid_597076 != nil:
    section.add "If-Match", valid_597076
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

proc call*(call_597078: Call_TagUpdate_597068; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the tag specified by its identifier.
  ## 
  let valid = call_597078.validator(path, query, header, formData, body)
  let scheme = call_597078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597078.url(scheme.get, call_597078.host, call_597078.base,
                         call_597078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597078, url, valid)

proc call*(call_597079: Call_TagUpdate_597068; tagId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## tagUpdate
  ## Updates the details of the tag specified by its identifier.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597080 = newJObject()
  var query_597081 = newJObject()
  var body_597082 = newJObject()
  add(path_597080, "tagId", newJString(tagId))
  add(path_597080, "resourceGroupName", newJString(resourceGroupName))
  add(query_597081, "api-version", newJString(apiVersion))
  add(path_597080, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597082 = parameters
  add(path_597080, "serviceName", newJString(serviceName))
  result = call_597079.call(path_597080, query_597081, nil, nil, body_597082)

var tagUpdate* = Call_TagUpdate_597068(name: "tagUpdate", meth: HttpMethod.HttpPatch,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}",
                                    validator: validate_TagUpdate_597069,
                                    base: "", url: url_TagUpdate_597070,
                                    schemes: {Scheme.Https})
type
  Call_TagDelete_597043 = ref object of OpenApiRestCall_596457
proc url_TagDelete_597045(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "tagId" in path, "`tagId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/tags/"),
               (kind: VariableSegment, value: "tagId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagDelete_597044(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes specific tag of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagId: JString (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagId` field"
  var valid_597046 = path.getOrDefault("tagId")
  valid_597046 = validateParameter(valid_597046, JString, required = true,
                                 default = nil)
  if valid_597046 != nil:
    section.add "tagId", valid_597046
  var valid_597047 = path.getOrDefault("resourceGroupName")
  valid_597047 = validateParameter(valid_597047, JString, required = true,
                                 default = nil)
  if valid_597047 != nil:
    section.add "resourceGroupName", valid_597047
  var valid_597048 = path.getOrDefault("subscriptionId")
  valid_597048 = validateParameter(valid_597048, JString, required = true,
                                 default = nil)
  if valid_597048 != nil:
    section.add "subscriptionId", valid_597048
  var valid_597049 = path.getOrDefault("serviceName")
  valid_597049 = validateParameter(valid_597049, JString, required = true,
                                 default = nil)
  if valid_597049 != nil:
    section.add "serviceName", valid_597049
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597050 = query.getOrDefault("api-version")
  valid_597050 = validateParameter(valid_597050, JString, required = true,
                                 default = nil)
  if valid_597050 != nil:
    section.add "api-version", valid_597050
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597051 = header.getOrDefault("If-Match")
  valid_597051 = validateParameter(valid_597051, JString, required = true,
                                 default = nil)
  if valid_597051 != nil:
    section.add "If-Match", valid_597051
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597052: Call_TagDelete_597043; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specific tag of the API Management service instance.
  ## 
  let valid = call_597052.validator(path, query, header, formData, body)
  let scheme = call_597052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597052.url(scheme.get, call_597052.host, call_597052.base,
                         call_597052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597052, url, valid)

proc call*(call_597053: Call_TagDelete_597043; tagId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## tagDelete
  ## Deletes specific tag of the API Management service instance.
  ##   tagId: string (required)
  ##        : Tag identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597054 = newJObject()
  var query_597055 = newJObject()
  add(path_597054, "tagId", newJString(tagId))
  add(path_597054, "resourceGroupName", newJString(resourceGroupName))
  add(query_597055, "api-version", newJString(apiVersion))
  add(path_597054, "subscriptionId", newJString(subscriptionId))
  add(path_597054, "serviceName", newJString(serviceName))
  result = call_597053.call(path_597054, query_597055, nil, nil, nil)

var tagDelete* = Call_TagDelete_597043(name: "tagDelete",
                                    meth: HttpMethod.HttpDelete,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tags/{tagId}",
                                    validator: validate_TagDelete_597044,
                                    base: "", url: url_TagDelete_597045,
                                    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
