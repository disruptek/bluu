
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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
  macServiceName = "blueprint-blueprintDefinition"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BlueprintsList_563778 = ref object of OpenApiRestCall_563556
proc url_BlueprintsList_563780(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Blueprint/blueprints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlueprintsList_563779(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## List blueprint definitions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_563955 = path.getOrDefault("scope")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "scope", valid_563955
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563956 = query.getOrDefault("api-version")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "api-version", valid_563956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563979: Call_BlueprintsList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List blueprint definitions.
  ## 
  let valid = call_563979.validator(path, query, header, formData, body)
  let scheme = call_563979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563979.url(scheme.get, call_563979.host, call_563979.base,
                         call_563979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563979, url, valid)

proc call*(call_564050: Call_BlueprintsList_563778; apiVersion: string; scope: string): Recallable =
  ## blueprintsList
  ## List blueprint definitions.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_564051 = newJObject()
  var query_564053 = newJObject()
  add(query_564053, "api-version", newJString(apiVersion))
  add(path_564051, "scope", newJString(scope))
  result = call_564050.call(path_564051, query_564053, nil, nil, nil)

var blueprintsList* = Call_BlueprintsList_563778(name: "blueprintsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Blueprint/blueprints",
    validator: validate_BlueprintsList_563779, base: "", url: url_BlueprintsList_563780,
    schemes: {Scheme.Https})
type
  Call_BlueprintsCreateOrUpdate_564102 = ref object of OpenApiRestCall_563556
proc url_BlueprintsCreateOrUpdate_564104(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlueprintsCreateOrUpdate_564103(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a blueprint definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blueprintName: JString (required)
  ##                : Name of the blueprint definition.
  ##   scope: JString (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `blueprintName` field"
  var valid_564105 = path.getOrDefault("blueprintName")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "blueprintName", valid_564105
  var valid_564106 = path.getOrDefault("scope")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "scope", valid_564106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564107 = query.getOrDefault("api-version")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "api-version", valid_564107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   blueprint: JObject (required)
  ##            : Blueprint definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564109: Call_BlueprintsCreateOrUpdate_564102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a blueprint definition.
  ## 
  let valid = call_564109.validator(path, query, header, formData, body)
  let scheme = call_564109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564109.url(scheme.get, call_564109.host, call_564109.base,
                         call_564109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564109, url, valid)

proc call*(call_564110: Call_BlueprintsCreateOrUpdate_564102; apiVersion: string;
          blueprint: JsonNode; blueprintName: string; scope: string): Recallable =
  ## blueprintsCreateOrUpdate
  ## Create or update a blueprint definition.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blueprint: JObject (required)
  ##            : Blueprint definition.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_564111 = newJObject()
  var query_564112 = newJObject()
  var body_564113 = newJObject()
  add(query_564112, "api-version", newJString(apiVersion))
  if blueprint != nil:
    body_564113 = blueprint
  add(path_564111, "blueprintName", newJString(blueprintName))
  add(path_564111, "scope", newJString(scope))
  result = call_564110.call(path_564111, query_564112, nil, nil, body_564113)

var blueprintsCreateOrUpdate* = Call_BlueprintsCreateOrUpdate_564102(
    name: "blueprintsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}",
    validator: validate_BlueprintsCreateOrUpdate_564103, base: "",
    url: url_BlueprintsCreateOrUpdate_564104, schemes: {Scheme.Https})
type
  Call_BlueprintsGet_564092 = ref object of OpenApiRestCall_563556
proc url_BlueprintsGet_564094(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlueprintsGet_564093(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a blueprint definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blueprintName: JString (required)
  ##                : Name of the blueprint definition.
  ##   scope: JString (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `blueprintName` field"
  var valid_564095 = path.getOrDefault("blueprintName")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "blueprintName", valid_564095
  var valid_564096 = path.getOrDefault("scope")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "scope", valid_564096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564097 = query.getOrDefault("api-version")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "api-version", valid_564097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564098: Call_BlueprintsGet_564092; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a blueprint definition.
  ## 
  let valid = call_564098.validator(path, query, header, formData, body)
  let scheme = call_564098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564098.url(scheme.get, call_564098.host, call_564098.base,
                         call_564098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564098, url, valid)

proc call*(call_564099: Call_BlueprintsGet_564092; apiVersion: string;
          blueprintName: string; scope: string): Recallable =
  ## blueprintsGet
  ## Get a blueprint definition.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_564100 = newJObject()
  var query_564101 = newJObject()
  add(query_564101, "api-version", newJString(apiVersion))
  add(path_564100, "blueprintName", newJString(blueprintName))
  add(path_564100, "scope", newJString(scope))
  result = call_564099.call(path_564100, query_564101, nil, nil, nil)

var blueprintsGet* = Call_BlueprintsGet_564092(name: "blueprintsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}",
    validator: validate_BlueprintsGet_564093, base: "", url: url_BlueprintsGet_564094,
    schemes: {Scheme.Https})
type
  Call_BlueprintsDelete_564114 = ref object of OpenApiRestCall_563556
proc url_BlueprintsDelete_564116(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlueprintsDelete_564115(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Delete a blueprint definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blueprintName: JString (required)
  ##                : Name of the blueprint definition.
  ##   scope: JString (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `blueprintName` field"
  var valid_564117 = path.getOrDefault("blueprintName")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "blueprintName", valid_564117
  var valid_564118 = path.getOrDefault("scope")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "scope", valid_564118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564119 = query.getOrDefault("api-version")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "api-version", valid_564119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564120: Call_BlueprintsDelete_564114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a blueprint definition.
  ## 
  let valid = call_564120.validator(path, query, header, formData, body)
  let scheme = call_564120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564120.url(scheme.get, call_564120.host, call_564120.base,
                         call_564120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564120, url, valid)

proc call*(call_564121: Call_BlueprintsDelete_564114; apiVersion: string;
          blueprintName: string; scope: string): Recallable =
  ## blueprintsDelete
  ## Delete a blueprint definition.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_564122 = newJObject()
  var query_564123 = newJObject()
  add(query_564123, "api-version", newJString(apiVersion))
  add(path_564122, "blueprintName", newJString(blueprintName))
  add(path_564122, "scope", newJString(scope))
  result = call_564121.call(path_564122, query_564123, nil, nil, nil)

var blueprintsDelete* = Call_BlueprintsDelete_564114(name: "blueprintsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}",
    validator: validate_BlueprintsDelete_564115, base: "",
    url: url_BlueprintsDelete_564116, schemes: {Scheme.Https})
type
  Call_ArtifactsList_564124 = ref object of OpenApiRestCall_563556
proc url_ArtifactsList_564126(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName"),
               (kind: ConstantSegment, value: "/artifacts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsList_564125(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## List artifacts for a given blueprint definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blueprintName: JString (required)
  ##                : Name of the blueprint definition.
  ##   scope: JString (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `blueprintName` field"
  var valid_564127 = path.getOrDefault("blueprintName")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "blueprintName", valid_564127
  var valid_564128 = path.getOrDefault("scope")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "scope", valid_564128
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564129 = query.getOrDefault("api-version")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "api-version", valid_564129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564130: Call_ArtifactsList_564124; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifacts for a given blueprint definition.
  ## 
  let valid = call_564130.validator(path, query, header, formData, body)
  let scheme = call_564130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564130.url(scheme.get, call_564130.host, call_564130.base,
                         call_564130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564130, url, valid)

proc call*(call_564131: Call_ArtifactsList_564124; apiVersion: string;
          blueprintName: string; scope: string): Recallable =
  ## artifactsList
  ## List artifacts for a given blueprint definition.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_564132 = newJObject()
  var query_564133 = newJObject()
  add(query_564133, "api-version", newJString(apiVersion))
  add(path_564132, "blueprintName", newJString(blueprintName))
  add(path_564132, "scope", newJString(scope))
  result = call_564131.call(path_564132, query_564133, nil, nil, nil)

var artifactsList* = Call_ArtifactsList_564124(name: "artifactsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/artifacts",
    validator: validate_ArtifactsList_564125, base: "", url: url_ArtifactsList_564126,
    schemes: {Scheme.Https})
type
  Call_ArtifactsCreateOrUpdate_564145 = ref object of OpenApiRestCall_563556
proc url_ArtifactsCreateOrUpdate_564147(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  assert "artifactName" in path, "`artifactName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "artifactName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsCreateOrUpdate_564146(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update blueprint artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   artifactName: JString (required)
  ##               : Name of the blueprint artifact.
  ##   blueprintName: JString (required)
  ##                : Name of the blueprint definition.
  ##   scope: JString (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `artifactName` field"
  var valid_564148 = path.getOrDefault("artifactName")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "artifactName", valid_564148
  var valid_564149 = path.getOrDefault("blueprintName")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "blueprintName", valid_564149
  var valid_564150 = path.getOrDefault("scope")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "scope", valid_564150
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564151 = query.getOrDefault("api-version")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "api-version", valid_564151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifact: JObject (required)
  ##           : Blueprint artifact to create or update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564153: Call_ArtifactsCreateOrUpdate_564145; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update blueprint artifact.
  ## 
  let valid = call_564153.validator(path, query, header, formData, body)
  let scheme = call_564153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564153.url(scheme.get, call_564153.host, call_564153.base,
                         call_564153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564153, url, valid)

proc call*(call_564154: Call_ArtifactsCreateOrUpdate_564145; artifactName: string;
          artifact: JsonNode; apiVersion: string; blueprintName: string; scope: string): Recallable =
  ## artifactsCreateOrUpdate
  ## Create or update blueprint artifact.
  ##   artifactName: string (required)
  ##               : Name of the blueprint artifact.
  ##   artifact: JObject (required)
  ##           : Blueprint artifact to create or update.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_564155 = newJObject()
  var query_564156 = newJObject()
  var body_564157 = newJObject()
  add(path_564155, "artifactName", newJString(artifactName))
  if artifact != nil:
    body_564157 = artifact
  add(query_564156, "api-version", newJString(apiVersion))
  add(path_564155, "blueprintName", newJString(blueprintName))
  add(path_564155, "scope", newJString(scope))
  result = call_564154.call(path_564155, query_564156, nil, nil, body_564157)

var artifactsCreateOrUpdate* = Call_ArtifactsCreateOrUpdate_564145(
    name: "artifactsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/artifacts/{artifactName}",
    validator: validate_ArtifactsCreateOrUpdate_564146, base: "",
    url: url_ArtifactsCreateOrUpdate_564147, schemes: {Scheme.Https})
type
  Call_ArtifactsGet_564134 = ref object of OpenApiRestCall_563556
proc url_ArtifactsGet_564136(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  assert "artifactName" in path, "`artifactName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "artifactName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsGet_564135(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a blueprint artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   artifactName: JString (required)
  ##               : Name of the blueprint artifact.
  ##   blueprintName: JString (required)
  ##                : Name of the blueprint definition.
  ##   scope: JString (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `artifactName` field"
  var valid_564137 = path.getOrDefault("artifactName")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "artifactName", valid_564137
  var valid_564138 = path.getOrDefault("blueprintName")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "blueprintName", valid_564138
  var valid_564139 = path.getOrDefault("scope")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "scope", valid_564139
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564140 = query.getOrDefault("api-version")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "api-version", valid_564140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564141: Call_ArtifactsGet_564134; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a blueprint artifact.
  ## 
  let valid = call_564141.validator(path, query, header, formData, body)
  let scheme = call_564141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564141.url(scheme.get, call_564141.host, call_564141.base,
                         call_564141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564141, url, valid)

proc call*(call_564142: Call_ArtifactsGet_564134; artifactName: string;
          apiVersion: string; blueprintName: string; scope: string): Recallable =
  ## artifactsGet
  ## Get a blueprint artifact.
  ##   artifactName: string (required)
  ##               : Name of the blueprint artifact.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_564143 = newJObject()
  var query_564144 = newJObject()
  add(path_564143, "artifactName", newJString(artifactName))
  add(query_564144, "api-version", newJString(apiVersion))
  add(path_564143, "blueprintName", newJString(blueprintName))
  add(path_564143, "scope", newJString(scope))
  result = call_564142.call(path_564143, query_564144, nil, nil, nil)

var artifactsGet* = Call_ArtifactsGet_564134(name: "artifactsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/artifacts/{artifactName}",
    validator: validate_ArtifactsGet_564135, base: "", url: url_ArtifactsGet_564136,
    schemes: {Scheme.Https})
type
  Call_ArtifactsDelete_564158 = ref object of OpenApiRestCall_563556
proc url_ArtifactsDelete_564160(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  assert "artifactName" in path, "`artifactName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "artifactName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsDelete_564159(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Delete a blueprint artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   artifactName: JString (required)
  ##               : Name of the blueprint artifact.
  ##   blueprintName: JString (required)
  ##                : Name of the blueprint definition.
  ##   scope: JString (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `artifactName` field"
  var valid_564161 = path.getOrDefault("artifactName")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "artifactName", valid_564161
  var valid_564162 = path.getOrDefault("blueprintName")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "blueprintName", valid_564162
  var valid_564163 = path.getOrDefault("scope")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "scope", valid_564163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564164 = query.getOrDefault("api-version")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "api-version", valid_564164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564165: Call_ArtifactsDelete_564158; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a blueprint artifact.
  ## 
  let valid = call_564165.validator(path, query, header, formData, body)
  let scheme = call_564165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564165.url(scheme.get, call_564165.host, call_564165.base,
                         call_564165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564165, url, valid)

proc call*(call_564166: Call_ArtifactsDelete_564158; artifactName: string;
          apiVersion: string; blueprintName: string; scope: string): Recallable =
  ## artifactsDelete
  ## Delete a blueprint artifact.
  ##   artifactName: string (required)
  ##               : Name of the blueprint artifact.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_564167 = newJObject()
  var query_564168 = newJObject()
  add(path_564167, "artifactName", newJString(artifactName))
  add(query_564168, "api-version", newJString(apiVersion))
  add(path_564167, "blueprintName", newJString(blueprintName))
  add(path_564167, "scope", newJString(scope))
  result = call_564166.call(path_564167, query_564168, nil, nil, nil)

var artifactsDelete* = Call_ArtifactsDelete_564158(name: "artifactsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/artifacts/{artifactName}",
    validator: validate_ArtifactsDelete_564159, base: "", url: url_ArtifactsDelete_564160,
    schemes: {Scheme.Https})
type
  Call_PublishedBlueprintsList_564169 = ref object of OpenApiRestCall_563556
proc url_PublishedBlueprintsList_564171(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublishedBlueprintsList_564170(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List published versions of given blueprint definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blueprintName: JString (required)
  ##                : Name of the blueprint definition.
  ##   scope: JString (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `blueprintName` field"
  var valid_564172 = path.getOrDefault("blueprintName")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "blueprintName", valid_564172
  var valid_564173 = path.getOrDefault("scope")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "scope", valid_564173
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564174 = query.getOrDefault("api-version")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "api-version", valid_564174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564175: Call_PublishedBlueprintsList_564169; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List published versions of given blueprint definition.
  ## 
  let valid = call_564175.validator(path, query, header, formData, body)
  let scheme = call_564175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564175.url(scheme.get, call_564175.host, call_564175.base,
                         call_564175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564175, url, valid)

proc call*(call_564176: Call_PublishedBlueprintsList_564169; apiVersion: string;
          blueprintName: string; scope: string): Recallable =
  ## publishedBlueprintsList
  ## List published versions of given blueprint definition.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_564177 = newJObject()
  var query_564178 = newJObject()
  add(query_564178, "api-version", newJString(apiVersion))
  add(path_564177, "blueprintName", newJString(blueprintName))
  add(path_564177, "scope", newJString(scope))
  result = call_564176.call(path_564177, query_564178, nil, nil, nil)

var publishedBlueprintsList* = Call_PublishedBlueprintsList_564169(
    name: "publishedBlueprintsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions",
    validator: validate_PublishedBlueprintsList_564170, base: "",
    url: url_PublishedBlueprintsList_564171, schemes: {Scheme.Https})
type
  Call_PublishedBlueprintsCreate_564190 = ref object of OpenApiRestCall_563556
proc url_PublishedBlueprintsCreate_564192(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublishedBlueprintsCreate_564191(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Publish a new version of the blueprint definition with the latest artifacts. Published blueprint definitions are immutable.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : Version of the published blueprint definition.
  ##   blueprintName: JString (required)
  ##                : Name of the blueprint definition.
  ##   scope: JString (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_564193 = path.getOrDefault("versionId")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "versionId", valid_564193
  var valid_564194 = path.getOrDefault("blueprintName")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "blueprintName", valid_564194
  var valid_564195 = path.getOrDefault("scope")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "scope", valid_564195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564196 = query.getOrDefault("api-version")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "api-version", valid_564196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   publishedBlueprint: JObject
  ##                     : Published Blueprint to create or update.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564198: Call_PublishedBlueprintsCreate_564190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Publish a new version of the blueprint definition with the latest artifacts. Published blueprint definitions are immutable.
  ## 
  let valid = call_564198.validator(path, query, header, formData, body)
  let scheme = call_564198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564198.url(scheme.get, call_564198.host, call_564198.base,
                         call_564198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564198, url, valid)

proc call*(call_564199: Call_PublishedBlueprintsCreate_564190; apiVersion: string;
          versionId: string; blueprintName: string; scope: string;
          publishedBlueprint: JsonNode = nil): Recallable =
  ## publishedBlueprintsCreate
  ## Publish a new version of the blueprint definition with the latest artifacts. Published blueprint definitions are immutable.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   publishedBlueprint: JObject
  ##                     : Published Blueprint to create or update.
  ##   versionId: string (required)
  ##            : Version of the published blueprint definition.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_564200 = newJObject()
  var query_564201 = newJObject()
  var body_564202 = newJObject()
  add(query_564201, "api-version", newJString(apiVersion))
  if publishedBlueprint != nil:
    body_564202 = publishedBlueprint
  add(path_564200, "versionId", newJString(versionId))
  add(path_564200, "blueprintName", newJString(blueprintName))
  add(path_564200, "scope", newJString(scope))
  result = call_564199.call(path_564200, query_564201, nil, nil, body_564202)

var publishedBlueprintsCreate* = Call_PublishedBlueprintsCreate_564190(
    name: "publishedBlueprintsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions/{versionId}",
    validator: validate_PublishedBlueprintsCreate_564191, base: "",
    url: url_PublishedBlueprintsCreate_564192, schemes: {Scheme.Https})
type
  Call_PublishedBlueprintsGet_564179 = ref object of OpenApiRestCall_563556
proc url_PublishedBlueprintsGet_564181(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublishedBlueprintsGet_564180(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a published version of a blueprint definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : Version of the published blueprint definition.
  ##   blueprintName: JString (required)
  ##                : Name of the blueprint definition.
  ##   scope: JString (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_564182 = path.getOrDefault("versionId")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "versionId", valid_564182
  var valid_564183 = path.getOrDefault("blueprintName")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "blueprintName", valid_564183
  var valid_564184 = path.getOrDefault("scope")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "scope", valid_564184
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564185 = query.getOrDefault("api-version")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "api-version", valid_564185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564186: Call_PublishedBlueprintsGet_564179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a published version of a blueprint definition.
  ## 
  let valid = call_564186.validator(path, query, header, formData, body)
  let scheme = call_564186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564186.url(scheme.get, call_564186.host, call_564186.base,
                         call_564186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564186, url, valid)

proc call*(call_564187: Call_PublishedBlueprintsGet_564179; apiVersion: string;
          versionId: string; blueprintName: string; scope: string): Recallable =
  ## publishedBlueprintsGet
  ## Get a published version of a blueprint definition.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   versionId: string (required)
  ##            : Version of the published blueprint definition.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_564188 = newJObject()
  var query_564189 = newJObject()
  add(query_564189, "api-version", newJString(apiVersion))
  add(path_564188, "versionId", newJString(versionId))
  add(path_564188, "blueprintName", newJString(blueprintName))
  add(path_564188, "scope", newJString(scope))
  result = call_564187.call(path_564188, query_564189, nil, nil, nil)

var publishedBlueprintsGet* = Call_PublishedBlueprintsGet_564179(
    name: "publishedBlueprintsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions/{versionId}",
    validator: validate_PublishedBlueprintsGet_564180, base: "",
    url: url_PublishedBlueprintsGet_564181, schemes: {Scheme.Https})
type
  Call_PublishedBlueprintsDelete_564203 = ref object of OpenApiRestCall_563556
proc url_PublishedBlueprintsDelete_564205(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublishedBlueprintsDelete_564204(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a published version of a blueprint definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : Version of the published blueprint definition.
  ##   blueprintName: JString (required)
  ##                : Name of the blueprint definition.
  ##   scope: JString (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_564206 = path.getOrDefault("versionId")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "versionId", valid_564206
  var valid_564207 = path.getOrDefault("blueprintName")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "blueprintName", valid_564207
  var valid_564208 = path.getOrDefault("scope")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "scope", valid_564208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564209 = query.getOrDefault("api-version")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "api-version", valid_564209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564210: Call_PublishedBlueprintsDelete_564203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a published version of a blueprint definition.
  ## 
  let valid = call_564210.validator(path, query, header, formData, body)
  let scheme = call_564210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564210.url(scheme.get, call_564210.host, call_564210.base,
                         call_564210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564210, url, valid)

proc call*(call_564211: Call_PublishedBlueprintsDelete_564203; apiVersion: string;
          versionId: string; blueprintName: string; scope: string): Recallable =
  ## publishedBlueprintsDelete
  ## Delete a published version of a blueprint definition.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   versionId: string (required)
  ##            : Version of the published blueprint definition.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_564212 = newJObject()
  var query_564213 = newJObject()
  add(query_564213, "api-version", newJString(apiVersion))
  add(path_564212, "versionId", newJString(versionId))
  add(path_564212, "blueprintName", newJString(blueprintName))
  add(path_564212, "scope", newJString(scope))
  result = call_564211.call(path_564212, query_564213, nil, nil, nil)

var publishedBlueprintsDelete* = Call_PublishedBlueprintsDelete_564203(
    name: "publishedBlueprintsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions/{versionId}",
    validator: validate_PublishedBlueprintsDelete_564204, base: "",
    url: url_PublishedBlueprintsDelete_564205, schemes: {Scheme.Https})
type
  Call_PublishedArtifactsList_564214 = ref object of OpenApiRestCall_563556
proc url_PublishedArtifactsList_564216(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/artifacts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublishedArtifactsList_564215(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List artifacts for a version of a published blueprint definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : Version of the published blueprint definition.
  ##   blueprintName: JString (required)
  ##                : Name of the blueprint definition.
  ##   scope: JString (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_564217 = path.getOrDefault("versionId")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "versionId", valid_564217
  var valid_564218 = path.getOrDefault("blueprintName")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "blueprintName", valid_564218
  var valid_564219 = path.getOrDefault("scope")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "scope", valid_564219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564220 = query.getOrDefault("api-version")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "api-version", valid_564220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564221: Call_PublishedArtifactsList_564214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifacts for a version of a published blueprint definition.
  ## 
  let valid = call_564221.validator(path, query, header, formData, body)
  let scheme = call_564221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564221.url(scheme.get, call_564221.host, call_564221.base,
                         call_564221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564221, url, valid)

proc call*(call_564222: Call_PublishedArtifactsList_564214; apiVersion: string;
          versionId: string; blueprintName: string; scope: string): Recallable =
  ## publishedArtifactsList
  ## List artifacts for a version of a published blueprint definition.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   versionId: string (required)
  ##            : Version of the published blueprint definition.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_564223 = newJObject()
  var query_564224 = newJObject()
  add(query_564224, "api-version", newJString(apiVersion))
  add(path_564223, "versionId", newJString(versionId))
  add(path_564223, "blueprintName", newJString(blueprintName))
  add(path_564223, "scope", newJString(scope))
  result = call_564222.call(path_564223, query_564224, nil, nil, nil)

var publishedArtifactsList* = Call_PublishedArtifactsList_564214(
    name: "publishedArtifactsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions/{versionId}/artifacts",
    validator: validate_PublishedArtifactsList_564215, base: "",
    url: url_PublishedArtifactsList_564216, schemes: {Scheme.Https})
type
  Call_PublishedArtifactsGet_564225 = ref object of OpenApiRestCall_563556
proc url_PublishedArtifactsGet_564227(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "artifactName" in path, "`artifactName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "artifactName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublishedArtifactsGet_564226(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an artifact for a published blueprint definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   artifactName: JString (required)
  ##               : Name of the blueprint artifact.
  ##   versionId: JString (required)
  ##            : Version of the published blueprint definition.
  ##   blueprintName: JString (required)
  ##                : Name of the blueprint definition.
  ##   scope: JString (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `artifactName` field"
  var valid_564228 = path.getOrDefault("artifactName")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "artifactName", valid_564228
  var valid_564229 = path.getOrDefault("versionId")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "versionId", valid_564229
  var valid_564230 = path.getOrDefault("blueprintName")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "blueprintName", valid_564230
  var valid_564231 = path.getOrDefault("scope")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "scope", valid_564231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564232 = query.getOrDefault("api-version")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "api-version", valid_564232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564233: Call_PublishedArtifactsGet_564225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an artifact for a published blueprint definition.
  ## 
  let valid = call_564233.validator(path, query, header, formData, body)
  let scheme = call_564233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564233.url(scheme.get, call_564233.host, call_564233.base,
                         call_564233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564233, url, valid)

proc call*(call_564234: Call_PublishedArtifactsGet_564225; artifactName: string;
          apiVersion: string; versionId: string; blueprintName: string; scope: string): Recallable =
  ## publishedArtifactsGet
  ## Get an artifact for a published blueprint definition.
  ##   artifactName: string (required)
  ##               : Name of the blueprint artifact.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   versionId: string (required)
  ##            : Version of the published blueprint definition.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_564235 = newJObject()
  var query_564236 = newJObject()
  add(path_564235, "artifactName", newJString(artifactName))
  add(query_564236, "api-version", newJString(apiVersion))
  add(path_564235, "versionId", newJString(versionId))
  add(path_564235, "blueprintName", newJString(blueprintName))
  add(path_564235, "scope", newJString(scope))
  result = call_564234.call(path_564235, query_564236, nil, nil, nil)

var publishedArtifactsGet* = Call_PublishedArtifactsGet_564225(
    name: "publishedArtifactsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions/{versionId}/artifacts/{artifactName}",
    validator: validate_PublishedArtifactsGet_564226, base: "",
    url: url_PublishedArtifactsGet_564227, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
