
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
  Call_OperationsList_574680 = ref object of OpenApiRestCall_574458
proc url_OperationsList_574682(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_574681(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## List all of the available operations the Blueprint resource provider supports.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_574864: Call_OperationsList_574680; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all of the available operations the Blueprint resource provider supports.
  ## 
  let valid = call_574864.validator(path, query, header, formData, body)
  let scheme = call_574864.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574864.url(scheme.get, call_574864.host, call_574864.base,
                         call_574864.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574864, url, valid)

proc call*(call_574935: Call_OperationsList_574680; apiVersion: string): Recallable =
  ## operationsList
  ## List all of the available operations the Blueprint resource provider supports.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_574936 = newJObject()
  add(query_574936, "api-version", newJString(apiVersion))
  result = call_574935.call(nil, query_574936, nil, nil, nil)

var operationsList* = Call_OperationsList_574680(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Blueprint/operations",
    validator: validate_OperationsList_574681, base: "", url: url_OperationsList_574682,
    schemes: {Scheme.Https})
type
  Call_BlueprintsList_574976 = ref object of OpenApiRestCall_574458
proc url_BlueprintsList_574978(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupName" in path,
        "`managementGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Blueprint/blueprints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlueprintsList_574977(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## List Blueprint definitions within a Management Group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupName: JString (required)
  ##                      : ManagementGroup where blueprint stores.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managementGroupName` field"
  var valid_574993 = path.getOrDefault("managementGroupName")
  valid_574993 = validateParameter(valid_574993, JString, required = true,
                                 default = nil)
  if valid_574993 != nil:
    section.add "managementGroupName", valid_574993
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574994 = query.getOrDefault("api-version")
  valid_574994 = validateParameter(valid_574994, JString, required = true,
                                 default = nil)
  if valid_574994 != nil:
    section.add "api-version", valid_574994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574995: Call_BlueprintsList_574976; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List Blueprint definitions within a Management Group.
  ## 
  let valid = call_574995.validator(path, query, header, formData, body)
  let scheme = call_574995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574995.url(scheme.get, call_574995.host, call_574995.base,
                         call_574995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574995, url, valid)

proc call*(call_574996: Call_BlueprintsList_574976; managementGroupName: string;
          apiVersion: string): Recallable =
  ## blueprintsList
  ## List Blueprint definitions within a Management Group.
  ##   managementGroupName: string (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var path_574997 = newJObject()
  var query_574998 = newJObject()
  add(path_574997, "managementGroupName", newJString(managementGroupName))
  add(query_574998, "api-version", newJString(apiVersion))
  result = call_574996.call(path_574997, query_574998, nil, nil, nil)

var blueprintsList* = Call_BlueprintsList_574976(name: "blueprintsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints",
    validator: validate_BlueprintsList_574977, base: "", url: url_BlueprintsList_574978,
    schemes: {Scheme.Https})
type
  Call_BlueprintsCreateOrUpdate_575009 = ref object of OpenApiRestCall_574458
proc url_BlueprintsCreateOrUpdate_575011(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupName" in path,
        "`managementGroupName` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlueprintsCreateOrUpdate_575010(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update Blueprint definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupName: JString (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   blueprintName: JString (required)
  ##                : name of the blueprint.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managementGroupName` field"
  var valid_575012 = path.getOrDefault("managementGroupName")
  valid_575012 = validateParameter(valid_575012, JString, required = true,
                                 default = nil)
  if valid_575012 != nil:
    section.add "managementGroupName", valid_575012
  var valid_575013 = path.getOrDefault("blueprintName")
  valid_575013 = validateParameter(valid_575013, JString, required = true,
                                 default = nil)
  if valid_575013 != nil:
    section.add "blueprintName", valid_575013
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575014 = query.getOrDefault("api-version")
  valid_575014 = validateParameter(valid_575014, JString, required = true,
                                 default = nil)
  if valid_575014 != nil:
    section.add "api-version", valid_575014
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

proc call*(call_575016: Call_BlueprintsCreateOrUpdate_575009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update Blueprint definition.
  ## 
  let valid = call_575016.validator(path, query, header, formData, body)
  let scheme = call_575016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575016.url(scheme.get, call_575016.host, call_575016.base,
                         call_575016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575016, url, valid)

proc call*(call_575017: Call_BlueprintsCreateOrUpdate_575009;
          managementGroupName: string; apiVersion: string; blueprintName: string;
          blueprint: JsonNode): Recallable =
  ## blueprintsCreateOrUpdate
  ## Create or update Blueprint definition.
  ##   managementGroupName: string (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   blueprintName: string (required)
  ##                : name of the blueprint.
  ##   blueprint: JObject (required)
  ##            : Blueprint definition.
  var path_575018 = newJObject()
  var query_575019 = newJObject()
  var body_575020 = newJObject()
  add(path_575018, "managementGroupName", newJString(managementGroupName))
  add(query_575019, "api-version", newJString(apiVersion))
  add(path_575018, "blueprintName", newJString(blueprintName))
  if blueprint != nil:
    body_575020 = blueprint
  result = call_575017.call(path_575018, query_575019, nil, nil, body_575020)

var blueprintsCreateOrUpdate* = Call_BlueprintsCreateOrUpdate_575009(
    name: "blueprintsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}",
    validator: validate_BlueprintsCreateOrUpdate_575010, base: "",
    url: url_BlueprintsCreateOrUpdate_575011, schemes: {Scheme.Https})
type
  Call_BlueprintsGet_574999 = ref object of OpenApiRestCall_574458
proc url_BlueprintsGet_575001(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupName" in path,
        "`managementGroupName` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlueprintsGet_575000(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a blueprint definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupName: JString (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   blueprintName: JString (required)
  ##                : name of the blueprint.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managementGroupName` field"
  var valid_575002 = path.getOrDefault("managementGroupName")
  valid_575002 = validateParameter(valid_575002, JString, required = true,
                                 default = nil)
  if valid_575002 != nil:
    section.add "managementGroupName", valid_575002
  var valid_575003 = path.getOrDefault("blueprintName")
  valid_575003 = validateParameter(valid_575003, JString, required = true,
                                 default = nil)
  if valid_575003 != nil:
    section.add "blueprintName", valid_575003
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575004 = query.getOrDefault("api-version")
  valid_575004 = validateParameter(valid_575004, JString, required = true,
                                 default = nil)
  if valid_575004 != nil:
    section.add "api-version", valid_575004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575005: Call_BlueprintsGet_574999; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a blueprint definition.
  ## 
  let valid = call_575005.validator(path, query, header, formData, body)
  let scheme = call_575005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575005.url(scheme.get, call_575005.host, call_575005.base,
                         call_575005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575005, url, valid)

proc call*(call_575006: Call_BlueprintsGet_574999; managementGroupName: string;
          apiVersion: string; blueprintName: string): Recallable =
  ## blueprintsGet
  ## Get a blueprint definition.
  ##   managementGroupName: string (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   blueprintName: string (required)
  ##                : name of the blueprint.
  var path_575007 = newJObject()
  var query_575008 = newJObject()
  add(path_575007, "managementGroupName", newJString(managementGroupName))
  add(query_575008, "api-version", newJString(apiVersion))
  add(path_575007, "blueprintName", newJString(blueprintName))
  result = call_575006.call(path_575007, query_575008, nil, nil, nil)

var blueprintsGet* = Call_BlueprintsGet_574999(name: "blueprintsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}",
    validator: validate_BlueprintsGet_575000, base: "", url: url_BlueprintsGet_575001,
    schemes: {Scheme.Https})
type
  Call_BlueprintsDelete_575021 = ref object of OpenApiRestCall_574458
proc url_BlueprintsDelete_575023(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupName" in path,
        "`managementGroupName` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlueprintsDelete_575022(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Delete a blueprint definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupName: JString (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   blueprintName: JString (required)
  ##                : name of the blueprint.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managementGroupName` field"
  var valid_575024 = path.getOrDefault("managementGroupName")
  valid_575024 = validateParameter(valid_575024, JString, required = true,
                                 default = nil)
  if valid_575024 != nil:
    section.add "managementGroupName", valid_575024
  var valid_575025 = path.getOrDefault("blueprintName")
  valid_575025 = validateParameter(valid_575025, JString, required = true,
                                 default = nil)
  if valid_575025 != nil:
    section.add "blueprintName", valid_575025
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575026 = query.getOrDefault("api-version")
  valid_575026 = validateParameter(valid_575026, JString, required = true,
                                 default = nil)
  if valid_575026 != nil:
    section.add "api-version", valid_575026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575027: Call_BlueprintsDelete_575021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a blueprint definition.
  ## 
  let valid = call_575027.validator(path, query, header, formData, body)
  let scheme = call_575027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575027.url(scheme.get, call_575027.host, call_575027.base,
                         call_575027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575027, url, valid)

proc call*(call_575028: Call_BlueprintsDelete_575021; managementGroupName: string;
          apiVersion: string; blueprintName: string): Recallable =
  ## blueprintsDelete
  ## Delete a blueprint definition.
  ##   managementGroupName: string (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   blueprintName: string (required)
  ##                : name of the blueprint.
  var path_575029 = newJObject()
  var query_575030 = newJObject()
  add(path_575029, "managementGroupName", newJString(managementGroupName))
  add(query_575030, "api-version", newJString(apiVersion))
  add(path_575029, "blueprintName", newJString(blueprintName))
  result = call_575028.call(path_575029, query_575030, nil, nil, nil)

var blueprintsDelete* = Call_BlueprintsDelete_575021(name: "blueprintsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}",
    validator: validate_BlueprintsDelete_575022, base: "",
    url: url_BlueprintsDelete_575023, schemes: {Scheme.Https})
type
  Call_ArtifactsList_575031 = ref object of OpenApiRestCall_574458
proc url_ArtifactsList_575033(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupName" in path,
        "`managementGroupName` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName"),
               (kind: ConstantSegment, value: "/artifacts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsList_575032(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## List artifacts for a given Blueprint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupName: JString (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   blueprintName: JString (required)
  ##                : name of the blueprint.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managementGroupName` field"
  var valid_575034 = path.getOrDefault("managementGroupName")
  valid_575034 = validateParameter(valid_575034, JString, required = true,
                                 default = nil)
  if valid_575034 != nil:
    section.add "managementGroupName", valid_575034
  var valid_575035 = path.getOrDefault("blueprintName")
  valid_575035 = validateParameter(valid_575035, JString, required = true,
                                 default = nil)
  if valid_575035 != nil:
    section.add "blueprintName", valid_575035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575036 = query.getOrDefault("api-version")
  valid_575036 = validateParameter(valid_575036, JString, required = true,
                                 default = nil)
  if valid_575036 != nil:
    section.add "api-version", valid_575036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575037: Call_ArtifactsList_575031; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifacts for a given Blueprint.
  ## 
  let valid = call_575037.validator(path, query, header, formData, body)
  let scheme = call_575037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575037.url(scheme.get, call_575037.host, call_575037.base,
                         call_575037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575037, url, valid)

proc call*(call_575038: Call_ArtifactsList_575031; managementGroupName: string;
          apiVersion: string; blueprintName: string): Recallable =
  ## artifactsList
  ## List artifacts for a given Blueprint.
  ##   managementGroupName: string (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   blueprintName: string (required)
  ##                : name of the blueprint.
  var path_575039 = newJObject()
  var query_575040 = newJObject()
  add(path_575039, "managementGroupName", newJString(managementGroupName))
  add(query_575040, "api-version", newJString(apiVersion))
  add(path_575039, "blueprintName", newJString(blueprintName))
  result = call_575038.call(path_575039, query_575040, nil, nil, nil)

var artifactsList* = Call_ArtifactsList_575031(name: "artifactsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/artifacts",
    validator: validate_ArtifactsList_575032, base: "", url: url_ArtifactsList_575033,
    schemes: {Scheme.Https})
type
  Call_ArtifactsCreateOrUpdate_575052 = ref object of OpenApiRestCall_574458
proc url_ArtifactsCreateOrUpdate_575054(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupName" in path,
        "`managementGroupName` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  assert "artifactName" in path, "`artifactName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "artifactName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsCreateOrUpdate_575053(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update Blueprint artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   artifactName: JString (required)
  ##               : name of the artifact.
  ##   managementGroupName: JString (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   blueprintName: JString (required)
  ##                : name of the blueprint.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `artifactName` field"
  var valid_575055 = path.getOrDefault("artifactName")
  valid_575055 = validateParameter(valid_575055, JString, required = true,
                                 default = nil)
  if valid_575055 != nil:
    section.add "artifactName", valid_575055
  var valid_575056 = path.getOrDefault("managementGroupName")
  valid_575056 = validateParameter(valid_575056, JString, required = true,
                                 default = nil)
  if valid_575056 != nil:
    section.add "managementGroupName", valid_575056
  var valid_575057 = path.getOrDefault("blueprintName")
  valid_575057 = validateParameter(valid_575057, JString, required = true,
                                 default = nil)
  if valid_575057 != nil:
    section.add "blueprintName", valid_575057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575058 = query.getOrDefault("api-version")
  valid_575058 = validateParameter(valid_575058, JString, required = true,
                                 default = nil)
  if valid_575058 != nil:
    section.add "api-version", valid_575058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   artifact: JObject (required)
  ##           : Blueprint artifact to save.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575060: Call_ArtifactsCreateOrUpdate_575052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update Blueprint artifact.
  ## 
  let valid = call_575060.validator(path, query, header, formData, body)
  let scheme = call_575060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575060.url(scheme.get, call_575060.host, call_575060.base,
                         call_575060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575060, url, valid)

proc call*(call_575061: Call_ArtifactsCreateOrUpdate_575052; artifactName: string;
          managementGroupName: string; artifact: JsonNode; apiVersion: string;
          blueprintName: string): Recallable =
  ## artifactsCreateOrUpdate
  ## Create or update Blueprint artifact.
  ##   artifactName: string (required)
  ##               : name of the artifact.
  ##   managementGroupName: string (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   artifact: JObject (required)
  ##           : Blueprint artifact to save.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   blueprintName: string (required)
  ##                : name of the blueprint.
  var path_575062 = newJObject()
  var query_575063 = newJObject()
  var body_575064 = newJObject()
  add(path_575062, "artifactName", newJString(artifactName))
  add(path_575062, "managementGroupName", newJString(managementGroupName))
  if artifact != nil:
    body_575064 = artifact
  add(query_575063, "api-version", newJString(apiVersion))
  add(path_575062, "blueprintName", newJString(blueprintName))
  result = call_575061.call(path_575062, query_575063, nil, nil, body_575064)

var artifactsCreateOrUpdate* = Call_ArtifactsCreateOrUpdate_575052(
    name: "artifactsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/artifacts/{artifactName}",
    validator: validate_ArtifactsCreateOrUpdate_575053, base: "",
    url: url_ArtifactsCreateOrUpdate_575054, schemes: {Scheme.Https})
type
  Call_ArtifactsGet_575041 = ref object of OpenApiRestCall_574458
proc url_ArtifactsGet_575043(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupName" in path,
        "`managementGroupName` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  assert "artifactName" in path, "`artifactName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "artifactName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsGet_575042(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a Blueprint artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   artifactName: JString (required)
  ##               : name of the artifact.
  ##   managementGroupName: JString (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   blueprintName: JString (required)
  ##                : name of the blueprint.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `artifactName` field"
  var valid_575044 = path.getOrDefault("artifactName")
  valid_575044 = validateParameter(valid_575044, JString, required = true,
                                 default = nil)
  if valid_575044 != nil:
    section.add "artifactName", valid_575044
  var valid_575045 = path.getOrDefault("managementGroupName")
  valid_575045 = validateParameter(valid_575045, JString, required = true,
                                 default = nil)
  if valid_575045 != nil:
    section.add "managementGroupName", valid_575045
  var valid_575046 = path.getOrDefault("blueprintName")
  valid_575046 = validateParameter(valid_575046, JString, required = true,
                                 default = nil)
  if valid_575046 != nil:
    section.add "blueprintName", valid_575046
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575047 = query.getOrDefault("api-version")
  valid_575047 = validateParameter(valid_575047, JString, required = true,
                                 default = nil)
  if valid_575047 != nil:
    section.add "api-version", valid_575047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575048: Call_ArtifactsGet_575041; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Blueprint artifact.
  ## 
  let valid = call_575048.validator(path, query, header, formData, body)
  let scheme = call_575048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575048.url(scheme.get, call_575048.host, call_575048.base,
                         call_575048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575048, url, valid)

proc call*(call_575049: Call_ArtifactsGet_575041; artifactName: string;
          managementGroupName: string; apiVersion: string; blueprintName: string): Recallable =
  ## artifactsGet
  ## Get a Blueprint artifact.
  ##   artifactName: string (required)
  ##               : name of the artifact.
  ##   managementGroupName: string (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   blueprintName: string (required)
  ##                : name of the blueprint.
  var path_575050 = newJObject()
  var query_575051 = newJObject()
  add(path_575050, "artifactName", newJString(artifactName))
  add(path_575050, "managementGroupName", newJString(managementGroupName))
  add(query_575051, "api-version", newJString(apiVersion))
  add(path_575050, "blueprintName", newJString(blueprintName))
  result = call_575049.call(path_575050, query_575051, nil, nil, nil)

var artifactsGet* = Call_ArtifactsGet_575041(name: "artifactsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/artifacts/{artifactName}",
    validator: validate_ArtifactsGet_575042, base: "", url: url_ArtifactsGet_575043,
    schemes: {Scheme.Https})
type
  Call_ArtifactsDelete_575065 = ref object of OpenApiRestCall_574458
proc url_ArtifactsDelete_575067(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupName" in path,
        "`managementGroupName` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  assert "artifactName" in path, "`artifactName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "artifactName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ArtifactsDelete_575066(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Delete a Blueprint artifact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   artifactName: JString (required)
  ##               : name of the artifact.
  ##   managementGroupName: JString (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   blueprintName: JString (required)
  ##                : name of the blueprint.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `artifactName` field"
  var valid_575068 = path.getOrDefault("artifactName")
  valid_575068 = validateParameter(valid_575068, JString, required = true,
                                 default = nil)
  if valid_575068 != nil:
    section.add "artifactName", valid_575068
  var valid_575069 = path.getOrDefault("managementGroupName")
  valid_575069 = validateParameter(valid_575069, JString, required = true,
                                 default = nil)
  if valid_575069 != nil:
    section.add "managementGroupName", valid_575069
  var valid_575070 = path.getOrDefault("blueprintName")
  valid_575070 = validateParameter(valid_575070, JString, required = true,
                                 default = nil)
  if valid_575070 != nil:
    section.add "blueprintName", valid_575070
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575071 = query.getOrDefault("api-version")
  valid_575071 = validateParameter(valid_575071, JString, required = true,
                                 default = nil)
  if valid_575071 != nil:
    section.add "api-version", valid_575071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575072: Call_ArtifactsDelete_575065; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Blueprint artifact.
  ## 
  let valid = call_575072.validator(path, query, header, formData, body)
  let scheme = call_575072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575072.url(scheme.get, call_575072.host, call_575072.base,
                         call_575072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575072, url, valid)

proc call*(call_575073: Call_ArtifactsDelete_575065; artifactName: string;
          managementGroupName: string; apiVersion: string; blueprintName: string): Recallable =
  ## artifactsDelete
  ## Delete a Blueprint artifact.
  ##   artifactName: string (required)
  ##               : name of the artifact.
  ##   managementGroupName: string (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   blueprintName: string (required)
  ##                : name of the blueprint.
  var path_575074 = newJObject()
  var query_575075 = newJObject()
  add(path_575074, "artifactName", newJString(artifactName))
  add(path_575074, "managementGroupName", newJString(managementGroupName))
  add(query_575075, "api-version", newJString(apiVersion))
  add(path_575074, "blueprintName", newJString(blueprintName))
  result = call_575073.call(path_575074, query_575075, nil, nil, nil)

var artifactsDelete* = Call_ArtifactsDelete_575065(name: "artifactsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/artifacts/{artifactName}",
    validator: validate_ArtifactsDelete_575066, base: "", url: url_ArtifactsDelete_575067,
    schemes: {Scheme.Https})
type
  Call_PublishedBlueprintsList_575076 = ref object of OpenApiRestCall_574458
proc url_PublishedBlueprintsList_575078(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupName" in path,
        "`managementGroupName` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublishedBlueprintsList_575077(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List published versions of given Blueprint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupName: JString (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   blueprintName: JString (required)
  ##                : name of the blueprint.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managementGroupName` field"
  var valid_575079 = path.getOrDefault("managementGroupName")
  valid_575079 = validateParameter(valid_575079, JString, required = true,
                                 default = nil)
  if valid_575079 != nil:
    section.add "managementGroupName", valid_575079
  var valid_575080 = path.getOrDefault("blueprintName")
  valid_575080 = validateParameter(valid_575080, JString, required = true,
                                 default = nil)
  if valid_575080 != nil:
    section.add "blueprintName", valid_575080
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575081 = query.getOrDefault("api-version")
  valid_575081 = validateParameter(valid_575081, JString, required = true,
                                 default = nil)
  if valid_575081 != nil:
    section.add "api-version", valid_575081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575082: Call_PublishedBlueprintsList_575076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List published versions of given Blueprint.
  ## 
  let valid = call_575082.validator(path, query, header, formData, body)
  let scheme = call_575082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575082.url(scheme.get, call_575082.host, call_575082.base,
                         call_575082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575082, url, valid)

proc call*(call_575083: Call_PublishedBlueprintsList_575076;
          managementGroupName: string; apiVersion: string; blueprintName: string): Recallable =
  ## publishedBlueprintsList
  ## List published versions of given Blueprint.
  ##   managementGroupName: string (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   blueprintName: string (required)
  ##                : name of the blueprint.
  var path_575084 = newJObject()
  var query_575085 = newJObject()
  add(path_575084, "managementGroupName", newJString(managementGroupName))
  add(query_575085, "api-version", newJString(apiVersion))
  add(path_575084, "blueprintName", newJString(blueprintName))
  result = call_575083.call(path_575084, query_575085, nil, nil, nil)

var publishedBlueprintsList* = Call_PublishedBlueprintsList_575076(
    name: "publishedBlueprintsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions",
    validator: validate_PublishedBlueprintsList_575077, base: "",
    url: url_PublishedBlueprintsList_575078, schemes: {Scheme.Https})
type
  Call_PublishedBlueprintsCreate_575097 = ref object of OpenApiRestCall_574458
proc url_PublishedBlueprintsCreate_575099(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupName" in path,
        "`managementGroupName` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublishedBlueprintsCreate_575098(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Publish a new version of the Blueprint with the latest artifacts. Published Blueprints are immutable.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupName: JString (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   versionId: JString (required)
  ##            : version of the published blueprint.
  ##   blueprintName: JString (required)
  ##                : name of the blueprint.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managementGroupName` field"
  var valid_575100 = path.getOrDefault("managementGroupName")
  valid_575100 = validateParameter(valid_575100, JString, required = true,
                                 default = nil)
  if valid_575100 != nil:
    section.add "managementGroupName", valid_575100
  var valid_575101 = path.getOrDefault("versionId")
  valid_575101 = validateParameter(valid_575101, JString, required = true,
                                 default = nil)
  if valid_575101 != nil:
    section.add "versionId", valid_575101
  var valid_575102 = path.getOrDefault("blueprintName")
  valid_575102 = validateParameter(valid_575102, JString, required = true,
                                 default = nil)
  if valid_575102 != nil:
    section.add "blueprintName", valid_575102
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575103 = query.getOrDefault("api-version")
  valid_575103 = validateParameter(valid_575103, JString, required = true,
                                 default = nil)
  if valid_575103 != nil:
    section.add "api-version", valid_575103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575104: Call_PublishedBlueprintsCreate_575097; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Publish a new version of the Blueprint with the latest artifacts. Published Blueprints are immutable.
  ## 
  let valid = call_575104.validator(path, query, header, formData, body)
  let scheme = call_575104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575104.url(scheme.get, call_575104.host, call_575104.base,
                         call_575104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575104, url, valid)

proc call*(call_575105: Call_PublishedBlueprintsCreate_575097;
          managementGroupName: string; versionId: string; apiVersion: string;
          blueprintName: string): Recallable =
  ## publishedBlueprintsCreate
  ## Publish a new version of the Blueprint with the latest artifacts. Published Blueprints are immutable.
  ##   managementGroupName: string (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   versionId: string (required)
  ##            : version of the published blueprint.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   blueprintName: string (required)
  ##                : name of the blueprint.
  var path_575106 = newJObject()
  var query_575107 = newJObject()
  add(path_575106, "managementGroupName", newJString(managementGroupName))
  add(path_575106, "versionId", newJString(versionId))
  add(query_575107, "api-version", newJString(apiVersion))
  add(path_575106, "blueprintName", newJString(blueprintName))
  result = call_575105.call(path_575106, query_575107, nil, nil, nil)

var publishedBlueprintsCreate* = Call_PublishedBlueprintsCreate_575097(
    name: "publishedBlueprintsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions/{versionId}",
    validator: validate_PublishedBlueprintsCreate_575098, base: "",
    url: url_PublishedBlueprintsCreate_575099, schemes: {Scheme.Https})
type
  Call_PublishedBlueprintsGet_575086 = ref object of OpenApiRestCall_574458
proc url_PublishedBlueprintsGet_575088(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupName" in path,
        "`managementGroupName` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublishedBlueprintsGet_575087(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a published Blueprint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupName: JString (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   versionId: JString (required)
  ##            : version of the published blueprint.
  ##   blueprintName: JString (required)
  ##                : name of the blueprint.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managementGroupName` field"
  var valid_575089 = path.getOrDefault("managementGroupName")
  valid_575089 = validateParameter(valid_575089, JString, required = true,
                                 default = nil)
  if valid_575089 != nil:
    section.add "managementGroupName", valid_575089
  var valid_575090 = path.getOrDefault("versionId")
  valid_575090 = validateParameter(valid_575090, JString, required = true,
                                 default = nil)
  if valid_575090 != nil:
    section.add "versionId", valid_575090
  var valid_575091 = path.getOrDefault("blueprintName")
  valid_575091 = validateParameter(valid_575091, JString, required = true,
                                 default = nil)
  if valid_575091 != nil:
    section.add "blueprintName", valid_575091
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575092 = query.getOrDefault("api-version")
  valid_575092 = validateParameter(valid_575092, JString, required = true,
                                 default = nil)
  if valid_575092 != nil:
    section.add "api-version", valid_575092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575093: Call_PublishedBlueprintsGet_575086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a published Blueprint.
  ## 
  let valid = call_575093.validator(path, query, header, formData, body)
  let scheme = call_575093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575093.url(scheme.get, call_575093.host, call_575093.base,
                         call_575093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575093, url, valid)

proc call*(call_575094: Call_PublishedBlueprintsGet_575086;
          managementGroupName: string; versionId: string; apiVersion: string;
          blueprintName: string): Recallable =
  ## publishedBlueprintsGet
  ## Get a published Blueprint.
  ##   managementGroupName: string (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   versionId: string (required)
  ##            : version of the published blueprint.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   blueprintName: string (required)
  ##                : name of the blueprint.
  var path_575095 = newJObject()
  var query_575096 = newJObject()
  add(path_575095, "managementGroupName", newJString(managementGroupName))
  add(path_575095, "versionId", newJString(versionId))
  add(query_575096, "api-version", newJString(apiVersion))
  add(path_575095, "blueprintName", newJString(blueprintName))
  result = call_575094.call(path_575095, query_575096, nil, nil, nil)

var publishedBlueprintsGet* = Call_PublishedBlueprintsGet_575086(
    name: "publishedBlueprintsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions/{versionId}",
    validator: validate_PublishedBlueprintsGet_575087, base: "",
    url: url_PublishedBlueprintsGet_575088, schemes: {Scheme.Https})
type
  Call_PublishedBlueprintsDelete_575108 = ref object of OpenApiRestCall_574458
proc url_PublishedBlueprintsDelete_575110(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupName" in path,
        "`managementGroupName` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublishedBlueprintsDelete_575109(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a published Blueprint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupName: JString (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   versionId: JString (required)
  ##            : version of the published blueprint.
  ##   blueprintName: JString (required)
  ##                : name of the blueprint.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managementGroupName` field"
  var valid_575111 = path.getOrDefault("managementGroupName")
  valid_575111 = validateParameter(valid_575111, JString, required = true,
                                 default = nil)
  if valid_575111 != nil:
    section.add "managementGroupName", valid_575111
  var valid_575112 = path.getOrDefault("versionId")
  valid_575112 = validateParameter(valid_575112, JString, required = true,
                                 default = nil)
  if valid_575112 != nil:
    section.add "versionId", valid_575112
  var valid_575113 = path.getOrDefault("blueprintName")
  valid_575113 = validateParameter(valid_575113, JString, required = true,
                                 default = nil)
  if valid_575113 != nil:
    section.add "blueprintName", valid_575113
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575114 = query.getOrDefault("api-version")
  valid_575114 = validateParameter(valid_575114, JString, required = true,
                                 default = nil)
  if valid_575114 != nil:
    section.add "api-version", valid_575114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575115: Call_PublishedBlueprintsDelete_575108; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a published Blueprint.
  ## 
  let valid = call_575115.validator(path, query, header, formData, body)
  let scheme = call_575115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575115.url(scheme.get, call_575115.host, call_575115.base,
                         call_575115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575115, url, valid)

proc call*(call_575116: Call_PublishedBlueprintsDelete_575108;
          managementGroupName: string; versionId: string; apiVersion: string;
          blueprintName: string): Recallable =
  ## publishedBlueprintsDelete
  ## Delete a published Blueprint.
  ##   managementGroupName: string (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   versionId: string (required)
  ##            : version of the published blueprint.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   blueprintName: string (required)
  ##                : name of the blueprint.
  var path_575117 = newJObject()
  var query_575118 = newJObject()
  add(path_575117, "managementGroupName", newJString(managementGroupName))
  add(path_575117, "versionId", newJString(versionId))
  add(query_575118, "api-version", newJString(apiVersion))
  add(path_575117, "blueprintName", newJString(blueprintName))
  result = call_575116.call(path_575117, query_575118, nil, nil, nil)

var publishedBlueprintsDelete* = Call_PublishedBlueprintsDelete_575108(
    name: "publishedBlueprintsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions/{versionId}",
    validator: validate_PublishedBlueprintsDelete_575109, base: "",
    url: url_PublishedBlueprintsDelete_575110, schemes: {Scheme.Https})
type
  Call_PublishedArtifactsList_575119 = ref object of OpenApiRestCall_574458
proc url_PublishedArtifactsList_575121(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupName" in path,
        "`managementGroupName` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/artifacts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublishedArtifactsList_575120(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List artifacts for a published Blueprint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupName: JString (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   versionId: JString (required)
  ##            : version of the published blueprint.
  ##   blueprintName: JString (required)
  ##                : name of the blueprint.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managementGroupName` field"
  var valid_575122 = path.getOrDefault("managementGroupName")
  valid_575122 = validateParameter(valid_575122, JString, required = true,
                                 default = nil)
  if valid_575122 != nil:
    section.add "managementGroupName", valid_575122
  var valid_575123 = path.getOrDefault("versionId")
  valid_575123 = validateParameter(valid_575123, JString, required = true,
                                 default = nil)
  if valid_575123 != nil:
    section.add "versionId", valid_575123
  var valid_575124 = path.getOrDefault("blueprintName")
  valid_575124 = validateParameter(valid_575124, JString, required = true,
                                 default = nil)
  if valid_575124 != nil:
    section.add "blueprintName", valid_575124
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575125 = query.getOrDefault("api-version")
  valid_575125 = validateParameter(valid_575125, JString, required = true,
                                 default = nil)
  if valid_575125 != nil:
    section.add "api-version", valid_575125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575126: Call_PublishedArtifactsList_575119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifacts for a published Blueprint.
  ## 
  let valid = call_575126.validator(path, query, header, formData, body)
  let scheme = call_575126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575126.url(scheme.get, call_575126.host, call_575126.base,
                         call_575126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575126, url, valid)

proc call*(call_575127: Call_PublishedArtifactsList_575119;
          managementGroupName: string; versionId: string; apiVersion: string;
          blueprintName: string): Recallable =
  ## publishedArtifactsList
  ## List artifacts for a published Blueprint.
  ##   managementGroupName: string (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   versionId: string (required)
  ##            : version of the published blueprint.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   blueprintName: string (required)
  ##                : name of the blueprint.
  var path_575128 = newJObject()
  var query_575129 = newJObject()
  add(path_575128, "managementGroupName", newJString(managementGroupName))
  add(path_575128, "versionId", newJString(versionId))
  add(query_575129, "api-version", newJString(apiVersion))
  add(path_575128, "blueprintName", newJString(blueprintName))
  result = call_575127.call(path_575128, query_575129, nil, nil, nil)

var publishedArtifactsList* = Call_PublishedArtifactsList_575119(
    name: "publishedArtifactsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions/{versionId}/artifacts",
    validator: validate_PublishedArtifactsList_575120, base: "",
    url: url_PublishedArtifactsList_575121, schemes: {Scheme.Https})
type
  Call_PublishedArtifactsGet_575130 = ref object of OpenApiRestCall_574458
proc url_PublishedArtifactsGet_575132(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupName" in path,
        "`managementGroupName` is a required path parameter"
  assert "blueprintName" in path, "`blueprintName` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  assert "artifactName" in path, "`artifactName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Management/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Blueprint/blueprints/"),
               (kind: VariableSegment, value: "blueprintName"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/artifacts/"),
               (kind: VariableSegment, value: "artifactName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublishedArtifactsGet_575131(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an artifact for a published Blueprint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   artifactName: JString (required)
  ##               : name of the artifact.
  ##   managementGroupName: JString (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   versionId: JString (required)
  ##            : version of the published blueprint.
  ##   blueprintName: JString (required)
  ##                : name of the blueprint.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `artifactName` field"
  var valid_575133 = path.getOrDefault("artifactName")
  valid_575133 = validateParameter(valid_575133, JString, required = true,
                                 default = nil)
  if valid_575133 != nil:
    section.add "artifactName", valid_575133
  var valid_575134 = path.getOrDefault("managementGroupName")
  valid_575134 = validateParameter(valid_575134, JString, required = true,
                                 default = nil)
  if valid_575134 != nil:
    section.add "managementGroupName", valid_575134
  var valid_575135 = path.getOrDefault("versionId")
  valid_575135 = validateParameter(valid_575135, JString, required = true,
                                 default = nil)
  if valid_575135 != nil:
    section.add "versionId", valid_575135
  var valid_575136 = path.getOrDefault("blueprintName")
  valid_575136 = validateParameter(valid_575136, JString, required = true,
                                 default = nil)
  if valid_575136 != nil:
    section.add "blueprintName", valid_575136
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575137 = query.getOrDefault("api-version")
  valid_575137 = validateParameter(valid_575137, JString, required = true,
                                 default = nil)
  if valid_575137 != nil:
    section.add "api-version", valid_575137
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575138: Call_PublishedArtifactsGet_575130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an artifact for a published Blueprint.
  ## 
  let valid = call_575138.validator(path, query, header, formData, body)
  let scheme = call_575138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575138.url(scheme.get, call_575138.host, call_575138.base,
                         call_575138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575138, url, valid)

proc call*(call_575139: Call_PublishedArtifactsGet_575130; artifactName: string;
          managementGroupName: string; versionId: string; apiVersion: string;
          blueprintName: string): Recallable =
  ## publishedArtifactsGet
  ## Get an artifact for a published Blueprint.
  ##   artifactName: string (required)
  ##               : name of the artifact.
  ##   managementGroupName: string (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   versionId: string (required)
  ##            : version of the published blueprint.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   blueprintName: string (required)
  ##                : name of the blueprint.
  var path_575140 = newJObject()
  var query_575141 = newJObject()
  add(path_575140, "artifactName", newJString(artifactName))
  add(path_575140, "managementGroupName", newJString(managementGroupName))
  add(path_575140, "versionId", newJString(versionId))
  add(query_575141, "api-version", newJString(apiVersion))
  add(path_575140, "blueprintName", newJString(blueprintName))
  result = call_575139.call(path_575140, query_575141, nil, nil, nil)

var publishedArtifactsGet* = Call_PublishedArtifactsGet_575130(
    name: "publishedArtifactsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions/{versionId}/artifacts/{artifactName}",
    validator: validate_PublishedArtifactsGet_575131, base: "",
    url: url_PublishedArtifactsGet_575132, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
