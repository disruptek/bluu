
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  macServiceName = "managementgroups-management"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CheckNameAvailability_593647 = ref object of OpenApiRestCall_593425
proc url_CheckNameAvailability_593649(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CheckNameAvailability_593648(path: JsonNode; query: JsonNode;
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
  var valid_593808 = query.getOrDefault("api-version")
  valid_593808 = validateParameter(valid_593808, JString, required = true,
                                 default = nil)
  if valid_593808 != nil:
    section.add "api-version", valid_593808
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

proc call*(call_593832: Call_CheckNameAvailability_593647; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks if the specified management group name is valid and unique
  ## 
  let valid = call_593832.validator(path, query, header, formData, body)
  let scheme = call_593832.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593832.url(scheme.get, call_593832.host, call_593832.base,
                         call_593832.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593832, url, valid)

proc call*(call_593903: Call_CheckNameAvailability_593647; apiVersion: string;
          checkNameAvailabilityRequest: JsonNode): Recallable =
  ## checkNameAvailability
  ## Checks if the specified management group name is valid and unique
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   checkNameAvailabilityRequest: JObject (required)
  ##                               : Management group name availability check parameters.
  var query_593904 = newJObject()
  var body_593906 = newJObject()
  add(query_593904, "api-version", newJString(apiVersion))
  if checkNameAvailabilityRequest != nil:
    body_593906 = checkNameAvailabilityRequest
  result = call_593903.call(nil, query_593904, nil, nil, body_593906)

var checkNameAvailability* = Call_CheckNameAvailability_593647(
    name: "checkNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/checkNameAvailability",
    validator: validate_CheckNameAvailability_593648, base: "",
    url: url_CheckNameAvailability_593649, schemes: {Scheme.Https})
type
  Call_EntitiesList_593945 = ref object of OpenApiRestCall_593425
proc url_EntitiesList_593947(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_EntitiesList_593946(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593949 = query.getOrDefault("api-version")
  valid_593949 = validateParameter(valid_593949, JString, required = true,
                                 default = nil)
  if valid_593949 != nil:
    section.add "api-version", valid_593949
  var valid_593963 = query.getOrDefault("$view")
  valid_593963 = validateParameter(valid_593963, JString, required = false,
                                 default = newJString("FullHierarchy"))
  if valid_593963 != nil:
    section.add "$view", valid_593963
  var valid_593964 = query.getOrDefault("$top")
  valid_593964 = validateParameter(valid_593964, JInt, required = false, default = nil)
  if valid_593964 != nil:
    section.add "$top", valid_593964
  var valid_593965 = query.getOrDefault("$select")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = nil)
  if valid_593965 != nil:
    section.add "$select", valid_593965
  var valid_593966 = query.getOrDefault("$skiptoken")
  valid_593966 = validateParameter(valid_593966, JString, required = false,
                                 default = nil)
  if valid_593966 != nil:
    section.add "$skiptoken", valid_593966
  var valid_593967 = query.getOrDefault("groupName")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = nil)
  if valid_593967 != nil:
    section.add "groupName", valid_593967
  var valid_593968 = query.getOrDefault("$skip")
  valid_593968 = validateParameter(valid_593968, JInt, required = false, default = nil)
  if valid_593968 != nil:
    section.add "$skip", valid_593968
  var valid_593969 = query.getOrDefault("$search")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = newJString("AllowedParents"))
  if valid_593969 != nil:
    section.add "$search", valid_593969
  var valid_593970 = query.getOrDefault("$filter")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = nil)
  if valid_593970 != nil:
    section.add "$filter", valid_593970
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_593971 = header.getOrDefault("Cache-Control")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_593971 != nil:
    section.add "Cache-Control", valid_593971
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593972: Call_EntitiesList_593945; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all entities (Management Groups, Subscriptions, etc.) for the authenticated user.
  ## 
  let valid = call_593972.validator(path, query, header, formData, body)
  let scheme = call_593972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593972.url(scheme.get, call_593972.host, call_593972.base,
                         call_593972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593972, url, valid)

proc call*(call_593973: Call_EntitiesList_593945; apiVersion: string;
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
  var query_593974 = newJObject()
  add(query_593974, "api-version", newJString(apiVersion))
  add(query_593974, "$view", newJString(View))
  add(query_593974, "$top", newJInt(Top))
  add(query_593974, "$select", newJString(Select))
  add(query_593974, "$skiptoken", newJString(Skiptoken))
  add(query_593974, "groupName", newJString(groupName))
  add(query_593974, "$skip", newJInt(Skip))
  add(query_593974, "$search", newJString(Search))
  add(query_593974, "$filter", newJString(Filter))
  result = call_593973.call(nil, query_593974, nil, nil, nil)

var entitiesList* = Call_EntitiesList_593945(name: "entitiesList",
    meth: HttpMethod.HttpPost, host: "management.azure.com",
    route: "/providers/Microsoft.Management/getEntities",
    validator: validate_EntitiesList_593946, base: "", url: url_EntitiesList_593947,
    schemes: {Scheme.Https})
type
  Call_ManagementGroupsList_593975 = ref object of OpenApiRestCall_593425
proc url_ManagementGroupsList_593977(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ManagementGroupsList_593976(path: JsonNode; query: JsonNode;
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
  var valid_593978 = query.getOrDefault("api-version")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "api-version", valid_593978
  var valid_593979 = query.getOrDefault("$skiptoken")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "$skiptoken", valid_593979
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_593980 = header.getOrDefault("Cache-Control")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_593980 != nil:
    section.add "Cache-Control", valid_593980
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593981: Call_ManagementGroupsList_593975; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List management groups for the authenticated user.
  ## 
  let valid = call_593981.validator(path, query, header, formData, body)
  let scheme = call_593981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593981.url(scheme.get, call_593981.host, call_593981.base,
                         call_593981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593981, url, valid)

proc call*(call_593982: Call_ManagementGroupsList_593975; apiVersion: string;
          Skiptoken: string = ""): Recallable =
  ## managementGroupsList
  ## List management groups for the authenticated user.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   Skiptoken: string
  ##            : Page continuation token is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a token parameter that specifies a starting point to use for subsequent calls.
  var query_593983 = newJObject()
  add(query_593983, "api-version", newJString(apiVersion))
  add(query_593983, "$skiptoken", newJString(Skiptoken))
  result = call_593982.call(nil, query_593983, nil, nil, nil)

var managementGroupsList* = Call_ManagementGroupsList_593975(
    name: "managementGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/managementGroups",
    validator: validate_ManagementGroupsList_593976, base: "",
    url: url_ManagementGroupsList_593977, schemes: {Scheme.Https})
type
  Call_ManagementGroupsCreateOrUpdate_594011 = ref object of OpenApiRestCall_593425
proc url_ManagementGroupsCreateOrUpdate_594013(protocol: Scheme; host: string;
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

proc validate_ManagementGroupsCreateOrUpdate_594012(path: JsonNode;
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
  var valid_594014 = path.getOrDefault("groupId")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "groupId", valid_594014
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594015 = query.getOrDefault("api-version")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "api-version", valid_594015
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_594016 = header.getOrDefault("Cache-Control")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_594016 != nil:
    section.add "Cache-Control", valid_594016
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

proc call*(call_594018: Call_ManagementGroupsCreateOrUpdate_594011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a management group. If a management group is already created and a subsequent create request is issued with different properties, the management group properties will be updated.
  ## 
  let valid = call_594018.validator(path, query, header, formData, body)
  let scheme = call_594018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594018.url(scheme.get, call_594018.host, call_594018.base,
                         call_594018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594018, url, valid)

proc call*(call_594019: Call_ManagementGroupsCreateOrUpdate_594011;
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
  var path_594020 = newJObject()
  var query_594021 = newJObject()
  var body_594022 = newJObject()
  add(path_594020, "groupId", newJString(groupId))
  add(query_594021, "api-version", newJString(apiVersion))
  if createManagementGroupRequest != nil:
    body_594022 = createManagementGroupRequest
  result = call_594019.call(path_594020, query_594021, nil, nil, body_594022)

var managementGroupsCreateOrUpdate* = Call_ManagementGroupsCreateOrUpdate_594011(
    name: "managementGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/managementGroups/{groupId}",
    validator: validate_ManagementGroupsCreateOrUpdate_594012, base: "",
    url: url_ManagementGroupsCreateOrUpdate_594013, schemes: {Scheme.Https})
type
  Call_ManagementGroupsGet_593984 = ref object of OpenApiRestCall_593425
proc url_ManagementGroupsGet_593986(protocol: Scheme; host: string; base: string;
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

proc validate_ManagementGroupsGet_593985(path: JsonNode; query: JsonNode;
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
  var valid_594001 = path.getOrDefault("groupId")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "groupId", valid_594001
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
  var valid_594002 = query.getOrDefault("api-version")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "api-version", valid_594002
  var valid_594003 = query.getOrDefault("$expand")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = newJString("children"))
  if valid_594003 != nil:
    section.add "$expand", valid_594003
  var valid_594004 = query.getOrDefault("$recurse")
  valid_594004 = validateParameter(valid_594004, JBool, required = false, default = nil)
  if valid_594004 != nil:
    section.add "$recurse", valid_594004
  var valid_594005 = query.getOrDefault("$filter")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "$filter", valid_594005
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_594006 = header.getOrDefault("Cache-Control")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_594006 != nil:
    section.add "Cache-Control", valid_594006
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594007: Call_ManagementGroupsGet_593984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of the management group.
  ## 
  let valid = call_594007.validator(path, query, header, formData, body)
  let scheme = call_594007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594007.url(scheme.get, call_594007.host, call_594007.base,
                         call_594007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594007, url, valid)

proc call*(call_594008: Call_ManagementGroupsGet_593984; groupId: string;
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
  var path_594009 = newJObject()
  var query_594010 = newJObject()
  add(path_594009, "groupId", newJString(groupId))
  add(query_594010, "api-version", newJString(apiVersion))
  add(query_594010, "$expand", newJString(Expand))
  add(query_594010, "$recurse", newJBool(Recurse))
  add(query_594010, "$filter", newJString(Filter))
  result = call_594008.call(path_594009, query_594010, nil, nil, nil)

var managementGroupsGet* = Call_ManagementGroupsGet_593984(
    name: "managementGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/managementGroups/{groupId}",
    validator: validate_ManagementGroupsGet_593985, base: "",
    url: url_ManagementGroupsGet_593986, schemes: {Scheme.Https})
type
  Call_ManagementGroupsUpdate_594033 = ref object of OpenApiRestCall_593425
proc url_ManagementGroupsUpdate_594035(protocol: Scheme; host: string; base: string;
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

proc validate_ManagementGroupsUpdate_594034(path: JsonNode; query: JsonNode;
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
  var valid_594036 = path.getOrDefault("groupId")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "groupId", valid_594036
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594037 = query.getOrDefault("api-version")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "api-version", valid_594037
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_594038 = header.getOrDefault("Cache-Control")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_594038 != nil:
    section.add "Cache-Control", valid_594038
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

proc call*(call_594040: Call_ManagementGroupsUpdate_594033; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a management group.
  ## 
  let valid = call_594040.validator(path, query, header, formData, body)
  let scheme = call_594040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594040.url(scheme.get, call_594040.host, call_594040.base,
                         call_594040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594040, url, valid)

proc call*(call_594041: Call_ManagementGroupsUpdate_594033; groupId: string;
          apiVersion: string; patchGroupRequest: JsonNode): Recallable =
  ## managementGroupsUpdate
  ## Update a management group.
  ##   groupId: string (required)
  ##          : Management Group ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   patchGroupRequest: JObject (required)
  ##                    : Management group patch parameters.
  var path_594042 = newJObject()
  var query_594043 = newJObject()
  var body_594044 = newJObject()
  add(path_594042, "groupId", newJString(groupId))
  add(query_594043, "api-version", newJString(apiVersion))
  if patchGroupRequest != nil:
    body_594044 = patchGroupRequest
  result = call_594041.call(path_594042, query_594043, nil, nil, body_594044)

var managementGroupsUpdate* = Call_ManagementGroupsUpdate_594033(
    name: "managementGroupsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/managementGroups/{groupId}",
    validator: validate_ManagementGroupsUpdate_594034, base: "",
    url: url_ManagementGroupsUpdate_594035, schemes: {Scheme.Https})
type
  Call_ManagementGroupsDelete_594023 = ref object of OpenApiRestCall_593425
proc url_ManagementGroupsDelete_594025(protocol: Scheme; host: string; base: string;
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

proc validate_ManagementGroupsDelete_594024(path: JsonNode; query: JsonNode;
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
  var valid_594026 = path.getOrDefault("groupId")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "groupId", valid_594026
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594027 = query.getOrDefault("api-version")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "api-version", valid_594027
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_594028 = header.getOrDefault("Cache-Control")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_594028 != nil:
    section.add "Cache-Control", valid_594028
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594029: Call_ManagementGroupsDelete_594023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete management group. If a management group contains child resources, the request will fail.
  ## 
  let valid = call_594029.validator(path, query, header, formData, body)
  let scheme = call_594029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594029.url(scheme.get, call_594029.host, call_594029.base,
                         call_594029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594029, url, valid)

proc call*(call_594030: Call_ManagementGroupsDelete_594023; groupId: string;
          apiVersion: string): Recallable =
  ## managementGroupsDelete
  ## Delete management group. If a management group contains child resources, the request will fail.
  ##   groupId: string (required)
  ##          : Management Group ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  var path_594031 = newJObject()
  var query_594032 = newJObject()
  add(path_594031, "groupId", newJString(groupId))
  add(query_594032, "api-version", newJString(apiVersion))
  result = call_594030.call(path_594031, query_594032, nil, nil, nil)

var managementGroupsDelete* = Call_ManagementGroupsDelete_594023(
    name: "managementGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/managementGroups/{groupId}",
    validator: validate_ManagementGroupsDelete_594024, base: "",
    url: url_ManagementGroupsDelete_594025, schemes: {Scheme.Https})
type
  Call_ManagementGroupsGetDescendants_594045 = ref object of OpenApiRestCall_593425
proc url_ManagementGroupsGetDescendants_594047(protocol: Scheme; host: string;
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

proc validate_ManagementGroupsGetDescendants_594046(path: JsonNode;
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
  var valid_594048 = path.getOrDefault("groupId")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "groupId", valid_594048
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
  var valid_594049 = query.getOrDefault("api-version")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "api-version", valid_594049
  var valid_594050 = query.getOrDefault("$top")
  valid_594050 = validateParameter(valid_594050, JInt, required = false, default = nil)
  if valid_594050 != nil:
    section.add "$top", valid_594050
  var valid_594051 = query.getOrDefault("$skiptoken")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "$skiptoken", valid_594051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594052: Call_ManagementGroupsGetDescendants_594045; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all entities that descend from a management group.
  ## 
  ## 
  let valid = call_594052.validator(path, query, header, formData, body)
  let scheme = call_594052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594052.url(scheme.get, call_594052.host, call_594052.base,
                         call_594052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594052, url, valid)

proc call*(call_594053: Call_ManagementGroupsGetDescendants_594045;
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
  var path_594054 = newJObject()
  var query_594055 = newJObject()
  add(path_594054, "groupId", newJString(groupId))
  add(query_594055, "api-version", newJString(apiVersion))
  add(query_594055, "$top", newJInt(Top))
  add(query_594055, "$skiptoken", newJString(Skiptoken))
  result = call_594053.call(path_594054, query_594055, nil, nil, nil)

var managementGroupsGetDescendants* = Call_ManagementGroupsGetDescendants_594045(
    name: "managementGroupsGetDescendants", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/descendants",
    validator: validate_ManagementGroupsGetDescendants_594046, base: "",
    url: url_ManagementGroupsGetDescendants_594047, schemes: {Scheme.Https})
type
  Call_ManagementGroupSubscriptionsCreate_594056 = ref object of OpenApiRestCall_593425
proc url_ManagementGroupSubscriptionsCreate_594058(protocol: Scheme; host: string;
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

proc validate_ManagementGroupSubscriptionsCreate_594057(path: JsonNode;
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
  var valid_594059 = path.getOrDefault("groupId")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "groupId", valid_594059
  var valid_594060 = path.getOrDefault("subscriptionId")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "subscriptionId", valid_594060
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594061 = query.getOrDefault("api-version")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "api-version", valid_594061
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_594062 = header.getOrDefault("Cache-Control")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_594062 != nil:
    section.add "Cache-Control", valid_594062
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594063: Call_ManagementGroupSubscriptionsCreate_594056;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Associates existing subscription with the management group.
  ## 
  let valid = call_594063.validator(path, query, header, formData, body)
  let scheme = call_594063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594063.url(scheme.get, call_594063.host, call_594063.base,
                         call_594063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594063, url, valid)

proc call*(call_594064: Call_ManagementGroupSubscriptionsCreate_594056;
          groupId: string; apiVersion: string; subscriptionId: string): Recallable =
  ## managementGroupSubscriptionsCreate
  ## Associates existing subscription with the management group.
  ##   groupId: string (required)
  ##          : Management Group ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID.
  var path_594065 = newJObject()
  var query_594066 = newJObject()
  add(path_594065, "groupId", newJString(groupId))
  add(query_594066, "api-version", newJString(apiVersion))
  add(path_594065, "subscriptionId", newJString(subscriptionId))
  result = call_594064.call(path_594065, query_594066, nil, nil, nil)

var managementGroupSubscriptionsCreate* = Call_ManagementGroupSubscriptionsCreate_594056(
    name: "managementGroupSubscriptionsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/subscriptions/{subscriptionId}",
    validator: validate_ManagementGroupSubscriptionsCreate_594057, base: "",
    url: url_ManagementGroupSubscriptionsCreate_594058, schemes: {Scheme.Https})
type
  Call_ManagementGroupSubscriptionsDelete_594067 = ref object of OpenApiRestCall_593425
proc url_ManagementGroupSubscriptionsDelete_594069(protocol: Scheme; host: string;
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

proc validate_ManagementGroupSubscriptionsDelete_594068(path: JsonNode;
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
  var valid_594070 = path.getOrDefault("groupId")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "groupId", valid_594070
  var valid_594071 = path.getOrDefault("subscriptionId")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "subscriptionId", valid_594071
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594072 = query.getOrDefault("api-version")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "api-version", valid_594072
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_594073 = header.getOrDefault("Cache-Control")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_594073 != nil:
    section.add "Cache-Control", valid_594073
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594074: Call_ManagementGroupSubscriptionsDelete_594067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## De-associates subscription from the management group.
  ## 
  let valid = call_594074.validator(path, query, header, formData, body)
  let scheme = call_594074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594074.url(scheme.get, call_594074.host, call_594074.base,
                         call_594074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594074, url, valid)

proc call*(call_594075: Call_ManagementGroupSubscriptionsDelete_594067;
          groupId: string; apiVersion: string; subscriptionId: string): Recallable =
  ## managementGroupSubscriptionsDelete
  ## De-associates subscription from the management group.
  ##   groupId: string (required)
  ##          : Management Group ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID.
  var path_594076 = newJObject()
  var query_594077 = newJObject()
  add(path_594076, "groupId", newJString(groupId))
  add(query_594077, "api-version", newJString(apiVersion))
  add(path_594076, "subscriptionId", newJString(subscriptionId))
  result = call_594075.call(path_594076, query_594077, nil, nil, nil)

var managementGroupSubscriptionsDelete* = Call_ManagementGroupSubscriptionsDelete_594067(
    name: "managementGroupSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/subscriptions/{subscriptionId}",
    validator: validate_ManagementGroupSubscriptionsDelete_594068, base: "",
    url: url_ManagementGroupSubscriptionsDelete_594069, schemes: {Scheme.Https})
type
  Call_OperationsList_594078 = ref object of OpenApiRestCall_593425
proc url_OperationsList_594080(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_594079(path: JsonNode; query: JsonNode;
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
  var valid_594081 = query.getOrDefault("api-version")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "api-version", valid_594081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594082: Call_OperationsList_594078; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Management REST API operations.
  ## 
  let valid = call_594082.validator(path, query, header, formData, body)
  let scheme = call_594082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594082.url(scheme.get, call_594082.host, call_594082.base,
                         call_594082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594082, url, valid)

proc call*(call_594083: Call_OperationsList_594078; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Management REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  var query_594084 = newJObject()
  add(query_594084, "api-version", newJString(apiVersion))
  result = call_594083.call(nil, query_594084, nil, nil, nil)

var operationsList* = Call_OperationsList_594078(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Management/operations",
    validator: validate_OperationsList_594079, base: "", url: url_OperationsList_594080,
    schemes: {Scheme.Https})
type
  Call_StartTenantBackfill_594085 = ref object of OpenApiRestCall_593425
proc url_StartTenantBackfill_594087(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_StartTenantBackfill_594086(path: JsonNode; query: JsonNode;
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
  var valid_594088 = query.getOrDefault("api-version")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "api-version", valid_594088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594089: Call_StartTenantBackfill_594085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts backfilling subscriptions for the Tenant.
  ## 
  let valid = call_594089.validator(path, query, header, formData, body)
  let scheme = call_594089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594089.url(scheme.get, call_594089.host, call_594089.base,
                         call_594089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594089, url, valid)

proc call*(call_594090: Call_StartTenantBackfill_594085; apiVersion: string): Recallable =
  ## startTenantBackfill
  ## Starts backfilling subscriptions for the Tenant.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  var query_594091 = newJObject()
  add(query_594091, "api-version", newJString(apiVersion))
  result = call_594090.call(nil, query_594091, nil, nil, nil)

var startTenantBackfill* = Call_StartTenantBackfill_594085(
    name: "startTenantBackfill", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/startTenantBackfill",
    validator: validate_StartTenantBackfill_594086, base: "",
    url: url_StartTenantBackfill_594087, schemes: {Scheme.Https})
type
  Call_TenantBackfillStatus_594092 = ref object of OpenApiRestCall_593425
proc url_TenantBackfillStatus_594094(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TenantBackfillStatus_594093(path: JsonNode; query: JsonNode;
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
  var valid_594095 = query.getOrDefault("api-version")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "api-version", valid_594095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594096: Call_TenantBackfillStatus_594092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets tenant backfill status
  ## 
  let valid = call_594096.validator(path, query, header, formData, body)
  let scheme = call_594096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594096.url(scheme.get, call_594096.host, call_594096.base,
                         call_594096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594096, url, valid)

proc call*(call_594097: Call_TenantBackfillStatus_594092; apiVersion: string): Recallable =
  ## tenantBackfillStatus
  ## Gets tenant backfill status
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  var query_594098 = newJObject()
  add(query_594098, "api-version", newJString(apiVersion))
  result = call_594097.call(nil, query_594098, nil, nil, nil)

var tenantBackfillStatus* = Call_TenantBackfillStatus_594092(
    name: "tenantBackfillStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/tenantBackfillStatus",
    validator: validate_TenantBackfillStatus_594093, base: "",
    url: url_TenantBackfillStatus_594094, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
