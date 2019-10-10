
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on Group entity in your Azure API Management deployment. Groups are used to manage the visibility of products to developers. Each API Management service instance comes with the following immutable system groups whose membership is automatically managed by API Management.  - **Administrators** - Azure subscription administrators are members of this group. - **Developers** - Authenticated developer portal users fall into this group. - **Guests** - Unauthenticated developer portal users are placed into this group. In addition to these system groups, administrators can create custom groups or [leverage external groups in associated Azure Active Directory tenants](https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-aad#how-to-add-an-external-azure-active-directory-group). Custom and external groups can be used alongside system groups in giving developers visibility and access to API products. For example, you could create one custom group for developers affiliated with a specific partner organization and allow them access to the APIs from a product containing relevant APIs only. A user can be a member of more than one group.
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
  macServiceName = "apimanagement-apimgroups"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GroupListByService_573879 = ref object of OpenApiRestCall_573657
proc url_GroupListByService_573881(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/groups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupListByService_573880(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists a collection of groups defined within a service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-create-groups
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
  ##          : | Field       | Supported operators    | Supported functions                         |
  ## 
  ## |-------------|------------------------|---------------------------------------------|
  ## | id          | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name        | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | type        | eq, ne                 | N/A                                         |
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

proc call*(call_574075: Call_GroupListByService_573879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of groups defined within a service instance.
  ## 
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-create-groups
  let valid = call_574075.validator(path, query, header, formData, body)
  let scheme = call_574075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574075.url(scheme.get, call_574075.host, call_574075.base,
                         call_574075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574075, url, valid)

proc call*(call_574146: Call_GroupListByService_573879; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; serviceName: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## groupListByService
  ## Lists a collection of groups defined within a service instance.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-create-groups
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
  ## | description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | type        | eq, ne                 | N/A                                         |
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

var groupListByService* = Call_GroupListByService_573879(
    name: "groupListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/groups",
    validator: validate_GroupListByService_573880, base: "",
    url: url_GroupListByService_573881, schemes: {Scheme.Https})
type
  Call_GroupCreateOrUpdate_574209 = ref object of OpenApiRestCall_573657
proc url_GroupCreateOrUpdate_574211(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupCreateOrUpdate_574210(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates or Updates a group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_574229 = path.getOrDefault("groupId")
  valid_574229 = validateParameter(valid_574229, JString, required = true,
                                 default = nil)
  if valid_574229 != nil:
    section.add "groupId", valid_574229
  var valid_574230 = path.getOrDefault("resourceGroupName")
  valid_574230 = validateParameter(valid_574230, JString, required = true,
                                 default = nil)
  if valid_574230 != nil:
    section.add "resourceGroupName", valid_574230
  var valid_574231 = path.getOrDefault("subscriptionId")
  valid_574231 = validateParameter(valid_574231, JString, required = true,
                                 default = nil)
  if valid_574231 != nil:
    section.add "subscriptionId", valid_574231
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

proc call*(call_574235: Call_GroupCreateOrUpdate_574209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or Updates a group.
  ## 
  let valid = call_574235.validator(path, query, header, formData, body)
  let scheme = call_574235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574235.url(scheme.get, call_574235.host, call_574235.base,
                         call_574235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574235, url, valid)

proc call*(call_574236: Call_GroupCreateOrUpdate_574209; groupId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## groupCreateOrUpdate
  ## Creates or Updates a group.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
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
  var path_574237 = newJObject()
  var query_574238 = newJObject()
  var body_574239 = newJObject()
  add(path_574237, "groupId", newJString(groupId))
  add(path_574237, "resourceGroupName", newJString(resourceGroupName))
  add(query_574238, "api-version", newJString(apiVersion))
  add(path_574237, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574239 = parameters
  add(path_574237, "serviceName", newJString(serviceName))
  result = call_574236.call(path_574237, query_574238, nil, nil, body_574239)

var groupCreateOrUpdate* = Call_GroupCreateOrUpdate_574209(
    name: "groupCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/groups/{groupId}",
    validator: validate_GroupCreateOrUpdate_574210, base: "",
    url: url_GroupCreateOrUpdate_574211, schemes: {Scheme.Https})
type
  Call_GroupGetEntityTag_574253 = ref object of OpenApiRestCall_573657
proc url_GroupGetEntityTag_574255(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupGetEntityTag_574254(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the entity state (Etag) version of the group specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_574256 = path.getOrDefault("groupId")
  valid_574256 = validateParameter(valid_574256, JString, required = true,
                                 default = nil)
  if valid_574256 != nil:
    section.add "groupId", valid_574256
  var valid_574257 = path.getOrDefault("resourceGroupName")
  valid_574257 = validateParameter(valid_574257, JString, required = true,
                                 default = nil)
  if valid_574257 != nil:
    section.add "resourceGroupName", valid_574257
  var valid_574258 = path.getOrDefault("subscriptionId")
  valid_574258 = validateParameter(valid_574258, JString, required = true,
                                 default = nil)
  if valid_574258 != nil:
    section.add "subscriptionId", valid_574258
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

proc call*(call_574261: Call_GroupGetEntityTag_574253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the entity state (Etag) version of the group specified by its identifier.
  ## 
  let valid = call_574261.validator(path, query, header, formData, body)
  let scheme = call_574261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574261.url(scheme.get, call_574261.host, call_574261.base,
                         call_574261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574261, url, valid)

proc call*(call_574262: Call_GroupGetEntityTag_574253; groupId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## groupGetEntityTag
  ## Gets the entity state (Etag) version of the group specified by its identifier.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_574263 = newJObject()
  var query_574264 = newJObject()
  add(path_574263, "groupId", newJString(groupId))
  add(path_574263, "resourceGroupName", newJString(resourceGroupName))
  add(query_574264, "api-version", newJString(apiVersion))
  add(path_574263, "subscriptionId", newJString(subscriptionId))
  add(path_574263, "serviceName", newJString(serviceName))
  result = call_574262.call(path_574263, query_574264, nil, nil, nil)

var groupGetEntityTag* = Call_GroupGetEntityTag_574253(name: "groupGetEntityTag",
    meth: HttpMethod.HttpHead, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/groups/{groupId}",
    validator: validate_GroupGetEntityTag_574254, base: "",
    url: url_GroupGetEntityTag_574255, schemes: {Scheme.Https})
type
  Call_GroupGet_574188 = ref object of OpenApiRestCall_573657
proc url_GroupGet_574190(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupGet_574189(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the group specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_574200 = path.getOrDefault("groupId")
  valid_574200 = validateParameter(valid_574200, JString, required = true,
                                 default = nil)
  if valid_574200 != nil:
    section.add "groupId", valid_574200
  var valid_574201 = path.getOrDefault("resourceGroupName")
  valid_574201 = validateParameter(valid_574201, JString, required = true,
                                 default = nil)
  if valid_574201 != nil:
    section.add "resourceGroupName", valid_574201
  var valid_574202 = path.getOrDefault("subscriptionId")
  valid_574202 = validateParameter(valid_574202, JString, required = true,
                                 default = nil)
  if valid_574202 != nil:
    section.add "subscriptionId", valid_574202
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

proc call*(call_574205: Call_GroupGet_574188; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the group specified by its identifier.
  ## 
  let valid = call_574205.validator(path, query, header, formData, body)
  let scheme = call_574205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574205.url(scheme.get, call_574205.host, call_574205.base,
                         call_574205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574205, url, valid)

proc call*(call_574206: Call_GroupGet_574188; groupId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## groupGet
  ## Gets the details of the group specified by its identifier.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_574207 = newJObject()
  var query_574208 = newJObject()
  add(path_574207, "groupId", newJString(groupId))
  add(path_574207, "resourceGroupName", newJString(resourceGroupName))
  add(query_574208, "api-version", newJString(apiVersion))
  add(path_574207, "subscriptionId", newJString(subscriptionId))
  add(path_574207, "serviceName", newJString(serviceName))
  result = call_574206.call(path_574207, query_574208, nil, nil, nil)

var groupGet* = Call_GroupGet_574188(name: "groupGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/groups/{groupId}",
                                  validator: validate_GroupGet_574189, base: "",
                                  url: url_GroupGet_574190,
                                  schemes: {Scheme.Https})
type
  Call_GroupUpdate_574265 = ref object of OpenApiRestCall_573657
proc url_GroupUpdate_574267(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupUpdate_574266(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the details of the group specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_574268 = path.getOrDefault("groupId")
  valid_574268 = validateParameter(valid_574268, JString, required = true,
                                 default = nil)
  if valid_574268 != nil:
    section.add "groupId", valid_574268
  var valid_574269 = path.getOrDefault("resourceGroupName")
  valid_574269 = validateParameter(valid_574269, JString, required = true,
                                 default = nil)
  if valid_574269 != nil:
    section.add "resourceGroupName", valid_574269
  var valid_574270 = path.getOrDefault("subscriptionId")
  valid_574270 = validateParameter(valid_574270, JString, required = true,
                                 default = nil)
  if valid_574270 != nil:
    section.add "subscriptionId", valid_574270
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
  ##           : ETag of the Group Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
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

proc call*(call_574275: Call_GroupUpdate_574265; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of the group specified by its identifier.
  ## 
  let valid = call_574275.validator(path, query, header, formData, body)
  let scheme = call_574275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574275.url(scheme.get, call_574275.host, call_574275.base,
                         call_574275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574275, url, valid)

proc call*(call_574276: Call_GroupUpdate_574265; groupId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## groupUpdate
  ## Updates the details of the group specified by its identifier.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
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
  var path_574277 = newJObject()
  var query_574278 = newJObject()
  var body_574279 = newJObject()
  add(path_574277, "groupId", newJString(groupId))
  add(path_574277, "resourceGroupName", newJString(resourceGroupName))
  add(query_574278, "api-version", newJString(apiVersion))
  add(path_574277, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574279 = parameters
  add(path_574277, "serviceName", newJString(serviceName))
  result = call_574276.call(path_574277, query_574278, nil, nil, body_574279)

var groupUpdate* = Call_GroupUpdate_574265(name: "groupUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/groups/{groupId}",
                                        validator: validate_GroupUpdate_574266,
                                        base: "", url: url_GroupUpdate_574267,
                                        schemes: {Scheme.Https})
type
  Call_GroupDelete_574240 = ref object of OpenApiRestCall_573657
proc url_GroupDelete_574242(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupDelete_574241(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes specific group of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_574243 = path.getOrDefault("groupId")
  valid_574243 = validateParameter(valid_574243, JString, required = true,
                                 default = nil)
  if valid_574243 != nil:
    section.add "groupId", valid_574243
  var valid_574244 = path.getOrDefault("resourceGroupName")
  valid_574244 = validateParameter(valid_574244, JString, required = true,
                                 default = nil)
  if valid_574244 != nil:
    section.add "resourceGroupName", valid_574244
  var valid_574245 = path.getOrDefault("subscriptionId")
  valid_574245 = validateParameter(valid_574245, JString, required = true,
                                 default = nil)
  if valid_574245 != nil:
    section.add "subscriptionId", valid_574245
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
  ##           : ETag of the Group Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
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

proc call*(call_574249: Call_GroupDelete_574240; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specific group of the API Management service instance.
  ## 
  let valid = call_574249.validator(path, query, header, formData, body)
  let scheme = call_574249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574249.url(scheme.get, call_574249.host, call_574249.base,
                         call_574249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574249, url, valid)

proc call*(call_574250: Call_GroupDelete_574240; groupId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string): Recallable =
  ## groupDelete
  ## Deletes specific group of the API Management service instance.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_574251 = newJObject()
  var query_574252 = newJObject()
  add(path_574251, "groupId", newJString(groupId))
  add(path_574251, "resourceGroupName", newJString(resourceGroupName))
  add(query_574252, "api-version", newJString(apiVersion))
  add(path_574251, "subscriptionId", newJString(subscriptionId))
  add(path_574251, "serviceName", newJString(serviceName))
  result = call_574250.call(path_574251, query_574252, nil, nil, nil)

var groupDelete* = Call_GroupDelete_574240(name: "groupDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/groups/{groupId}",
                                        validator: validate_GroupDelete_574241,
                                        base: "", url: url_GroupDelete_574242,
                                        schemes: {Scheme.Https})
type
  Call_GroupUserList_574280 = ref object of OpenApiRestCall_573657
proc url_GroupUserList_574282(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupUserList_574281(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of the members of the group, specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_574283 = path.getOrDefault("groupId")
  valid_574283 = validateParameter(valid_574283, JString, required = true,
                                 default = nil)
  if valid_574283 != nil:
    section.add "groupId", valid_574283
  var valid_574284 = path.getOrDefault("resourceGroupName")
  valid_574284 = validateParameter(valid_574284, JString, required = true,
                                 default = nil)
  if valid_574284 != nil:
    section.add "resourceGroupName", valid_574284
  var valid_574285 = path.getOrDefault("subscriptionId")
  valid_574285 = validateParameter(valid_574285, JString, required = true,
                                 default = nil)
  if valid_574285 != nil:
    section.add "subscriptionId", valid_574285
  var valid_574286 = path.getOrDefault("serviceName")
  valid_574286 = validateParameter(valid_574286, JString, required = true,
                                 default = nil)
  if valid_574286 != nil:
    section.add "serviceName", valid_574286
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
  var valid_574287 = query.getOrDefault("api-version")
  valid_574287 = validateParameter(valid_574287, JString, required = true,
                                 default = nil)
  if valid_574287 != nil:
    section.add "api-version", valid_574287
  var valid_574288 = query.getOrDefault("$top")
  valid_574288 = validateParameter(valid_574288, JInt, required = false, default = nil)
  if valid_574288 != nil:
    section.add "$top", valid_574288
  var valid_574289 = query.getOrDefault("$skip")
  valid_574289 = validateParameter(valid_574289, JInt, required = false, default = nil)
  if valid_574289 != nil:
    section.add "$skip", valid_574289
  var valid_574290 = query.getOrDefault("$filter")
  valid_574290 = validateParameter(valid_574290, JString, required = false,
                                 default = nil)
  if valid_574290 != nil:
    section.add "$filter", valid_574290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574291: Call_GroupUserList_574280; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of the members of the group, specified by its identifier.
  ## 
  let valid = call_574291.validator(path, query, header, formData, body)
  let scheme = call_574291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574291.url(scheme.get, call_574291.host, call_574291.base,
                         call_574291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574291, url, valid)

proc call*(call_574292: Call_GroupUserList_574280; groupId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          serviceName: string; Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## groupUserList
  ## Lists a collection of the members of the group, specified by its identifier.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
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
  var path_574293 = newJObject()
  var query_574294 = newJObject()
  add(path_574293, "groupId", newJString(groupId))
  add(path_574293, "resourceGroupName", newJString(resourceGroupName))
  add(query_574294, "api-version", newJString(apiVersion))
  add(path_574293, "subscriptionId", newJString(subscriptionId))
  add(query_574294, "$top", newJInt(Top))
  add(query_574294, "$skip", newJInt(Skip))
  add(path_574293, "serviceName", newJString(serviceName))
  add(query_574294, "$filter", newJString(Filter))
  result = call_574292.call(path_574293, query_574294, nil, nil, nil)

var groupUserList* = Call_GroupUserList_574280(name: "groupUserList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/groups/{groupId}/users",
    validator: validate_GroupUserList_574281, base: "", url: url_GroupUserList_574282,
    schemes: {Scheme.Https})
type
  Call_GroupUserCreate_574295 = ref object of OpenApiRestCall_573657
proc url_GroupUserCreate_574297(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupUserCreate_574296(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Adds a user to the specified group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_574298 = path.getOrDefault("groupId")
  valid_574298 = validateParameter(valid_574298, JString, required = true,
                                 default = nil)
  if valid_574298 != nil:
    section.add "groupId", valid_574298
  var valid_574299 = path.getOrDefault("resourceGroupName")
  valid_574299 = validateParameter(valid_574299, JString, required = true,
                                 default = nil)
  if valid_574299 != nil:
    section.add "resourceGroupName", valid_574299
  var valid_574300 = path.getOrDefault("subscriptionId")
  valid_574300 = validateParameter(valid_574300, JString, required = true,
                                 default = nil)
  if valid_574300 != nil:
    section.add "subscriptionId", valid_574300
  var valid_574301 = path.getOrDefault("uid")
  valid_574301 = validateParameter(valid_574301, JString, required = true,
                                 default = nil)
  if valid_574301 != nil:
    section.add "uid", valid_574301
  var valid_574302 = path.getOrDefault("serviceName")
  valid_574302 = validateParameter(valid_574302, JString, required = true,
                                 default = nil)
  if valid_574302 != nil:
    section.add "serviceName", valid_574302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574303 = query.getOrDefault("api-version")
  valid_574303 = validateParameter(valid_574303, JString, required = true,
                                 default = nil)
  if valid_574303 != nil:
    section.add "api-version", valid_574303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574304: Call_GroupUserCreate_574295; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a user to the specified group.
  ## 
  let valid = call_574304.validator(path, query, header, formData, body)
  let scheme = call_574304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574304.url(scheme.get, call_574304.host, call_574304.base,
                         call_574304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574304, url, valid)

proc call*(call_574305: Call_GroupUserCreate_574295; groupId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          uid: string; serviceName: string): Recallable =
  ## groupUserCreate
  ## Adds a user to the specified group.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
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
  var path_574306 = newJObject()
  var query_574307 = newJObject()
  add(path_574306, "groupId", newJString(groupId))
  add(path_574306, "resourceGroupName", newJString(resourceGroupName))
  add(query_574307, "api-version", newJString(apiVersion))
  add(path_574306, "subscriptionId", newJString(subscriptionId))
  add(path_574306, "uid", newJString(uid))
  add(path_574306, "serviceName", newJString(serviceName))
  result = call_574305.call(path_574306, query_574307, nil, nil, nil)

var groupUserCreate* = Call_GroupUserCreate_574295(name: "groupUserCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/groups/{groupId}/users/{uid}",
    validator: validate_GroupUserCreate_574296, base: "", url: url_GroupUserCreate_574297,
    schemes: {Scheme.Https})
type
  Call_GroupUserCheckEntityExists_574321 = ref object of OpenApiRestCall_573657
proc url_GroupUserCheckEntityExists_574323(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupUserCheckEntityExists_574322(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks that user entity specified by identifier is associated with the group entity.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_574324 = path.getOrDefault("groupId")
  valid_574324 = validateParameter(valid_574324, JString, required = true,
                                 default = nil)
  if valid_574324 != nil:
    section.add "groupId", valid_574324
  var valid_574325 = path.getOrDefault("resourceGroupName")
  valid_574325 = validateParameter(valid_574325, JString, required = true,
                                 default = nil)
  if valid_574325 != nil:
    section.add "resourceGroupName", valid_574325
  var valid_574326 = path.getOrDefault("subscriptionId")
  valid_574326 = validateParameter(valid_574326, JString, required = true,
                                 default = nil)
  if valid_574326 != nil:
    section.add "subscriptionId", valid_574326
  var valid_574327 = path.getOrDefault("uid")
  valid_574327 = validateParameter(valid_574327, JString, required = true,
                                 default = nil)
  if valid_574327 != nil:
    section.add "uid", valid_574327
  var valid_574328 = path.getOrDefault("serviceName")
  valid_574328 = validateParameter(valid_574328, JString, required = true,
                                 default = nil)
  if valid_574328 != nil:
    section.add "serviceName", valid_574328
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574329 = query.getOrDefault("api-version")
  valid_574329 = validateParameter(valid_574329, JString, required = true,
                                 default = nil)
  if valid_574329 != nil:
    section.add "api-version", valid_574329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574330: Call_GroupUserCheckEntityExists_574321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks that user entity specified by identifier is associated with the group entity.
  ## 
  let valid = call_574330.validator(path, query, header, formData, body)
  let scheme = call_574330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574330.url(scheme.get, call_574330.host, call_574330.base,
                         call_574330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574330, url, valid)

proc call*(call_574331: Call_GroupUserCheckEntityExists_574321; groupId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          uid: string; serviceName: string): Recallable =
  ## groupUserCheckEntityExists
  ## Checks that user entity specified by identifier is associated with the group entity.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
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
  var path_574332 = newJObject()
  var query_574333 = newJObject()
  add(path_574332, "groupId", newJString(groupId))
  add(path_574332, "resourceGroupName", newJString(resourceGroupName))
  add(query_574333, "api-version", newJString(apiVersion))
  add(path_574332, "subscriptionId", newJString(subscriptionId))
  add(path_574332, "uid", newJString(uid))
  add(path_574332, "serviceName", newJString(serviceName))
  result = call_574331.call(path_574332, query_574333, nil, nil, nil)

var groupUserCheckEntityExists* = Call_GroupUserCheckEntityExists_574321(
    name: "groupUserCheckEntityExists", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/groups/{groupId}/users/{uid}",
    validator: validate_GroupUserCheckEntityExists_574322, base: "",
    url: url_GroupUserCheckEntityExists_574323, schemes: {Scheme.Https})
type
  Call_GroupUserDelete_574308 = ref object of OpenApiRestCall_573657
proc url_GroupUserDelete_574310(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "uid" in path, "`uid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "uid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GroupUserDelete_574309(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Remove existing user from existing group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   uid: JString (required)
  ##      : User identifier. Must be unique in the current API Management service instance.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_574311 = path.getOrDefault("groupId")
  valid_574311 = validateParameter(valid_574311, JString, required = true,
                                 default = nil)
  if valid_574311 != nil:
    section.add "groupId", valid_574311
  var valid_574312 = path.getOrDefault("resourceGroupName")
  valid_574312 = validateParameter(valid_574312, JString, required = true,
                                 default = nil)
  if valid_574312 != nil:
    section.add "resourceGroupName", valid_574312
  var valid_574313 = path.getOrDefault("subscriptionId")
  valid_574313 = validateParameter(valid_574313, JString, required = true,
                                 default = nil)
  if valid_574313 != nil:
    section.add "subscriptionId", valid_574313
  var valid_574314 = path.getOrDefault("uid")
  valid_574314 = validateParameter(valid_574314, JString, required = true,
                                 default = nil)
  if valid_574314 != nil:
    section.add "uid", valid_574314
  var valid_574315 = path.getOrDefault("serviceName")
  valid_574315 = validateParameter(valid_574315, JString, required = true,
                                 default = nil)
  if valid_574315 != nil:
    section.add "serviceName", valid_574315
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574316 = query.getOrDefault("api-version")
  valid_574316 = validateParameter(valid_574316, JString, required = true,
                                 default = nil)
  if valid_574316 != nil:
    section.add "api-version", valid_574316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574317: Call_GroupUserDelete_574308; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove existing user from existing group.
  ## 
  let valid = call_574317.validator(path, query, header, formData, body)
  let scheme = call_574317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574317.url(scheme.get, call_574317.host, call_574317.base,
                         call_574317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574317, url, valid)

proc call*(call_574318: Call_GroupUserDelete_574308; groupId: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          uid: string; serviceName: string): Recallable =
  ## groupUserDelete
  ## Remove existing user from existing group.
  ##   groupId: string (required)
  ##          : Group identifier. Must be unique in the current API Management service instance.
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
  var path_574319 = newJObject()
  var query_574320 = newJObject()
  add(path_574319, "groupId", newJString(groupId))
  add(path_574319, "resourceGroupName", newJString(resourceGroupName))
  add(query_574320, "api-version", newJString(apiVersion))
  add(path_574319, "subscriptionId", newJString(subscriptionId))
  add(path_574319, "uid", newJString(uid))
  add(path_574319, "serviceName", newJString(serviceName))
  result = call_574318.call(path_574319, query_574320, nil, nil, nil)

var groupUserDelete* = Call_GroupUserDelete_574308(name: "groupUserDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/groups/{groupId}/users/{uid}",
    validator: validate_GroupUserDelete_574309, base: "", url: url_GroupUserDelete_574310,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
