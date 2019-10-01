
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

  OpenApiRestCall_574458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574458): Option[Scheme] {.used.} =
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
  macServiceName = "blueprint-blueprintDefinition"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BlueprintsList_574680 = ref object of OpenApiRestCall_574458
proc url_BlueprintsList_574682(protocol: Scheme; host: string; base: string;
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

proc validate_BlueprintsList_574681(path: JsonNode; query: JsonNode;
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
  var valid_574855 = path.getOrDefault("scope")
  valid_574855 = validateParameter(valid_574855, JString, required = true,
                                 default = nil)
  if valid_574855 != nil:
    section.add "scope", valid_574855
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574856 = query.getOrDefault("api-version")
  valid_574856 = validateParameter(valid_574856, JString, required = true,
                                 default = nil)
  if valid_574856 != nil:
    section.add "api-version", valid_574856
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574879: Call_BlueprintsList_574680; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List blueprint definitions.
  ## 
  let valid = call_574879.validator(path, query, header, formData, body)
  let scheme = call_574879.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574879.url(scheme.get, call_574879.host, call_574879.base,
                         call_574879.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574879, url, valid)

proc call*(call_574950: Call_BlueprintsList_574680; apiVersion: string; scope: string): Recallable =
  ## blueprintsList
  ## List blueprint definitions.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_574951 = newJObject()
  var query_574953 = newJObject()
  add(query_574953, "api-version", newJString(apiVersion))
  add(path_574951, "scope", newJString(scope))
  result = call_574950.call(path_574951, query_574953, nil, nil, nil)

var blueprintsList* = Call_BlueprintsList_574680(name: "blueprintsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Blueprint/blueprints",
    validator: validate_BlueprintsList_574681, base: "", url: url_BlueprintsList_574682,
    schemes: {Scheme.Https})
type
  Call_BlueprintsCreateOrUpdate_575002 = ref object of OpenApiRestCall_574458
proc url_BlueprintsCreateOrUpdate_575004(protocol: Scheme; host: string;
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

proc validate_BlueprintsCreateOrUpdate_575003(path: JsonNode; query: JsonNode;
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
  var valid_575005 = path.getOrDefault("blueprintName")
  valid_575005 = validateParameter(valid_575005, JString, required = true,
                                 default = nil)
  if valid_575005 != nil:
    section.add "blueprintName", valid_575005
  var valid_575006 = path.getOrDefault("scope")
  valid_575006 = validateParameter(valid_575006, JString, required = true,
                                 default = nil)
  if valid_575006 != nil:
    section.add "scope", valid_575006
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575007 = query.getOrDefault("api-version")
  valid_575007 = validateParameter(valid_575007, JString, required = true,
                                 default = nil)
  if valid_575007 != nil:
    section.add "api-version", valid_575007
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

proc call*(call_575009: Call_BlueprintsCreateOrUpdate_575002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a blueprint definition.
  ## 
  let valid = call_575009.validator(path, query, header, formData, body)
  let scheme = call_575009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575009.url(scheme.get, call_575009.host, call_575009.base,
                         call_575009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575009, url, valid)

proc call*(call_575010: Call_BlueprintsCreateOrUpdate_575002; apiVersion: string;
          blueprintName: string; blueprint: JsonNode; scope: string): Recallable =
  ## blueprintsCreateOrUpdate
  ## Create or update a blueprint definition.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   blueprint: JObject (required)
  ##            : Blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_575011 = newJObject()
  var query_575012 = newJObject()
  var body_575013 = newJObject()
  add(query_575012, "api-version", newJString(apiVersion))
  add(path_575011, "blueprintName", newJString(blueprintName))
  if blueprint != nil:
    body_575013 = blueprint
  add(path_575011, "scope", newJString(scope))
  result = call_575010.call(path_575011, query_575012, nil, nil, body_575013)

var blueprintsCreateOrUpdate* = Call_BlueprintsCreateOrUpdate_575002(
    name: "blueprintsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}",
    validator: validate_BlueprintsCreateOrUpdate_575003, base: "",
    url: url_BlueprintsCreateOrUpdate_575004, schemes: {Scheme.Https})
type
  Call_BlueprintsGet_574992 = ref object of OpenApiRestCall_574458
proc url_BlueprintsGet_574994(protocol: Scheme; host: string; base: string;
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

proc validate_BlueprintsGet_574993(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574995 = path.getOrDefault("blueprintName")
  valid_574995 = validateParameter(valid_574995, JString, required = true,
                                 default = nil)
  if valid_574995 != nil:
    section.add "blueprintName", valid_574995
  var valid_574996 = path.getOrDefault("scope")
  valid_574996 = validateParameter(valid_574996, JString, required = true,
                                 default = nil)
  if valid_574996 != nil:
    section.add "scope", valid_574996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574997 = query.getOrDefault("api-version")
  valid_574997 = validateParameter(valid_574997, JString, required = true,
                                 default = nil)
  if valid_574997 != nil:
    section.add "api-version", valid_574997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574998: Call_BlueprintsGet_574992; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a blueprint definition.
  ## 
  let valid = call_574998.validator(path, query, header, formData, body)
  let scheme = call_574998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574998.url(scheme.get, call_574998.host, call_574998.base,
                         call_574998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574998, url, valid)

proc call*(call_574999: Call_BlueprintsGet_574992; apiVersion: string;
          blueprintName: string; scope: string): Recallable =
  ## blueprintsGet
  ## Get a blueprint definition.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_575000 = newJObject()
  var query_575001 = newJObject()
  add(query_575001, "api-version", newJString(apiVersion))
  add(path_575000, "blueprintName", newJString(blueprintName))
  add(path_575000, "scope", newJString(scope))
  result = call_574999.call(path_575000, query_575001, nil, nil, nil)

var blueprintsGet* = Call_BlueprintsGet_574992(name: "blueprintsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}",
    validator: validate_BlueprintsGet_574993, base: "", url: url_BlueprintsGet_574994,
    schemes: {Scheme.Https})
type
  Call_BlueprintsDelete_575014 = ref object of OpenApiRestCall_574458
proc url_BlueprintsDelete_575016(protocol: Scheme; host: string; base: string;
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

proc validate_BlueprintsDelete_575015(path: JsonNode; query: JsonNode;
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
  var valid_575017 = path.getOrDefault("blueprintName")
  valid_575017 = validateParameter(valid_575017, JString, required = true,
                                 default = nil)
  if valid_575017 != nil:
    section.add "blueprintName", valid_575017
  var valid_575018 = path.getOrDefault("scope")
  valid_575018 = validateParameter(valid_575018, JString, required = true,
                                 default = nil)
  if valid_575018 != nil:
    section.add "scope", valid_575018
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575019 = query.getOrDefault("api-version")
  valid_575019 = validateParameter(valid_575019, JString, required = true,
                                 default = nil)
  if valid_575019 != nil:
    section.add "api-version", valid_575019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575020: Call_BlueprintsDelete_575014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a blueprint definition.
  ## 
  let valid = call_575020.validator(path, query, header, formData, body)
  let scheme = call_575020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575020.url(scheme.get, call_575020.host, call_575020.base,
                         call_575020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575020, url, valid)

proc call*(call_575021: Call_BlueprintsDelete_575014; apiVersion: string;
          blueprintName: string; scope: string): Recallable =
  ## blueprintsDelete
  ## Delete a blueprint definition.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_575022 = newJObject()
  var query_575023 = newJObject()
  add(query_575023, "api-version", newJString(apiVersion))
  add(path_575022, "blueprintName", newJString(blueprintName))
  add(path_575022, "scope", newJString(scope))
  result = call_575021.call(path_575022, query_575023, nil, nil, nil)

var blueprintsDelete* = Call_BlueprintsDelete_575014(name: "blueprintsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}",
    validator: validate_BlueprintsDelete_575015, base: "",
    url: url_BlueprintsDelete_575016, schemes: {Scheme.Https})
type
  Call_ArtifactsList_575024 = ref object of OpenApiRestCall_574458
proc url_ArtifactsList_575026(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactsList_575025(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575027 = path.getOrDefault("blueprintName")
  valid_575027 = validateParameter(valid_575027, JString, required = true,
                                 default = nil)
  if valid_575027 != nil:
    section.add "blueprintName", valid_575027
  var valid_575028 = path.getOrDefault("scope")
  valid_575028 = validateParameter(valid_575028, JString, required = true,
                                 default = nil)
  if valid_575028 != nil:
    section.add "scope", valid_575028
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575029 = query.getOrDefault("api-version")
  valid_575029 = validateParameter(valid_575029, JString, required = true,
                                 default = nil)
  if valid_575029 != nil:
    section.add "api-version", valid_575029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575030: Call_ArtifactsList_575024; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifacts for a given blueprint definition.
  ## 
  let valid = call_575030.validator(path, query, header, formData, body)
  let scheme = call_575030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575030.url(scheme.get, call_575030.host, call_575030.base,
                         call_575030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575030, url, valid)

proc call*(call_575031: Call_ArtifactsList_575024; apiVersion: string;
          blueprintName: string; scope: string): Recallable =
  ## artifactsList
  ## List artifacts for a given blueprint definition.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_575032 = newJObject()
  var query_575033 = newJObject()
  add(query_575033, "api-version", newJString(apiVersion))
  add(path_575032, "blueprintName", newJString(blueprintName))
  add(path_575032, "scope", newJString(scope))
  result = call_575031.call(path_575032, query_575033, nil, nil, nil)

var artifactsList* = Call_ArtifactsList_575024(name: "artifactsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/artifacts",
    validator: validate_ArtifactsList_575025, base: "", url: url_ArtifactsList_575026,
    schemes: {Scheme.Https})
type
  Call_ArtifactsCreateOrUpdate_575045 = ref object of OpenApiRestCall_574458
proc url_ArtifactsCreateOrUpdate_575047(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactsCreateOrUpdate_575046(path: JsonNode; query: JsonNode;
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
  var valid_575048 = path.getOrDefault("artifactName")
  valid_575048 = validateParameter(valid_575048, JString, required = true,
                                 default = nil)
  if valid_575048 != nil:
    section.add "artifactName", valid_575048
  var valid_575049 = path.getOrDefault("blueprintName")
  valid_575049 = validateParameter(valid_575049, JString, required = true,
                                 default = nil)
  if valid_575049 != nil:
    section.add "blueprintName", valid_575049
  var valid_575050 = path.getOrDefault("scope")
  valid_575050 = validateParameter(valid_575050, JString, required = true,
                                 default = nil)
  if valid_575050 != nil:
    section.add "scope", valid_575050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575051 = query.getOrDefault("api-version")
  valid_575051 = validateParameter(valid_575051, JString, required = true,
                                 default = nil)
  if valid_575051 != nil:
    section.add "api-version", valid_575051
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

proc call*(call_575053: Call_ArtifactsCreateOrUpdate_575045; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update blueprint artifact.
  ## 
  let valid = call_575053.validator(path, query, header, formData, body)
  let scheme = call_575053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575053.url(scheme.get, call_575053.host, call_575053.base,
                         call_575053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575053, url, valid)

proc call*(call_575054: Call_ArtifactsCreateOrUpdate_575045; artifactName: string;
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
  var path_575055 = newJObject()
  var query_575056 = newJObject()
  var body_575057 = newJObject()
  add(path_575055, "artifactName", newJString(artifactName))
  if artifact != nil:
    body_575057 = artifact
  add(query_575056, "api-version", newJString(apiVersion))
  add(path_575055, "blueprintName", newJString(blueprintName))
  add(path_575055, "scope", newJString(scope))
  result = call_575054.call(path_575055, query_575056, nil, nil, body_575057)

var artifactsCreateOrUpdate* = Call_ArtifactsCreateOrUpdate_575045(
    name: "artifactsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/artifacts/{artifactName}",
    validator: validate_ArtifactsCreateOrUpdate_575046, base: "",
    url: url_ArtifactsCreateOrUpdate_575047, schemes: {Scheme.Https})
type
  Call_ArtifactsGet_575034 = ref object of OpenApiRestCall_574458
proc url_ArtifactsGet_575036(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactsGet_575035(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575037 = path.getOrDefault("artifactName")
  valid_575037 = validateParameter(valid_575037, JString, required = true,
                                 default = nil)
  if valid_575037 != nil:
    section.add "artifactName", valid_575037
  var valid_575038 = path.getOrDefault("blueprintName")
  valid_575038 = validateParameter(valid_575038, JString, required = true,
                                 default = nil)
  if valid_575038 != nil:
    section.add "blueprintName", valid_575038
  var valid_575039 = path.getOrDefault("scope")
  valid_575039 = validateParameter(valid_575039, JString, required = true,
                                 default = nil)
  if valid_575039 != nil:
    section.add "scope", valid_575039
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575040 = query.getOrDefault("api-version")
  valid_575040 = validateParameter(valid_575040, JString, required = true,
                                 default = nil)
  if valid_575040 != nil:
    section.add "api-version", valid_575040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575041: Call_ArtifactsGet_575034; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a blueprint artifact.
  ## 
  let valid = call_575041.validator(path, query, header, formData, body)
  let scheme = call_575041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575041.url(scheme.get, call_575041.host, call_575041.base,
                         call_575041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575041, url, valid)

proc call*(call_575042: Call_ArtifactsGet_575034; artifactName: string;
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
  var path_575043 = newJObject()
  var query_575044 = newJObject()
  add(path_575043, "artifactName", newJString(artifactName))
  add(query_575044, "api-version", newJString(apiVersion))
  add(path_575043, "blueprintName", newJString(blueprintName))
  add(path_575043, "scope", newJString(scope))
  result = call_575042.call(path_575043, query_575044, nil, nil, nil)

var artifactsGet* = Call_ArtifactsGet_575034(name: "artifactsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/artifacts/{artifactName}",
    validator: validate_ArtifactsGet_575035, base: "", url: url_ArtifactsGet_575036,
    schemes: {Scheme.Https})
type
  Call_ArtifactsDelete_575058 = ref object of OpenApiRestCall_574458
proc url_ArtifactsDelete_575060(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactsDelete_575059(path: JsonNode; query: JsonNode;
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
  var valid_575061 = path.getOrDefault("artifactName")
  valid_575061 = validateParameter(valid_575061, JString, required = true,
                                 default = nil)
  if valid_575061 != nil:
    section.add "artifactName", valid_575061
  var valid_575062 = path.getOrDefault("blueprintName")
  valid_575062 = validateParameter(valid_575062, JString, required = true,
                                 default = nil)
  if valid_575062 != nil:
    section.add "blueprintName", valid_575062
  var valid_575063 = path.getOrDefault("scope")
  valid_575063 = validateParameter(valid_575063, JString, required = true,
                                 default = nil)
  if valid_575063 != nil:
    section.add "scope", valid_575063
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575064 = query.getOrDefault("api-version")
  valid_575064 = validateParameter(valid_575064, JString, required = true,
                                 default = nil)
  if valid_575064 != nil:
    section.add "api-version", valid_575064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575065: Call_ArtifactsDelete_575058; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a blueprint artifact.
  ## 
  let valid = call_575065.validator(path, query, header, formData, body)
  let scheme = call_575065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575065.url(scheme.get, call_575065.host, call_575065.base,
                         call_575065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575065, url, valid)

proc call*(call_575066: Call_ArtifactsDelete_575058; artifactName: string;
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
  var path_575067 = newJObject()
  var query_575068 = newJObject()
  add(path_575067, "artifactName", newJString(artifactName))
  add(query_575068, "api-version", newJString(apiVersion))
  add(path_575067, "blueprintName", newJString(blueprintName))
  add(path_575067, "scope", newJString(scope))
  result = call_575066.call(path_575067, query_575068, nil, nil, nil)

var artifactsDelete* = Call_ArtifactsDelete_575058(name: "artifactsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/artifacts/{artifactName}",
    validator: validate_ArtifactsDelete_575059, base: "", url: url_ArtifactsDelete_575060,
    schemes: {Scheme.Https})
type
  Call_PublishedBlueprintsList_575069 = ref object of OpenApiRestCall_574458
proc url_PublishedBlueprintsList_575071(protocol: Scheme; host: string; base: string;
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

proc validate_PublishedBlueprintsList_575070(path: JsonNode; query: JsonNode;
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
  var valid_575072 = path.getOrDefault("blueprintName")
  valid_575072 = validateParameter(valid_575072, JString, required = true,
                                 default = nil)
  if valid_575072 != nil:
    section.add "blueprintName", valid_575072
  var valid_575073 = path.getOrDefault("scope")
  valid_575073 = validateParameter(valid_575073, JString, required = true,
                                 default = nil)
  if valid_575073 != nil:
    section.add "scope", valid_575073
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575074 = query.getOrDefault("api-version")
  valid_575074 = validateParameter(valid_575074, JString, required = true,
                                 default = nil)
  if valid_575074 != nil:
    section.add "api-version", valid_575074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575075: Call_PublishedBlueprintsList_575069; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List published versions of given blueprint definition.
  ## 
  let valid = call_575075.validator(path, query, header, formData, body)
  let scheme = call_575075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575075.url(scheme.get, call_575075.host, call_575075.base,
                         call_575075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575075, url, valid)

proc call*(call_575076: Call_PublishedBlueprintsList_575069; apiVersion: string;
          blueprintName: string; scope: string): Recallable =
  ## publishedBlueprintsList
  ## List published versions of given blueprint definition.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_575077 = newJObject()
  var query_575078 = newJObject()
  add(query_575078, "api-version", newJString(apiVersion))
  add(path_575077, "blueprintName", newJString(blueprintName))
  add(path_575077, "scope", newJString(scope))
  result = call_575076.call(path_575077, query_575078, nil, nil, nil)

var publishedBlueprintsList* = Call_PublishedBlueprintsList_575069(
    name: "publishedBlueprintsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions",
    validator: validate_PublishedBlueprintsList_575070, base: "",
    url: url_PublishedBlueprintsList_575071, schemes: {Scheme.Https})
type
  Call_PublishedBlueprintsCreate_575090 = ref object of OpenApiRestCall_574458
proc url_PublishedBlueprintsCreate_575092(protocol: Scheme; host: string;
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

proc validate_PublishedBlueprintsCreate_575091(path: JsonNode; query: JsonNode;
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
  var valid_575093 = path.getOrDefault("versionId")
  valid_575093 = validateParameter(valid_575093, JString, required = true,
                                 default = nil)
  if valid_575093 != nil:
    section.add "versionId", valid_575093
  var valid_575094 = path.getOrDefault("blueprintName")
  valid_575094 = validateParameter(valid_575094, JString, required = true,
                                 default = nil)
  if valid_575094 != nil:
    section.add "blueprintName", valid_575094
  var valid_575095 = path.getOrDefault("scope")
  valid_575095 = validateParameter(valid_575095, JString, required = true,
                                 default = nil)
  if valid_575095 != nil:
    section.add "scope", valid_575095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575096 = query.getOrDefault("api-version")
  valid_575096 = validateParameter(valid_575096, JString, required = true,
                                 default = nil)
  if valid_575096 != nil:
    section.add "api-version", valid_575096
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

proc call*(call_575098: Call_PublishedBlueprintsCreate_575090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Publish a new version of the blueprint definition with the latest artifacts. Published blueprint definitions are immutable.
  ## 
  let valid = call_575098.validator(path, query, header, formData, body)
  let scheme = call_575098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575098.url(scheme.get, call_575098.host, call_575098.base,
                         call_575098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575098, url, valid)

proc call*(call_575099: Call_PublishedBlueprintsCreate_575090; versionId: string;
          apiVersion: string; blueprintName: string; scope: string;
          publishedBlueprint: JsonNode = nil): Recallable =
  ## publishedBlueprintsCreate
  ## Publish a new version of the blueprint definition with the latest artifacts. Published blueprint definitions are immutable.
  ##   versionId: string (required)
  ##            : Version of the published blueprint definition.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   publishedBlueprint: JObject
  ##                     : Published Blueprint to create or update.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_575100 = newJObject()
  var query_575101 = newJObject()
  var body_575102 = newJObject()
  add(path_575100, "versionId", newJString(versionId))
  add(query_575101, "api-version", newJString(apiVersion))
  if publishedBlueprint != nil:
    body_575102 = publishedBlueprint
  add(path_575100, "blueprintName", newJString(blueprintName))
  add(path_575100, "scope", newJString(scope))
  result = call_575099.call(path_575100, query_575101, nil, nil, body_575102)

var publishedBlueprintsCreate* = Call_PublishedBlueprintsCreate_575090(
    name: "publishedBlueprintsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions/{versionId}",
    validator: validate_PublishedBlueprintsCreate_575091, base: "",
    url: url_PublishedBlueprintsCreate_575092, schemes: {Scheme.Https})
type
  Call_PublishedBlueprintsGet_575079 = ref object of OpenApiRestCall_574458
proc url_PublishedBlueprintsGet_575081(protocol: Scheme; host: string; base: string;
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

proc validate_PublishedBlueprintsGet_575080(path: JsonNode; query: JsonNode;
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
  var valid_575082 = path.getOrDefault("versionId")
  valid_575082 = validateParameter(valid_575082, JString, required = true,
                                 default = nil)
  if valid_575082 != nil:
    section.add "versionId", valid_575082
  var valid_575083 = path.getOrDefault("blueprintName")
  valid_575083 = validateParameter(valid_575083, JString, required = true,
                                 default = nil)
  if valid_575083 != nil:
    section.add "blueprintName", valid_575083
  var valid_575084 = path.getOrDefault("scope")
  valid_575084 = validateParameter(valid_575084, JString, required = true,
                                 default = nil)
  if valid_575084 != nil:
    section.add "scope", valid_575084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575085 = query.getOrDefault("api-version")
  valid_575085 = validateParameter(valid_575085, JString, required = true,
                                 default = nil)
  if valid_575085 != nil:
    section.add "api-version", valid_575085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575086: Call_PublishedBlueprintsGet_575079; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a published version of a blueprint definition.
  ## 
  let valid = call_575086.validator(path, query, header, formData, body)
  let scheme = call_575086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575086.url(scheme.get, call_575086.host, call_575086.base,
                         call_575086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575086, url, valid)

proc call*(call_575087: Call_PublishedBlueprintsGet_575079; versionId: string;
          apiVersion: string; blueprintName: string; scope: string): Recallable =
  ## publishedBlueprintsGet
  ## Get a published version of a blueprint definition.
  ##   versionId: string (required)
  ##            : Version of the published blueprint definition.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_575088 = newJObject()
  var query_575089 = newJObject()
  add(path_575088, "versionId", newJString(versionId))
  add(query_575089, "api-version", newJString(apiVersion))
  add(path_575088, "blueprintName", newJString(blueprintName))
  add(path_575088, "scope", newJString(scope))
  result = call_575087.call(path_575088, query_575089, nil, nil, nil)

var publishedBlueprintsGet* = Call_PublishedBlueprintsGet_575079(
    name: "publishedBlueprintsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions/{versionId}",
    validator: validate_PublishedBlueprintsGet_575080, base: "",
    url: url_PublishedBlueprintsGet_575081, schemes: {Scheme.Https})
type
  Call_PublishedBlueprintsDelete_575103 = ref object of OpenApiRestCall_574458
proc url_PublishedBlueprintsDelete_575105(protocol: Scheme; host: string;
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

proc validate_PublishedBlueprintsDelete_575104(path: JsonNode; query: JsonNode;
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
  var valid_575106 = path.getOrDefault("versionId")
  valid_575106 = validateParameter(valid_575106, JString, required = true,
                                 default = nil)
  if valid_575106 != nil:
    section.add "versionId", valid_575106
  var valid_575107 = path.getOrDefault("blueprintName")
  valid_575107 = validateParameter(valid_575107, JString, required = true,
                                 default = nil)
  if valid_575107 != nil:
    section.add "blueprintName", valid_575107
  var valid_575108 = path.getOrDefault("scope")
  valid_575108 = validateParameter(valid_575108, JString, required = true,
                                 default = nil)
  if valid_575108 != nil:
    section.add "scope", valid_575108
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575109 = query.getOrDefault("api-version")
  valid_575109 = validateParameter(valid_575109, JString, required = true,
                                 default = nil)
  if valid_575109 != nil:
    section.add "api-version", valid_575109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575110: Call_PublishedBlueprintsDelete_575103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a published version of a blueprint definition.
  ## 
  let valid = call_575110.validator(path, query, header, formData, body)
  let scheme = call_575110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575110.url(scheme.get, call_575110.host, call_575110.base,
                         call_575110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575110, url, valid)

proc call*(call_575111: Call_PublishedBlueprintsDelete_575103; versionId: string;
          apiVersion: string; blueprintName: string; scope: string): Recallable =
  ## publishedBlueprintsDelete
  ## Delete a published version of a blueprint definition.
  ##   versionId: string (required)
  ##            : Version of the published blueprint definition.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_575112 = newJObject()
  var query_575113 = newJObject()
  add(path_575112, "versionId", newJString(versionId))
  add(query_575113, "api-version", newJString(apiVersion))
  add(path_575112, "blueprintName", newJString(blueprintName))
  add(path_575112, "scope", newJString(scope))
  result = call_575111.call(path_575112, query_575113, nil, nil, nil)

var publishedBlueprintsDelete* = Call_PublishedBlueprintsDelete_575103(
    name: "publishedBlueprintsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions/{versionId}",
    validator: validate_PublishedBlueprintsDelete_575104, base: "",
    url: url_PublishedBlueprintsDelete_575105, schemes: {Scheme.Https})
type
  Call_PublishedArtifactsList_575114 = ref object of OpenApiRestCall_574458
proc url_PublishedArtifactsList_575116(protocol: Scheme; host: string; base: string;
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

proc validate_PublishedArtifactsList_575115(path: JsonNode; query: JsonNode;
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
  var valid_575117 = path.getOrDefault("versionId")
  valid_575117 = validateParameter(valid_575117, JString, required = true,
                                 default = nil)
  if valid_575117 != nil:
    section.add "versionId", valid_575117
  var valid_575118 = path.getOrDefault("blueprintName")
  valid_575118 = validateParameter(valid_575118, JString, required = true,
                                 default = nil)
  if valid_575118 != nil:
    section.add "blueprintName", valid_575118
  var valid_575119 = path.getOrDefault("scope")
  valid_575119 = validateParameter(valid_575119, JString, required = true,
                                 default = nil)
  if valid_575119 != nil:
    section.add "scope", valid_575119
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575120 = query.getOrDefault("api-version")
  valid_575120 = validateParameter(valid_575120, JString, required = true,
                                 default = nil)
  if valid_575120 != nil:
    section.add "api-version", valid_575120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575121: Call_PublishedArtifactsList_575114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifacts for a version of a published blueprint definition.
  ## 
  let valid = call_575121.validator(path, query, header, formData, body)
  let scheme = call_575121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575121.url(scheme.get, call_575121.host, call_575121.base,
                         call_575121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575121, url, valid)

proc call*(call_575122: Call_PublishedArtifactsList_575114; versionId: string;
          apiVersion: string; blueprintName: string; scope: string): Recallable =
  ## publishedArtifactsList
  ## List artifacts for a version of a published blueprint definition.
  ##   versionId: string (required)
  ##            : Version of the published blueprint definition.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_575123 = newJObject()
  var query_575124 = newJObject()
  add(path_575123, "versionId", newJString(versionId))
  add(query_575124, "api-version", newJString(apiVersion))
  add(path_575123, "blueprintName", newJString(blueprintName))
  add(path_575123, "scope", newJString(scope))
  result = call_575122.call(path_575123, query_575124, nil, nil, nil)

var publishedArtifactsList* = Call_PublishedArtifactsList_575114(
    name: "publishedArtifactsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions/{versionId}/artifacts",
    validator: validate_PublishedArtifactsList_575115, base: "",
    url: url_PublishedArtifactsList_575116, schemes: {Scheme.Https})
type
  Call_PublishedArtifactsGet_575125 = ref object of OpenApiRestCall_574458
proc url_PublishedArtifactsGet_575127(protocol: Scheme; host: string; base: string;
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

proc validate_PublishedArtifactsGet_575126(path: JsonNode; query: JsonNode;
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
  var valid_575128 = path.getOrDefault("artifactName")
  valid_575128 = validateParameter(valid_575128, JString, required = true,
                                 default = nil)
  if valid_575128 != nil:
    section.add "artifactName", valid_575128
  var valid_575129 = path.getOrDefault("versionId")
  valid_575129 = validateParameter(valid_575129, JString, required = true,
                                 default = nil)
  if valid_575129 != nil:
    section.add "versionId", valid_575129
  var valid_575130 = path.getOrDefault("blueprintName")
  valid_575130 = validateParameter(valid_575130, JString, required = true,
                                 default = nil)
  if valid_575130 != nil:
    section.add "blueprintName", valid_575130
  var valid_575131 = path.getOrDefault("scope")
  valid_575131 = validateParameter(valid_575131, JString, required = true,
                                 default = nil)
  if valid_575131 != nil:
    section.add "scope", valid_575131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575132 = query.getOrDefault("api-version")
  valid_575132 = validateParameter(valid_575132, JString, required = true,
                                 default = nil)
  if valid_575132 != nil:
    section.add "api-version", valid_575132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575133: Call_PublishedArtifactsGet_575125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an artifact for a published blueprint definition.
  ## 
  let valid = call_575133.validator(path, query, header, formData, body)
  let scheme = call_575133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575133.url(scheme.get, call_575133.host, call_575133.base,
                         call_575133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575133, url, valid)

proc call*(call_575134: Call_PublishedArtifactsGet_575125; artifactName: string;
          versionId: string; apiVersion: string; blueprintName: string; scope: string): Recallable =
  ## publishedArtifactsGet
  ## Get an artifact for a published blueprint definition.
  ##   artifactName: string (required)
  ##               : Name of the blueprint artifact.
  ##   versionId: string (required)
  ##            : Version of the published blueprint definition.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_575135 = newJObject()
  var query_575136 = newJObject()
  add(path_575135, "artifactName", newJString(artifactName))
  add(path_575135, "versionId", newJString(versionId))
  add(query_575136, "api-version", newJString(apiVersion))
  add(path_575135, "blueprintName", newJString(blueprintName))
  add(path_575135, "scope", newJString(scope))
  result = call_575134.call(path_575135, query_575136, nil, nil, nil)

var publishedArtifactsGet* = Call_PublishedArtifactsGet_575125(
    name: "publishedArtifactsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions/{versionId}/artifacts/{artifactName}",
    validator: validate_PublishedArtifactsGet_575126, base: "",
    url: url_PublishedArtifactsGet_575127, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
