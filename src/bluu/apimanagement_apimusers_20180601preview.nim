
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2018-06-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on User entity in Azure API Management deployment. The User entity in API Management represents the developers that call the APIs of the products to which they are subscribed.
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
  macServiceName = "apimanagement-apimusers"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_UserListByService_596679 = ref object of OpenApiRestCall_596457
proc url_UserListByService_596681(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserListByService_596680(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists a collection of registered users in the specified service instance.
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
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   expandGroups: JBool
  ##   $filter: JString
  ##          : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |firstName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |lastName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |email | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |state | eq |    |
  ## |registrationDate | ge, le, eq, ne, gt, lt |    |
  ## |note | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |groups |     |    |
  ## 
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
  var valid_596848 = query.getOrDefault("expandGroups")
  valid_596848 = validateParameter(valid_596848, JBool, required = false, default = nil)
  if valid_596848 != nil:
    section.add "expandGroups", valid_596848
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

proc call*(call_596876: Call_UserListByService_596679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of registered users in the specified service instance.
  ## 
  let valid = call_596876.validator(path, query, header, formData, body)
  let scheme = call_596876.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596876.url(scheme.get, call_596876.host, call_596876.base,
                         call_596876.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596876, url, valid)

proc call*(call_596947: Call_UserListByService_596679; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          Top: int = 0; Skip: int = 0; expandGroups: bool = false; Filter: string = ""): Recallable =
  ## userListByService
  ## Lists a collection of registered users in the specified service instance.
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
  ##   expandGroups: bool
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |firstName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |lastName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |email | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |state | eq |    |
  ## |registrationDate | ge, le, eq, ne, gt, lt |    |
  ## |note | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |groups |     |    |
  ## 
  var path_596948 = newJObject()
  var query_596950 = newJObject()
  add(path_596948, "resourceGroupName", newJString(resourceGroupName))
  add(query_596950, "api-version", newJString(apiVersion))
  add(path_596948, "subscriptionId", newJString(subscriptionId))
  add(query_596950, "$top", newJInt(Top))
  add(query_596950, "$skip", newJInt(Skip))
  add(query_596950, "expandGroups", newJBool(expandGroups))
  add(path_596948, "serviceName", newJString(serviceName))
  add(query_596950, "$filter", newJString(Filter))
  result = call_596947.call(path_596948, query_596950, nil, nil, nil)

var userListByService* = Call_UserListByService_596679(name: "userListByService",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users",
    validator: validate_UserListByService_596680, base: "",
    url: url_UserListByService_596681, schemes: {Scheme.Https})
type
  Call_UserCreateOrUpdate_597001 = ref object of OpenApiRestCall_596457
proc url_UserCreateOrUpdate_597003(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserCreateOrUpdate_597002(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates or Updates a user.
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
  ##   userId: JString (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597031 = path.getOrDefault("resourceGroupName")
  valid_597031 = validateParameter(valid_597031, JString, required = true,
                                 default = nil)
  if valid_597031 != nil:
    section.add "resourceGroupName", valid_597031
  var valid_597032 = path.getOrDefault("subscriptionId")
  valid_597032 = validateParameter(valid_597032, JString, required = true,
                                 default = nil)
  if valid_597032 != nil:
    section.add "subscriptionId", valid_597032
  var valid_597033 = path.getOrDefault("serviceName")
  valid_597033 = validateParameter(valid_597033, JString, required = true,
                                 default = nil)
  if valid_597033 != nil:
    section.add "serviceName", valid_597033
  var valid_597034 = path.getOrDefault("userId")
  valid_597034 = validateParameter(valid_597034, JString, required = true,
                                 default = nil)
  if valid_597034 != nil:
    section.add "userId", valid_597034
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
  ##             : Create or update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597038: Call_UserCreateOrUpdate_597001; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates a user.
  ## 
  let valid = call_597038.validator(path, query, header, formData, body)
  let scheme = call_597038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597038.url(scheme.get, call_597038.host, call_597038.base,
                         call_597038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597038, url, valid)

proc call*(call_597039: Call_UserCreateOrUpdate_597001; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          serviceName: string; userId: string): Recallable =
  ## userCreateOrUpdate
  ## Creates or Updates a user.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create or update parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   userId: string (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  var path_597040 = newJObject()
  var query_597041 = newJObject()
  var body_597042 = newJObject()
  add(path_597040, "resourceGroupName", newJString(resourceGroupName))
  add(query_597041, "api-version", newJString(apiVersion))
  add(path_597040, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597042 = parameters
  add(path_597040, "serviceName", newJString(serviceName))
  add(path_597040, "userId", newJString(userId))
  result = call_597039.call(path_597040, query_597041, nil, nil, body_597042)

var userCreateOrUpdate* = Call_UserCreateOrUpdate_597001(
    name: "userCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{userId}",
    validator: validate_UserCreateOrUpdate_597002, base: "",
    url: url_UserCreateOrUpdate_597003, schemes: {Scheme.Https})
type
  Call_UserGetEntityTag_597058 = ref object of OpenApiRestCall_596457
proc url_UserGetEntityTag_597060(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserGetEntityTag_597059(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the user specified by its identifier.
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
  ##   userId: JString (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597061 = path.getOrDefault("resourceGroupName")
  valid_597061 = validateParameter(valid_597061, JString, required = true,
                                 default = nil)
  if valid_597061 != nil:
    section.add "resourceGroupName", valid_597061
  var valid_597062 = path.getOrDefault("subscriptionId")
  valid_597062 = validateParameter(valid_597062, JString, required = true,
                                 default = nil)
  if valid_597062 != nil:
    section.add "subscriptionId", valid_597062
  var valid_597063 = path.getOrDefault("serviceName")
  valid_597063 = validateParameter(valid_597063, JString, required = true,
                                 default = nil)
  if valid_597063 != nil:
    section.add "serviceName", valid_597063
  var valid_597064 = path.getOrDefault("userId")
  valid_597064 = validateParameter(valid_597064, JString, required = true,
                                 default = nil)
  if valid_597064 != nil:
    section.add "userId", valid_597064
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597065 = query.getOrDefault("api-version")
  valid_597065 = validateParameter(valid_597065, JString, required = true,
                                 default = nil)
  if valid_597065 != nil:
    section.add "api-version", valid_597065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597066: Call_UserGetEntityTag_597058; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the user specified by its identifier.
  ## 
  let valid = call_597066.validator(path, query, header, formData, body)
  let scheme = call_597066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597066.url(scheme.get, call_597066.host, call_597066.base,
                         call_597066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597066, url, valid)

proc call*(call_597067: Call_UserGetEntityTag_597058; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          userId: string): Recallable =
  ## userGetEntityTag
  ## Gets the entity state (Etag) version of the user specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   userId: string (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  var path_597068 = newJObject()
  var query_597069 = newJObject()
  add(path_597068, "resourceGroupName", newJString(resourceGroupName))
  add(query_597069, "api-version", newJString(apiVersion))
  add(path_597068, "subscriptionId", newJString(subscriptionId))
  add(path_597068, "serviceName", newJString(serviceName))
  add(path_597068, "userId", newJString(userId))
  result = call_597067.call(path_597068, query_597069, nil, nil, nil)

var userGetEntityTag* = Call_UserGetEntityTag_597058(name: "userGetEntityTag",
    meth: HttpMethod.HttpHead, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{userId}",
    validator: validate_UserGetEntityTag_597059, base: "",
    url: url_UserGetEntityTag_597060, schemes: {Scheme.Https})
type
  Call_UserGet_596989 = ref object of OpenApiRestCall_596457
proc url_UserGet_596991(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserGet_596990(path: JsonNode; query: JsonNode; header: JsonNode;
                            formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the user specified by its identifier.
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
  ##   userId: JString (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_596992 = path.getOrDefault("resourceGroupName")
  valid_596992 = validateParameter(valid_596992, JString, required = true,
                                 default = nil)
  if valid_596992 != nil:
    section.add "resourceGroupName", valid_596992
  var valid_596993 = path.getOrDefault("subscriptionId")
  valid_596993 = validateParameter(valid_596993, JString, required = true,
                                 default = nil)
  if valid_596993 != nil:
    section.add "subscriptionId", valid_596993
  var valid_596994 = path.getOrDefault("serviceName")
  valid_596994 = validateParameter(valid_596994, JString, required = true,
                                 default = nil)
  if valid_596994 != nil:
    section.add "serviceName", valid_596994
  var valid_596995 = path.getOrDefault("userId")
  valid_596995 = validateParameter(valid_596995, JString, required = true,
                                 default = nil)
  if valid_596995 != nil:
    section.add "userId", valid_596995
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

proc call*(call_596997: Call_UserGet_596989; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the user specified by its identifier.
  ## 
  let valid = call_596997.validator(path, query, header, formData, body)
  let scheme = call_596997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596997.url(scheme.get, call_596997.host, call_596997.base,
                         call_596997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596997, url, valid)

proc call*(call_596998: Call_UserGet_596989; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          userId: string): Recallable =
  ## userGet
  ## Gets the details of the user specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   userId: string (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  var path_596999 = newJObject()
  var query_597000 = newJObject()
  add(path_596999, "resourceGroupName", newJString(resourceGroupName))
  add(query_597000, "api-version", newJString(apiVersion))
  add(path_596999, "subscriptionId", newJString(subscriptionId))
  add(path_596999, "serviceName", newJString(serviceName))
  add(path_596999, "userId", newJString(userId))
  result = call_596998.call(path_596999, query_597000, nil, nil, nil)

var userGet* = Call_UserGet_596989(name: "userGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{userId}",
                                validator: validate_UserGet_596990, base: "",
                                url: url_UserGet_596991, schemes: {Scheme.Https})
type
  Call_UserUpdate_597070 = ref object of OpenApiRestCall_596457
proc url_UserUpdate_597072(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserUpdate_597071(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the details of the user specified by its identifier.
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
  ##   userId: JString (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597073 = path.getOrDefault("resourceGroupName")
  valid_597073 = validateParameter(valid_597073, JString, required = true,
                                 default = nil)
  if valid_597073 != nil:
    section.add "resourceGroupName", valid_597073
  var valid_597074 = path.getOrDefault("subscriptionId")
  valid_597074 = validateParameter(valid_597074, JString, required = true,
                                 default = nil)
  if valid_597074 != nil:
    section.add "subscriptionId", valid_597074
  var valid_597075 = path.getOrDefault("serviceName")
  valid_597075 = validateParameter(valid_597075, JString, required = true,
                                 default = nil)
  if valid_597075 != nil:
    section.add "serviceName", valid_597075
  var valid_597076 = path.getOrDefault("userId")
  valid_597076 = validateParameter(valid_597076, JString, required = true,
                                 default = nil)
  if valid_597076 != nil:
    section.add "userId", valid_597076
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597077 = query.getOrDefault("api-version")
  valid_597077 = validateParameter(valid_597077, JString, required = true,
                                 default = nil)
  if valid_597077 != nil:
    section.add "api-version", valid_597077
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597078 = header.getOrDefault("If-Match")
  valid_597078 = validateParameter(valid_597078, JString, required = true,
                                 default = nil)
  if valid_597078 != nil:
    section.add "If-Match", valid_597078
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

proc call*(call_597080: Call_UserUpdate_597070; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the user specified by its identifier.
  ## 
  let valid = call_597080.validator(path, query, header, formData, body)
  let scheme = call_597080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597080.url(scheme.get, call_597080.host, call_597080.base,
                         call_597080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597080, url, valid)

proc call*(call_597081: Call_UserUpdate_597070; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          serviceName: string; userId: string): Recallable =
  ## userUpdate
  ## Updates the details of the user specified by its identifier.
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
  ##   userId: string (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  var path_597082 = newJObject()
  var query_597083 = newJObject()
  var body_597084 = newJObject()
  add(path_597082, "resourceGroupName", newJString(resourceGroupName))
  add(query_597083, "api-version", newJString(apiVersion))
  add(path_597082, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597084 = parameters
  add(path_597082, "serviceName", newJString(serviceName))
  add(path_597082, "userId", newJString(userId))
  result = call_597081.call(path_597082, query_597083, nil, nil, body_597084)

var userUpdate* = Call_UserUpdate_597070(name: "userUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{userId}",
                                      validator: validate_UserUpdate_597071,
                                      base: "", url: url_UserUpdate_597072,
                                      schemes: {Scheme.Https})
type
  Call_UserDelete_597043 = ref object of OpenApiRestCall_596457
proc url_UserDelete_597045(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserDelete_597044(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes specific user.
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
  ##   userId: JString (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597046 = path.getOrDefault("resourceGroupName")
  valid_597046 = validateParameter(valid_597046, JString, required = true,
                                 default = nil)
  if valid_597046 != nil:
    section.add "resourceGroupName", valid_597046
  var valid_597047 = path.getOrDefault("subscriptionId")
  valid_597047 = validateParameter(valid_597047, JString, required = true,
                                 default = nil)
  if valid_597047 != nil:
    section.add "subscriptionId", valid_597047
  var valid_597048 = path.getOrDefault("serviceName")
  valid_597048 = validateParameter(valid_597048, JString, required = true,
                                 default = nil)
  if valid_597048 != nil:
    section.add "serviceName", valid_597048
  var valid_597049 = path.getOrDefault("userId")
  valid_597049 = validateParameter(valid_597049, JString, required = true,
                                 default = nil)
  if valid_597049 != nil:
    section.add "userId", valid_597049
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   deleteSubscriptions: JBool
  ##                      : Whether to delete user's subscription or not.
  ##   notify: JBool
  ##         : Send an Account Closed Email notification to the User.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597050 = query.getOrDefault("api-version")
  valid_597050 = validateParameter(valid_597050, JString, required = true,
                                 default = nil)
  if valid_597050 != nil:
    section.add "api-version", valid_597050
  var valid_597051 = query.getOrDefault("deleteSubscriptions")
  valid_597051 = validateParameter(valid_597051, JBool, required = false, default = nil)
  if valid_597051 != nil:
    section.add "deleteSubscriptions", valid_597051
  var valid_597052 = query.getOrDefault("notify")
  valid_597052 = validateParameter(valid_597052, JBool, required = false, default = nil)
  if valid_597052 != nil:
    section.add "notify", valid_597052
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597053 = header.getOrDefault("If-Match")
  valid_597053 = validateParameter(valid_597053, JString, required = true,
                                 default = nil)
  if valid_597053 != nil:
    section.add "If-Match", valid_597053
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597054: Call_UserDelete_597043; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specific user.
  ## 
  let valid = call_597054.validator(path, query, header, formData, body)
  let scheme = call_597054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597054.url(scheme.get, call_597054.host, call_597054.base,
                         call_597054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597054, url, valid)

proc call*(call_597055: Call_UserDelete_597043; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          userId: string; deleteSubscriptions: bool = false; notify: bool = false): Recallable =
  ## userDelete
  ## Deletes specific user.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   deleteSubscriptions: bool
  ##                      : Whether to delete user's subscription or not.
  ##   notify: bool
  ##         : Send an Account Closed Email notification to the User.
  ##   userId: string (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  var path_597056 = newJObject()
  var query_597057 = newJObject()
  add(path_597056, "resourceGroupName", newJString(resourceGroupName))
  add(query_597057, "api-version", newJString(apiVersion))
  add(path_597056, "subscriptionId", newJString(subscriptionId))
  add(path_597056, "serviceName", newJString(serviceName))
  add(query_597057, "deleteSubscriptions", newJBool(deleteSubscriptions))
  add(query_597057, "notify", newJBool(notify))
  add(path_597056, "userId", newJString(userId))
  result = call_597055.call(path_597056, query_597057, nil, nil, nil)

var userDelete* = Call_UserDelete_597043(name: "userDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{userId}",
                                      validator: validate_UserDelete_597044,
                                      base: "", url: url_UserDelete_597045,
                                      schemes: {Scheme.Https})
type
  Call_UserConfirmationPasswordSend_597085 = ref object of OpenApiRestCall_596457
proc url_UserConfirmationPasswordSend_597087(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/confirmations/password/send")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserConfirmationPasswordSend_597086(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sends confirmation
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
  ##   userId: JString (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597088 = path.getOrDefault("resourceGroupName")
  valid_597088 = validateParameter(valid_597088, JString, required = true,
                                 default = nil)
  if valid_597088 != nil:
    section.add "resourceGroupName", valid_597088
  var valid_597089 = path.getOrDefault("subscriptionId")
  valid_597089 = validateParameter(valid_597089, JString, required = true,
                                 default = nil)
  if valid_597089 != nil:
    section.add "subscriptionId", valid_597089
  var valid_597090 = path.getOrDefault("serviceName")
  valid_597090 = validateParameter(valid_597090, JString, required = true,
                                 default = nil)
  if valid_597090 != nil:
    section.add "serviceName", valid_597090
  var valid_597091 = path.getOrDefault("userId")
  valid_597091 = validateParameter(valid_597091, JString, required = true,
                                 default = nil)
  if valid_597091 != nil:
    section.add "userId", valid_597091
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597092 = query.getOrDefault("api-version")
  valid_597092 = validateParameter(valid_597092, JString, required = true,
                                 default = nil)
  if valid_597092 != nil:
    section.add "api-version", valid_597092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597093: Call_UserConfirmationPasswordSend_597085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends confirmation
  ## 
  let valid = call_597093.validator(path, query, header, formData, body)
  let scheme = call_597093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597093.url(scheme.get, call_597093.host, call_597093.base,
                         call_597093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597093, url, valid)

proc call*(call_597094: Call_UserConfirmationPasswordSend_597085;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; userId: string): Recallable =
  ## userConfirmationPasswordSend
  ## Sends confirmation
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   userId: string (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  var path_597095 = newJObject()
  var query_597096 = newJObject()
  add(path_597095, "resourceGroupName", newJString(resourceGroupName))
  add(query_597096, "api-version", newJString(apiVersion))
  add(path_597095, "subscriptionId", newJString(subscriptionId))
  add(path_597095, "serviceName", newJString(serviceName))
  add(path_597095, "userId", newJString(userId))
  result = call_597094.call(path_597095, query_597096, nil, nil, nil)

var userConfirmationPasswordSend* = Call_UserConfirmationPasswordSend_597085(
    name: "userConfirmationPasswordSend", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{userId}/confirmations/password/send",
    validator: validate_UserConfirmationPasswordSend_597086, base: "",
    url: url_UserConfirmationPasswordSend_597087, schemes: {Scheme.Https})
type
  Call_UserGenerateSsoUrl_597097 = ref object of OpenApiRestCall_596457
proc url_UserGenerateSsoUrl_597099(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/generateSsoUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserGenerateSsoUrl_597098(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves a redirection URL containing an authentication token for signing a given user into the developer portal.
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
  ##   userId: JString (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597100 = path.getOrDefault("resourceGroupName")
  valid_597100 = validateParameter(valid_597100, JString, required = true,
                                 default = nil)
  if valid_597100 != nil:
    section.add "resourceGroupName", valid_597100
  var valid_597101 = path.getOrDefault("subscriptionId")
  valid_597101 = validateParameter(valid_597101, JString, required = true,
                                 default = nil)
  if valid_597101 != nil:
    section.add "subscriptionId", valid_597101
  var valid_597102 = path.getOrDefault("serviceName")
  valid_597102 = validateParameter(valid_597102, JString, required = true,
                                 default = nil)
  if valid_597102 != nil:
    section.add "serviceName", valid_597102
  var valid_597103 = path.getOrDefault("userId")
  valid_597103 = validateParameter(valid_597103, JString, required = true,
                                 default = nil)
  if valid_597103 != nil:
    section.add "userId", valid_597103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597104 = query.getOrDefault("api-version")
  valid_597104 = validateParameter(valid_597104, JString, required = true,
                                 default = nil)
  if valid_597104 != nil:
    section.add "api-version", valid_597104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597105: Call_UserGenerateSsoUrl_597097; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a redirection URL containing an authentication token for signing a given user into the developer portal.
  ## 
  let valid = call_597105.validator(path, query, header, formData, body)
  let scheme = call_597105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597105.url(scheme.get, call_597105.host, call_597105.base,
                         call_597105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597105, url, valid)

proc call*(call_597106: Call_UserGenerateSsoUrl_597097; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          userId: string): Recallable =
  ## userGenerateSsoUrl
  ## Retrieves a redirection URL containing an authentication token for signing a given user into the developer portal.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   userId: string (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  var path_597107 = newJObject()
  var query_597108 = newJObject()
  add(path_597107, "resourceGroupName", newJString(resourceGroupName))
  add(query_597108, "api-version", newJString(apiVersion))
  add(path_597107, "subscriptionId", newJString(subscriptionId))
  add(path_597107, "serviceName", newJString(serviceName))
  add(path_597107, "userId", newJString(userId))
  result = call_597106.call(path_597107, query_597108, nil, nil, nil)

var userGenerateSsoUrl* = Call_UserGenerateSsoUrl_597097(
    name: "userGenerateSsoUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{userId}/generateSsoUrl",
    validator: validate_UserGenerateSsoUrl_597098, base: "",
    url: url_UserGenerateSsoUrl_597099, schemes: {Scheme.Https})
type
  Call_UserGroupList_597109 = ref object of OpenApiRestCall_596457
proc url_UserGroupList_597111(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/groups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserGroupList_597110(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all user groups.
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
  ##   userId: JString (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597112 = path.getOrDefault("resourceGroupName")
  valid_597112 = validateParameter(valid_597112, JString, required = true,
                                 default = nil)
  if valid_597112 != nil:
    section.add "resourceGroupName", valid_597112
  var valid_597113 = path.getOrDefault("subscriptionId")
  valid_597113 = validateParameter(valid_597113, JString, required = true,
                                 default = nil)
  if valid_597113 != nil:
    section.add "subscriptionId", valid_597113
  var valid_597114 = path.getOrDefault("serviceName")
  valid_597114 = validateParameter(valid_597114, JString, required = true,
                                 default = nil)
  if valid_597114 != nil:
    section.add "serviceName", valid_597114
  var valid_597115 = path.getOrDefault("userId")
  valid_597115 = validateParameter(valid_597115, JString, required = true,
                                 default = nil)
  if valid_597115 != nil:
    section.add "userId", valid_597115
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
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597116 = query.getOrDefault("api-version")
  valid_597116 = validateParameter(valid_597116, JString, required = true,
                                 default = nil)
  if valid_597116 != nil:
    section.add "api-version", valid_597116
  var valid_597117 = query.getOrDefault("$top")
  valid_597117 = validateParameter(valid_597117, JInt, required = false, default = nil)
  if valid_597117 != nil:
    section.add "$top", valid_597117
  var valid_597118 = query.getOrDefault("$skip")
  valid_597118 = validateParameter(valid_597118, JInt, required = false, default = nil)
  if valid_597118 != nil:
    section.add "$skip", valid_597118
  var valid_597119 = query.getOrDefault("$filter")
  valid_597119 = validateParameter(valid_597119, JString, required = false,
                                 default = nil)
  if valid_597119 != nil:
    section.add "$filter", valid_597119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597120: Call_UserGroupList_597109; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all user groups.
  ## 
  let valid = call_597120.validator(path, query, header, formData, body)
  let scheme = call_597120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597120.url(scheme.get, call_597120.host, call_597120.base,
                         call_597120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597120, url, valid)

proc call*(call_597121: Call_UserGroupList_597109; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          userId: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## userGroupList
  ## Lists all user groups.
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
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  ##   userId: string (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  var path_597122 = newJObject()
  var query_597123 = newJObject()
  add(path_597122, "resourceGroupName", newJString(resourceGroupName))
  add(query_597123, "api-version", newJString(apiVersion))
  add(path_597122, "subscriptionId", newJString(subscriptionId))
  add(query_597123, "$top", newJInt(Top))
  add(query_597123, "$skip", newJInt(Skip))
  add(path_597122, "serviceName", newJString(serviceName))
  add(query_597123, "$filter", newJString(Filter))
  add(path_597122, "userId", newJString(userId))
  result = call_597121.call(path_597122, query_597123, nil, nil, nil)

var userGroupList* = Call_UserGroupList_597109(name: "userGroupList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{userId}/groups",
    validator: validate_UserGroupList_597110, base: "", url: url_UserGroupList_597111,
    schemes: {Scheme.Https})
type
  Call_UserIdentitiesList_597124 = ref object of OpenApiRestCall_596457
proc url_UserIdentitiesList_597126(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/identities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserIdentitiesList_597125(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## List of all user identities.
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
  ##   userId: JString (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597127 = path.getOrDefault("resourceGroupName")
  valid_597127 = validateParameter(valid_597127, JString, required = true,
                                 default = nil)
  if valid_597127 != nil:
    section.add "resourceGroupName", valid_597127
  var valid_597128 = path.getOrDefault("subscriptionId")
  valid_597128 = validateParameter(valid_597128, JString, required = true,
                                 default = nil)
  if valid_597128 != nil:
    section.add "subscriptionId", valid_597128
  var valid_597129 = path.getOrDefault("serviceName")
  valid_597129 = validateParameter(valid_597129, JString, required = true,
                                 default = nil)
  if valid_597129 != nil:
    section.add "serviceName", valid_597129
  var valid_597130 = path.getOrDefault("userId")
  valid_597130 = validateParameter(valid_597130, JString, required = true,
                                 default = nil)
  if valid_597130 != nil:
    section.add "userId", valid_597130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597131 = query.getOrDefault("api-version")
  valid_597131 = validateParameter(valid_597131, JString, required = true,
                                 default = nil)
  if valid_597131 != nil:
    section.add "api-version", valid_597131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597132: Call_UserIdentitiesList_597124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List of all user identities.
  ## 
  let valid = call_597132.validator(path, query, header, formData, body)
  let scheme = call_597132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597132.url(scheme.get, call_597132.host, call_597132.base,
                         call_597132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597132, url, valid)

proc call*(call_597133: Call_UserIdentitiesList_597124; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          userId: string): Recallable =
  ## userIdentitiesList
  ## List of all user identities.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   userId: string (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  var path_597134 = newJObject()
  var query_597135 = newJObject()
  add(path_597134, "resourceGroupName", newJString(resourceGroupName))
  add(query_597135, "api-version", newJString(apiVersion))
  add(path_597134, "subscriptionId", newJString(subscriptionId))
  add(path_597134, "serviceName", newJString(serviceName))
  add(path_597134, "userId", newJString(userId))
  result = call_597133.call(path_597134, query_597135, nil, nil, nil)

var userIdentitiesList* = Call_UserIdentitiesList_597124(
    name: "userIdentitiesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{userId}/identities",
    validator: validate_UserIdentitiesList_597125, base: "",
    url: url_UserIdentitiesList_597126, schemes: {Scheme.Https})
type
  Call_UserSubscriptionList_597136 = ref object of OpenApiRestCall_596457
proc url_UserSubscriptionList_597138(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/subscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserSubscriptionList_597137(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the collection of subscriptions of the specified user.
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
  ##   userId: JString (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597139 = path.getOrDefault("resourceGroupName")
  valid_597139 = validateParameter(valid_597139, JString, required = true,
                                 default = nil)
  if valid_597139 != nil:
    section.add "resourceGroupName", valid_597139
  var valid_597140 = path.getOrDefault("subscriptionId")
  valid_597140 = validateParameter(valid_597140, JString, required = true,
                                 default = nil)
  if valid_597140 != nil:
    section.add "subscriptionId", valid_597140
  var valid_597141 = path.getOrDefault("serviceName")
  valid_597141 = validateParameter(valid_597141, JString, required = true,
                                 default = nil)
  if valid_597141 != nil:
    section.add "serviceName", valid_597141
  var valid_597142 = path.getOrDefault("userId")
  valid_597142 = validateParameter(valid_597142, JString, required = true,
                                 default = nil)
  if valid_597142 != nil:
    section.add "userId", valid_597142
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
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |stateComment | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |ownerId | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |scope | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |userId | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |productId | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597143 = query.getOrDefault("api-version")
  valid_597143 = validateParameter(valid_597143, JString, required = true,
                                 default = nil)
  if valid_597143 != nil:
    section.add "api-version", valid_597143
  var valid_597144 = query.getOrDefault("$top")
  valid_597144 = validateParameter(valid_597144, JInt, required = false, default = nil)
  if valid_597144 != nil:
    section.add "$top", valid_597144
  var valid_597145 = query.getOrDefault("$skip")
  valid_597145 = validateParameter(valid_597145, JInt, required = false, default = nil)
  if valid_597145 != nil:
    section.add "$skip", valid_597145
  var valid_597146 = query.getOrDefault("$filter")
  valid_597146 = validateParameter(valid_597146, JString, required = false,
                                 default = nil)
  if valid_597146 != nil:
    section.add "$filter", valid_597146
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597147: Call_UserSubscriptionList_597136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the collection of subscriptions of the specified user.
  ## 
  let valid = call_597147.validator(path, query, header, formData, body)
  let scheme = call_597147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597147.url(scheme.get, call_597147.host, call_597147.base,
                         call_597147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597147, url, valid)

proc call*(call_597148: Call_UserSubscriptionList_597136;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; userId: string; Top: int = 0; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## userSubscriptionList
  ## Lists the collection of subscriptions of the specified user.
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
  ##         : | Field       | Supported operators    | Supported functions               |
  ## |-------------|------------------------|-----------------------------------|
  ## 
  ## |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |displayName | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |stateComment | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |ownerId | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |scope | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |userId | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## |productId | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
  ## 
  ##   userId: string (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  var path_597149 = newJObject()
  var query_597150 = newJObject()
  add(path_597149, "resourceGroupName", newJString(resourceGroupName))
  add(query_597150, "api-version", newJString(apiVersion))
  add(path_597149, "subscriptionId", newJString(subscriptionId))
  add(query_597150, "$top", newJInt(Top))
  add(query_597150, "$skip", newJInt(Skip))
  add(path_597149, "serviceName", newJString(serviceName))
  add(query_597150, "$filter", newJString(Filter))
  add(path_597149, "userId", newJString(userId))
  result = call_597148.call(path_597149, query_597150, nil, nil, nil)

var userSubscriptionList* = Call_UserSubscriptionList_597136(
    name: "userSubscriptionList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{userId}/subscriptions",
    validator: validate_UserSubscriptionList_597137, base: "",
    url: url_UserSubscriptionList_597138, schemes: {Scheme.Https})
type
  Call_UserGetSharedAccessToken_597151 = ref object of OpenApiRestCall_596457
proc url_UserGetSharedAccessToken_597153(protocol: Scheme; host: string;
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
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/token")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserGetSharedAccessToken_597152(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Shared Access Authorization Token for the User.
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
  ##   userId: JString (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597154 = path.getOrDefault("resourceGroupName")
  valid_597154 = validateParameter(valid_597154, JString, required = true,
                                 default = nil)
  if valid_597154 != nil:
    section.add "resourceGroupName", valid_597154
  var valid_597155 = path.getOrDefault("subscriptionId")
  valid_597155 = validateParameter(valid_597155, JString, required = true,
                                 default = nil)
  if valid_597155 != nil:
    section.add "subscriptionId", valid_597155
  var valid_597156 = path.getOrDefault("serviceName")
  valid_597156 = validateParameter(valid_597156, JString, required = true,
                                 default = nil)
  if valid_597156 != nil:
    section.add "serviceName", valid_597156
  var valid_597157 = path.getOrDefault("userId")
  valid_597157 = validateParameter(valid_597157, JString, required = true,
                                 default = nil)
  if valid_597157 != nil:
    section.add "userId", valid_597157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597158 = query.getOrDefault("api-version")
  valid_597158 = validateParameter(valid_597158, JString, required = true,
                                 default = nil)
  if valid_597158 != nil:
    section.add "api-version", valid_597158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create Authorization Token parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597160: Call_UserGetSharedAccessToken_597151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Shared Access Authorization Token for the User.
  ## 
  let valid = call_597160.validator(path, query, header, formData, body)
  let scheme = call_597160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597160.url(scheme.get, call_597160.host, call_597160.base,
                         call_597160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597160, url, valid)

proc call*(call_597161: Call_UserGetSharedAccessToken_597151;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string; userId: string): Recallable =
  ## userGetSharedAccessToken
  ## Gets the Shared Access Authorization Token for the User.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Create Authorization Token parameters.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   userId: string (required)
  ##         : User identifier. Must be unique in the current API Management service instance.
  var path_597162 = newJObject()
  var query_597163 = newJObject()
  var body_597164 = newJObject()
  add(path_597162, "resourceGroupName", newJString(resourceGroupName))
  add(query_597163, "api-version", newJString(apiVersion))
  add(path_597162, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597164 = parameters
  add(path_597162, "serviceName", newJString(serviceName))
  add(path_597162, "userId", newJString(userId))
  result = call_597161.call(path_597162, query_597163, nil, nil, body_597164)

var userGetSharedAccessToken* = Call_UserGetSharedAccessToken_597151(
    name: "userGetSharedAccessToken", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{userId}/token",
    validator: validate_UserGetSharedAccessToken_597152, base: "",
    url: url_UserGetSharedAccessToken_597153, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
