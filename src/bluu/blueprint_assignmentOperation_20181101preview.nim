
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_574442 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574442](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574442): Option[Scheme] {.used.} =
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
  macServiceName = "blueprint-assignmentOperation"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AssignmentOperationsList_574664 = ref object of OpenApiRestCall_574442
proc url_AssignmentOperationsList_574666(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/assignmentOperations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssignmentOperationsList_574665(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List operations for given blueprint assignment within a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  ##   assignmentName: JString (required)
  ##                 : Name of the blueprint assignment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_574839 = path.getOrDefault("scope")
  valid_574839 = validateParameter(valid_574839, JString, required = true,
                                 default = nil)
  if valid_574839 != nil:
    section.add "scope", valid_574839
  var valid_574840 = path.getOrDefault("assignmentName")
  valid_574840 = validateParameter(valid_574840, JString, required = true,
                                 default = nil)
  if valid_574840 != nil:
    section.add "assignmentName", valid_574840
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574841 = query.getOrDefault("api-version")
  valid_574841 = validateParameter(valid_574841, JString, required = true,
                                 default = nil)
  if valid_574841 != nil:
    section.add "api-version", valid_574841
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574864: Call_AssignmentOperationsList_574664; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List operations for given blueprint assignment within a subscription.
  ## 
  let valid = call_574864.validator(path, query, header, formData, body)
  let scheme = call_574864.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574864.url(scheme.get, call_574864.host, call_574864.base,
                         call_574864.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574864, url, valid)

proc call*(call_574935: Call_AssignmentOperationsList_574664; apiVersion: string;
          scope: string; assignmentName: string): Recallable =
  ## assignmentOperationsList
  ## List operations for given blueprint assignment within a subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  ##   assignmentName: string (required)
  ##                 : Name of the blueprint assignment.
  var path_574936 = newJObject()
  var query_574938 = newJObject()
  add(query_574938, "api-version", newJString(apiVersion))
  add(path_574936, "scope", newJString(scope))
  add(path_574936, "assignmentName", newJString(assignmentName))
  result = call_574935.call(path_574936, query_574938, nil, nil, nil)

var assignmentOperationsList* = Call_AssignmentOperationsList_574664(
    name: "assignmentOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprintAssignments/{assignmentName}/assignmentOperations",
    validator: validate_AssignmentOperationsList_574665, base: "",
    url: url_AssignmentOperationsList_574666, schemes: {Scheme.Https})
type
  Call_AssignmentOperationsGet_574977 = ref object of OpenApiRestCall_574442
proc url_AssignmentOperationsGet_574979(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "assignmentName" in path, "`assignmentName` is a required path parameter"
  assert "assignmentOperationName" in path,
        "`assignmentOperationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Blueprint/blueprintAssignments/"),
               (kind: VariableSegment, value: "assignmentName"),
               (kind: ConstantSegment, value: "/assignmentOperations/"),
               (kind: VariableSegment, value: "assignmentOperationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssignmentOperationsGet_574978(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a blueprint assignment operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   assignmentOperationName: JString (required)
  ##                          : Name of the blueprint assignment operation.
  ##   scope: JString (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  ##   assignmentName: JString (required)
  ##                 : Name of the blueprint assignment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `assignmentOperationName` field"
  var valid_574980 = path.getOrDefault("assignmentOperationName")
  valid_574980 = validateParameter(valid_574980, JString, required = true,
                                 default = nil)
  if valid_574980 != nil:
    section.add "assignmentOperationName", valid_574980
  var valid_574981 = path.getOrDefault("scope")
  valid_574981 = validateParameter(valid_574981, JString, required = true,
                                 default = nil)
  if valid_574981 != nil:
    section.add "scope", valid_574981
  var valid_574982 = path.getOrDefault("assignmentName")
  valid_574982 = validateParameter(valid_574982, JString, required = true,
                                 default = nil)
  if valid_574982 != nil:
    section.add "assignmentName", valid_574982
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574983 = query.getOrDefault("api-version")
  valid_574983 = validateParameter(valid_574983, JString, required = true,
                                 default = nil)
  if valid_574983 != nil:
    section.add "api-version", valid_574983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574984: Call_AssignmentOperationsGet_574977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a blueprint assignment operation.
  ## 
  let valid = call_574984.validator(path, query, header, formData, body)
  let scheme = call_574984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574984.url(scheme.get, call_574984.host, call_574984.base,
                         call_574984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574984, url, valid)

proc call*(call_574985: Call_AssignmentOperationsGet_574977; apiVersion: string;
          assignmentOperationName: string; scope: string; assignmentName: string): Recallable =
  ## assignmentOperationsGet
  ## Get a blueprint assignment operation.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   assignmentOperationName: string (required)
  ##                          : Name of the blueprint assignment operation.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  ##   assignmentName: string (required)
  ##                 : Name of the blueprint assignment.
  var path_574986 = newJObject()
  var query_574987 = newJObject()
  add(query_574987, "api-version", newJString(apiVersion))
  add(path_574986, "assignmentOperationName", newJString(assignmentOperationName))
  add(path_574986, "scope", newJString(scope))
  add(path_574986, "assignmentName", newJString(assignmentName))
  result = call_574985.call(path_574986, query_574987, nil, nil, nil)

var assignmentOperationsGet* = Call_AssignmentOperationsGet_574977(
    name: "assignmentOperationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprintAssignments/{assignmentName}/assignmentOperations/{assignmentOperationName}",
    validator: validate_AssignmentOperationsGet_574978, base: "",
    url: url_AssignmentOperationsGet_574979, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
