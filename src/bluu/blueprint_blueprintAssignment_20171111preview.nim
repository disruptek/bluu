
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: BlueprintClient
## version: 2017-11-11-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Blueprint Client.
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

  OpenApiRestCall_574457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574457): Option[Scheme] {.used.} =
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
  macServiceName = "blueprint-blueprintAssignment"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AssignmentsList_574679 = ref object of OpenApiRestCall_574457
proc url_AssignmentsList_574681(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Blueprint/blueprintAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssignmentsList_574680(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## List Blueprint assignments within a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : azure subscriptionId, which we assign the blueprint to.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574854 = path.getOrDefault("subscriptionId")
  valid_574854 = validateParameter(valid_574854, JString, required = true,
                                 default = nil)
  if valid_574854 != nil:
    section.add "subscriptionId", valid_574854
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574855 = query.getOrDefault("api-version")
  valid_574855 = validateParameter(valid_574855, JString, required = true,
                                 default = nil)
  if valid_574855 != nil:
    section.add "api-version", valid_574855
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574878: Call_AssignmentsList_574679; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List Blueprint assignments within a subscription.
  ## 
  let valid = call_574878.validator(path, query, header, formData, body)
  let scheme = call_574878.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574878.url(scheme.get, call_574878.host, call_574878.base,
                         call_574878.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574878, url, valid)

proc call*(call_574949: Call_AssignmentsList_574679; apiVersion: string;
          subscriptionId: string): Recallable =
  ## assignmentsList
  ## List Blueprint assignments within a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : azure subscriptionId, which we assign the blueprint to.
  var path_574950 = newJObject()
  var query_574952 = newJObject()
  add(query_574952, "api-version", newJString(apiVersion))
  add(path_574950, "subscriptionId", newJString(subscriptionId))
  result = call_574949.call(path_574950, query_574952, nil, nil, nil)

var assignmentsList* = Call_AssignmentsList_574679(name: "assignmentsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Blueprint/blueprintAssignments",
    validator: validate_AssignmentsList_574680, base: "", url: url_AssignmentsList_574681,
    schemes: {Scheme.Https})
type
  Call_AssignmentsCreateOrUpdate_575001 = ref object of OpenApiRestCall_574457
proc url_AssignmentsCreateOrUpdate_575003(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "assignmentName" in path, "`assignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Blueprint/blueprintAssignments/"),
               (kind: VariableSegment, value: "assignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssignmentsCreateOrUpdate_575002(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a Blueprint assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : azure subscriptionId, which we assign the blueprint to.
  ##   assignmentName: JString (required)
  ##                 : name of the assignment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575004 = path.getOrDefault("subscriptionId")
  valid_575004 = validateParameter(valid_575004, JString, required = true,
                                 default = nil)
  if valid_575004 != nil:
    section.add "subscriptionId", valid_575004
  var valid_575005 = path.getOrDefault("assignmentName")
  valid_575005 = validateParameter(valid_575005, JString, required = true,
                                 default = nil)
  if valid_575005 != nil:
    section.add "assignmentName", valid_575005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575006 = query.getOrDefault("api-version")
  valid_575006 = validateParameter(valid_575006, JString, required = true,
                                 default = nil)
  if valid_575006 != nil:
    section.add "api-version", valid_575006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   assignment: JObject (required)
  ##             : assignment object to save.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575008: Call_AssignmentsCreateOrUpdate_575001; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Blueprint assignment.
  ## 
  let valid = call_575008.validator(path, query, header, formData, body)
  let scheme = call_575008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575008.url(scheme.get, call_575008.host, call_575008.base,
                         call_575008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575008, url, valid)

proc call*(call_575009: Call_AssignmentsCreateOrUpdate_575001; apiVersion: string;
          assignment: JsonNode; subscriptionId: string; assignmentName: string): Recallable =
  ## assignmentsCreateOrUpdate
  ## Create or update a Blueprint assignment.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   assignment: JObject (required)
  ##             : assignment object to save.
  ##   subscriptionId: string (required)
  ##                 : azure subscriptionId, which we assign the blueprint to.
  ##   assignmentName: string (required)
  ##                 : name of the assignment.
  var path_575010 = newJObject()
  var query_575011 = newJObject()
  var body_575012 = newJObject()
  add(query_575011, "api-version", newJString(apiVersion))
  if assignment != nil:
    body_575012 = assignment
  add(path_575010, "subscriptionId", newJString(subscriptionId))
  add(path_575010, "assignmentName", newJString(assignmentName))
  result = call_575009.call(path_575010, query_575011, nil, nil, body_575012)

var assignmentsCreateOrUpdate* = Call_AssignmentsCreateOrUpdate_575001(
    name: "assignmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Blueprint/blueprintAssignments/{assignmentName}",
    validator: validate_AssignmentsCreateOrUpdate_575002, base: "",
    url: url_AssignmentsCreateOrUpdate_575003, schemes: {Scheme.Https})
type
  Call_AssignmentsGet_574991 = ref object of OpenApiRestCall_574457
proc url_AssignmentsGet_574993(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "assignmentName" in path, "`assignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Blueprint/blueprintAssignments/"),
               (kind: VariableSegment, value: "assignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssignmentsGet_574992(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get a Blueprint assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : azure subscriptionId, which we assign the blueprint to.
  ##   assignmentName: JString (required)
  ##                 : name of the assignment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574994 = path.getOrDefault("subscriptionId")
  valid_574994 = validateParameter(valid_574994, JString, required = true,
                                 default = nil)
  if valid_574994 != nil:
    section.add "subscriptionId", valid_574994
  var valid_574995 = path.getOrDefault("assignmentName")
  valid_574995 = validateParameter(valid_574995, JString, required = true,
                                 default = nil)
  if valid_574995 != nil:
    section.add "assignmentName", valid_574995
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574996 = query.getOrDefault("api-version")
  valid_574996 = validateParameter(valid_574996, JString, required = true,
                                 default = nil)
  if valid_574996 != nil:
    section.add "api-version", valid_574996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574997: Call_AssignmentsGet_574991; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Blueprint assignment.
  ## 
  let valid = call_574997.validator(path, query, header, formData, body)
  let scheme = call_574997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574997.url(scheme.get, call_574997.host, call_574997.base,
                         call_574997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574997, url, valid)

proc call*(call_574998: Call_AssignmentsGet_574991; apiVersion: string;
          subscriptionId: string; assignmentName: string): Recallable =
  ## assignmentsGet
  ## Get a Blueprint assignment.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : azure subscriptionId, which we assign the blueprint to.
  ##   assignmentName: string (required)
  ##                 : name of the assignment.
  var path_574999 = newJObject()
  var query_575000 = newJObject()
  add(query_575000, "api-version", newJString(apiVersion))
  add(path_574999, "subscriptionId", newJString(subscriptionId))
  add(path_574999, "assignmentName", newJString(assignmentName))
  result = call_574998.call(path_574999, query_575000, nil, nil, nil)

var assignmentsGet* = Call_AssignmentsGet_574991(name: "assignmentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Blueprint/blueprintAssignments/{assignmentName}",
    validator: validate_AssignmentsGet_574992, base: "", url: url_AssignmentsGet_574993,
    schemes: {Scheme.Https})
type
  Call_AssignmentsDelete_575013 = ref object of OpenApiRestCall_574457
proc url_AssignmentsDelete_575015(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "assignmentName" in path, "`assignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Blueprint/blueprintAssignments/"),
               (kind: VariableSegment, value: "assignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssignmentsDelete_575014(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Delete a Blueprint assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : azure subscriptionId, which we assign the blueprint to.
  ##   assignmentName: JString (required)
  ##                 : name of the assignment.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575016 = path.getOrDefault("subscriptionId")
  valid_575016 = validateParameter(valid_575016, JString, required = true,
                                 default = nil)
  if valid_575016 != nil:
    section.add "subscriptionId", valid_575016
  var valid_575017 = path.getOrDefault("assignmentName")
  valid_575017 = validateParameter(valid_575017, JString, required = true,
                                 default = nil)
  if valid_575017 != nil:
    section.add "assignmentName", valid_575017
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575018 = query.getOrDefault("api-version")
  valid_575018 = validateParameter(valid_575018, JString, required = true,
                                 default = nil)
  if valid_575018 != nil:
    section.add "api-version", valid_575018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575019: Call_AssignmentsDelete_575013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Blueprint assignment.
  ## 
  let valid = call_575019.validator(path, query, header, formData, body)
  let scheme = call_575019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575019.url(scheme.get, call_575019.host, call_575019.base,
                         call_575019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575019, url, valid)

proc call*(call_575020: Call_AssignmentsDelete_575013; apiVersion: string;
          subscriptionId: string; assignmentName: string): Recallable =
  ## assignmentsDelete
  ## Delete a Blueprint assignment.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : azure subscriptionId, which we assign the blueprint to.
  ##   assignmentName: string (required)
  ##                 : name of the assignment.
  var path_575021 = newJObject()
  var query_575022 = newJObject()
  add(query_575022, "api-version", newJString(apiVersion))
  add(path_575021, "subscriptionId", newJString(subscriptionId))
  add(path_575021, "assignmentName", newJString(assignmentName))
  result = call_575020.call(path_575021, query_575022, nil, nil, nil)

var assignmentsDelete* = Call_AssignmentsDelete_575013(name: "assignmentsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Blueprint/blueprintAssignments/{assignmentName}",
    validator: validate_AssignmentsDelete_575014, base: "",
    url: url_AssignmentsDelete_575015, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
