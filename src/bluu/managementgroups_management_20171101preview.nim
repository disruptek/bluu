
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Management Groups
## version: 2017-11-01-preview
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
  Call_ManagementGroupsList_567880 = ref object of OpenApiRestCall_567658
proc url_ManagementGroupsList_567882(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ManagementGroupsList_567881(path: JsonNode; query: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2017-11-01-preview.
  ##   $skiptoken: JString
  ##             : Page continuation token is only used if a previous operation returned a partial result. 
  ## If a previous response contains a nextLink element, the value of the nextLink element will include a token parameter that specifies a starting point to use for subsequent calls.
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568042 = query.getOrDefault("api-version")
  valid_568042 = validateParameter(valid_568042, JString, required = true,
                                 default = nil)
  if valid_568042 != nil:
    section.add "api-version", valid_568042
  var valid_568043 = query.getOrDefault("$skiptoken")
  valid_568043 = validateParameter(valid_568043, JString, required = false,
                                 default = nil)
  if valid_568043 != nil:
    section.add "$skiptoken", valid_568043
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_568057 = header.getOrDefault("Cache-Control")
  valid_568057 = validateParameter(valid_568057, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_568057 != nil:
    section.add "Cache-Control", valid_568057
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568080: Call_ManagementGroupsList_567880; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List management groups for the authenticated user.
  ## 
  ## 
  let valid = call_568080.validator(path, query, header, formData, body)
  let scheme = call_568080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568080.url(scheme.get, call_568080.host, call_568080.base,
                         call_568080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568080, url, valid)

proc call*(call_568151: Call_ManagementGroupsList_567880; apiVersion: string;
          Skiptoken: string = ""): Recallable =
  ## managementGroupsList
  ## List management groups for the authenticated user.
  ## 
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2017-11-01-preview.
  ##   Skiptoken: string
  ##            : Page continuation token is only used if a previous operation returned a partial result. 
  ## If a previous response contains a nextLink element, the value of the nextLink element will include a token parameter that specifies a starting point to use for subsequent calls.
  ## 
  var query_568152 = newJObject()
  add(query_568152, "api-version", newJString(apiVersion))
  add(query_568152, "$skiptoken", newJString(Skiptoken))
  result = call_568151.call(nil, query_568152, nil, nil, nil)

var managementGroupsList* = Call_ManagementGroupsList_567880(
    name: "managementGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/managementGroups",
    validator: validate_ManagementGroupsList_567881, base: "",
    url: url_ManagementGroupsList_567882, schemes: {Scheme.Https})
type
  Call_ManagementGroupsCreateOrUpdate_568218 = ref object of OpenApiRestCall_567658
proc url_ManagementGroupsCreateOrUpdate_568220(protocol: Scheme; host: string;
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

proc validate_ManagementGroupsCreateOrUpdate_568219(path: JsonNode;
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
  var valid_568221 = path.getOrDefault("groupId")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "groupId", valid_568221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2017-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568222 = query.getOrDefault("api-version")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "api-version", valid_568222
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_568223 = header.getOrDefault("Cache-Control")
  valid_568223 = validateParameter(valid_568223, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_568223 != nil:
    section.add "Cache-Control", valid_568223
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

proc call*(call_568225: Call_ManagementGroupsCreateOrUpdate_568218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a management group.
  ## If a management group is already created and a subsequent create request is issued with different properties, the management group properties will be updated.
  ## 
  ## 
  let valid = call_568225.validator(path, query, header, formData, body)
  let scheme = call_568225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568225.url(scheme.get, call_568225.host, call_568225.base,
                         call_568225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568225, url, valid)

proc call*(call_568226: Call_ManagementGroupsCreateOrUpdate_568218;
          groupId: string; apiVersion: string;
          createManagementGroupRequest: JsonNode): Recallable =
  ## managementGroupsCreateOrUpdate
  ## Create or update a management group.
  ## If a management group is already created and a subsequent create request is issued with different properties, the management group properties will be updated.
  ## 
  ##   groupId: string (required)
  ##          : Management Group ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2017-11-01-preview.
  ##   createManagementGroupRequest: JObject (required)
  ##                               : Management group creation parameters.
  var path_568227 = newJObject()
  var query_568228 = newJObject()
  var body_568229 = newJObject()
  add(path_568227, "groupId", newJString(groupId))
  add(query_568228, "api-version", newJString(apiVersion))
  if createManagementGroupRequest != nil:
    body_568229 = createManagementGroupRequest
  result = call_568226.call(path_568227, query_568228, nil, nil, body_568229)

var managementGroupsCreateOrUpdate* = Call_ManagementGroupsCreateOrUpdate_568218(
    name: "managementGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/managementGroups/{groupId}",
    validator: validate_ManagementGroupsCreateOrUpdate_568219, base: "",
    url: url_ManagementGroupsCreateOrUpdate_568220, schemes: {Scheme.Https})
type
  Call_ManagementGroupsGet_568192 = ref object of OpenApiRestCall_567658
proc url_ManagementGroupsGet_568194(protocol: Scheme; host: string; base: string;
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

proc validate_ManagementGroupsGet_568193(path: JsonNode; query: JsonNode;
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
  var valid_568209 = path.getOrDefault("groupId")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "groupId", valid_568209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2017-11-01-preview.
  ##   $expand: JString
  ##          : The $expand=children query string parameter allows clients to request inclusion of children in the response payload.
  ##   $recurse: JBool
  ##           : The $recurse=true query string parameter allows clients to request inclusion of entire hierarchy in the response payload.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568210 = query.getOrDefault("api-version")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "api-version", valid_568210
  var valid_568211 = query.getOrDefault("$expand")
  valid_568211 = validateParameter(valid_568211, JString, required = false,
                                 default = newJString("children"))
  if valid_568211 != nil:
    section.add "$expand", valid_568211
  var valid_568212 = query.getOrDefault("$recurse")
  valid_568212 = validateParameter(valid_568212, JBool, required = false, default = nil)
  if valid_568212 != nil:
    section.add "$recurse", valid_568212
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

proc call*(call_568214: Call_ManagementGroupsGet_568192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the details of the management group.
  ## 
  ## 
  let valid = call_568214.validator(path, query, header, formData, body)
  let scheme = call_568214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568214.url(scheme.get, call_568214.host, call_568214.base,
                         call_568214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568214, url, valid)

proc call*(call_568215: Call_ManagementGroupsGet_568192; groupId: string;
          apiVersion: string; Expand: string = "children"; Recurse: bool = false): Recallable =
  ## managementGroupsGet
  ## Get the details of the management group.
  ## 
  ##   groupId: string (required)
  ##          : Management Group ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2017-11-01-preview.
  ##   Expand: string
  ##         : The $expand=children query string parameter allows clients to request inclusion of children in the response payload.
  ##   Recurse: bool
  ##          : The $recurse=true query string parameter allows clients to request inclusion of entire hierarchy in the response payload.
  var path_568216 = newJObject()
  var query_568217 = newJObject()
  add(path_568216, "groupId", newJString(groupId))
  add(query_568217, "api-version", newJString(apiVersion))
  add(query_568217, "$expand", newJString(Expand))
  add(query_568217, "$recurse", newJBool(Recurse))
  result = call_568215.call(path_568216, query_568217, nil, nil, nil)

var managementGroupsGet* = Call_ManagementGroupsGet_568192(
    name: "managementGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/managementGroups/{groupId}",
    validator: validate_ManagementGroupsGet_568193, base: "",
    url: url_ManagementGroupsGet_568194, schemes: {Scheme.Https})
type
  Call_ManagementGroupsUpdate_568240 = ref object of OpenApiRestCall_567658
proc url_ManagementGroupsUpdate_568242(protocol: Scheme; host: string; base: string;
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

proc validate_ManagementGroupsUpdate_568241(path: JsonNode; query: JsonNode;
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
  var valid_568243 = path.getOrDefault("groupId")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "groupId", valid_568243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2017-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568244 = query.getOrDefault("api-version")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "api-version", valid_568244
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_568245 = header.getOrDefault("Cache-Control")
  valid_568245 = validateParameter(valid_568245, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_568245 != nil:
    section.add "Cache-Control", valid_568245
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

proc call*(call_568247: Call_ManagementGroupsUpdate_568240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a management group.
  ## 
  ## 
  let valid = call_568247.validator(path, query, header, formData, body)
  let scheme = call_568247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568247.url(scheme.get, call_568247.host, call_568247.base,
                         call_568247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568247, url, valid)

proc call*(call_568248: Call_ManagementGroupsUpdate_568240; groupId: string;
          apiVersion: string; createManagementGroupRequest: JsonNode): Recallable =
  ## managementGroupsUpdate
  ## Update a management group.
  ## 
  ##   groupId: string (required)
  ##          : Management Group ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2017-11-01-preview.
  ##   createManagementGroupRequest: JObject (required)
  ##                               : Management group creation parameters.
  var path_568249 = newJObject()
  var query_568250 = newJObject()
  var body_568251 = newJObject()
  add(path_568249, "groupId", newJString(groupId))
  add(query_568250, "api-version", newJString(apiVersion))
  if createManagementGroupRequest != nil:
    body_568251 = createManagementGroupRequest
  result = call_568248.call(path_568249, query_568250, nil, nil, body_568251)

var managementGroupsUpdate* = Call_ManagementGroupsUpdate_568240(
    name: "managementGroupsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/managementGroups/{groupId}",
    validator: validate_ManagementGroupsUpdate_568241, base: "",
    url: url_ManagementGroupsUpdate_568242, schemes: {Scheme.Https})
type
  Call_ManagementGroupsDelete_568230 = ref object of OpenApiRestCall_567658
proc url_ManagementGroupsDelete_568232(protocol: Scheme; host: string; base: string;
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

proc validate_ManagementGroupsDelete_568231(path: JsonNode; query: JsonNode;
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
  var valid_568233 = path.getOrDefault("groupId")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "groupId", valid_568233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2017-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568234 = query.getOrDefault("api-version")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "api-version", valid_568234
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_568235 = header.getOrDefault("Cache-Control")
  valid_568235 = validateParameter(valid_568235, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_568235 != nil:
    section.add "Cache-Control", valid_568235
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568236: Call_ManagementGroupsDelete_568230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete management group.
  ## If a management group contains child resources, the request will fail.
  ## 
  ## 
  let valid = call_568236.validator(path, query, header, formData, body)
  let scheme = call_568236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568236.url(scheme.get, call_568236.host, call_568236.base,
                         call_568236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568236, url, valid)

proc call*(call_568237: Call_ManagementGroupsDelete_568230; groupId: string;
          apiVersion: string): Recallable =
  ## managementGroupsDelete
  ## Delete management group.
  ## If a management group contains child resources, the request will fail.
  ## 
  ##   groupId: string (required)
  ##          : Management Group ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2017-11-01-preview.
  var path_568238 = newJObject()
  var query_568239 = newJObject()
  add(path_568238, "groupId", newJString(groupId))
  add(query_568239, "api-version", newJString(apiVersion))
  result = call_568237.call(path_568238, query_568239, nil, nil, nil)

var managementGroupsDelete* = Call_ManagementGroupsDelete_568230(
    name: "managementGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com",
    route: "/providers/Microsoft.Management/managementGroups/{groupId}",
    validator: validate_ManagementGroupsDelete_568231, base: "",
    url: url_ManagementGroupsDelete_568232, schemes: {Scheme.Https})
type
  Call_ManagementGroupSubscriptionsCreate_568252 = ref object of OpenApiRestCall_567658
proc url_ManagementGroupSubscriptionsCreate_568254(protocol: Scheme; host: string;
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

proc validate_ManagementGroupSubscriptionsCreate_568253(path: JsonNode;
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
  var valid_568255 = path.getOrDefault("groupId")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "groupId", valid_568255
  var valid_568256 = path.getOrDefault("subscriptionId")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "subscriptionId", valid_568256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2017-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568257 = query.getOrDefault("api-version")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "api-version", valid_568257
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_568258 = header.getOrDefault("Cache-Control")
  valid_568258 = validateParameter(valid_568258, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_568258 != nil:
    section.add "Cache-Control", valid_568258
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568259: Call_ManagementGroupSubscriptionsCreate_568252;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Associates existing subscription with the management group.
  ## 
  ## 
  let valid = call_568259.validator(path, query, header, formData, body)
  let scheme = call_568259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568259.url(scheme.get, call_568259.host, call_568259.base,
                         call_568259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568259, url, valid)

proc call*(call_568260: Call_ManagementGroupSubscriptionsCreate_568252;
          groupId: string; apiVersion: string; subscriptionId: string): Recallable =
  ## managementGroupSubscriptionsCreate
  ## Associates existing subscription with the management group.
  ## 
  ##   groupId: string (required)
  ##          : Management Group ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2017-11-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID.
  var path_568261 = newJObject()
  var query_568262 = newJObject()
  add(path_568261, "groupId", newJString(groupId))
  add(query_568262, "api-version", newJString(apiVersion))
  add(path_568261, "subscriptionId", newJString(subscriptionId))
  result = call_568260.call(path_568261, query_568262, nil, nil, nil)

var managementGroupSubscriptionsCreate* = Call_ManagementGroupSubscriptionsCreate_568252(
    name: "managementGroupSubscriptionsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/subscriptions/{subscriptionId}",
    validator: validate_ManagementGroupSubscriptionsCreate_568253, base: "",
    url: url_ManagementGroupSubscriptionsCreate_568254, schemes: {Scheme.Https})
type
  Call_ManagementGroupSubscriptionsDelete_568263 = ref object of OpenApiRestCall_567658
proc url_ManagementGroupSubscriptionsDelete_568265(protocol: Scheme; host: string;
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

proc validate_ManagementGroupSubscriptionsDelete_568264(path: JsonNode;
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
  var valid_568266 = path.getOrDefault("groupId")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "groupId", valid_568266
  var valid_568267 = path.getOrDefault("subscriptionId")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "subscriptionId", valid_568267
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. The current version is 2017-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568268 = query.getOrDefault("api-version")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "api-version", valid_568268
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Indicates that the request shouldn't utilize any caches.
  section = newJObject()
  var valid_568269 = header.getOrDefault("Cache-Control")
  valid_568269 = validateParameter(valid_568269, JString, required = false,
                                 default = newJString("no-cache"))
  if valid_568269 != nil:
    section.add "Cache-Control", valid_568269
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568270: Call_ManagementGroupSubscriptionsDelete_568263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## De-associates subscription from the management group.
  ## 
  ## 
  let valid = call_568270.validator(path, query, header, formData, body)
  let scheme = call_568270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568270.url(scheme.get, call_568270.host, call_568270.base,
                         call_568270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568270, url, valid)

proc call*(call_568271: Call_ManagementGroupSubscriptionsDelete_568263;
          groupId: string; apiVersion: string; subscriptionId: string): Recallable =
  ## managementGroupSubscriptionsDelete
  ## De-associates subscription from the management group.
  ## 
  ##   groupId: string (required)
  ##          : Management Group ID.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2017-11-01-preview.
  ##   subscriptionId: string (required)
  ##                 : Subscription ID.
  var path_568272 = newJObject()
  var query_568273 = newJObject()
  add(path_568272, "groupId", newJString(groupId))
  add(query_568273, "api-version", newJString(apiVersion))
  add(path_568272, "subscriptionId", newJString(subscriptionId))
  result = call_568271.call(path_568272, query_568273, nil, nil, nil)

var managementGroupSubscriptionsDelete* = Call_ManagementGroupSubscriptionsDelete_568263(
    name: "managementGroupSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{groupId}/subscriptions/{subscriptionId}",
    validator: validate_ManagementGroupSubscriptionsDelete_568264, base: "",
    url: url_ManagementGroupSubscriptionsDelete_568265, schemes: {Scheme.Https})
type
  Call_OperationsList_568274 = ref object of OpenApiRestCall_567658
proc url_OperationsList_568276(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_568275(path: JsonNode; query: JsonNode;
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
  ##              : Version of the API to be used with the client request. The current version is 2017-11-01-preview.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568277 = query.getOrDefault("api-version")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "api-version", valid_568277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568278: Call_OperationsList_568274; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Management REST API operations.
  ## 
  let valid = call_568278.validator(path, query, header, formData, body)
  let scheme = call_568278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568278.url(scheme.get, call_568278.host, call_568278.base,
                         call_568278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568278, url, valid)

proc call*(call_568279: Call_OperationsList_568274; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Management REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. The current version is 2017-11-01-preview.
  var query_568280 = newJObject()
  add(query_568280, "api-version", newJString(apiVersion))
  result = call_568279.call(nil, query_568280, nil, nil, nil)

var operationsList* = Call_OperationsList_568274(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Management/operations",
    validator: validate_OperationsList_568275, base: "", url: url_OperationsList_568276,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
