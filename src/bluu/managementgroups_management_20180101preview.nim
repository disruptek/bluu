
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Management Groups
## version: 2018-01-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Azure Management Groups API enables consolidation of multiple 
## subscriptions/resources into an organizational hierarchy and centrally 
## manage access control, policies, alerting and reporting for those resources.
## 
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
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   $skiptoken: JString
  ##             : Page continuation token is only used if a previous operation returned a partial result. 
  ## If a previous response contains a nextLink element, the value of the nextLink element will include a token parameter that specifies a starting point to use for subsequent calls.
  ## 
  ##   groupName: JString
  ##            : A filter which allows the call to be filtered for a specific group.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568182 = query.getOrDefault("api-version")
  valid_568182 = validateParameter(valid_568182, JString, required = true,
                                 default = nil)
  if valid_568182 != nil:
    section.add "api-version", valid_568182
  var valid_568183 = query.getOrDefault("$skiptoken")
  valid_568183 = validateParameter(valid_568183, JString, required = false,
                                 default = nil)
  if valid_568183 != nil:
    section.add "$skiptoken", valid_568183
  var valid_568184 = query.getOrDefault("groupName")
  valid_568184 = validateParameter(valid_568184, JString, required = false,
                                 default = nil)
  if valid_568184 != nil:
    section.add "groupName", valid_568184
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_568198 = header.getOrDefault("Cache-Control")
  valid_568198 = validateParameter(valid_568198, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_568198 != nil:
    section.add "Cache-Control", valid_568198
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568199: Call_EntitiesList_568178; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all entities (Management Groups, Subscriptions, etc.) for the authenticated user.
  ## 
  ## 
  let valid = call_568199.validator(path, query, header, formData, body)
  let scheme = call_568199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568199.url(scheme.get, call_568199.host, call_568199.base,
                         call_568199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568199, url, valid)

proc call*(call_568200: Call_EntitiesList_568178; apiVersion: string;
          Skiptoken: string = ""; groupName: string = ""): Recallable =
  ## entitiesList
  ## List all entities (Management Groups, Subscriptions, etc.) for the authenticated user.
  ## 
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   Skiptoken: string
  ##            : Page continuation token is only used if a previous operation returned a partial result. 
  ## If a previous response contains a nextLink element, the value of the nextLink element will include a token parameter that specifies a starting point to use for subsequent calls.
  ## 
  ##   groupName: string
  ##            : A filter which allows the call to be filtered for a specific group.
  var query_568201 = newJObject()
  add(query_568201, "api-version", newJString(apiVersion))
  add(query_568201, "$skiptoken", newJString(Skiptoken))
  add(query_568201, "groupName", newJString(groupName))
  result = call_568200.call(nil, query_568201, nil, nil, nil)

var entitiesList* = Call_EntitiesList_568178(name: "entitiesList",
    meth: HttpMethod.HttpPost, host: "management.azure.com",
    route: "/providers/Microsoft.Management/getEntities",
    validator: validate_EntitiesList_568179, base: "", url: url_EntitiesList_568180,
    schemes: {Scheme.Https})
type
  Call_ManagementGroupsList_568202 = ref object of OpenApiRestCall_567658
proc url_ManagementGroupsList_568204(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ManagementGroupsList_568203(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List management groups for the authenticated user.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   $skiptoken: JString
  ##             : Page continuation token is only used if a previous operation returned a partial result. 
  ## If a previous response contains a nextLink element, the value of the nextLink element will include a token parameter that specifies a starting point to use for subsequent calls.
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568205 = query.getOrDefault("api-version")
  valid_568205 = validateParameter(valid_568205, JString, required = true,
                                 default = nil)
  if valid_568205 != nil:
    section.add "api-version", valid_568205
  var valid_568206 = query.getOrDefault("$skiptoken")
  valid_568206 = validateParameter(valid_568206, JString, required = false,
                                 default = nil)
  if valid_568206 != nil:
    section.add "$skiptoken", valid_568206
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_568207 = header.getOrDefault("Cache-Control")
  valid_568207 = validateParameter(valid_568207, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_568207 != nil:
    section.add "Cache-Control", valid_568207
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568208: Call_ManagementGroupsList_568202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List management groups for the authenticated user.
  ## 
  ## 
  let valid = call_568208.validator(path, query, header, formData, body)
  let scheme = call_568208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568208.url(scheme.get, call_568208.host, call_568208.base,
                         call_568208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568208, url, valid)

proc call*(call_568209: Call_ManagementGroupsList_568202; apiVersion: string;
          Skiptoken: string = ""): Recallable =
  ## managementGroupsList
  ## List management groups for the authenticated user.
  ## 
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   Skiptoken: string
  ##            : Page continuation token is only used if a previous operation returned a partial result. 
  ## If a previous response contains a nextLink element, the value of the nextLink element will include a token parameter that specifies a starting point to use for subsequent calls.
  ## 
  var query_568210 = newJObject()
  add(query_568210, "api-version", newJString(apiVersion))
  add(query_568210, "$skiptoken", newJString(Skiptoken))
  result = call_568209.call(nil, query_568210, nil, nil, nil)

var managementGroupsList* = Call_ManagementGroupsList_568202(
    name: "managementGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/managementGroups",
    validator: validate_ManagementGroupsList_568203, base: "",
    url: url_ManagementGroupsList_568204, schemes: {Scheme.Https})
type
  Call_ManagementGroupsCreateOrUpdate_568238 = ref object of OpenApiRestCall_567658
proc url_ManagementGroupsCreateOrUpdate_568240(protocol: Scheme; host: string;
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

proc validate_ManagementGroupsCreateOrUpdate_568239(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a management group.
  ## If a management group is already created and a subsequent create request is issued with different properties, the management group properties will be updated.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Management Group ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_568241 = path.getOrDefault("groupId")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "groupId", valid_568241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568242 = query.getOrDefault("api-version")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "api-version", valid_568242
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_568243 = header.getOrDefault("Cache-Control")
  valid_568243 = validateParameter(valid_568243, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_568243 != nil:
    section.add "Cache-Control", valid_568243
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

proc call*(call_568245: Call_ManagementGroupsCreateOrUpdate_568238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a management group.
  ## If a management group is already created and a subsequent create request is issued with different properties, the management group properties will be updated.
  ## 
  ## 
  let valid = call_568245.validator(path, query, header, formData, body)
  let scheme = call_568245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568245.url(scheme.get, call_568245.host, call_568245.base,
                         call_568245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568245, url, valid)

proc call*(call_568246: Call_ManagementGroupsCreateOrUpdate_568238;
          groupId: string; apiVersion: string;
          createManagementGroupRequest: JsonNode): Recallable =
  ## managementGroupsCreateOrUpdate
  ## Create or update a management group.
  ## If a management group is already created and a subsequent create request is issued with different properties, the management group properties will be updated.
  ## 
  ##   groupId: string (required)
  ##          : Management Group ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   createManagementGroupRequest: JObject (required)
  ##                               : Management group creation parameters.
  var path_568247 = newJObject()
  var query_568248 = newJObject()
  var body_568249 = newJObject()
  add(path_568247, "groupId", newJString(groupId))
  add(query_568248, "api-version", newJString(apiVersion))
  if createManagementGroupRequest != nil:
    body_568249 = createManagementGroupRequest
  result = call_568246.call(path_568247, query_568248, nil, nil, body_568249)

var managementGroupsCreateOrUpdate* = Call_ManagementGroupsCreateOrUpdate_568238(
    name: "managementGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/managementGroups/{groupId}",
    validator: validate_ManagementGroupsCreateOrUpdate_568239, base: "",
    url: url_ManagementGroupsCreateOrUpdate_568240, schemes: {Scheme.Https})
type
  Call_ManagementGroupsGet_568211 = ref object of OpenApiRestCall_567658
proc url_ManagementGroupsGet_568213(protocol: Scheme; host: string; base: string;
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

proc validate_ManagementGroupsGet_568212(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get the details of the management group.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Management Group ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_568228 = path.getOrDefault("groupId")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "groupId", valid_568228
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
  var valid_568229 = query.getOrDefault("api-version")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "api-version", valid_568229
  var valid_568230 = query.getOrDefault("$expand")
  valid_568230 = validateParameter(valid_568230, JString, required = false,
                                 default = newJString("children"))
  if valid_568230 != nil:
    section.add "$expand", valid_568230
  var valid_568231 = query.getOrDefault("$recurse")
  valid_568231 = validateParameter(valid_568231, JBool, required = false, default = nil)
  if valid_568231 != nil:
    section.add "$recurse", valid_568231
  var valid_568232 = query.getOrDefault("$filter")
  valid_568232 = validateParameter(valid_568232, JString, required = false,
                                 default = nil)
  if valid_568232 != nil:
    section.add "$filter", valid_568232
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_568233 = header.getOrDefault("Cache-Control")
  valid_568233 = validateParameter(valid_568233, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_568233 != nil:
    section.add "Cache-Control", valid_568233
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568234: Call_ManagementGroupsGet_568211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of the management group.
  ## 
  ## 
  let valid = call_568234.validator(path, query, header, formData, body)
  let scheme = call_568234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568234.url(scheme.get, call_568234.host, call_568234.base,
                         call_568234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568234, url, valid)

proc call*(call_568235: Call_ManagementGroupsGet_568211; groupId: string;
          apiVersion: string; Expand: string = "children"; Recurse: bool = false;
          Filter: string = ""): Recallable =
  ## managementGroupsGet
  ## Get the details of the management group.
  ## 
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
  var path_568236 = newJObject()
  var query_568237 = newJObject()
  add(path_568236, "groupId", newJString(groupId))
  add(query_568237, "api-version", newJString(apiVersion))
  add(query_568237, "$expand", newJString(Expand))
  add(query_568237, "$recurse", newJBool(Recurse))
  add(query_568237, "$filter", newJString(Filter))
  result = call_568235.call(path_568236, query_568237, nil, nil, nil)

var managementGroupsGet* = Call_ManagementGroupsGet_568211(
    name: "managementGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/managementGroups/{groupId}",
    validator: validate_ManagementGroupsGet_568212, base: "",
    url: url_ManagementGroupsGet_568213, schemes: {Scheme.Https})
type
  Call_ManagementGroupsUpdate_568260 = ref object of OpenApiRestCall_567658
proc url_ManagementGroupsUpdate_568262(protocol: Scheme; host: string; base: string;
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

proc validate_ManagementGroupsUpdate_568261(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a management group.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Management Group ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_568263 = path.getOrDefault("groupId")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "groupId", valid_568263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568264 = query.getOrDefault("api-version")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "api-version", valid_568264
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_568265 = header.getOrDefault("Cache-Control")
  valid_568265 = validateParameter(valid_568265, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_568265 != nil:
    section.add "Cache-Control", valid_568265
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

proc call*(call_568267: Call_ManagementGroupsUpdate_568260; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a management group.
  ## 
  ## 
  let valid = call_568267.validator(path, query, header, formData, body)
  let scheme = call_568267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568267.url(scheme.get, call_568267.host, call_568267.base,
                         call_568267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568267, url, valid)

proc call*(call_568268: Call_ManagementGroupsUpdate_568260; groupId: string;
          apiVersion: string; patchGroupRequest: JsonNode): Recallable =
  ## managementGroupsUpdate
  ## Update a management group.
  ## 
  ##   groupId: string (required)
  ##          : Management Group ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   patchGroupRequest: JObject (required)
  ##                    : Management group patch parameters.
  var path_568269 = newJObject()
  var query_568270 = newJObject()
  var body_568271 = newJObject()
  add(path_568269, "groupId", newJString(groupId))
  add(query_568270, "api-version", newJString(apiVersion))
  if patchGroupRequest != nil:
    body_568271 = patchGroupRequest
  result = call_568268.call(path_568269, query_568270, nil, nil, body_568271)

var managementGroupsUpdate* = Call_ManagementGroupsUpdate_568260(
    name: "managementGroupsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/managementGroups/{groupId}",
    validator: validate_ManagementGroupsUpdate_568261, base: "",
    url: url_ManagementGroupsUpdate_568262, schemes: {Scheme.Https})
type
  Call_ManagementGroupsDelete_568250 = ref object of OpenApiRestCall_567658
proc url_ManagementGroupsDelete_568252(protocol: Scheme; host: string; base: string;
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

proc validate_ManagementGroupsDelete_568251(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete management group.
  ## If a management group contains child resources, the request will fail.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupId: JString (required)
  ##          : Management Group ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupId` field"
  var valid_568253 = path.getOrDefault("groupId")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "groupId", valid_568253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568254 = query.getOrDefault("api-version")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "api-version", valid_568254
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_568255 = header.getOrDefault("Cache-Control")
  valid_568255 = validateParameter(valid_568255, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_568255 != nil:
    section.add "Cache-Control", valid_568255
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568256: Call_ManagementGroupsDelete_568250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete management group.
  ## If a management group contains child resources, the request will fail.
  ## 
  ## 
  let valid = call_568256.validator(path, query, header, formData, body)
  let scheme = call_568256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568256.url(scheme.get, call_568256.host, call_568256.base,
                         call_568256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568256, url, valid)

proc call*(call_568257: Call_ManagementGroupsDelete_568250; groupId: string;
          apiVersion: string): Recallable =
  ## managementGroupsDelete
  ## Delete management group.
  ## If a management group contains child resources, the request will fail.
  ## 
  ##   groupId: string (required)
  ##          : Management Group ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  var path_568258 = newJObject()
  var query_568259 = newJObject()
  add(path_568258, "groupId", newJString(groupId))
  add(query_568259, "api-version", newJString(apiVersion))
  result = call_568257.call(path_568258, query_568259, nil, nil, nil)

var managementGroupsDelete* = Call_ManagementGroupsDelete_568250(
    name: "managementGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/managementGroups/{groupId}",
    validator: validate_ManagementGroupsDelete_568251, base: "",
    url: url_ManagementGroupsDelete_568252, schemes: {Scheme.Https})
type
  Call_ManagementGroupSubscriptionsCreate_568272 = ref object of OpenApiRestCall_567658
proc url_ManagementGroupSubscriptionsCreate_568274(protocol: Scheme; host: string;
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

proc validate_ManagementGroupSubscriptionsCreate_568273(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Associates existing subscription with the management group.
  ## 
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
  var valid_568275 = path.getOrDefault("groupId")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "groupId", valid_568275
  var valid_568276 = path.getOrDefault("subscriptionId")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "subscriptionId", valid_568276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568277 = query.getOrDefault("api-version")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "api-version", valid_568277
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_568278 = header.getOrDefault("Cache-Control")
  valid_568278 = validateParameter(valid_568278, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_568278 != nil:
    section.add "Cache-Control", valid_568278
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568279: Call_ManagementGroupSubscriptionsCreate_568272;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Associates existing subscription with the management group.
  ## 
  ## 
  let valid = call_568279.validator(path, query, header, formData, body)
  let scheme = call_568279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568279.url(scheme.get, call_568279.host, call_568279.base,
                         call_568279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568279, url, valid)

proc call*(call_568280: Call_ManagementGroupSubscriptionsCreate_568272;
          groupId: string; apiVersion: string; subscriptionId: string): Recallable =
  ## managementGroupSubscriptionsCreate
  ## Associates existing subscription with the management group.
  ## 
  ##   groupId: string (required)
  ##          : Management Group ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID.
  var path_568281 = newJObject()
  var query_568282 = newJObject()
  add(path_568281, "groupId", newJString(groupId))
  add(query_568282, "api-version", newJString(apiVersion))
  add(path_568281, "subscriptionId", newJString(subscriptionId))
  result = call_568280.call(path_568281, query_568282, nil, nil, nil)

var managementGroupSubscriptionsCreate* = Call_ManagementGroupSubscriptionsCreate_568272(
    name: "managementGroupSubscriptionsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/subscriptions/{subscriptionId}",
    validator: validate_ManagementGroupSubscriptionsCreate_568273, base: "",
    url: url_ManagementGroupSubscriptionsCreate_568274, schemes: {Scheme.Https})
type
  Call_ManagementGroupSubscriptionsDelete_568283 = ref object of OpenApiRestCall_567658
proc url_ManagementGroupSubscriptionsDelete_568285(protocol: Scheme; host: string;
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

proc validate_ManagementGroupSubscriptionsDelete_568284(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## De-associates subscription from the management group.
  ## 
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
  var valid_568286 = path.getOrDefault("groupId")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "groupId", valid_568286
  var valid_568287 = path.getOrDefault("subscriptionId")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "subscriptionId", valid_568287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568288 = query.getOrDefault("api-version")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "api-version", valid_568288
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_568289 = header.getOrDefault("Cache-Control")
  valid_568289 = validateParameter(valid_568289, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_568289 != nil:
    section.add "Cache-Control", valid_568289
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568290: Call_ManagementGroupSubscriptionsDelete_568283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## De-associates subscription from the management group.
  ## 
  ## 
  let valid = call_568290.validator(path, query, header, formData, body)
  let scheme = call_568290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568290.url(scheme.get, call_568290.host, call_568290.base,
                         call_568290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568290, url, valid)

proc call*(call_568291: Call_ManagementGroupSubscriptionsDelete_568283;
          groupId: string; apiVersion: string; subscriptionId: string): Recallable =
  ## managementGroupSubscriptionsDelete
  ## De-associates subscription from the management group.
  ## 
  ##   groupId: string (required)
  ##          : Management Group ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID.
  var path_568292 = newJObject()
  var query_568293 = newJObject()
  add(path_568292, "groupId", newJString(groupId))
  add(query_568293, "api-version", newJString(apiVersion))
  add(path_568292, "subscriptionId", newJString(subscriptionId))
  result = call_568291.call(path_568292, query_568293, nil, nil, nil)

var managementGroupSubscriptionsDelete* = Call_ManagementGroupSubscriptionsDelete_568283(
    name: "managementGroupSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/subscriptions/{subscriptionId}",
    validator: validate_ManagementGroupSubscriptionsDelete_568284, base: "",
    url: url_ManagementGroupSubscriptionsDelete_568285, schemes: {Scheme.Https})
type
  Call_OperationsList_568294 = ref object of OpenApiRestCall_567658
proc url_OperationsList_568296(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_568295(path: JsonNode; query: JsonNode;
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
  var valid_568297 = query.getOrDefault("api-version")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "api-version", valid_568297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568298: Call_OperationsList_568294; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Management REST API operations.
  ## 
  let valid = call_568298.validator(path, query, header, formData, body)
  let scheme = call_568298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568298.url(scheme.get, call_568298.host, call_568298.base,
                         call_568298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568298, url, valid)

proc call*(call_568299: Call_OperationsList_568294; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Management REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  var query_568300 = newJObject()
  add(query_568300, "api-version", newJString(apiVersion))
  result = call_568299.call(nil, query_568300, nil, nil, nil)

var operationsList* = Call_OperationsList_568294(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Management/operations",
    validator: validate_OperationsList_568295, base: "", url: url_OperationsList_568296,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
