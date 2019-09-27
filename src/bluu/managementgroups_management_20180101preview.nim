
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  var valid_593949 = query.getOrDefault("api-version")
  valid_593949 = validateParameter(valid_593949, JString, required = true,
                                 default = nil)
  if valid_593949 != nil:
    section.add "api-version", valid_593949
  var valid_593950 = query.getOrDefault("$skiptoken")
  valid_593950 = validateParameter(valid_593950, JString, required = false,
                                 default = nil)
  if valid_593950 != nil:
    section.add "$skiptoken", valid_593950
  var valid_593951 = query.getOrDefault("groupName")
  valid_593951 = validateParameter(valid_593951, JString, required = false,
                                 default = nil)
  if valid_593951 != nil:
    section.add "groupName", valid_593951
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_593965 = header.getOrDefault("Cache-Control")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_593965 != nil:
    section.add "Cache-Control", valid_593965
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593966: Call_EntitiesList_593945; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all entities (Management Groups, Subscriptions, etc.) for the authenticated user.
  ## 
  ## 
  let valid = call_593966.validator(path, query, header, formData, body)
  let scheme = call_593966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593966.url(scheme.get, call_593966.host, call_593966.base,
                         call_593966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593966, url, valid)

proc call*(call_593967: Call_EntitiesList_593945; apiVersion: string;
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
  var query_593968 = newJObject()
  add(query_593968, "api-version", newJString(apiVersion))
  add(query_593968, "$skiptoken", newJString(Skiptoken))
  add(query_593968, "groupName", newJString(groupName))
  result = call_593967.call(nil, query_593968, nil, nil, nil)

var entitiesList* = Call_EntitiesList_593945(name: "entitiesList",
    meth: HttpMethod.HttpPost, host: "management.azure.com",
    route: "/providers/Microsoft.Management/getEntities",
    validator: validate_EntitiesList_593946, base: "", url: url_EntitiesList_593947,
    schemes: {Scheme.Https})
type
  Call_ManagementGroupsList_593969 = ref object of OpenApiRestCall_593425
proc url_ManagementGroupsList_593971(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ManagementGroupsList_593970(path: JsonNode; query: JsonNode;
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
  var valid_593972 = query.getOrDefault("api-version")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "api-version", valid_593972
  var valid_593973 = query.getOrDefault("$skiptoken")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "$skiptoken", valid_593973
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_593974 = header.getOrDefault("Cache-Control")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_593974 != nil:
    section.add "Cache-Control", valid_593974
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593975: Call_ManagementGroupsList_593969; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List management groups for the authenticated user.
  ## 
  ## 
  let valid = call_593975.validator(path, query, header, formData, body)
  let scheme = call_593975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593975.url(scheme.get, call_593975.host, call_593975.base,
                         call_593975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593975, url, valid)

proc call*(call_593976: Call_ManagementGroupsList_593969; apiVersion: string;
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
  var query_593977 = newJObject()
  add(query_593977, "api-version", newJString(apiVersion))
  add(query_593977, "$skiptoken", newJString(Skiptoken))
  result = call_593976.call(nil, query_593977, nil, nil, nil)

var managementGroupsList* = Call_ManagementGroupsList_593969(
    name: "managementGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/managementGroups",
    validator: validate_ManagementGroupsList_593970, base: "",
    url: url_ManagementGroupsList_593971, schemes: {Scheme.Https})
type
  Call_ManagementGroupsCreateOrUpdate_594005 = ref object of OpenApiRestCall_593425
proc url_ManagementGroupsCreateOrUpdate_594007(protocol: Scheme; host: string;
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

proc validate_ManagementGroupsCreateOrUpdate_594006(path: JsonNode;
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
  var valid_594008 = path.getOrDefault("groupId")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "groupId", valid_594008
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594009 = query.getOrDefault("api-version")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "api-version", valid_594009
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_594010 = header.getOrDefault("Cache-Control")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_594010 != nil:
    section.add "Cache-Control", valid_594010
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

proc call*(call_594012: Call_ManagementGroupsCreateOrUpdate_594005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a management group.
  ## If a management group is already created and a subsequent create request is issued with different properties, the management group properties will be updated.
  ## 
  ## 
  let valid = call_594012.validator(path, query, header, formData, body)
  let scheme = call_594012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594012.url(scheme.get, call_594012.host, call_594012.base,
                         call_594012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594012, url, valid)

proc call*(call_594013: Call_ManagementGroupsCreateOrUpdate_594005;
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
  var path_594014 = newJObject()
  var query_594015 = newJObject()
  var body_594016 = newJObject()
  add(path_594014, "groupId", newJString(groupId))
  add(query_594015, "api-version", newJString(apiVersion))
  if createManagementGroupRequest != nil:
    body_594016 = createManagementGroupRequest
  result = call_594013.call(path_594014, query_594015, nil, nil, body_594016)

var managementGroupsCreateOrUpdate* = Call_ManagementGroupsCreateOrUpdate_594005(
    name: "managementGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/managementGroups/{groupId}",
    validator: validate_ManagementGroupsCreateOrUpdate_594006, base: "",
    url: url_ManagementGroupsCreateOrUpdate_594007, schemes: {Scheme.Https})
type
  Call_ManagementGroupsGet_593978 = ref object of OpenApiRestCall_593425
proc url_ManagementGroupsGet_593980(protocol: Scheme; host: string; base: string;
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

proc validate_ManagementGroupsGet_593979(path: JsonNode; query: JsonNode;
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
  var valid_593995 = path.getOrDefault("groupId")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "groupId", valid_593995
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
  var valid_593996 = query.getOrDefault("api-version")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "api-version", valid_593996
  var valid_593997 = query.getOrDefault("$expand")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = newJString("children"))
  if valid_593997 != nil:
    section.add "$expand", valid_593997
  var valid_593998 = query.getOrDefault("$recurse")
  valid_593998 = validateParameter(valid_593998, JBool, required = false, default = nil)
  if valid_593998 != nil:
    section.add "$recurse", valid_593998
  var valid_593999 = query.getOrDefault("$filter")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "$filter", valid_593999
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_594000 = header.getOrDefault("Cache-Control")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_594000 != nil:
    section.add "Cache-Control", valid_594000
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594001: Call_ManagementGroupsGet_593978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of the management group.
  ## 
  ## 
  let valid = call_594001.validator(path, query, header, formData, body)
  let scheme = call_594001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594001.url(scheme.get, call_594001.host, call_594001.base,
                         call_594001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594001, url, valid)

proc call*(call_594002: Call_ManagementGroupsGet_593978; groupId: string;
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
  var path_594003 = newJObject()
  var query_594004 = newJObject()
  add(path_594003, "groupId", newJString(groupId))
  add(query_594004, "api-version", newJString(apiVersion))
  add(query_594004, "$expand", newJString(Expand))
  add(query_594004, "$recurse", newJBool(Recurse))
  add(query_594004, "$filter", newJString(Filter))
  result = call_594002.call(path_594003, query_594004, nil, nil, nil)

var managementGroupsGet* = Call_ManagementGroupsGet_593978(
    name: "managementGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/managementGroups/{groupId}",
    validator: validate_ManagementGroupsGet_593979, base: "",
    url: url_ManagementGroupsGet_593980, schemes: {Scheme.Https})
type
  Call_ManagementGroupsUpdate_594027 = ref object of OpenApiRestCall_593425
proc url_ManagementGroupsUpdate_594029(protocol: Scheme; host: string; base: string;
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

proc validate_ManagementGroupsUpdate_594028(path: JsonNode; query: JsonNode;
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
  var valid_594030 = path.getOrDefault("groupId")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "groupId", valid_594030
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594031 = query.getOrDefault("api-version")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "api-version", valid_594031
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_594032 = header.getOrDefault("Cache-Control")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_594032 != nil:
    section.add "Cache-Control", valid_594032
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

proc call*(call_594034: Call_ManagementGroupsUpdate_594027; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a management group.
  ## 
  ## 
  let valid = call_594034.validator(path, query, header, formData, body)
  let scheme = call_594034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594034.url(scheme.get, call_594034.host, call_594034.base,
                         call_594034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594034, url, valid)

proc call*(call_594035: Call_ManagementGroupsUpdate_594027; groupId: string;
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
  var path_594036 = newJObject()
  var query_594037 = newJObject()
  var body_594038 = newJObject()
  add(path_594036, "groupId", newJString(groupId))
  add(query_594037, "api-version", newJString(apiVersion))
  if patchGroupRequest != nil:
    body_594038 = patchGroupRequest
  result = call_594035.call(path_594036, query_594037, nil, nil, body_594038)

var managementGroupsUpdate* = Call_ManagementGroupsUpdate_594027(
    name: "managementGroupsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/managementGroups/{groupId}",
    validator: validate_ManagementGroupsUpdate_594028, base: "",
    url: url_ManagementGroupsUpdate_594029, schemes: {Scheme.Https})
type
  Call_ManagementGroupsDelete_594017 = ref object of OpenApiRestCall_593425
proc url_ManagementGroupsDelete_594019(protocol: Scheme; host: string; base: string;
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

proc validate_ManagementGroupsDelete_594018(path: JsonNode; query: JsonNode;
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
  var valid_594020 = path.getOrDefault("groupId")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "groupId", valid_594020
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594021 = query.getOrDefault("api-version")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "api-version", valid_594021
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_594022 = header.getOrDefault("Cache-Control")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_594022 != nil:
    section.add "Cache-Control", valid_594022
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594023: Call_ManagementGroupsDelete_594017; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete management group.
  ## If a management group contains child resources, the request will fail.
  ## 
  ## 
  let valid = call_594023.validator(path, query, header, formData, body)
  let scheme = call_594023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594023.url(scheme.get, call_594023.host, call_594023.base,
                         call_594023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594023, url, valid)

proc call*(call_594024: Call_ManagementGroupsDelete_594017; groupId: string;
          apiVersion: string): Recallable =
  ## managementGroupsDelete
  ## Delete management group.
  ## If a management group contains child resources, the request will fail.
  ## 
  ##   groupId: string (required)
  ##          : Management Group ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  var path_594025 = newJObject()
  var query_594026 = newJObject()
  add(path_594025, "groupId", newJString(groupId))
  add(query_594026, "api-version", newJString(apiVersion))
  result = call_594024.call(path_594025, query_594026, nil, nil, nil)

var managementGroupsDelete* = Call_ManagementGroupsDelete_594017(
    name: "managementGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/managementGroups/{groupId}",
    validator: validate_ManagementGroupsDelete_594018, base: "",
    url: url_ManagementGroupsDelete_594019, schemes: {Scheme.Https})
type
  Call_ManagementGroupSubscriptionsCreate_594039 = ref object of OpenApiRestCall_593425
proc url_ManagementGroupSubscriptionsCreate_594041(protocol: Scheme; host: string;
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

proc validate_ManagementGroupSubscriptionsCreate_594040(path: JsonNode;
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
  var valid_594042 = path.getOrDefault("groupId")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "groupId", valid_594042
  var valid_594043 = path.getOrDefault("subscriptionId")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "subscriptionId", valid_594043
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594044 = query.getOrDefault("api-version")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "api-version", valid_594044
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_594045 = header.getOrDefault("Cache-Control")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_594045 != nil:
    section.add "Cache-Control", valid_594045
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594046: Call_ManagementGroupSubscriptionsCreate_594039;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Associates existing subscription with the management group.
  ## 
  ## 
  let valid = call_594046.validator(path, query, header, formData, body)
  let scheme = call_594046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594046.url(scheme.get, call_594046.host, call_594046.base,
                         call_594046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594046, url, valid)

proc call*(call_594047: Call_ManagementGroupSubscriptionsCreate_594039;
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
  var path_594048 = newJObject()
  var query_594049 = newJObject()
  add(path_594048, "groupId", newJString(groupId))
  add(query_594049, "api-version", newJString(apiVersion))
  add(path_594048, "subscriptionId", newJString(subscriptionId))
  result = call_594047.call(path_594048, query_594049, nil, nil, nil)

var managementGroupSubscriptionsCreate* = Call_ManagementGroupSubscriptionsCreate_594039(
    name: "managementGroupSubscriptionsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/subscriptions/{subscriptionId}",
    validator: validate_ManagementGroupSubscriptionsCreate_594040, base: "",
    url: url_ManagementGroupSubscriptionsCreate_594041, schemes: {Scheme.Https})
type
  Call_ManagementGroupSubscriptionsDelete_594050 = ref object of OpenApiRestCall_593425
proc url_ManagementGroupSubscriptionsDelete_594052(protocol: Scheme; host: string;
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

proc validate_ManagementGroupSubscriptionsDelete_594051(path: JsonNode;
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
  var valid_594053 = path.getOrDefault("groupId")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "groupId", valid_594053
  var valid_594054 = path.getOrDefault("subscriptionId")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "subscriptionId", valid_594054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594055 = query.getOrDefault("api-version")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "api-version", valid_594055
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_594056 = header.getOrDefault("Cache-Control")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_594056 != nil:
    section.add "Cache-Control", valid_594056
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594057: Call_ManagementGroupSubscriptionsDelete_594050;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## De-associates subscription from the management group.
  ## 
  ## 
  let valid = call_594057.validator(path, query, header, formData, body)
  let scheme = call_594057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594057.url(scheme.get, call_594057.host, call_594057.base,
                         call_594057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594057, url, valid)

proc call*(call_594058: Call_ManagementGroupSubscriptionsDelete_594050;
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
  var path_594059 = newJObject()
  var query_594060 = newJObject()
  add(path_594059, "groupId", newJString(groupId))
  add(query_594060, "api-version", newJString(apiVersion))
  add(path_594059, "subscriptionId", newJString(subscriptionId))
  result = call_594058.call(path_594059, query_594060, nil, nil, nil)

var managementGroupSubscriptionsDelete* = Call_ManagementGroupSubscriptionsDelete_594050(
    name: "managementGroupSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/subscriptions/{subscriptionId}",
    validator: validate_ManagementGroupSubscriptionsDelete_594051, base: "",
    url: url_ManagementGroupSubscriptionsDelete_594052, schemes: {Scheme.Https})
type
  Call_OperationsList_594061 = ref object of OpenApiRestCall_593425
proc url_OperationsList_594063(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_594062(path: JsonNode; query: JsonNode;
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
  var valid_594064 = query.getOrDefault("api-version")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "api-version", valid_594064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594065: Call_OperationsList_594061; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Management REST API operations.
  ## 
  let valid = call_594065.validator(path, query, header, formData, body)
  let scheme = call_594065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594065.url(scheme.get, call_594065.host, call_594065.base,
                         call_594065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594065, url, valid)

proc call*(call_594066: Call_OperationsList_594061; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Management REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2018-01-01-preview.
  var query_594067 = newJObject()
  add(query_594067, "api-version", newJString(apiVersion))
  result = call_594066.call(nil, query_594067, nil, nil, nil)

var operationsList* = Call_OperationsList_594061(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Management/operations",
    validator: validate_OperationsList_594062, base: "", url: url_OperationsList_594063,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
