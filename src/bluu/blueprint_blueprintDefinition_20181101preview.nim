
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
  macServiceName = "blueprint-blueprintDefinition"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BlueprintsList_593647 = ref object of OpenApiRestCall_593425
proc url_BlueprintsList_593649(protocol: Scheme; host: string; base: string;
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

proc validate_BlueprintsList_593648(path: JsonNode; query: JsonNode;
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
  var valid_593822 = path.getOrDefault("scope")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "scope", valid_593822
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593823 = query.getOrDefault("api-version")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "api-version", valid_593823
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593846: Call_BlueprintsList_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List blueprint definitions.
  ## 
  let valid = call_593846.validator(path, query, header, formData, body)
  let scheme = call_593846.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593846.url(scheme.get, call_593846.host, call_593846.base,
                         call_593846.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593846, url, valid)

proc call*(call_593917: Call_BlueprintsList_593647; apiVersion: string; scope: string): Recallable =
  ## blueprintsList
  ## List blueprint definitions.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_593918 = newJObject()
  var query_593920 = newJObject()
  add(query_593920, "api-version", newJString(apiVersion))
  add(path_593918, "scope", newJString(scope))
  result = call_593917.call(path_593918, query_593920, nil, nil, nil)

var blueprintsList* = Call_BlueprintsList_593647(name: "blueprintsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Blueprint/blueprints",
    validator: validate_BlueprintsList_593648, base: "", url: url_BlueprintsList_593649,
    schemes: {Scheme.Https})
type
  Call_BlueprintsCreateOrUpdate_593969 = ref object of OpenApiRestCall_593425
proc url_BlueprintsCreateOrUpdate_593971(protocol: Scheme; host: string;
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

proc validate_BlueprintsCreateOrUpdate_593970(path: JsonNode; query: JsonNode;
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
  var valid_593972 = path.getOrDefault("blueprintName")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "blueprintName", valid_593972
  var valid_593973 = path.getOrDefault("scope")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "scope", valid_593973
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593974 = query.getOrDefault("api-version")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "api-version", valid_593974
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

proc call*(call_593976: Call_BlueprintsCreateOrUpdate_593969; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a blueprint definition.
  ## 
  let valid = call_593976.validator(path, query, header, formData, body)
  let scheme = call_593976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593976.url(scheme.get, call_593976.host, call_593976.base,
                         call_593976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593976, url, valid)

proc call*(call_593977: Call_BlueprintsCreateOrUpdate_593969; apiVersion: string;
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
  var path_593978 = newJObject()
  var query_593979 = newJObject()
  var body_593980 = newJObject()
  add(query_593979, "api-version", newJString(apiVersion))
  add(path_593978, "blueprintName", newJString(blueprintName))
  if blueprint != nil:
    body_593980 = blueprint
  add(path_593978, "scope", newJString(scope))
  result = call_593977.call(path_593978, query_593979, nil, nil, body_593980)

var blueprintsCreateOrUpdate* = Call_BlueprintsCreateOrUpdate_593969(
    name: "blueprintsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}",
    validator: validate_BlueprintsCreateOrUpdate_593970, base: "",
    url: url_BlueprintsCreateOrUpdate_593971, schemes: {Scheme.Https})
type
  Call_BlueprintsGet_593959 = ref object of OpenApiRestCall_593425
proc url_BlueprintsGet_593961(protocol: Scheme; host: string; base: string;
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

proc validate_BlueprintsGet_593960(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593962 = path.getOrDefault("blueprintName")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "blueprintName", valid_593962
  var valid_593963 = path.getOrDefault("scope")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "scope", valid_593963
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593964 = query.getOrDefault("api-version")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "api-version", valid_593964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593965: Call_BlueprintsGet_593959; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a blueprint definition.
  ## 
  let valid = call_593965.validator(path, query, header, formData, body)
  let scheme = call_593965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593965.url(scheme.get, call_593965.host, call_593965.base,
                         call_593965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593965, url, valid)

proc call*(call_593966: Call_BlueprintsGet_593959; apiVersion: string;
          blueprintName: string; scope: string): Recallable =
  ## blueprintsGet
  ## Get a blueprint definition.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_593967 = newJObject()
  var query_593968 = newJObject()
  add(query_593968, "api-version", newJString(apiVersion))
  add(path_593967, "blueprintName", newJString(blueprintName))
  add(path_593967, "scope", newJString(scope))
  result = call_593966.call(path_593967, query_593968, nil, nil, nil)

var blueprintsGet* = Call_BlueprintsGet_593959(name: "blueprintsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}",
    validator: validate_BlueprintsGet_593960, base: "", url: url_BlueprintsGet_593961,
    schemes: {Scheme.Https})
type
  Call_BlueprintsDelete_593981 = ref object of OpenApiRestCall_593425
proc url_BlueprintsDelete_593983(protocol: Scheme; host: string; base: string;
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

proc validate_BlueprintsDelete_593982(path: JsonNode; query: JsonNode;
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
  var valid_593984 = path.getOrDefault("blueprintName")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "blueprintName", valid_593984
  var valid_593985 = path.getOrDefault("scope")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "scope", valid_593985
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593986 = query.getOrDefault("api-version")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "api-version", valid_593986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593987: Call_BlueprintsDelete_593981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a blueprint definition.
  ## 
  let valid = call_593987.validator(path, query, header, formData, body)
  let scheme = call_593987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593987.url(scheme.get, call_593987.host, call_593987.base,
                         call_593987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593987, url, valid)

proc call*(call_593988: Call_BlueprintsDelete_593981; apiVersion: string;
          blueprintName: string; scope: string): Recallable =
  ## blueprintsDelete
  ## Delete a blueprint definition.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_593989 = newJObject()
  var query_593990 = newJObject()
  add(query_593990, "api-version", newJString(apiVersion))
  add(path_593989, "blueprintName", newJString(blueprintName))
  add(path_593989, "scope", newJString(scope))
  result = call_593988.call(path_593989, query_593990, nil, nil, nil)

var blueprintsDelete* = Call_BlueprintsDelete_593981(name: "blueprintsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}",
    validator: validate_BlueprintsDelete_593982, base: "",
    url: url_BlueprintsDelete_593983, schemes: {Scheme.Https})
type
  Call_ArtifactsList_593991 = ref object of OpenApiRestCall_593425
proc url_ArtifactsList_593993(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactsList_593992(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593994 = path.getOrDefault("blueprintName")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "blueprintName", valid_593994
  var valid_593995 = path.getOrDefault("scope")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "scope", valid_593995
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593996 = query.getOrDefault("api-version")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "api-version", valid_593996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593997: Call_ArtifactsList_593991; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifacts for a given blueprint definition.
  ## 
  let valid = call_593997.validator(path, query, header, formData, body)
  let scheme = call_593997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593997.url(scheme.get, call_593997.host, call_593997.base,
                         call_593997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593997, url, valid)

proc call*(call_593998: Call_ArtifactsList_593991; apiVersion: string;
          blueprintName: string; scope: string): Recallable =
  ## artifactsList
  ## List artifacts for a given blueprint definition.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_593999 = newJObject()
  var query_594000 = newJObject()
  add(query_594000, "api-version", newJString(apiVersion))
  add(path_593999, "blueprintName", newJString(blueprintName))
  add(path_593999, "scope", newJString(scope))
  result = call_593998.call(path_593999, query_594000, nil, nil, nil)

var artifactsList* = Call_ArtifactsList_593991(name: "artifactsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/artifacts",
    validator: validate_ArtifactsList_593992, base: "", url: url_ArtifactsList_593993,
    schemes: {Scheme.Https})
type
  Call_ArtifactsCreateOrUpdate_594012 = ref object of OpenApiRestCall_593425
proc url_ArtifactsCreateOrUpdate_594014(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactsCreateOrUpdate_594013(path: JsonNode; query: JsonNode;
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
  var valid_594015 = path.getOrDefault("artifactName")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "artifactName", valid_594015
  var valid_594016 = path.getOrDefault("blueprintName")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "blueprintName", valid_594016
  var valid_594017 = path.getOrDefault("scope")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "scope", valid_594017
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594018 = query.getOrDefault("api-version")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "api-version", valid_594018
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

proc call*(call_594020: Call_ArtifactsCreateOrUpdate_594012; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update blueprint artifact.
  ## 
  let valid = call_594020.validator(path, query, header, formData, body)
  let scheme = call_594020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594020.url(scheme.get, call_594020.host, call_594020.base,
                         call_594020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594020, url, valid)

proc call*(call_594021: Call_ArtifactsCreateOrUpdate_594012; artifactName: string;
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
  var path_594022 = newJObject()
  var query_594023 = newJObject()
  var body_594024 = newJObject()
  add(path_594022, "artifactName", newJString(artifactName))
  if artifact != nil:
    body_594024 = artifact
  add(query_594023, "api-version", newJString(apiVersion))
  add(path_594022, "blueprintName", newJString(blueprintName))
  add(path_594022, "scope", newJString(scope))
  result = call_594021.call(path_594022, query_594023, nil, nil, body_594024)

var artifactsCreateOrUpdate* = Call_ArtifactsCreateOrUpdate_594012(
    name: "artifactsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/artifacts/{artifactName}",
    validator: validate_ArtifactsCreateOrUpdate_594013, base: "",
    url: url_ArtifactsCreateOrUpdate_594014, schemes: {Scheme.Https})
type
  Call_ArtifactsGet_594001 = ref object of OpenApiRestCall_593425
proc url_ArtifactsGet_594003(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactsGet_594002(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594004 = path.getOrDefault("artifactName")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "artifactName", valid_594004
  var valid_594005 = path.getOrDefault("blueprintName")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "blueprintName", valid_594005
  var valid_594006 = path.getOrDefault("scope")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "scope", valid_594006
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594007 = query.getOrDefault("api-version")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "api-version", valid_594007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594008: Call_ArtifactsGet_594001; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a blueprint artifact.
  ## 
  let valid = call_594008.validator(path, query, header, formData, body)
  let scheme = call_594008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594008.url(scheme.get, call_594008.host, call_594008.base,
                         call_594008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594008, url, valid)

proc call*(call_594009: Call_ArtifactsGet_594001; artifactName: string;
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
  var path_594010 = newJObject()
  var query_594011 = newJObject()
  add(path_594010, "artifactName", newJString(artifactName))
  add(query_594011, "api-version", newJString(apiVersion))
  add(path_594010, "blueprintName", newJString(blueprintName))
  add(path_594010, "scope", newJString(scope))
  result = call_594009.call(path_594010, query_594011, nil, nil, nil)

var artifactsGet* = Call_ArtifactsGet_594001(name: "artifactsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/artifacts/{artifactName}",
    validator: validate_ArtifactsGet_594002, base: "", url: url_ArtifactsGet_594003,
    schemes: {Scheme.Https})
type
  Call_ArtifactsDelete_594025 = ref object of OpenApiRestCall_593425
proc url_ArtifactsDelete_594027(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactsDelete_594026(path: JsonNode; query: JsonNode;
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
  var valid_594028 = path.getOrDefault("artifactName")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "artifactName", valid_594028
  var valid_594029 = path.getOrDefault("blueprintName")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "blueprintName", valid_594029
  var valid_594030 = path.getOrDefault("scope")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "scope", valid_594030
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594031 = query.getOrDefault("api-version")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "api-version", valid_594031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594032: Call_ArtifactsDelete_594025; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a blueprint artifact.
  ## 
  let valid = call_594032.validator(path, query, header, formData, body)
  let scheme = call_594032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594032.url(scheme.get, call_594032.host, call_594032.base,
                         call_594032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594032, url, valid)

proc call*(call_594033: Call_ArtifactsDelete_594025; artifactName: string;
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
  var path_594034 = newJObject()
  var query_594035 = newJObject()
  add(path_594034, "artifactName", newJString(artifactName))
  add(query_594035, "api-version", newJString(apiVersion))
  add(path_594034, "blueprintName", newJString(blueprintName))
  add(path_594034, "scope", newJString(scope))
  result = call_594033.call(path_594034, query_594035, nil, nil, nil)

var artifactsDelete* = Call_ArtifactsDelete_594025(name: "artifactsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/artifacts/{artifactName}",
    validator: validate_ArtifactsDelete_594026, base: "", url: url_ArtifactsDelete_594027,
    schemes: {Scheme.Https})
type
  Call_PublishedBlueprintsList_594036 = ref object of OpenApiRestCall_593425
proc url_PublishedBlueprintsList_594038(protocol: Scheme; host: string; base: string;
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

proc validate_PublishedBlueprintsList_594037(path: JsonNode; query: JsonNode;
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
  var valid_594039 = path.getOrDefault("blueprintName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "blueprintName", valid_594039
  var valid_594040 = path.getOrDefault("scope")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "scope", valid_594040
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594041 = query.getOrDefault("api-version")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "api-version", valid_594041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594042: Call_PublishedBlueprintsList_594036; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List published versions of given blueprint definition.
  ## 
  let valid = call_594042.validator(path, query, header, formData, body)
  let scheme = call_594042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594042.url(scheme.get, call_594042.host, call_594042.base,
                         call_594042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594042, url, valid)

proc call*(call_594043: Call_PublishedBlueprintsList_594036; apiVersion: string;
          blueprintName: string; scope: string): Recallable =
  ## publishedBlueprintsList
  ## List published versions of given blueprint definition.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   blueprintName: string (required)
  ##                : Name of the blueprint definition.
  ##   scope: string (required)
  ##        : The scope of the resource. Valid scopes are: management group (format: '/providers/Microsoft.Management/managementGroups/{managementGroup}'), subscription (format: '/subscriptions/{subscriptionId}'). For blueprint assignments management group scope is reserved for future use.
  var path_594044 = newJObject()
  var query_594045 = newJObject()
  add(query_594045, "api-version", newJString(apiVersion))
  add(path_594044, "blueprintName", newJString(blueprintName))
  add(path_594044, "scope", newJString(scope))
  result = call_594043.call(path_594044, query_594045, nil, nil, nil)

var publishedBlueprintsList* = Call_PublishedBlueprintsList_594036(
    name: "publishedBlueprintsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions",
    validator: validate_PublishedBlueprintsList_594037, base: "",
    url: url_PublishedBlueprintsList_594038, schemes: {Scheme.Https})
type
  Call_PublishedBlueprintsCreate_594057 = ref object of OpenApiRestCall_593425
proc url_PublishedBlueprintsCreate_594059(protocol: Scheme; host: string;
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

proc validate_PublishedBlueprintsCreate_594058(path: JsonNode; query: JsonNode;
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
  var valid_594060 = path.getOrDefault("versionId")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "versionId", valid_594060
  var valid_594061 = path.getOrDefault("blueprintName")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "blueprintName", valid_594061
  var valid_594062 = path.getOrDefault("scope")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "scope", valid_594062
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594063 = query.getOrDefault("api-version")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "api-version", valid_594063
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

proc call*(call_594065: Call_PublishedBlueprintsCreate_594057; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Publish a new version of the blueprint definition with the latest artifacts. Published blueprint definitions are immutable.
  ## 
  let valid = call_594065.validator(path, query, header, formData, body)
  let scheme = call_594065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594065.url(scheme.get, call_594065.host, call_594065.base,
                         call_594065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594065, url, valid)

proc call*(call_594066: Call_PublishedBlueprintsCreate_594057; versionId: string;
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
  var path_594067 = newJObject()
  var query_594068 = newJObject()
  var body_594069 = newJObject()
  add(path_594067, "versionId", newJString(versionId))
  add(query_594068, "api-version", newJString(apiVersion))
  if publishedBlueprint != nil:
    body_594069 = publishedBlueprint
  add(path_594067, "blueprintName", newJString(blueprintName))
  add(path_594067, "scope", newJString(scope))
  result = call_594066.call(path_594067, query_594068, nil, nil, body_594069)

var publishedBlueprintsCreate* = Call_PublishedBlueprintsCreate_594057(
    name: "publishedBlueprintsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions/{versionId}",
    validator: validate_PublishedBlueprintsCreate_594058, base: "",
    url: url_PublishedBlueprintsCreate_594059, schemes: {Scheme.Https})
type
  Call_PublishedBlueprintsGet_594046 = ref object of OpenApiRestCall_593425
proc url_PublishedBlueprintsGet_594048(protocol: Scheme; host: string; base: string;
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

proc validate_PublishedBlueprintsGet_594047(path: JsonNode; query: JsonNode;
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
  var valid_594049 = path.getOrDefault("versionId")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "versionId", valid_594049
  var valid_594050 = path.getOrDefault("blueprintName")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "blueprintName", valid_594050
  var valid_594051 = path.getOrDefault("scope")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "scope", valid_594051
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594052 = query.getOrDefault("api-version")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "api-version", valid_594052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594053: Call_PublishedBlueprintsGet_594046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a published version of a blueprint definition.
  ## 
  let valid = call_594053.validator(path, query, header, formData, body)
  let scheme = call_594053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594053.url(scheme.get, call_594053.host, call_594053.base,
                         call_594053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594053, url, valid)

proc call*(call_594054: Call_PublishedBlueprintsGet_594046; versionId: string;
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
  var path_594055 = newJObject()
  var query_594056 = newJObject()
  add(path_594055, "versionId", newJString(versionId))
  add(query_594056, "api-version", newJString(apiVersion))
  add(path_594055, "blueprintName", newJString(blueprintName))
  add(path_594055, "scope", newJString(scope))
  result = call_594054.call(path_594055, query_594056, nil, nil, nil)

var publishedBlueprintsGet* = Call_PublishedBlueprintsGet_594046(
    name: "publishedBlueprintsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions/{versionId}",
    validator: validate_PublishedBlueprintsGet_594047, base: "",
    url: url_PublishedBlueprintsGet_594048, schemes: {Scheme.Https})
type
  Call_PublishedBlueprintsDelete_594070 = ref object of OpenApiRestCall_593425
proc url_PublishedBlueprintsDelete_594072(protocol: Scheme; host: string;
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

proc validate_PublishedBlueprintsDelete_594071(path: JsonNode; query: JsonNode;
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
  var valid_594073 = path.getOrDefault("versionId")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "versionId", valid_594073
  var valid_594074 = path.getOrDefault("blueprintName")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "blueprintName", valid_594074
  var valid_594075 = path.getOrDefault("scope")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "scope", valid_594075
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594076 = query.getOrDefault("api-version")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "api-version", valid_594076
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594077: Call_PublishedBlueprintsDelete_594070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a published version of a blueprint definition.
  ## 
  let valid = call_594077.validator(path, query, header, formData, body)
  let scheme = call_594077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594077.url(scheme.get, call_594077.host, call_594077.base,
                         call_594077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594077, url, valid)

proc call*(call_594078: Call_PublishedBlueprintsDelete_594070; versionId: string;
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
  var path_594079 = newJObject()
  var query_594080 = newJObject()
  add(path_594079, "versionId", newJString(versionId))
  add(query_594080, "api-version", newJString(apiVersion))
  add(path_594079, "blueprintName", newJString(blueprintName))
  add(path_594079, "scope", newJString(scope))
  result = call_594078.call(path_594079, query_594080, nil, nil, nil)

var publishedBlueprintsDelete* = Call_PublishedBlueprintsDelete_594070(
    name: "publishedBlueprintsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions/{versionId}",
    validator: validate_PublishedBlueprintsDelete_594071, base: "",
    url: url_PublishedBlueprintsDelete_594072, schemes: {Scheme.Https})
type
  Call_PublishedArtifactsList_594081 = ref object of OpenApiRestCall_593425
proc url_PublishedArtifactsList_594083(protocol: Scheme; host: string; base: string;
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

proc validate_PublishedArtifactsList_594082(path: JsonNode; query: JsonNode;
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
  var valid_594084 = path.getOrDefault("versionId")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "versionId", valid_594084
  var valid_594085 = path.getOrDefault("blueprintName")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "blueprintName", valid_594085
  var valid_594086 = path.getOrDefault("scope")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "scope", valid_594086
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594087 = query.getOrDefault("api-version")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "api-version", valid_594087
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594088: Call_PublishedArtifactsList_594081; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifacts for a version of a published blueprint definition.
  ## 
  let valid = call_594088.validator(path, query, header, formData, body)
  let scheme = call_594088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594088.url(scheme.get, call_594088.host, call_594088.base,
                         call_594088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594088, url, valid)

proc call*(call_594089: Call_PublishedArtifactsList_594081; versionId: string;
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
  var path_594090 = newJObject()
  var query_594091 = newJObject()
  add(path_594090, "versionId", newJString(versionId))
  add(query_594091, "api-version", newJString(apiVersion))
  add(path_594090, "blueprintName", newJString(blueprintName))
  add(path_594090, "scope", newJString(scope))
  result = call_594089.call(path_594090, query_594091, nil, nil, nil)

var publishedArtifactsList* = Call_PublishedArtifactsList_594081(
    name: "publishedArtifactsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions/{versionId}/artifacts",
    validator: validate_PublishedArtifactsList_594082, base: "",
    url: url_PublishedArtifactsList_594083, schemes: {Scheme.Https})
type
  Call_PublishedArtifactsGet_594092 = ref object of OpenApiRestCall_593425
proc url_PublishedArtifactsGet_594094(protocol: Scheme; host: string; base: string;
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

proc validate_PublishedArtifactsGet_594093(path: JsonNode; query: JsonNode;
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
  var valid_594095 = path.getOrDefault("artifactName")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "artifactName", valid_594095
  var valid_594096 = path.getOrDefault("versionId")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "versionId", valid_594096
  var valid_594097 = path.getOrDefault("blueprintName")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "blueprintName", valid_594097
  var valid_594098 = path.getOrDefault("scope")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "scope", valid_594098
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594099 = query.getOrDefault("api-version")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "api-version", valid_594099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594100: Call_PublishedArtifactsGet_594092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an artifact for a published blueprint definition.
  ## 
  let valid = call_594100.validator(path, query, header, formData, body)
  let scheme = call_594100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594100.url(scheme.get, call_594100.host, call_594100.base,
                         call_594100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594100, url, valid)

proc call*(call_594101: Call_PublishedArtifactsGet_594092; artifactName: string;
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
  var path_594102 = newJObject()
  var query_594103 = newJObject()
  add(path_594102, "artifactName", newJString(artifactName))
  add(path_594102, "versionId", newJString(versionId))
  add(query_594103, "api-version", newJString(apiVersion))
  add(path_594102, "blueprintName", newJString(blueprintName))
  add(path_594102, "scope", newJString(scope))
  result = call_594101.call(path_594102, query_594103, nil, nil, nil)

var publishedArtifactsGet* = Call_PublishedArtifactsGet_594092(
    name: "publishedArtifactsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions/{versionId}/artifacts/{artifactName}",
    validator: validate_PublishedArtifactsGet_594093, base: "",
    url: url_PublishedArtifactsGet_594094, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
