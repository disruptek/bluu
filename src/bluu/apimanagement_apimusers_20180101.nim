
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2018-01-01
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
  Call_UserGetIdentity_596679 = ref object of OpenApiRestCall_596457
proc url_UserGetIdentity_596681(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/identity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserGetIdentity_596680(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Returns calling user identity information.
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
  var valid_596841 = path.getOrDefault("resourceGroupName")
  valid_596841 = validateParameter(valid_596841, JString, required = true,
                                 default = nil)
  if valid_596841 != nil:
    section.add "resourceGroupName", valid_596841
  var valid_596842 = path.getOrDefault("subscriptionId")
  valid_596842 = validateParameter(valid_596842, JString, required = true,
                                 default = nil)
  if valid_596842 != nil:
    section.add "subscriptionId", valid_596842
  var valid_596843 = path.getOrDefault("serviceName")
  valid_596843 = validateParameter(valid_596843, JString, required = true,
                                 default = nil)
  if valid_596843 != nil:
    section.add "serviceName", valid_596843
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596844 = query.getOrDefault("api-version")
  valid_596844 = validateParameter(valid_596844, JString, required = true,
                                 default = nil)
  if valid_596844 != nil:
    section.add "api-version", valid_596844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596871: Call_UserGetIdentity_596679; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns calling user identity information.
  ## 
  let valid = call_596871.validator(path, query, header, formData, body)
  let scheme = call_596871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596871.url(scheme.get, call_596871.host, call_596871.base,
                         call_596871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596871, url, valid)

proc call*(call_596942: Call_UserGetIdentity_596679; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string): Recallable =
  ## userGetIdentity
  ## Returns calling user identity information.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_596943 = newJObject()
  var query_596945 = newJObject()
  add(path_596943, "resourceGroupName", newJString(resourceGroupName))
  add(query_596945, "api-version", newJString(apiVersion))
  add(path_596943, "subscriptionId", newJString(subscriptionId))
  add(path_596943, "serviceName", newJString(serviceName))
  result = call_596942.call(path_596943, query_596945, nil, nil, nil)

var userGetIdentity* = Call_UserGetIdentity_596679(name: "userGetIdentity",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/identity",
    validator: validate_UserGetIdentity_596680, base: "", url: url_UserGetIdentity_596681,
    schemes: {Scheme.Https})
type
  Call_UserListByService_596984 = ref object of OpenApiRestCall_596457
proc url_UserListByService_596986(protocol: Scheme; host: string; base: string;
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

proc validate_UserListByService_596985(path: JsonNode; query: JsonNode;
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
  var valid_596988 = path.getOrDefault("resourceGroupName")
  valid_596988 = validateParameter(valid_596988, JString, required = true,
                                 default = nil)
  if valid_596988 != nil:
    section.add "resourceGroupName", valid_596988
  var valid_596989 = path.getOrDefault("subscriptionId")
  valid_596989 = validateParameter(valid_596989, JString, required = true,
                                 default = nil)
  if valid_596989 != nil:
    section.add "subscriptionId", valid_596989
  var valid_596990 = path.getOrDefault("serviceName")
  valid_596990 = validateParameter(valid_596990, JString, required = true,
                                 default = nil)
  if valid_596990 != nil:
    section.add "serviceName", valid_596990
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field            | Supported operators    | Supported functions               |
  ## 
  ## |------------------|------------------------|-----------------------------------|
  ## | id               | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | firstName        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | lastName         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | email            | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state            | eq                     | N/A                               |
  ## | registrationDate | ge, le, eq, ne, gt, lt | N/A                               |
  ## | note             | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596991 = query.getOrDefault("api-version")
  valid_596991 = validateParameter(valid_596991, JString, required = true,
                                 default = nil)
  if valid_596991 != nil:
    section.add "api-version", valid_596991
  var valid_596992 = query.getOrDefault("$top")
  valid_596992 = validateParameter(valid_596992, JInt, required = false, default = nil)
  if valid_596992 != nil:
    section.add "$top", valid_596992
  var valid_596993 = query.getOrDefault("$skip")
  valid_596993 = validateParameter(valid_596993, JInt, required = false, default = nil)
  if valid_596993 != nil:
    section.add "$skip", valid_596993
  var valid_596994 = query.getOrDefault("$filter")
  valid_596994 = validateParameter(valid_596994, JString, required = false,
                                 default = nil)
  if valid_596994 != nil:
    section.add "$filter", valid_596994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596995: Call_UserListByService_596984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of registered users in the specified service instance.
  ## 
  let valid = call_596995.validator(path, query, header, formData, body)
  let scheme = call_596995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596995.url(scheme.get, call_596995.host, call_596995.base,
                         call_596995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596995, url, valid)

proc call*(call_596996: Call_UserListByService_596984; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
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
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field            | Supported operators    | Supported functions               |
  ## 
  ## |------------------|------------------------|-----------------------------------|
  ## | id               | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | firstName        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | lastName         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | email            | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state            | eq                     | N/A                               |
  ## | registrationDate | ge, le, eq, ne, gt, lt | N/A                               |
  ## | note             | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_596997 = newJObject()
  var query_596998 = newJObject()
  add(path_596997, "resourceGroupName", newJString(resourceGroupName))
  add(query_596998, "api-version", newJString(apiVersion))
  add(path_596997, "subscriptionId", newJString(subscriptionId))
  add(query_596998, "$top", newJInt(Top))
  add(query_596998, "$skip", newJInt(Skip))
  add(path_596997, "serviceName", newJString(serviceName))
  add(query_596998, "$filter", newJString(Filter))
  result = call_596996.call(path_596997, query_596998, nil, nil, nil)

var userListByService* = Call_UserListByService_596984(name: "userListByService",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users",
    validator: validate_UserListByService_596985, base: "",
    url: url_UserListByService_596986, schemes: {Scheme.Https})
type
  Call_UserCreateOrUpdate_597020 = ref object of OpenApiRestCall_596457
proc url_UserCreateOrUpdate_597022(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserCreateOrUpdate_597021(path: JsonNode; query: JsonNode;
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
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597040 = path.getOrDefault("resourceGroupName")
  valid_597040 = validateParameter(valid_597040, JString, required = true,
                                 default = nil)
  if valid_597040 != nil:
    section.add "resourceGroupName", valid_597040
  var valid_597041 = path.getOrDefault("subscriptionId")
  valid_597041 = validateParameter(valid_597041, JString, required = true,
                                 default = nil)
  if valid_597041 != nil:
    section.add "subscriptionId", valid_597041
  var valid_597042 = path.getOrDefault("uid")
  valid_597042 = validateParameter(valid_597042, JString, required = true,
                                 default = nil)
  if valid_597042 != nil:
    section.add "uid", valid_597042
  var valid_597043 = path.getOrDefault("serviceName")
  valid_597043 = validateParameter(valid_597043, JString, required = true,
                                 default = nil)
  if valid_597043 != nil:
    section.add "serviceName", valid_597043
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597044 = query.getOrDefault("api-version")
  valid_597044 = validateParameter(valid_597044, JString, required = true,
                                 default = nil)
  if valid_597044 != nil:
    section.add "api-version", valid_597044
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the Entity. Not required when creating an entity, but required when updating an entity.
  section = newJObject()
  var valid_597045 = header.getOrDefault("If-Match")
  valid_597045 = validateParameter(valid_597045, JString, required = false,
                                 default = nil)
  if valid_597045 != nil:
    section.add "If-Match", valid_597045
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

proc call*(call_597047: Call_UserCreateOrUpdate_597020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates a user.
  ## 
  let valid = call_597047.validator(path, query, header, formData, body)
  let scheme = call_597047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597047.url(scheme.get, call_597047.host, call_597047.base,
                         call_597047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597047, url, valid)

proc call*(call_597048: Call_UserCreateOrUpdate_597020; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          uid: string; serviceName: string): Recallable =
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
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597049 = newJObject()
  var query_597050 = newJObject()
  var body_597051 = newJObject()
  add(path_597049, "resourceGroupName", newJString(resourceGroupName))
  add(query_597050, "api-version", newJString(apiVersion))
  add(path_597049, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597051 = parameters
  add(path_597049, "uid", newJString(uid))
  add(path_597049, "serviceName", newJString(serviceName))
  result = call_597048.call(path_597049, query_597050, nil, nil, body_597051)

var userCreateOrUpdate* = Call_UserCreateOrUpdate_597020(
    name: "userCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}",
    validator: validate_UserCreateOrUpdate_597021, base: "",
    url: url_UserCreateOrUpdate_597022, schemes: {Scheme.Https})
type
  Call_UserGetEntityTag_597067 = ref object of OpenApiRestCall_596457
proc url_UserGetEntityTag_597069(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserGetEntityTag_597068(path: JsonNode; query: JsonNode;
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
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597070 = path.getOrDefault("resourceGroupName")
  valid_597070 = validateParameter(valid_597070, JString, required = true,
                                 default = nil)
  if valid_597070 != nil:
    section.add "resourceGroupName", valid_597070
  var valid_597071 = path.getOrDefault("subscriptionId")
  valid_597071 = validateParameter(valid_597071, JString, required = true,
                                 default = nil)
  if valid_597071 != nil:
    section.add "subscriptionId", valid_597071
  var valid_597072 = path.getOrDefault("uid")
  valid_597072 = validateParameter(valid_597072, JString, required = true,
                                 default = nil)
  if valid_597072 != nil:
    section.add "uid", valid_597072
  var valid_597073 = path.getOrDefault("serviceName")
  valid_597073 = validateParameter(valid_597073, JString, required = true,
                                 default = nil)
  if valid_597073 != nil:
    section.add "serviceName", valid_597073
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597074 = query.getOrDefault("api-version")
  valid_597074 = validateParameter(valid_597074, JString, required = true,
                                 default = nil)
  if valid_597074 != nil:
    section.add "api-version", valid_597074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597075: Call_UserGetEntityTag_597067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the user specified by its identifier.
  ## 
  let valid = call_597075.validator(path, query, header, formData, body)
  let scheme = call_597075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597075.url(scheme.get, call_597075.host, call_597075.base,
                         call_597075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597075, url, valid)

proc call*(call_597076: Call_UserGetEntityTag_597067; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; uid: string; serviceName: string): Recallable =
  ## userGetEntityTag
  ## Gets the entity state (Etag) version of the user specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597077 = newJObject()
  var query_597078 = newJObject()
  add(path_597077, "resourceGroupName", newJString(resourceGroupName))
  add(query_597078, "api-version", newJString(apiVersion))
  add(path_597077, "subscriptionId", newJString(subscriptionId))
  add(path_597077, "uid", newJString(uid))
  add(path_597077, "serviceName", newJString(serviceName))
  result = call_597076.call(path_597077, query_597078, nil, nil, nil)

var userGetEntityTag* = Call_UserGetEntityTag_597067(name: "userGetEntityTag",
    meth: HttpMethod.HttpHead, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}",
    validator: validate_UserGetEntityTag_597068, base: "",
    url: url_UserGetEntityTag_597069, schemes: {Scheme.Https})
type
  Call_UserGet_596999 = ref object of OpenApiRestCall_596457
proc url_UserGet_597001(protocol: Scheme; host: string; base: string; route: string;
                       path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserGet_597000(path: JsonNode; query: JsonNode; header: JsonNode;
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
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597011 = path.getOrDefault("resourceGroupName")
  valid_597011 = validateParameter(valid_597011, JString, required = true,
                                 default = nil)
  if valid_597011 != nil:
    section.add "resourceGroupName", valid_597011
  var valid_597012 = path.getOrDefault("subscriptionId")
  valid_597012 = validateParameter(valid_597012, JString, required = true,
                                 default = nil)
  if valid_597012 != nil:
    section.add "subscriptionId", valid_597012
  var valid_597013 = path.getOrDefault("uid")
  valid_597013 = validateParameter(valid_597013, JString, required = true,
                                 default = nil)
  if valid_597013 != nil:
    section.add "uid", valid_597013
  var valid_597014 = path.getOrDefault("serviceName")
  valid_597014 = validateParameter(valid_597014, JString, required = true,
                                 default = nil)
  if valid_597014 != nil:
    section.add "serviceName", valid_597014
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597015 = query.getOrDefault("api-version")
  valid_597015 = validateParameter(valid_597015, JString, required = true,
                                 default = nil)
  if valid_597015 != nil:
    section.add "api-version", valid_597015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597016: Call_UserGet_596999; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the user specified by its identifier.
  ## 
  let valid = call_597016.validator(path, query, header, formData, body)
  let scheme = call_597016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597016.url(scheme.get, call_597016.host, call_597016.base,
                         call_597016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597016, url, valid)

proc call*(call_597017: Call_UserGet_596999; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; uid: string; serviceName: string): Recallable =
  ## userGet
  ## Gets the details of the user specified by its identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597018 = newJObject()
  var query_597019 = newJObject()
  add(path_597018, "resourceGroupName", newJString(resourceGroupName))
  add(query_597019, "api-version", newJString(apiVersion))
  add(path_597018, "subscriptionId", newJString(subscriptionId))
  add(path_597018, "uid", newJString(uid))
  add(path_597018, "serviceName", newJString(serviceName))
  result = call_597017.call(path_597018, query_597019, nil, nil, nil)

var userGet* = Call_UserGet_596999(name: "userGet", meth: HttpMethod.HttpGet,
                                host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}",
                                validator: validate_UserGet_597000, base: "",
                                url: url_UserGet_597001, schemes: {Scheme.Https})
type
  Call_UserUpdate_597079 = ref object of OpenApiRestCall_596457
proc url_UserUpdate_597081(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserUpdate_597080(path: JsonNode; query: JsonNode; header: JsonNode;
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
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597082 = path.getOrDefault("resourceGroupName")
  valid_597082 = validateParameter(valid_597082, JString, required = true,
                                 default = nil)
  if valid_597082 != nil:
    section.add "resourceGroupName", valid_597082
  var valid_597083 = path.getOrDefault("subscriptionId")
  valid_597083 = validateParameter(valid_597083, JString, required = true,
                                 default = nil)
  if valid_597083 != nil:
    section.add "subscriptionId", valid_597083
  var valid_597084 = path.getOrDefault("uid")
  valid_597084 = validateParameter(valid_597084, JString, required = true,
                                 default = nil)
  if valid_597084 != nil:
    section.add "uid", valid_597084
  var valid_597085 = path.getOrDefault("serviceName")
  valid_597085 = validateParameter(valid_597085, JString, required = true,
                                 default = nil)
  if valid_597085 != nil:
    section.add "serviceName", valid_597085
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597086 = query.getOrDefault("api-version")
  valid_597086 = validateParameter(valid_597086, JString, required = true,
                                 default = nil)
  if valid_597086 != nil:
    section.add "api-version", valid_597086
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597087 = header.getOrDefault("If-Match")
  valid_597087 = validateParameter(valid_597087, JString, required = true,
                                 default = nil)
  if valid_597087 != nil:
    section.add "If-Match", valid_597087
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

proc call*(call_597089: Call_UserUpdate_597079; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the user specified by its identifier.
  ## 
  let valid = call_597089.validator(path, query, header, formData, body)
  let scheme = call_597089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597089.url(scheme.get, call_597089.host, call_597089.base,
                         call_597089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597089, url, valid)

proc call*(call_597090: Call_UserUpdate_597079; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          uid: string; serviceName: string): Recallable =
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
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597091 = newJObject()
  var query_597092 = newJObject()
  var body_597093 = newJObject()
  add(path_597091, "resourceGroupName", newJString(resourceGroupName))
  add(query_597092, "api-version", newJString(apiVersion))
  add(path_597091, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597093 = parameters
  add(path_597091, "uid", newJString(uid))
  add(path_597091, "serviceName", newJString(serviceName))
  result = call_597090.call(path_597091, query_597092, nil, nil, body_597093)

var userUpdate* = Call_UserUpdate_597079(name: "userUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}",
                                      validator: validate_UserUpdate_597080,
                                      base: "", url: url_UserUpdate_597081,
                                      schemes: {Scheme.Https})
type
  Call_UserDelete_597052 = ref object of OpenApiRestCall_596457
proc url_UserDelete_597054(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserDelete_597053(path: JsonNode; query: JsonNode; header: JsonNode;
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
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597055 = path.getOrDefault("resourceGroupName")
  valid_597055 = validateParameter(valid_597055, JString, required = true,
                                 default = nil)
  if valid_597055 != nil:
    section.add "resourceGroupName", valid_597055
  var valid_597056 = path.getOrDefault("subscriptionId")
  valid_597056 = validateParameter(valid_597056, JString, required = true,
                                 default = nil)
  if valid_597056 != nil:
    section.add "subscriptionId", valid_597056
  var valid_597057 = path.getOrDefault("uid")
  valid_597057 = validateParameter(valid_597057, JString, required = true,
                                 default = nil)
  if valid_597057 != nil:
    section.add "uid", valid_597057
  var valid_597058 = path.getOrDefault("serviceName")
  valid_597058 = validateParameter(valid_597058, JString, required = true,
                                 default = nil)
  if valid_597058 != nil:
    section.add "serviceName", valid_597058
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
  var valid_597059 = query.getOrDefault("api-version")
  valid_597059 = validateParameter(valid_597059, JString, required = true,
                                 default = nil)
  if valid_597059 != nil:
    section.add "api-version", valid_597059
  var valid_597060 = query.getOrDefault("deleteSubscriptions")
  valid_597060 = validateParameter(valid_597060, JBool, required = false, default = nil)
  if valid_597060 != nil:
    section.add "deleteSubscriptions", valid_597060
  var valid_597061 = query.getOrDefault("notify")
  valid_597061 = validateParameter(valid_597061, JBool, required = false, default = nil)
  if valid_597061 != nil:
    section.add "notify", valid_597061
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597062 = header.getOrDefault("If-Match")
  valid_597062 = validateParameter(valid_597062, JString, required = true,
                                 default = nil)
  if valid_597062 != nil:
    section.add "If-Match", valid_597062
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597063: Call_UserDelete_597052; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specific user.
  ## 
  let valid = call_597063.validator(path, query, header, formData, body)
  let scheme = call_597063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597063.url(scheme.get, call_597063.host, call_597063.base,
                         call_597063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597063, url, valid)

proc call*(call_597064: Call_UserDelete_597052; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; uid: string;
          serviceName: string; deleteSubscriptions: bool = false; notify: bool = false): Recallable =
  ## userDelete
  ## Deletes specific user.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   deleteSubscriptions: bool
  ##                      : Whether to delete user's subscription or not.
  ##   notify: bool
  ##         : Send an Account Closed Email notification to the User.
  var path_597065 = newJObject()
  var query_597066 = newJObject()
  add(path_597065, "resourceGroupName", newJString(resourceGroupName))
  add(query_597066, "api-version", newJString(apiVersion))
  add(path_597065, "subscriptionId", newJString(subscriptionId))
  add(path_597065, "uid", newJString(uid))
  add(path_597065, "serviceName", newJString(serviceName))
  add(query_597066, "deleteSubscriptions", newJBool(deleteSubscriptions))
  add(query_597066, "notify", newJBool(notify))
  result = call_597064.call(path_597065, query_597066, nil, nil, nil)

var userDelete* = Call_UserDelete_597052(name: "userDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}",
                                      validator: validate_UserDelete_597053,
                                      base: "", url: url_UserDelete_597054,
                                      schemes: {Scheme.Https})
type
  Call_UserGenerateSsoUrl_597094 = ref object of OpenApiRestCall_596457
proc url_UserGenerateSsoUrl_597096(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid"),
               (kind: ConstantSegment, value: "/generateSsoUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserGenerateSsoUrl_597095(path: JsonNode; query: JsonNode;
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
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597097 = path.getOrDefault("resourceGroupName")
  valid_597097 = validateParameter(valid_597097, JString, required = true,
                                 default = nil)
  if valid_597097 != nil:
    section.add "resourceGroupName", valid_597097
  var valid_597098 = path.getOrDefault("subscriptionId")
  valid_597098 = validateParameter(valid_597098, JString, required = true,
                                 default = nil)
  if valid_597098 != nil:
    section.add "subscriptionId", valid_597098
  var valid_597099 = path.getOrDefault("uid")
  valid_597099 = validateParameter(valid_597099, JString, required = true,
                                 default = nil)
  if valid_597099 != nil:
    section.add "uid", valid_597099
  var valid_597100 = path.getOrDefault("serviceName")
  valid_597100 = validateParameter(valid_597100, JString, required = true,
                                 default = nil)
  if valid_597100 != nil:
    section.add "serviceName", valid_597100
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597101 = query.getOrDefault("api-version")
  valid_597101 = validateParameter(valid_597101, JString, required = true,
                                 default = nil)
  if valid_597101 != nil:
    section.add "api-version", valid_597101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597102: Call_UserGenerateSsoUrl_597094; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a redirection URL containing an authentication token for signing a given user into the developer portal.
  ## 
  let valid = call_597102.validator(path, query, header, formData, body)
  let scheme = call_597102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597102.url(scheme.get, call_597102.host, call_597102.base,
                         call_597102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597102, url, valid)

proc call*(call_597103: Call_UserGenerateSsoUrl_597094; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; uid: string; serviceName: string): Recallable =
  ## userGenerateSsoUrl
  ## Retrieves a redirection URL containing an authentication token for signing a given user into the developer portal.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597104 = newJObject()
  var query_597105 = newJObject()
  add(path_597104, "resourceGroupName", newJString(resourceGroupName))
  add(query_597105, "api-version", newJString(apiVersion))
  add(path_597104, "subscriptionId", newJString(subscriptionId))
  add(path_597104, "uid", newJString(uid))
  add(path_597104, "serviceName", newJString(serviceName))
  result = call_597103.call(path_597104, query_597105, nil, nil, nil)

var userGenerateSsoUrl* = Call_UserGenerateSsoUrl_597094(
    name: "userGenerateSsoUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}/generateSsoUrl",
    validator: validate_UserGenerateSsoUrl_597095, base: "",
    url: url_UserGenerateSsoUrl_597096, schemes: {Scheme.Https})
type
  Call_UserGroupList_597106 = ref object of OpenApiRestCall_596457
proc url_UserGroupList_597108(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid"),
               (kind: ConstantSegment, value: "/groups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserGroupList_597107(path: JsonNode; query: JsonNode; header: JsonNode;
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
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597109 = path.getOrDefault("resourceGroupName")
  valid_597109 = validateParameter(valid_597109, JString, required = true,
                                 default = nil)
  if valid_597109 != nil:
    section.add "resourceGroupName", valid_597109
  var valid_597110 = path.getOrDefault("subscriptionId")
  valid_597110 = validateParameter(valid_597110, JString, required = true,
                                 default = nil)
  if valid_597110 != nil:
    section.add "subscriptionId", valid_597110
  var valid_597111 = path.getOrDefault("uid")
  valid_597111 = validateParameter(valid_597111, JString, required = true,
                                 default = nil)
  if valid_597111 != nil:
    section.add "uid", valid_597111
  var valid_597112 = path.getOrDefault("serviceName")
  valid_597112 = validateParameter(valid_597112, JString, required = true,
                                 default = nil)
  if valid_597112 != nil:
    section.add "serviceName", valid_597112
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
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597113 = query.getOrDefault("api-version")
  valid_597113 = validateParameter(valid_597113, JString, required = true,
                                 default = nil)
  if valid_597113 != nil:
    section.add "api-version", valid_597113
  var valid_597114 = query.getOrDefault("$top")
  valid_597114 = validateParameter(valid_597114, JInt, required = false, default = nil)
  if valid_597114 != nil:
    section.add "$top", valid_597114
  var valid_597115 = query.getOrDefault("$skip")
  valid_597115 = validateParameter(valid_597115, JInt, required = false, default = nil)
  if valid_597115 != nil:
    section.add "$skip", valid_597115
  var valid_597116 = query.getOrDefault("$filter")
  valid_597116 = validateParameter(valid_597116, JString, required = false,
                                 default = nil)
  if valid_597116 != nil:
    section.add "$filter", valid_597116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597117: Call_UserGroupList_597106; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all user groups.
  ## 
  let valid = call_597117.validator(path, query, header, formData, body)
  let scheme = call_597117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597117.url(scheme.get, call_597117.host, call_597117.base,
                         call_597117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597117, url, valid)

proc call*(call_597118: Call_UserGroupList_597106; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; uid: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
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
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var path_597119 = newJObject()
  var query_597120 = newJObject()
  add(path_597119, "resourceGroupName", newJString(resourceGroupName))
  add(query_597120, "api-version", newJString(apiVersion))
  add(path_597119, "subscriptionId", newJString(subscriptionId))
  add(query_597120, "$top", newJInt(Top))
  add(query_597120, "$skip", newJInt(Skip))
  add(path_597119, "uid", newJString(uid))
  add(path_597119, "serviceName", newJString(serviceName))
  add(query_597120, "$filter", newJString(Filter))
  result = call_597118.call(path_597119, query_597120, nil, nil, nil)

var userGroupList* = Call_UserGroupList_597106(name: "userGroupList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}/groups",
    validator: validate_UserGroupList_597107, base: "", url: url_UserGroupList_597108,
    schemes: {Scheme.Https})
type
  Call_UserIdentitiesList_597121 = ref object of OpenApiRestCall_596457
proc url_UserIdentitiesList_597123(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid"),
               (kind: ConstantSegment, value: "/identities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserIdentitiesList_597122(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists all user identities.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597124 = path.getOrDefault("resourceGroupName")
  valid_597124 = validateParameter(valid_597124, JString, required = true,
                                 default = nil)
  if valid_597124 != nil:
    section.add "resourceGroupName", valid_597124
  var valid_597125 = path.getOrDefault("subscriptionId")
  valid_597125 = validateParameter(valid_597125, JString, required = true,
                                 default = nil)
  if valid_597125 != nil:
    section.add "subscriptionId", valid_597125
  var valid_597126 = path.getOrDefault("uid")
  valid_597126 = validateParameter(valid_597126, JString, required = true,
                                 default = nil)
  if valid_597126 != nil:
    section.add "uid", valid_597126
  var valid_597127 = path.getOrDefault("serviceName")
  valid_597127 = validateParameter(valid_597127, JString, required = true,
                                 default = nil)
  if valid_597127 != nil:
    section.add "serviceName", valid_597127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597128 = query.getOrDefault("api-version")
  valid_597128 = validateParameter(valid_597128, JString, required = true,
                                 default = nil)
  if valid_597128 != nil:
    section.add "api-version", valid_597128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597129: Call_UserIdentitiesList_597121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all user identities.
  ## 
  let valid = call_597129.validator(path, query, header, formData, body)
  let scheme = call_597129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597129.url(scheme.get, call_597129.host, call_597129.base,
                         call_597129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597129, url, valid)

proc call*(call_597130: Call_UserIdentitiesList_597121; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; uid: string; serviceName: string): Recallable =
  ## userIdentitiesList
  ## Lists all user identities.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597131 = newJObject()
  var query_597132 = newJObject()
  add(path_597131, "resourceGroupName", newJString(resourceGroupName))
  add(query_597132, "api-version", newJString(apiVersion))
  add(path_597131, "subscriptionId", newJString(subscriptionId))
  add(path_597131, "uid", newJString(uid))
  add(path_597131, "serviceName", newJString(serviceName))
  result = call_597130.call(path_597131, query_597132, nil, nil, nil)

var userIdentitiesList* = Call_UserIdentitiesList_597121(
    name: "userIdentitiesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}/identities",
    validator: validate_UserIdentitiesList_597122, base: "",
    url: url_UserIdentitiesList_597123, schemes: {Scheme.Https})
type
  Call_UserSubscriptionList_597133 = ref object of OpenApiRestCall_596457
proc url_UserSubscriptionList_597135(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid"),
               (kind: ConstantSegment, value: "/subscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserSubscriptionList_597134(path: JsonNode; query: JsonNode;
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
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597136 = path.getOrDefault("resourceGroupName")
  valid_597136 = validateParameter(valid_597136, JString, required = true,
                                 default = nil)
  if valid_597136 != nil:
    section.add "resourceGroupName", valid_597136
  var valid_597137 = path.getOrDefault("subscriptionId")
  valid_597137 = validateParameter(valid_597137, JString, required = true,
                                 default = nil)
  if valid_597137 != nil:
    section.add "subscriptionId", valid_597137
  var valid_597138 = path.getOrDefault("uid")
  valid_597138 = validateParameter(valid_597138, JString, required = true,
                                 default = nil)
  if valid_597138 != nil:
    section.add "uid", valid_597138
  var valid_597139 = path.getOrDefault("serviceName")
  valid_597139 = validateParameter(valid_597139, JString, required = true,
                                 default = nil)
  if valid_597139 != nil:
    section.add "serviceName", valid_597139
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field        | Supported operators    | Supported functions                         |
  ## 
  ## |--------------|------------------------|---------------------------------------------|
  ## | id           | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | stateComment | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | userId       | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | productId    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state        | eq                     |                                             |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597140 = query.getOrDefault("api-version")
  valid_597140 = validateParameter(valid_597140, JString, required = true,
                                 default = nil)
  if valid_597140 != nil:
    section.add "api-version", valid_597140
  var valid_597141 = query.getOrDefault("$top")
  valid_597141 = validateParameter(valid_597141, JInt, required = false, default = nil)
  if valid_597141 != nil:
    section.add "$top", valid_597141
  var valid_597142 = query.getOrDefault("$skip")
  valid_597142 = validateParameter(valid_597142, JInt, required = false, default = nil)
  if valid_597142 != nil:
    section.add "$skip", valid_597142
  var valid_597143 = query.getOrDefault("$filter")
  valid_597143 = validateParameter(valid_597143, JString, required = false,
                                 default = nil)
  if valid_597143 != nil:
    section.add "$filter", valid_597143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597144: Call_UserSubscriptionList_597133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the collection of subscriptions of the specified user.
  ## 
  let valid = call_597144.validator(path, query, header, formData, body)
  let scheme = call_597144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597144.url(scheme.get, call_597144.host, call_597144.base,
                         call_597144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597144, url, valid)

proc call*(call_597145: Call_UserSubscriptionList_597133;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          uid: string; serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
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
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Filter: string
  ##         : | Field        | Supported operators    | Supported functions                         |
  ## 
  ## |--------------|------------------------|---------------------------------------------|
  ## | id           | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | stateComment | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | userId       | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | productId    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state        | eq                     |                                             |
  var path_597146 = newJObject()
  var query_597147 = newJObject()
  add(path_597146, "resourceGroupName", newJString(resourceGroupName))
  add(query_597147, "api-version", newJString(apiVersion))
  add(path_597146, "subscriptionId", newJString(subscriptionId))
  add(query_597147, "$top", newJInt(Top))
  add(query_597147, "$skip", newJInt(Skip))
  add(path_597146, "uid", newJString(uid))
  add(path_597146, "serviceName", newJString(serviceName))
  add(query_597147, "$filter", newJString(Filter))
  result = call_597145.call(path_597146, query_597147, nil, nil, nil)

var userSubscriptionList* = Call_UserSubscriptionList_597133(
    name: "userSubscriptionList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}/subscriptions",
    validator: validate_UserSubscriptionList_597134, base: "",
    url: url_UserSubscriptionList_597135, schemes: {Scheme.Https})
type
  Call_UserGetSharedAccessToken_597148 = ref object of OpenApiRestCall_596457
proc url_UserGetSharedAccessToken_597150(protocol: Scheme; host: string;
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
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid"),
               (kind: ConstantSegment, value: "/token")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UserGetSharedAccessToken_597149(path: JsonNode; query: JsonNode;
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
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597151 = path.getOrDefault("resourceGroupName")
  valid_597151 = validateParameter(valid_597151, JString, required = true,
                                 default = nil)
  if valid_597151 != nil:
    section.add "resourceGroupName", valid_597151
  var valid_597152 = path.getOrDefault("subscriptionId")
  valid_597152 = validateParameter(valid_597152, JString, required = true,
                                 default = nil)
  if valid_597152 != nil:
    section.add "subscriptionId", valid_597152
  var valid_597153 = path.getOrDefault("uid")
  valid_597153 = validateParameter(valid_597153, JString, required = true,
                                 default = nil)
  if valid_597153 != nil:
    section.add "uid", valid_597153
  var valid_597154 = path.getOrDefault("serviceName")
  valid_597154 = validateParameter(valid_597154, JString, required = true,
                                 default = nil)
  if valid_597154 != nil:
    section.add "serviceName", valid_597154
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597155 = query.getOrDefault("api-version")
  valid_597155 = validateParameter(valid_597155, JString, required = true,
                                 default = nil)
  if valid_597155 != nil:
    section.add "api-version", valid_597155
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

proc call*(call_597157: Call_UserGetSharedAccessToken_597148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Shared Access Authorization Token for the User.
  ## 
  let valid = call_597157.validator(path, query, header, formData, body)
  let scheme = call_597157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597157.url(scheme.get, call_597157.host, call_597157.base,
                         call_597157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597157, url, valid)

proc call*(call_597158: Call_UserGetSharedAccessToken_597148;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; uid: string; serviceName: string): Recallable =
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
  ##   uid: string (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597159 = newJObject()
  var query_597160 = newJObject()
  var body_597161 = newJObject()
  add(path_597159, "resourceGroupName", newJString(resourceGroupName))
  add(query_597160, "api-version", newJString(apiVersion))
  add(path_597159, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597161 = parameters
  add(path_597159, "uid", newJString(uid))
  add(path_597159, "serviceName", newJString(serviceName))
  result = call_597158.call(path_597159, query_597160, nil, nil, body_597161)

var userGetSharedAccessToken* = Call_UserGetSharedAccessToken_597148(
    name: "userGetSharedAccessToken", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}/token",
    validator: validate_UserGetSharedAccessToken_597149, base: "",
    url: url_UserGetSharedAccessToken_597150, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
