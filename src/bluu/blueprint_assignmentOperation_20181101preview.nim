
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593409 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593409](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593409): Option[Scheme] {.used.} =
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
  macServiceName = "blueprint-assignmentOperation"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AssignmentOperationsList_593631 = ref object of OpenApiRestCall_593409
proc url_AssignmentOperationsList_593633(protocol: Scheme; host: string;
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

proc validate_AssignmentOperationsList_593632(path: JsonNode; query: JsonNode;
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
  var valid_593806 = path.getOrDefault("scope")
  valid_593806 = validateParameter(valid_593806, JString, required = true,
                                 default = nil)
  if valid_593806 != nil:
    section.add "scope", valid_593806
  var valid_593807 = path.getOrDefault("assignmentName")
  valid_593807 = validateParameter(valid_593807, JString, required = true,
                                 default = nil)
  if valid_593807 != nil:
    section.add "assignmentName", valid_593807
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_593831: Call_AssignmentOperationsList_593631; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List operations for given blueprint assignment within a subscription.
  ## 
  let valid = call_593831.validator(path, query, header, formData, body)
  let scheme = call_593831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593831.url(scheme.get, call_593831.host, call_593831.base,
                         call_593831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593831, url, valid)

proc call*(call_593902: Call_AssignmentOperationsList_593631; apiVersion: string;
          scope: string; assignmentName: string): Recallable =
  ## assignmentOperationsList
  ## List operations for given blueprint assignment within a subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  ##   assignmentName: string (required)
  ##                 : Name of the blueprint assignment.
  var path_593903 = newJObject()
  var query_593905 = newJObject()
  add(query_593905, "api-version", newJString(apiVersion))
  add(path_593903, "scope", newJString(scope))
  add(path_593903, "assignmentName", newJString(assignmentName))
  result = call_593902.call(path_593903, query_593905, nil, nil, nil)

var assignmentOperationsList* = Call_AssignmentOperationsList_593631(
    name: "assignmentOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprintAssignments/{assignmentName}/assignmentOperations",
    validator: validate_AssignmentOperationsList_593632, base: "",
    url: url_AssignmentOperationsList_593633, schemes: {Scheme.Https})
type
  Call_AssignmentOperationsGet_593944 = ref object of OpenApiRestCall_593409
proc url_AssignmentOperationsGet_593946(protocol: Scheme; host: string; base: string;
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

proc validate_AssignmentOperationsGet_593945(path: JsonNode; query: JsonNode;
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
  var valid_593947 = path.getOrDefault("assignmentOperationName")
  valid_593947 = validateParameter(valid_593947, JString, required = true,
                                 default = nil)
  if valid_593947 != nil:
    section.add "assignmentOperationName", valid_593947
  var valid_593948 = path.getOrDefault("scope")
  valid_593948 = validateParameter(valid_593948, JString, required = true,
                                 default = nil)
  if valid_593948 != nil:
    section.add "scope", valid_593948
  var valid_593949 = path.getOrDefault("assignmentName")
  valid_593949 = validateParameter(valid_593949, JString, required = true,
                                 default = nil)
  if valid_593949 != nil:
    section.add "assignmentName", valid_593949
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593950 = query.getOrDefault("api-version")
  valid_593950 = validateParameter(valid_593950, JString, required = true,
                                 default = nil)
  if valid_593950 != nil:
    section.add "api-version", valid_593950
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593951: Call_AssignmentOperationsGet_593944; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a blueprint assignment operation.
  ## 
  let valid = call_593951.validator(path, query, header, formData, body)
  let scheme = call_593951.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593951.url(scheme.get, call_593951.host, call_593951.base,
                         call_593951.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593951, url, valid)

proc call*(call_593952: Call_AssignmentOperationsGet_593944; apiVersion: string;
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
  var path_593953 = newJObject()
  var query_593954 = newJObject()
  add(query_593954, "api-version", newJString(apiVersion))
  add(path_593953, "assignmentOperationName", newJString(assignmentOperationName))
  add(path_593953, "scope", newJString(scope))
  add(path_593953, "assignmentName", newJString(assignmentName))
  result = call_593952.call(path_593953, query_593954, nil, nil, nil)

var assignmentOperationsGet* = Call_AssignmentOperationsGet_593944(
    name: "assignmentOperationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprintAssignments/{assignmentName}/assignmentOperations/{assignmentOperationName}",
    validator: validate_AssignmentOperationsGet_593945, base: "",
    url: url_AssignmentOperationsGet_593946, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
