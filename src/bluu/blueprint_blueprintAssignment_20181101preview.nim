
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: BlueprintClient
## version: 2018-11-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Blueprints Client provides access to blueprint definitions, assignments, and artifacts, and related blueprint operations.
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "blueprint-blueprintAssignment"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AssignmentsList_563777 = ref object of OpenApiRestCall_563555
proc url_AssignmentsList_563779(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Blueprint/blueprintAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssignmentsList_563778(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## List blueprint assignments within a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_563954 = path.getOrDefault("scope")
  valid_563954 = validateParameter(valid_563954, JString, required = true,
                                 default = nil)
  if valid_563954 != nil:
    section.add "scope", valid_563954
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563955 = query.getOrDefault("api-version")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "api-version", valid_563955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563978: Call_AssignmentsList_563777; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List blueprint assignments within a subscription.
  ## 
  let valid = call_563978.validator(path, query, header, formData, body)
  let scheme = call_563978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563978.url(scheme.get, call_563978.host, call_563978.base,
                         call_563978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563978, url, valid)

proc call*(call_564049: Call_AssignmentsList_563777; apiVersion: string;
          scope: string): Recallable =
  ## assignmentsList
  ## List blueprint assignments within a subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_564050 = newJObject()
  var query_564052 = newJObject()
  add(query_564052, "api-version", newJString(apiVersion))
  add(path_564050, "scope", newJString(scope))
  result = call_564049.call(path_564050, query_564052, nil, nil, nil)

var assignmentsList* = Call_AssignmentsList_563777(name: "assignmentsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Blueprint/blueprintAssignments",
    validator: validate_AssignmentsList_563778, base: "", url: url_AssignmentsList_563779,
    schemes: {Scheme.Https})
type
  Call_AssignmentsCreateOrUpdate_564101 = ref object of OpenApiRestCall_563555
proc url_AssignmentsCreateOrUpdate_564103(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "assignmentName" in path, "`assignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Blueprint/blueprintAssignments/"),
               (kind: VariableSegment, value: "assignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssignmentsCreateOrUpdate_564102(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a blueprint assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   assignmentName: JString (required)
  ##                 : Name of the blueprint assignment.
  ##   scope: JString (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `assignmentName` field"
  var valid_564104 = path.getOrDefault("assignmentName")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "assignmentName", valid_564104
  var valid_564105 = path.getOrDefault("scope")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "scope", valid_564105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564106 = query.getOrDefault("api-version")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "api-version", valid_564106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   assignment: JObject (required)
  ##             : Blueprint assignment object to save.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564108: Call_AssignmentsCreateOrUpdate_564101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a blueprint assignment.
  ## 
  let valid = call_564108.validator(path, query, header, formData, body)
  let scheme = call_564108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564108.url(scheme.get, call_564108.host, call_564108.base,
                         call_564108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564108, url, valid)

proc call*(call_564109: Call_AssignmentsCreateOrUpdate_564101; apiVersion: string;
          assignment: JsonNode; assignmentName: string; scope: string): Recallable =
  ## assignmentsCreateOrUpdate
  ## Create or update a blueprint assignment.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   assignment: JObject (required)
  ##             : Blueprint assignment object to save.
  ##   assignmentName: string (required)
  ##                 : Name of the blueprint assignment.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_564110 = newJObject()
  var query_564111 = newJObject()
  var body_564112 = newJObject()
  add(query_564111, "api-version", newJString(apiVersion))
  if assignment != nil:
    body_564112 = assignment
  add(path_564110, "assignmentName", newJString(assignmentName))
  add(path_564110, "scope", newJString(scope))
  result = call_564109.call(path_564110, query_564111, nil, nil, body_564112)

var assignmentsCreateOrUpdate* = Call_AssignmentsCreateOrUpdate_564101(
    name: "assignmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprintAssignments/{assignmentName}",
    validator: validate_AssignmentsCreateOrUpdate_564102, base: "",
    url: url_AssignmentsCreateOrUpdate_564103, schemes: {Scheme.Https})
type
  Call_AssignmentsGet_564091 = ref object of OpenApiRestCall_563555
proc url_AssignmentsGet_564093(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "assignmentName" in path, "`assignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Blueprint/blueprintAssignments/"),
               (kind: VariableSegment, value: "assignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssignmentsGet_564092(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get a blueprint assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   assignmentName: JString (required)
  ##                 : Name of the blueprint assignment.
  ##   scope: JString (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `assignmentName` field"
  var valid_564094 = path.getOrDefault("assignmentName")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "assignmentName", valid_564094
  var valid_564095 = path.getOrDefault("scope")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "scope", valid_564095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564096 = query.getOrDefault("api-version")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "api-version", valid_564096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564097: Call_AssignmentsGet_564091; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a blueprint assignment.
  ## 
  let valid = call_564097.validator(path, query, header, formData, body)
  let scheme = call_564097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564097.url(scheme.get, call_564097.host, call_564097.base,
                         call_564097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564097, url, valid)

proc call*(call_564098: Call_AssignmentsGet_564091; apiVersion: string;
          assignmentName: string; scope: string): Recallable =
  ## assignmentsGet
  ## Get a blueprint assignment.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   assignmentName: string (required)
  ##                 : Name of the blueprint assignment.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_564099 = newJObject()
  var query_564100 = newJObject()
  add(query_564100, "api-version", newJString(apiVersion))
  add(path_564099, "assignmentName", newJString(assignmentName))
  add(path_564099, "scope", newJString(scope))
  result = call_564098.call(path_564099, query_564100, nil, nil, nil)

var assignmentsGet* = Call_AssignmentsGet_564091(name: "assignmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprintAssignments/{assignmentName}",
    validator: validate_AssignmentsGet_564092, base: "", url: url_AssignmentsGet_564093,
    schemes: {Scheme.Https})
type
  Call_AssignmentsDelete_564113 = ref object of OpenApiRestCall_563555
proc url_AssignmentsDelete_564115(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "assignmentName" in path, "`assignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Blueprint/blueprintAssignments/"),
               (kind: VariableSegment, value: "assignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssignmentsDelete_564114(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Delete a blueprint assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   assignmentName: JString (required)
  ##                 : Name of the blueprint assignment.
  ##   scope: JString (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `assignmentName` field"
  var valid_564116 = path.getOrDefault("assignmentName")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "assignmentName", valid_564116
  var valid_564117 = path.getOrDefault("scope")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "scope", valid_564117
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564118 = query.getOrDefault("api-version")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "api-version", valid_564118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564119: Call_AssignmentsDelete_564113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a blueprint assignment.
  ## 
  let valid = call_564119.validator(path, query, header, formData, body)
  let scheme = call_564119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564119.url(scheme.get, call_564119.host, call_564119.base,
                         call_564119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564119, url, valid)

proc call*(call_564120: Call_AssignmentsDelete_564113; apiVersion: string;
          assignmentName: string; scope: string): Recallable =
  ## assignmentsDelete
  ## Delete a blueprint assignment.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   assignmentName: string (required)
  ##                 : Name of the blueprint assignment.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_564121 = newJObject()
  var query_564122 = newJObject()
  add(query_564122, "api-version", newJString(apiVersion))
  add(path_564121, "assignmentName", newJString(assignmentName))
  add(path_564121, "scope", newJString(scope))
  result = call_564120.call(path_564121, query_564122, nil, nil, nil)

var assignmentsDelete* = Call_AssignmentsDelete_564113(name: "assignmentsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprintAssignments/{assignmentName}",
    validator: validate_AssignmentsDelete_564114, base: "",
    url: url_AssignmentsDelete_564115, schemes: {Scheme.Https})
type
  Call_AssignmentsWhoIsBlueprint_564123 = ref object of OpenApiRestCall_563555
proc url_AssignmentsWhoIsBlueprint_564125(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "assignmentName" in path, "`assignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Blueprint/blueprintAssignments/"),
               (kind: VariableSegment, value: "assignmentName"),
               (kind: ConstantSegment, value: "/WhoIsBlueprint")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssignmentsWhoIsBlueprint_564124(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Blueprints service SPN objectId
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   assignmentName: JString (required)
  ##                 : Name of the blueprint assignment.
  ##   scope: JString (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `assignmentName` field"
  var valid_564126 = path.getOrDefault("assignmentName")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "assignmentName", valid_564126
  var valid_564127 = path.getOrDefault("scope")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "scope", valid_564127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564128 = query.getOrDefault("api-version")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "api-version", valid_564128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564129: Call_AssignmentsWhoIsBlueprint_564123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Blueprints service SPN objectId
  ## 
  let valid = call_564129.validator(path, query, header, formData, body)
  let scheme = call_564129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564129.url(scheme.get, call_564129.host, call_564129.base,
                         call_564129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564129, url, valid)

proc call*(call_564130: Call_AssignmentsWhoIsBlueprint_564123; apiVersion: string;
          assignmentName: string; scope: string): Recallable =
  ## assignmentsWhoIsBlueprint
  ## Get Blueprints service SPN objectId
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   assignmentName: string (required)
  ##                 : Name of the blueprint assignment.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_564131 = newJObject()
  var query_564132 = newJObject()
  add(query_564132, "api-version", newJString(apiVersion))
  add(path_564131, "assignmentName", newJString(assignmentName))
  add(path_564131, "scope", newJString(scope))
  result = call_564130.call(path_564131, query_564132, nil, nil, nil)

var assignmentsWhoIsBlueprint* = Call_AssignmentsWhoIsBlueprint_564123(
    name: "assignmentsWhoIsBlueprint", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprintAssignments/{assignmentName}/WhoIsBlueprint",
    validator: validate_AssignmentsWhoIsBlueprint_564124, base: "",
    url: url_AssignmentsWhoIsBlueprint_564125, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
