
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2016-10-10
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
  Call_UsersListByService_596679 = ref object of OpenApiRestCall_596457
proc url_UsersListByService_596681(protocol: Scheme; host: string; base: string;
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

proc validate_UsersListByService_596680(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists a collection of registered users in the specified service instance.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/dn776330.aspx
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

proc call*(call_596875: Call_UsersListByService_596679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of registered users in the specified service instance.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/dn776330.aspx
  let valid = call_596875.validator(path, query, header, formData, body)
  let scheme = call_596875.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596875.url(scheme.get, call_596875.host, call_596875.base,
                         call_596875.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596875, url, valid)

proc call*(call_596946: Call_UsersListByService_596679; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## usersListByService
  ## Lists a collection of registered users in the specified service instance.
  ## https://msdn.microsoft.com/en-us/library/azure/dn776330.aspx
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

var usersListByService* = Call_UsersListByService_596679(
    name: "usersListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users",
    validator: validate_UsersListByService_596680, base: "",
    url: url_UsersListByService_596681, schemes: {Scheme.Https})
type
  Call_UsersCreateOrUpdate_597009 = ref object of OpenApiRestCall_596457
proc url_UsersCreateOrUpdate_597011(protocol: Scheme; host: string; base: string;
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

proc validate_UsersCreateOrUpdate_597010(path: JsonNode; query: JsonNode;
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
  var valid_597039 = path.getOrDefault("resourceGroupName")
  valid_597039 = validateParameter(valid_597039, JString, required = true,
                                 default = nil)
  if valid_597039 != nil:
    section.add "resourceGroupName", valid_597039
  var valid_597040 = path.getOrDefault("subscriptionId")
  valid_597040 = validateParameter(valid_597040, JString, required = true,
                                 default = nil)
  if valid_597040 != nil:
    section.add "subscriptionId", valid_597040
  var valid_597041 = path.getOrDefault("uid")
  valid_597041 = validateParameter(valid_597041, JString, required = true,
                                 default = nil)
  if valid_597041 != nil:
    section.add "uid", valid_597041
  var valid_597042 = path.getOrDefault("serviceName")
  valid_597042 = validateParameter(valid_597042, JString, required = true,
                                 default = nil)
  if valid_597042 != nil:
    section.add "serviceName", valid_597042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597043 = query.getOrDefault("api-version")
  valid_597043 = validateParameter(valid_597043, JString, required = true,
                                 default = nil)
  if valid_597043 != nil:
    section.add "api-version", valid_597043
  result.add "query", section
  section = newJObject()
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

proc call*(call_597045: Call_UsersCreateOrUpdate_597009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates a user.
  ## 
  let valid = call_597045.validator(path, query, header, formData, body)
  let scheme = call_597045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597045.url(scheme.get, call_597045.host, call_597045.base,
                         call_597045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597045, url, valid)

proc call*(call_597046: Call_UsersCreateOrUpdate_597009; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          uid: string; serviceName: string): Recallable =
  ## usersCreateOrUpdate
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
  var path_597047 = newJObject()
  var query_597048 = newJObject()
  var body_597049 = newJObject()
  add(path_597047, "resourceGroupName", newJString(resourceGroupName))
  add(query_597048, "api-version", newJString(apiVersion))
  add(path_597047, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597049 = parameters
  add(path_597047, "uid", newJString(uid))
  add(path_597047, "serviceName", newJString(serviceName))
  result = call_597046.call(path_597047, query_597048, nil, nil, body_597049)

var usersCreateOrUpdate* = Call_UsersCreateOrUpdate_597009(
    name: "usersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}",
    validator: validate_UsersCreateOrUpdate_597010, base: "",
    url: url_UsersCreateOrUpdate_597011, schemes: {Scheme.Https})
type
  Call_UsersGet_596988 = ref object of OpenApiRestCall_596457
proc url_UsersGet_596990(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UsersGet_596989(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_597002 = path.getOrDefault("uid")
  valid_597002 = validateParameter(valid_597002, JString, required = true,
                                 default = nil)
  if valid_597002 != nil:
    section.add "uid", valid_597002
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

proc call*(call_597005: Call_UsersGet_596988; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the user specified by its identifier.
  ## 
  let valid = call_597005.validator(path, query, header, formData, body)
  let scheme = call_597005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597005.url(scheme.get, call_597005.host, call_597005.base,
                         call_597005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597005, url, valid)

proc call*(call_597006: Call_UsersGet_596988; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; uid: string; serviceName: string): Recallable =
  ## usersGet
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
  var path_597007 = newJObject()
  var query_597008 = newJObject()
  add(path_597007, "resourceGroupName", newJString(resourceGroupName))
  add(query_597008, "api-version", newJString(apiVersion))
  add(path_597007, "subscriptionId", newJString(subscriptionId))
  add(path_597007, "uid", newJString(uid))
  add(path_597007, "serviceName", newJString(serviceName))
  result = call_597006.call(path_597007, query_597008, nil, nil, nil)

var usersGet* = Call_UsersGet_596988(name: "usersGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}",
                                  validator: validate_UsersGet_596989, base: "",
                                  url: url_UsersGet_596990,
                                  schemes: {Scheme.Https})
type
  Call_UsersUpdate_597064 = ref object of OpenApiRestCall_596457
proc url_UsersUpdate_597066(protocol: Scheme; host: string; base: string;
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

proc validate_UsersUpdate_597065(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_597067 = path.getOrDefault("resourceGroupName")
  valid_597067 = validateParameter(valid_597067, JString, required = true,
                                 default = nil)
  if valid_597067 != nil:
    section.add "resourceGroupName", valid_597067
  var valid_597068 = path.getOrDefault("subscriptionId")
  valid_597068 = validateParameter(valid_597068, JString, required = true,
                                 default = nil)
  if valid_597068 != nil:
    section.add "subscriptionId", valid_597068
  var valid_597069 = path.getOrDefault("uid")
  valid_597069 = validateParameter(valid_597069, JString, required = true,
                                 default = nil)
  if valid_597069 != nil:
    section.add "uid", valid_597069
  var valid_597070 = path.getOrDefault("serviceName")
  valid_597070 = validateParameter(valid_597070, JString, required = true,
                                 default = nil)
  if valid_597070 != nil:
    section.add "serviceName", valid_597070
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597071 = query.getOrDefault("api-version")
  valid_597071 = validateParameter(valid_597071, JString, required = true,
                                 default = nil)
  if valid_597071 != nil:
    section.add "api-version", valid_597071
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the user to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597072 = header.getOrDefault("If-Match")
  valid_597072 = validateParameter(valid_597072, JString, required = true,
                                 default = nil)
  if valid_597072 != nil:
    section.add "If-Match", valid_597072
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

proc call*(call_597074: Call_UsersUpdate_597064; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the user specified by its identifier.
  ## 
  let valid = call_597074.validator(path, query, header, formData, body)
  let scheme = call_597074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597074.url(scheme.get, call_597074.host, call_597074.base,
                         call_597074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597074, url, valid)

proc call*(call_597075: Call_UsersUpdate_597064; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          uid: string; serviceName: string): Recallable =
  ## usersUpdate
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
  var path_597076 = newJObject()
  var query_597077 = newJObject()
  var body_597078 = newJObject()
  add(path_597076, "resourceGroupName", newJString(resourceGroupName))
  add(query_597077, "api-version", newJString(apiVersion))
  add(path_597076, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597078 = parameters
  add(path_597076, "uid", newJString(uid))
  add(path_597076, "serviceName", newJString(serviceName))
  result = call_597075.call(path_597076, query_597077, nil, nil, body_597078)

var usersUpdate* = Call_UsersUpdate_597064(name: "usersUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}",
                                        validator: validate_UsersUpdate_597065,
                                        base: "", url: url_UsersUpdate_597066,
                                        schemes: {Scheme.Https})
type
  Call_UsersDelete_597050 = ref object of OpenApiRestCall_596457
proc url_UsersDelete_597052(protocol: Scheme; host: string; base: string;
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

proc validate_UsersDelete_597051(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_597053 = path.getOrDefault("resourceGroupName")
  valid_597053 = validateParameter(valid_597053, JString, required = true,
                                 default = nil)
  if valid_597053 != nil:
    section.add "resourceGroupName", valid_597053
  var valid_597054 = path.getOrDefault("subscriptionId")
  valid_597054 = validateParameter(valid_597054, JString, required = true,
                                 default = nil)
  if valid_597054 != nil:
    section.add "subscriptionId", valid_597054
  var valid_597055 = path.getOrDefault("uid")
  valid_597055 = validateParameter(valid_597055, JString, required = true,
                                 default = nil)
  if valid_597055 != nil:
    section.add "uid", valid_597055
  var valid_597056 = path.getOrDefault("serviceName")
  valid_597056 = validateParameter(valid_597056, JString, required = true,
                                 default = nil)
  if valid_597056 != nil:
    section.add "serviceName", valid_597056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   deleteSubscriptions: JBool
  ##                      : Whether to delete user's subscription or not.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597057 = query.getOrDefault("api-version")
  valid_597057 = validateParameter(valid_597057, JString, required = true,
                                 default = nil)
  if valid_597057 != nil:
    section.add "api-version", valid_597057
  var valid_597058 = query.getOrDefault("deleteSubscriptions")
  valid_597058 = validateParameter(valid_597058, JBool, required = false, default = nil)
  if valid_597058 != nil:
    section.add "deleteSubscriptions", valid_597058
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the user to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597059 = header.getOrDefault("If-Match")
  valid_597059 = validateParameter(valid_597059, JString, required = true,
                                 default = nil)
  if valid_597059 != nil:
    section.add "If-Match", valid_597059
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597060: Call_UsersDelete_597050; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specific user.
  ## 
  let valid = call_597060.validator(path, query, header, formData, body)
  let scheme = call_597060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597060.url(scheme.get, call_597060.host, call_597060.base,
                         call_597060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597060, url, valid)

proc call*(call_597061: Call_UsersDelete_597050; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; uid: string;
          serviceName: string; deleteSubscriptions: bool = false): Recallable =
  ## usersDelete
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
  var path_597062 = newJObject()
  var query_597063 = newJObject()
  add(path_597062, "resourceGroupName", newJString(resourceGroupName))
  add(query_597063, "api-version", newJString(apiVersion))
  add(path_597062, "subscriptionId", newJString(subscriptionId))
  add(path_597062, "uid", newJString(uid))
  add(path_597062, "serviceName", newJString(serviceName))
  add(query_597063, "deleteSubscriptions", newJBool(deleteSubscriptions))
  result = call_597061.call(path_597062, query_597063, nil, nil, nil)

var usersDelete* = Call_UsersDelete_597050(name: "usersDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}",
                                        validator: validate_UsersDelete_597051,
                                        base: "", url: url_UsersDelete_597052,
                                        schemes: {Scheme.Https})
type
  Call_UsersGenerateSsoUrl_597079 = ref object of OpenApiRestCall_596457
proc url_UsersGenerateSsoUrl_597081(protocol: Scheme; host: string; base: string;
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

proc validate_UsersGenerateSsoUrl_597080(path: JsonNode; query: JsonNode;
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
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597087: Call_UsersGenerateSsoUrl_597079; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a redirection URL containing an authentication token for signing a given user into the developer portal.
  ## 
  let valid = call_597087.validator(path, query, header, formData, body)
  let scheme = call_597087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597087.url(scheme.get, call_597087.host, call_597087.base,
                         call_597087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597087, url, valid)

proc call*(call_597088: Call_UsersGenerateSsoUrl_597079; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; uid: string; serviceName: string): Recallable =
  ## usersGenerateSsoUrl
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
  var path_597089 = newJObject()
  var query_597090 = newJObject()
  add(path_597089, "resourceGroupName", newJString(resourceGroupName))
  add(query_597090, "api-version", newJString(apiVersion))
  add(path_597089, "subscriptionId", newJString(subscriptionId))
  add(path_597089, "uid", newJString(uid))
  add(path_597089, "serviceName", newJString(serviceName))
  result = call_597088.call(path_597089, query_597090, nil, nil, nil)

var usersGenerateSsoUrl* = Call_UsersGenerateSsoUrl_597079(
    name: "usersGenerateSsoUrl", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}/generateSsoUrl",
    validator: validate_UsersGenerateSsoUrl_597080, base: "",
    url: url_UsersGenerateSsoUrl_597081, schemes: {Scheme.Https})
type
  Call_UserGroupsListByUsers_597091 = ref object of OpenApiRestCall_596457
proc url_UserGroupsListByUsers_597093(protocol: Scheme; host: string; base: string;
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

proc validate_UserGroupsListByUsers_597092(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_597094 = path.getOrDefault("resourceGroupName")
  valid_597094 = validateParameter(valid_597094, JString, required = true,
                                 default = nil)
  if valid_597094 != nil:
    section.add "resourceGroupName", valid_597094
  var valid_597095 = path.getOrDefault("subscriptionId")
  valid_597095 = validateParameter(valid_597095, JString, required = true,
                                 default = nil)
  if valid_597095 != nil:
    section.add "subscriptionId", valid_597095
  var valid_597096 = path.getOrDefault("uid")
  valid_597096 = validateParameter(valid_597096, JString, required = true,
                                 default = nil)
  if valid_597096 != nil:
    section.add "uid", valid_597096
  var valid_597097 = path.getOrDefault("serviceName")
  valid_597097 = validateParameter(valid_597097, JString, required = true,
                                 default = nil)
  if valid_597097 != nil:
    section.add "serviceName", valid_597097
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
  var valid_597098 = query.getOrDefault("api-version")
  valid_597098 = validateParameter(valid_597098, JString, required = true,
                                 default = nil)
  if valid_597098 != nil:
    section.add "api-version", valid_597098
  var valid_597099 = query.getOrDefault("$top")
  valid_597099 = validateParameter(valid_597099, JInt, required = false, default = nil)
  if valid_597099 != nil:
    section.add "$top", valid_597099
  var valid_597100 = query.getOrDefault("$skip")
  valid_597100 = validateParameter(valid_597100, JInt, required = false, default = nil)
  if valid_597100 != nil:
    section.add "$skip", valid_597100
  var valid_597101 = query.getOrDefault("$filter")
  valid_597101 = validateParameter(valid_597101, JString, required = false,
                                 default = nil)
  if valid_597101 != nil:
    section.add "$filter", valid_597101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597102: Call_UserGroupsListByUsers_597091; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all user groups.
  ## 
  let valid = call_597102.validator(path, query, header, formData, body)
  let scheme = call_597102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597102.url(scheme.get, call_597102.host, call_597102.base,
                         call_597102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597102, url, valid)

proc call*(call_597103: Call_UserGroupsListByUsers_597091;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          uid: string; serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## userGroupsListByUsers
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
  var path_597104 = newJObject()
  var query_597105 = newJObject()
  add(path_597104, "resourceGroupName", newJString(resourceGroupName))
  add(query_597105, "api-version", newJString(apiVersion))
  add(path_597104, "subscriptionId", newJString(subscriptionId))
  add(query_597105, "$top", newJInt(Top))
  add(query_597105, "$skip", newJInt(Skip))
  add(path_597104, "uid", newJString(uid))
  add(path_597104, "serviceName", newJString(serviceName))
  add(query_597105, "$filter", newJString(Filter))
  result = call_597103.call(path_597104, query_597105, nil, nil, nil)

var userGroupsListByUsers* = Call_UserGroupsListByUsers_597091(
    name: "userGroupsListByUsers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}/groups",
    validator: validate_UserGroupsListByUsers_597092, base: "",
    url: url_UserGroupsListByUsers_597093, schemes: {Scheme.Https})
type
  Call_UserIdentitiesListByUsers_597106 = ref object of OpenApiRestCall_596457
proc url_UserIdentitiesListByUsers_597108(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_UserIdentitiesListByUsers_597107(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597113 = query.getOrDefault("api-version")
  valid_597113 = validateParameter(valid_597113, JString, required = true,
                                 default = nil)
  if valid_597113 != nil:
    section.add "api-version", valid_597113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597114: Call_UserIdentitiesListByUsers_597106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all user identities.
  ## 
  let valid = call_597114.validator(path, query, header, formData, body)
  let scheme = call_597114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597114.url(scheme.get, call_597114.host, call_597114.base,
                         call_597114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597114, url, valid)

proc call*(call_597115: Call_UserIdentitiesListByUsers_597106;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          uid: string; serviceName: string): Recallable =
  ## userIdentitiesListByUsers
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
  var path_597116 = newJObject()
  var query_597117 = newJObject()
  add(path_597116, "resourceGroupName", newJString(resourceGroupName))
  add(query_597117, "api-version", newJString(apiVersion))
  add(path_597116, "subscriptionId", newJString(subscriptionId))
  add(path_597116, "uid", newJString(uid))
  add(path_597116, "serviceName", newJString(serviceName))
  result = call_597115.call(path_597116, query_597117, nil, nil, nil)

var userIdentitiesListByUsers* = Call_UserIdentitiesListByUsers_597106(
    name: "userIdentitiesListByUsers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}/identities",
    validator: validate_UserIdentitiesListByUsers_597107, base: "",
    url: url_UserIdentitiesListByUsers_597108, schemes: {Scheme.Https})
type
  Call_UserSubscriptionsListByUsers_597118 = ref object of OpenApiRestCall_596457
proc url_UserSubscriptionsListByUsers_597120(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_UserSubscriptionsListByUsers_597119(path: JsonNode; query: JsonNode;
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
  var valid_597121 = path.getOrDefault("resourceGroupName")
  valid_597121 = validateParameter(valid_597121, JString, required = true,
                                 default = nil)
  if valid_597121 != nil:
    section.add "resourceGroupName", valid_597121
  var valid_597122 = path.getOrDefault("subscriptionId")
  valid_597122 = validateParameter(valid_597122, JString, required = true,
                                 default = nil)
  if valid_597122 != nil:
    section.add "subscriptionId", valid_597122
  var valid_597123 = path.getOrDefault("uid")
  valid_597123 = validateParameter(valid_597123, JString, required = true,
                                 default = nil)
  if valid_597123 != nil:
    section.add "uid", valid_597123
  var valid_597124 = path.getOrDefault("serviceName")
  valid_597124 = validateParameter(valid_597124, JString, required = true,
                                 default = nil)
  if valid_597124 != nil:
    section.add "serviceName", valid_597124
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
  var valid_597125 = query.getOrDefault("api-version")
  valid_597125 = validateParameter(valid_597125, JString, required = true,
                                 default = nil)
  if valid_597125 != nil:
    section.add "api-version", valid_597125
  var valid_597126 = query.getOrDefault("$top")
  valid_597126 = validateParameter(valid_597126, JInt, required = false, default = nil)
  if valid_597126 != nil:
    section.add "$top", valid_597126
  var valid_597127 = query.getOrDefault("$skip")
  valid_597127 = validateParameter(valid_597127, JInt, required = false, default = nil)
  if valid_597127 != nil:
    section.add "$skip", valid_597127
  var valid_597128 = query.getOrDefault("$filter")
  valid_597128 = validateParameter(valid_597128, JString, required = false,
                                 default = nil)
  if valid_597128 != nil:
    section.add "$filter", valid_597128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597129: Call_UserSubscriptionsListByUsers_597118; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the collection of subscriptions of the specified user.
  ## 
  let valid = call_597129.validator(path, query, header, formData, body)
  let scheme = call_597129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597129.url(scheme.get, call_597129.host, call_597129.base,
                         call_597129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597129, url, valid)

proc call*(call_597130: Call_UserSubscriptionsListByUsers_597118;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          uid: string; serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## userSubscriptionsListByUsers
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
  var path_597131 = newJObject()
  var query_597132 = newJObject()
  add(path_597131, "resourceGroupName", newJString(resourceGroupName))
  add(query_597132, "api-version", newJString(apiVersion))
  add(path_597131, "subscriptionId", newJString(subscriptionId))
  add(query_597132, "$top", newJInt(Top))
  add(query_597132, "$skip", newJInt(Skip))
  add(path_597131, "uid", newJString(uid))
  add(path_597131, "serviceName", newJString(serviceName))
  add(query_597132, "$filter", newJString(Filter))
  result = call_597130.call(path_597131, query_597132, nil, nil, nil)

var userSubscriptionsListByUsers* = Call_UserSubscriptionsListByUsers_597118(
    name: "userSubscriptionsListByUsers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}/subscriptions",
    validator: validate_UserSubscriptionsListByUsers_597119, base: "",
    url: url_UserSubscriptionsListByUsers_597120, schemes: {Scheme.Https})
type
  Call_UsersGetSharedAccessToken_597133 = ref object of OpenApiRestCall_596457
proc url_UsersGetSharedAccessToken_597135(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_UsersGetSharedAccessToken_597134(path: JsonNode; query: JsonNode;
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
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597140 = query.getOrDefault("api-version")
  valid_597140 = validateParameter(valid_597140, JString, required = true,
                                 default = nil)
  if valid_597140 != nil:
    section.add "api-version", valid_597140
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

proc call*(call_597142: Call_UsersGetSharedAccessToken_597133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Shared Access Authorization Token for the User.
  ## 
  let valid = call_597142.validator(path, query, header, formData, body)
  let scheme = call_597142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597142.url(scheme.get, call_597142.host, call_597142.base,
                         call_597142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597142, url, valid)

proc call*(call_597143: Call_UsersGetSharedAccessToken_597133;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; uid: string; serviceName: string): Recallable =
  ## usersGetSharedAccessToken
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
  var path_597144 = newJObject()
  var query_597145 = newJObject()
  var body_597146 = newJObject()
  add(path_597144, "resourceGroupName", newJString(resourceGroupName))
  add(query_597145, "api-version", newJString(apiVersion))
  add(path_597144, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597146 = parameters
  add(path_597144, "uid", newJString(uid))
  add(path_597144, "serviceName", newJString(serviceName))
  result = call_597143.call(path_597144, query_597145, nil, nil, body_597146)

var usersGetSharedAccessToken* = Call_UsersGetSharedAccessToken_597133(
    name: "usersGetSharedAccessToken", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{uid}/token",
    validator: validate_UsersGetSharedAccessToken_597134, base: "",
    url: url_UsersGetSharedAccessToken_597135, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
