
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Management Groups
## version: 2018-03-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Azure Management Groups API enables consolidation of multiple subscriptions/resources into an organizational hierarchy and centrally manage access control, policies, alerting and reporting for those resources.
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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
  macServiceName = "managementgroups-management"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CheckNameAvailability_567880 = ref object of OpenApiRestCall_567658
proc url_CheckNameAvailability_567882(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CheckNameAvailability_567881(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks if the specified management group name is valid and unique
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568041 = query.getOrDefault("api-version")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "api-version", valid_568041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   checkNameAvailabilityRequest: JObject (required)
  ##                               : Management group name availability check parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568065: Call_CheckNameAvailability_567880; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks if the specified management group name is valid and unique
  ## 
  let valid = call_568065.validator(path, query, header, formData, body)
  let scheme = call_568065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568065.url(scheme.get, call_568065.host, call_568065.base,
                         call_568065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568065, url, valid)

proc call*(call_568136: Call_CheckNameAvailability_567880; apiVersion: string;
          checkNameAvailabilityRequest: JsonNode): Recallable =
  ## checkNameAvailability
  ## Checks if the specified management group name is valid and unique
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   checkNameAvailabilityRequest: JObject (required)
  ##                               : Management group name availability check parameters.
  var query_568137 = newJObject()
  var body_568139 = newJObject()
  add(query_568137, "api-version", newJString(apiVersion))
  if checkNameAvailabilityRequest != nil:
    body_568139 = checkNameAvailabilityRequest
  result = call_568136.call(nil, query_568137, nil, nil, body_568139)

var checkNameAvailability* = Call_CheckNameAvailability_567880(
    name: "checkNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/checkNameAvailability",
    validator: validate_CheckNameAvailability_567881, base: "",
    url: url_CheckNameAvailability_567882, schemes: {Scheme.Https})
type
  Call_EntitiesList_568178 = ref object of OpenApiRestCall_567658
proc url_EntitiesList_568180(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_EntitiesList_568179(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List all entities (Management Groups, Subscriptions, etc.) for the authenticated user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   $view: JString
  ##        : The view parameter allows clients to filter the type of data that is returned by the getEntities call.
  ##   $top: JInt
  ##       : Number of elements to return when retrieving results. Passing this in will override $skipToken.
  ##   $select: JString
  ##          : This parameter specifies the fields to include in the response. Can include any combination of Name,DisplayName,Type,ParentDisplayNameChain,ParentChain, e.g. '$select=Name,DisplayName,Type,ParentDisplayNameChain,ParentNameChain'. When specified the $select parameter can override select in $skipToken.
  ##   $skiptoken: JString
  ##             : Page continuation token is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a token parameter that specifies a starting point to use for subsequent calls.
  ##   groupName: JString
  ##            : A filter which allows the get entities call to focus on a particular group (i.e. "$filter=name eq 'groupName'")
  ##   $skip: JInt
  ##        : Number of entities to skip over when retrieving results. Passing this in will override $skipToken.
  ##   $search: JString
  ##          : The $search parameter is used in conjunction with the $filter parameter to return three different outputs depending on the parameter passed in. With $search=AllowedParents the API will return the entity info of all groups that the requested entity will be able to reparent to as determined by the user's permissions. With $search=AllowedChildren the API will return the entity info of all entities that can be added as children of the requested entity. With $search=ParentAndFirstLevelChildren the API will return the parent and  first level of children that the user has either direct access to or indirect access via one of their descendants.
  ##   $filter: JString
  ##          : The filter parameter allows you to filter on the name or display name fields. You can check for equality on the name field (e.g. name eq '{entityName}')  and you can check for substrings on either the name or display name fields(e.g. contains(name, '{substringToSearch}'), contains(displayName, '{substringToSearch')). Note that the '{entityName}' and '{substringToSearch}' fields are checked case insensitively.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568182 = query.getOrDefault("api-version")
  valid_568182 = validateParameter(valid_568182, JString, required = true,
                                 default = nil)
  if valid_568182 != nil:
    section.add "api-version", valid_568182
  var valid_568196 = query.getOrDefault("$view")
  valid_568196 = validateParameter(valid_568196, JString, required = false,
                                 default = newJString("FullHierarchy"))
  if valid_568196 != nil:
    section.add "$view", valid_568196
  var valid_568197 = query.getOrDefault("$top")
  valid_568197 = validateParameter(valid_568197, JInt, required = false, default = nil)
  if valid_568197 != nil:
    section.add "$top", valid_568197
  var valid_568198 = query.getOrDefault("$select")
  valid_568198 = validateParameter(valid_568198, JString, required = false,
                                 default = nil)
  if valid_568198 != nil:
    section.add "$select", valid_568198
  var valid_568199 = query.getOrDefault("$skiptoken")
  valid_568199 = validateParameter(valid_568199, JString, required = false,
                                 default = nil)
  if valid_568199 != nil:
    section.add "$skiptoken", valid_568199
  var valid_568200 = query.getOrDefault("groupName")
  valid_568200 = validateParameter(valid_568200, JString, required = false,
                                 default = nil)
  if valid_568200 != nil:
    section.add "groupName", valid_568200
  var valid_568201 = query.getOrDefault("$skip")
  valid_568201 = validateParameter(valid_568201, JInt, required = false, default = nil)
  if valid_568201 != nil:
    section.add "$skip", valid_568201
  var valid_568202 = query.getOrDefault("$search")
  valid_568202 = validateParameter(valid_568202, JString, required = false,
                                 default = newJString("AllowedParents"))
  if valid_568202 != nil:
    section.add "$search", valid_568202
  var valid_568203 = query.getOrDefault("$filter")
  valid_568203 = validateParameter(valid_568203, JString, required = false,
                                 default = nil)
  if valid_568203 != nil:
    section.add "$filter", valid_568203
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_568204 = header.getOrDefault("Cache-Control")
  valid_568204 = validateParameter(valid_568204, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_568204 != nil:
    section.add "Cache-Control", valid_568204
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568205: Call_EntitiesList_568178; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all entities (Management Groups, Subscriptions, etc.) for the authenticated user.
  ## 
  let valid = call_568205.validator(path, query, header, formData, body)
  let scheme = call_568205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568205.url(scheme.get, call_568205.host, call_568205.base,
                         call_568205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568205, url, valid)

proc call*(call_568206: Call_EntitiesList_568178; apiVersion: string;
          View: string = "FullHierarchy"; Top: int = 0; Select: string = "";
          Skiptoken: string = ""; groupName: string = ""; Skip: int = 0;
          Search: string = "AllowedParents"; Filter: string = ""): Recallable =
  ## entitiesList
  ## List all entities (Management Groups, Subscriptions, etc.) for the authenticated user.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   View: string
  ##       : The view parameter allows clients to filter the type of data that is returned by the getEntities call.
  ##   Top: int
  ##      : Number of elements to return when retrieving results. Passing this in will override $skipToken.
  ##   Select: string
  ##         : This parameter specifies the fields to include in the response. Can include any combination of Name,DisplayName,Type,ParentDisplayNameChain,ParentChain, e.g. '$select=Name,DisplayName,Type,ParentDisplayNameChain,ParentNameChain'. When specified the $select parameter can override select in $skipToken.
  ##   Skiptoken: string
  ##            : Page continuation token is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a token parameter that specifies a starting point to use for subsequent calls.
  ##   groupName: string
  ##            : A filter which allows the get entities call to focus on a particular group (i.e. "$filter=name eq 'groupName'")
  ##   Skip: int
  ##       : Number of entities to skip over when retrieving results. Passing this in will override $skipToken.
  ##   Search: string
  ##         : The $search parameter is used in conjunction with the $filter parameter to return three different outputs depending on the parameter passed in. With $search=AllowedParents the API will return the entity info of all groups that the requested entity will be able to reparent to as determined by the user's permissions. With $search=AllowedChildren the API will return the entity info of all entities that can be added as children of the requested entity. With $search=ParentAndFirstLevelChildren the API will return the parent and  first level of children that the user has either direct access to or indirect access via one of their descendants.
  ##   Filter: string
  ##         : The filter parameter allows you to filter on the name or display name fields. You can check for equality on the name field (e.g. name eq '{entityName}')  and you can check for substrings on either the name or display name fields(e.g. contains(name, '{substringToSearch}'), contains(displayName, '{substringToSearch')). Note that the '{entityName}' and '{substringToSearch}' fields are checked case insensitively.
  var query_568207 = newJObject()
  add(query_568207, "api-version", newJString(apiVersion))
  add(query_568207, "$view", newJString(View))
  add(query_568207, "$top", newJInt(Top))
  add(query_568207, "$select", newJString(Select))
  add(query_568207, "$skiptoken", newJString(Skiptoken))
  add(query_568207, "groupName", newJString(groupName))
  add(query_568207, "$skip", newJInt(Skip))
  add(query_568207, "$search", newJString(Search))
  add(query_568207, "$filter", newJString(Filter))
  result = call_568206.call(nil, query_568207, nil, nil, nil)

var entitiesList* = Call_EntitiesList_568178(name: "entitiesList",
    meth: HttpMethod.HttpPost, host: "management.azure.com",
    route: "/providers/Microsoft.Management/getEntities",
    validator: validate_EntitiesList_568179, base: "", url: url_EntitiesList_568180,
    schemes: {Scheme.Https})
type
  Call_ManagementGroupsList_568208 = ref object of OpenApiRestCall_567658
proc url_ManagementGroupsList_568210(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ManagementGroupsList_568209(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List management groups for the authenticated user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   $skiptoken: JString
  ##             : Page continuation token is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a token parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568211 = query.getOrDefault("api-version")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "api-version", valid_568211
  var valid_568212 = query.getOrDefault("$skiptoken")
  valid_568212 = validateParameter(valid_568212, JString, required = false,
                                 default = nil)
  if valid_568212 != nil:
    section.add "$skiptoken", valid_568212
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_568213 = header.getOrDefault("Cache-Control")
  valid_568213 = validateParameter(valid_568213, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_568213 != nil:
    section.add "Cache-Control", valid_568213
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568214: Call_ManagementGroupsList_568208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List management groups for the authenticated user.
  ## 
  let valid = call_568214.validator(path, query, header, formData, body)
  let scheme = call_568214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568214.url(scheme.get, call_568214.host, call_568214.base,
                         call_568214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568214, url, valid)

proc call*(call_568215: Call_ManagementGroupsList_568208; apiVersion: string;
          Skiptoken: string = ""): Recallable =
  ## managementGroupsList
  ## List management groups for the authenticated user.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   Skiptoken: string
  ##            : Page continuation token is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a token parameter that specifies a starting point to use for subsequent calls.
  var query_568216 = newJObject()
  add(query_568216, "api-version", newJString(apiVersion))
  add(query_568216, "$skiptoken", newJString(Skiptoken))
  result = call_568215.call(nil, query_568216, nil, nil, nil)

var managementGroupsList* = Call_ManagementGroupsList_568208(
    name: "managementGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/managementGroups",
    validator: validate_ManagementGroupsList_568209, base: "",
    url: url_ManagementGroupsList_568210, schemes: {Scheme.Https})
type
  Call_ManagementGroupsCreateOrUpdate_568244 = ref object of OpenApiRestCall_567658
proc url_ManagementGroupsCreateOrUpdate_568246(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementGroupsCreateOrUpdate_568245(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a management group. If a management group is already created and a subsequent create request is issued with different properties, the management group properties will be updated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Management Group ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_568247 = path.getOrDefault("groupId")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "groupId", valid_568247
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568248 = query.getOrDefault("api-version")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "api-version", valid_568248
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_568249 = header.getOrDefault("Cache-Control")
  valid_568249 = validateParameter(valid_568249, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_568249 != nil:
    section.add "Cache-Control", valid_568249
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   createManagementGroupRequest: JObject (required)
  ##                               : Management group creation parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568251: Call_ManagementGroupsCreateOrUpdate_568244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a management group. If a management group is already created and a subsequent create request is issued with different properties, the management group properties will be updated.
  ## 
  let valid = call_568251.validator(path, query, header, formData, body)
  let scheme = call_568251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568251.url(scheme.get, call_568251.host, call_568251.base,
                         call_568251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568251, url, valid)

proc call*(call_568252: Call_ManagementGroupsCreateOrUpdate_568244;
          groupId: string; apiVersion: string;
          createManagementGroupRequest: JsonNode): Recallable =
  ## managementGroupsCreateOrUpdate
  ## Create or update a management group. If a management group is already created and a subsequent create request is issued with different properties, the management group properties will be updated.
  ##   groupId: string (required)
  ##          : Management Group ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   createManagementGroupRequest: JObject (required)
  ##                               : Management group creation parameters.
  var path_568253 = newJObject()
  var query_568254 = newJObject()
  var body_568255 = newJObject()
  add(path_568253, "groupId", newJString(groupId))
  add(query_568254, "api-version", newJString(apiVersion))
  if createManagementGroupRequest != nil:
    body_568255 = createManagementGroupRequest
  result = call_568252.call(path_568253, query_568254, nil, nil, body_568255)

var managementGroupsCreateOrUpdate* = Call_ManagementGroupsCreateOrUpdate_568244(
    name: "managementGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/managementGroups/{groupId}",
    validator: validate_ManagementGroupsCreateOrUpdate_568245, base: "",
    url: url_ManagementGroupsCreateOrUpdate_568246, schemes: {Scheme.Https})
type
  Call_ManagementGroupsGet_568217 = ref object of OpenApiRestCall_567658
proc url_ManagementGroupsGet_568219(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementGroupsGet_568218(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get the details of the management group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Management Group ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_568234 = path.getOrDefault("groupId")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "groupId", valid_568234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   $expand: JString
  ##          : The $expand=children query string parameter allows clients to request inclusion of children in the response payload.
  ##   $recurse: JBool
  ##           : The $recurse=true query string parameter allows clients to request inclusion of entire hierarchy in the response payload. Note that  $expand=children must be passed up if $recurse is set to true.
  ##   $filter: JString
  ##          : A filter which allows the exclusion of subscriptions from results (i.e. '$filter=children.childType ne Subscription')
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568235 = query.getOrDefault("api-version")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "api-version", valid_568235
  var valid_568236 = query.getOrDefault("$expand")
  valid_568236 = validateParameter(valid_568236, JString, required = false,
                                 default = newJString("children"))
  if valid_568236 != nil:
    section.add "$expand", valid_568236
  var valid_568237 = query.getOrDefault("$recurse")
  valid_568237 = validateParameter(valid_568237, JBool, required = false, default = nil)
  if valid_568237 != nil:
    section.add "$recurse", valid_568237
  var valid_568238 = query.getOrDefault("$filter")
  valid_568238 = validateParameter(valid_568238, JString, required = false,
                                 default = nil)
  if valid_568238 != nil:
    section.add "$filter", valid_568238
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_568239 = header.getOrDefault("Cache-Control")
  valid_568239 = validateParameter(valid_568239, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_568239 != nil:
    section.add "Cache-Control", valid_568239
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568240: Call_ManagementGroupsGet_568217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of the management group.
  ## 
  let valid = call_568240.validator(path, query, header, formData, body)
  let scheme = call_568240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568240.url(scheme.get, call_568240.host, call_568240.base,
                         call_568240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568240, url, valid)

proc call*(call_568241: Call_ManagementGroupsGet_568217; groupId: string;
          apiVersion: string; Expand: string = "children"; Recurse: bool = false;
          Filter: string = ""): Recallable =
  ## managementGroupsGet
  ## Get the details of the management group.
  ##   groupId: string (required)
  ##          : Management Group ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   Expand: string
  ##         : The $expand=children query string parameter allows clients to request inclusion of children in the response payload.
  ##   Recurse: bool
  ##          : The $recurse=true query string parameter allows clients to request inclusion of entire hierarchy in the response payload. Note that  $expand=children must be passed up if $recurse is set to true.
  ##   Filter: string
  ##         : A filter which allows the exclusion of subscriptions from results (i.e. '$filter=children.childType ne Subscription')
  var path_568242 = newJObject()
  var query_568243 = newJObject()
  add(path_568242, "groupId", newJString(groupId))
  add(query_568243, "api-version", newJString(apiVersion))
  add(query_568243, "$expand", newJString(Expand))
  add(query_568243, "$recurse", newJBool(Recurse))
  add(query_568243, "$filter", newJString(Filter))
  result = call_568241.call(path_568242, query_568243, nil, nil, nil)

var managementGroupsGet* = Call_ManagementGroupsGet_568217(
    name: "managementGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/managementGroups/{groupId}",
    validator: validate_ManagementGroupsGet_568218, base: "",
    url: url_ManagementGroupsGet_568219, schemes: {Scheme.Https})
type
  Call_ManagementGroupsUpdate_568266 = ref object of OpenApiRestCall_567658
proc url_ManagementGroupsUpdate_568268(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementGroupsUpdate_568267(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a management group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Management Group ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_568269 = path.getOrDefault("groupId")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "groupId", valid_568269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568270 = query.getOrDefault("api-version")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "api-version", valid_568270
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_568271 = header.getOrDefault("Cache-Control")
  valid_568271 = validateParameter(valid_568271, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_568271 != nil:
    section.add "Cache-Control", valid_568271
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   patchGroupRequest: JObject (required)
  ##                    : Management group patch parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568273: Call_ManagementGroupsUpdate_568266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a management group.
  ## 
  let valid = call_568273.validator(path, query, header, formData, body)
  let scheme = call_568273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568273.url(scheme.get, call_568273.host, call_568273.base,
                         call_568273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568273, url, valid)

proc call*(call_568274: Call_ManagementGroupsUpdate_568266; groupId: string;
          apiVersion: string; patchGroupRequest: JsonNode): Recallable =
  ## managementGroupsUpdate
  ## Update a management group.
  ##   groupId: string (required)
  ##          : Management Group ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   patchGroupRequest: JObject (required)
  ##                    : Management group patch parameters.
  var path_568275 = newJObject()
  var query_568276 = newJObject()
  var body_568277 = newJObject()
  add(path_568275, "groupId", newJString(groupId))
  add(query_568276, "api-version", newJString(apiVersion))
  if patchGroupRequest != nil:
    body_568277 = patchGroupRequest
  result = call_568274.call(path_568275, query_568276, nil, nil, body_568277)

var managementGroupsUpdate* = Call_ManagementGroupsUpdate_568266(
    name: "managementGroupsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/managementGroups/{groupId}",
    validator: validate_ManagementGroupsUpdate_568267, base: "",
    url: url_ManagementGroupsUpdate_568268, schemes: {Scheme.Https})
type
  Call_ManagementGroupsDelete_568256 = ref object of OpenApiRestCall_567658
proc url_ManagementGroupsDelete_568258(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementGroupsDelete_568257(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete management group. If a management group contains child resources, the request will fail.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Management Group ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_568259 = path.getOrDefault("groupId")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "groupId", valid_568259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568260 = query.getOrDefault("api-version")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "api-version", valid_568260
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_568261 = header.getOrDefault("Cache-Control")
  valid_568261 = validateParameter(valid_568261, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_568261 != nil:
    section.add "Cache-Control", valid_568261
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568262: Call_ManagementGroupsDelete_568256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete management group. If a management group contains child resources, the request will fail.
  ## 
  let valid = call_568262.validator(path, query, header, formData, body)
  let scheme = call_568262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568262.url(scheme.get, call_568262.host, call_568262.base,
                         call_568262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568262, url, valid)

proc call*(call_568263: Call_ManagementGroupsDelete_568256; groupId: string;
          apiVersion: string): Recallable =
  ## managementGroupsDelete
  ## Delete management group. If a management group contains child resources, the request will fail.
  ##   groupId: string (required)
  ##          : Management Group ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  var path_568264 = newJObject()
  var query_568265 = newJObject()
  add(path_568264, "groupId", newJString(groupId))
  add(query_568265, "api-version", newJString(apiVersion))
  result = call_568263.call(path_568264, query_568265, nil, nil, nil)

var managementGroupsDelete* = Call_ManagementGroupsDelete_568256(
    name: "managementGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/managementGroups/{groupId}",
    validator: validate_ManagementGroupsDelete_568257, base: "",
    url: url_ManagementGroupsDelete_568258, schemes: {Scheme.Https})
type
  Call_ManagementGroupsGetDescendants_568278 = ref object of OpenApiRestCall_567658
proc url_ManagementGroupsGetDescendants_568280(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId"),
               (kind: ConstantSegment, value: "/descendants")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementGroupsGetDescendants_568279(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all entities that descend from a management group.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Management Group ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_568281 = path.getOrDefault("groupId")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "groupId", valid_568281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   $top: JInt
  ##       : Number of elements to return when retrieving results. Passing this in will override $skipToken.
  ##   $skiptoken: JString
  ##             : Page continuation token is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a token parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568282 = query.getOrDefault("api-version")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "api-version", valid_568282
  var valid_568283 = query.getOrDefault("$top")
  valid_568283 = validateParameter(valid_568283, JInt, required = false, default = nil)
  if valid_568283 != nil:
    section.add "$top", valid_568283
  var valid_568284 = query.getOrDefault("$skiptoken")
  valid_568284 = validateParameter(valid_568284, JString, required = false,
                                 default = nil)
  if valid_568284 != nil:
    section.add "$skiptoken", valid_568284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568285: Call_ManagementGroupsGetDescendants_568278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all entities that descend from a management group.
  ## 
  ## 
  let valid = call_568285.validator(path, query, header, formData, body)
  let scheme = call_568285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568285.url(scheme.get, call_568285.host, call_568285.base,
                         call_568285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568285, url, valid)

proc call*(call_568286: Call_ManagementGroupsGetDescendants_568278;
          groupId: string; apiVersion: string; Top: int = 0; Skiptoken: string = ""): Recallable =
  ## managementGroupsGetDescendants
  ## List all entities that descend from a management group.
  ## 
  ##   groupId: string (required)
  ##          : Management Group ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   Top: int
  ##      : Number of elements to return when retrieving results. Passing this in will override $skipToken.
  ##   Skiptoken: string
  ##            : Page continuation token is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a token parameter that specifies a starting point to use for subsequent calls.
  var path_568287 = newJObject()
  var query_568288 = newJObject()
  add(path_568287, "groupId", newJString(groupId))
  add(query_568288, "api-version", newJString(apiVersion))
  add(query_568288, "$top", newJInt(Top))
  add(query_568288, "$skiptoken", newJString(Skiptoken))
  result = call_568286.call(path_568287, query_568288, nil, nil, nil)

var managementGroupsGetDescendants* = Call_ManagementGroupsGetDescendants_568278(
    name: "managementGroupsGetDescendants", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/descendants",
    validator: validate_ManagementGroupsGetDescendants_568279, base: "",
    url: url_ManagementGroupsGetDescendants_568280, schemes: {Scheme.Https})
type
  Call_ManagementGroupSubscriptionsCreate_568289 = ref object of OpenApiRestCall_567658
proc url_ManagementGroupSubscriptionsCreate_568291(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementGroupSubscriptionsCreate_568290(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Associates existing subscription with the management group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Management Group ID.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_568292 = path.getOrDefault("groupId")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "groupId", valid_568292
  var valid_568293 = path.getOrDefault("subscriptionId")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "subscriptionId", valid_568293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568294 = query.getOrDefault("api-version")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "api-version", valid_568294
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_568295 = header.getOrDefault("Cache-Control")
  valid_568295 = validateParameter(valid_568295, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_568295 != nil:
    section.add "Cache-Control", valid_568295
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568296: Call_ManagementGroupSubscriptionsCreate_568289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Associates existing subscription with the management group.
  ## 
  let valid = call_568296.validator(path, query, header, formData, body)
  let scheme = call_568296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568296.url(scheme.get, call_568296.host, call_568296.base,
                         call_568296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568296, url, valid)

proc call*(call_568297: Call_ManagementGroupSubscriptionsCreate_568289;
          groupId: string; apiVersion: string; subscriptionId: string): Recallable =
  ## managementGroupSubscriptionsCreate
  ## Associates existing subscription with the management group.
  ##   groupId: string (required)
  ##          : Management Group ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID.
  var path_568298 = newJObject()
  var query_568299 = newJObject()
  add(path_568298, "groupId", newJString(groupId))
  add(query_568299, "api-version", newJString(apiVersion))
  add(path_568298, "subscriptionId", newJString(subscriptionId))
  result = call_568297.call(path_568298, query_568299, nil, nil, nil)

var managementGroupSubscriptionsCreate* = Call_ManagementGroupSubscriptionsCreate_568289(
    name: "managementGroupSubscriptionsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/subscriptions/{subscriptionId}",
    validator: validate_ManagementGroupSubscriptionsCreate_568290, base: "",
    url: url_ManagementGroupSubscriptionsCreate_568291, schemes: {Scheme.Https})
type
  Call_ManagementGroupSubscriptionsDelete_568300 = ref object of OpenApiRestCall_567658
proc url_ManagementGroupSubscriptionsDelete_568302(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupId" in path, "`groupId` is a required path parameter"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "groupId"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementGroupSubscriptionsDelete_568301(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## De-associates subscription from the management group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Management Group ID.
  ##   subscriptionId: JString (required)
  ##                 : Subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_568303 = path.getOrDefault("groupId")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "groupId", valid_568303
  var valid_568304 = path.getOrDefault("subscriptionId")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "subscriptionId", valid_568304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568305 = query.getOrDefault("api-version")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "api-version", valid_568305
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_568306 = header.getOrDefault("Cache-Control")
  valid_568306 = validateParameter(valid_568306, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_568306 != nil:
    section.add "Cache-Control", valid_568306
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568307: Call_ManagementGroupSubscriptionsDelete_568300;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## De-associates subscription from the management group.
  ## 
  let valid = call_568307.validator(path, query, header, formData, body)
  let scheme = call_568307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568307.url(scheme.get, call_568307.host, call_568307.base,
                         call_568307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568307, url, valid)

proc call*(call_568308: Call_ManagementGroupSubscriptionsDelete_568300;
          groupId: string; apiVersion: string; subscriptionId: string): Recallable =
  ## managementGroupSubscriptionsDelete
  ## De-associates subscription from the management group.
  ##   groupId: string (required)
  ##          : Management Group ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID.
  var path_568309 = newJObject()
  var query_568310 = newJObject()
  add(path_568309, "groupId", newJString(groupId))
  add(query_568310, "api-version", newJString(apiVersion))
  add(path_568309, "subscriptionId", newJString(subscriptionId))
  result = call_568308.call(path_568309, query_568310, nil, nil, nil)

var managementGroupSubscriptionsDelete* = Call_ManagementGroupSubscriptionsDelete_568300(
    name: "managementGroupSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/subscriptions/{subscriptionId}",
    validator: validate_ManagementGroupSubscriptionsDelete_568301, base: "",
    url: url_ManagementGroupSubscriptionsDelete_568302, schemes: {Scheme.Https})
type
  Call_OperationsList_568311 = ref object of OpenApiRestCall_567658
proc url_OperationsList_568313(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_568312(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Management REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568314 = query.getOrDefault("api-version")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "api-version", valid_568314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568315: Call_OperationsList_568311; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Management REST API operations.
  ## 
  let valid = call_568315.validator(path, query, header, formData, body)
  let scheme = call_568315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568315.url(scheme.get, call_568315.host, call_568315.base,
                         call_568315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568315, url, valid)

proc call*(call_568316: Call_OperationsList_568311; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Management REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  var query_568317 = newJObject()
  add(query_568317, "api-version", newJString(apiVersion))
  result = call_568316.call(nil, query_568317, nil, nil, nil)

var operationsList* = Call_OperationsList_568311(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Management/operations",
    validator: validate_OperationsList_568312, base: "", url: url_OperationsList_568313,
    schemes: {Scheme.Https})
type
  Call_StartTenantBackfill_568318 = ref object of OpenApiRestCall_567658
proc url_StartTenantBackfill_568320(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_StartTenantBackfill_568319(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Starts backfilling subscriptions for the Tenant.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568321 = query.getOrDefault("api-version")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "api-version", valid_568321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568322: Call_StartTenantBackfill_568318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts backfilling subscriptions for the Tenant.
  ## 
  let valid = call_568322.validator(path, query, header, formData, body)
  let scheme = call_568322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568322.url(scheme.get, call_568322.host, call_568322.base,
                         call_568322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568322, url, valid)

proc call*(call_568323: Call_StartTenantBackfill_568318; apiVersion: string): Recallable =
  ## startTenantBackfill
  ## Starts backfilling subscriptions for the Tenant.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  var query_568324 = newJObject()
  add(query_568324, "api-version", newJString(apiVersion))
  result = call_568323.call(nil, query_568324, nil, nil, nil)

var startTenantBackfill* = Call_StartTenantBackfill_568318(
    name: "startTenantBackfill", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/startTenantBackfill",
    validator: validate_StartTenantBackfill_568319, base: "",
    url: url_StartTenantBackfill_568320, schemes: {Scheme.Https})
type
  Call_TenantBackfillStatus_568325 = ref object of OpenApiRestCall_567658
proc url_TenantBackfillStatus_568327(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TenantBackfillStatus_568326(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets tenant backfill status
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568328 = query.getOrDefault("api-version")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "api-version", valid_568328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568329: Call_TenantBackfillStatus_568325; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets tenant backfill status
  ## 
  let valid = call_568329.validator(path, query, header, formData, body)
  let scheme = call_568329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568329.url(scheme.get, call_568329.host, call_568329.base,
                         call_568329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568329, url, valid)

proc call*(call_568330: Call_TenantBackfillStatus_568325; apiVersion: string): Recallable =
  ## tenantBackfillStatus
  ## Gets tenant backfill status
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  var query_568331 = newJObject()
  add(query_568331, "api-version", newJString(apiVersion))
  result = call_568330.call(nil, query_568331, nil, nil, nil)

var tenantBackfillStatus* = Call_TenantBackfillStatus_568325(
    name: "tenantBackfillStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/tenantBackfillStatus",
    validator: validate_TenantBackfillStatus_568326, base: "",
    url: url_TenantBackfillStatus_568327, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
