
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  Call_OperationsList_593647 = ref object of OpenApiRestCall_593425
proc url_OperationsList_593649(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593648(path: JsonNode; query: JsonNode;
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

proc call*(call_593831: Call_OperationsList_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all of the available operations the Blueprint resource provider supports.
  ## 
  let valid = call_593831.validator(path, query, header, formData, body)
  let scheme = call_593831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593831.url(scheme.get, call_593831.host, call_593831.base,
                         call_593831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593831, url, valid)

proc call*(call_593902: Call_OperationsList_593647; apiVersion: string): Recallable =
  ## operationsList
  ## List all of the available operations the Blueprint resource provider supports.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_593903 = newJObject()
  add(query_593903, "api-version", newJString(apiVersion))
  result = call_593902.call(nil, query_593903, nil, nil, nil)

var operationsList* = Call_OperationsList_593647(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Blueprint/operations",
    validator: validate_OperationsList_593648, base: "", url: url_OperationsList_593649,
    schemes: {Scheme.Https})
type
  Call_BlueprintsList_593943 = ref object of OpenApiRestCall_593425
proc url_BlueprintsList_593945(protocol: Scheme; host: string; base: string;
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

proc validate_BlueprintsList_593944(path: JsonNode; query: JsonNode;
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
  var valid_593960 = path.getOrDefault("managementGroupName")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "managementGroupName", valid_593960
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593961 = query.getOrDefault("api-version")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "api-version", valid_593961
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593962: Call_BlueprintsList_593943; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List Blueprint definitions within a Management Group.
  ## 
  let valid = call_593962.validator(path, query, header, formData, body)
  let scheme = call_593962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593962.url(scheme.get, call_593962.host, call_593962.base,
                         call_593962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593962, url, valid)

proc call*(call_593963: Call_BlueprintsList_593943; managementGroupName: string;
          apiVersion: string): Recallable =
  ## blueprintsList
  ## List Blueprint definitions within a Management Group.
  ##   managementGroupName: string (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var path_593964 = newJObject()
  var query_593965 = newJObject()
  add(path_593964, "managementGroupName", newJString(managementGroupName))
  add(query_593965, "api-version", newJString(apiVersion))
  result = call_593963.call(path_593964, query_593965, nil, nil, nil)

var blueprintsList* = Call_BlueprintsList_593943(name: "blueprintsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints",
    validator: validate_BlueprintsList_593944, base: "", url: url_BlueprintsList_593945,
    schemes: {Scheme.Https})
type
  Call_BlueprintsCreateOrUpdate_593976 = ref object of OpenApiRestCall_593425
proc url_BlueprintsCreateOrUpdate_593978(protocol: Scheme; host: string;
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

proc validate_BlueprintsCreateOrUpdate_593977(path: JsonNode; query: JsonNode;
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
  var valid_593979 = path.getOrDefault("managementGroupName")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "managementGroupName", valid_593979
  var valid_593980 = path.getOrDefault("blueprintName")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "blueprintName", valid_593980
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593981 = query.getOrDefault("api-version")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "api-version", valid_593981
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

proc call*(call_593983: Call_BlueprintsCreateOrUpdate_593976; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update Blueprint definition.
  ## 
  let valid = call_593983.validator(path, query, header, formData, body)
  let scheme = call_593983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593983.url(scheme.get, call_593983.host, call_593983.base,
                         call_593983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593983, url, valid)

proc call*(call_593984: Call_BlueprintsCreateOrUpdate_593976;
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
  var path_593985 = newJObject()
  var query_593986 = newJObject()
  var body_593987 = newJObject()
  add(path_593985, "managementGroupName", newJString(managementGroupName))
  add(query_593986, "api-version", newJString(apiVersion))
  add(path_593985, "blueprintName", newJString(blueprintName))
  if blueprint != nil:
    body_593987 = blueprint
  result = call_593984.call(path_593985, query_593986, nil, nil, body_593987)

var blueprintsCreateOrUpdate* = Call_BlueprintsCreateOrUpdate_593976(
    name: "blueprintsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}",
    validator: validate_BlueprintsCreateOrUpdate_593977, base: "",
    url: url_BlueprintsCreateOrUpdate_593978, schemes: {Scheme.Https})
type
  Call_BlueprintsGet_593966 = ref object of OpenApiRestCall_593425
proc url_BlueprintsGet_593968(protocol: Scheme; host: string; base: string;
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

proc validate_BlueprintsGet_593967(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593969 = path.getOrDefault("managementGroupName")
  valid_593969 = validateParameter(valid_593969, JString, required = true,
                                 default = nil)
  if valid_593969 != nil:
    section.add "managementGroupName", valid_593969
  var valid_593970 = path.getOrDefault("blueprintName")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "blueprintName", valid_593970
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593971 = query.getOrDefault("api-version")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "api-version", valid_593971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593972: Call_BlueprintsGet_593966; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a blueprint definition.
  ## 
  let valid = call_593972.validator(path, query, header, formData, body)
  let scheme = call_593972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593972.url(scheme.get, call_593972.host, call_593972.base,
                         call_593972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593972, url, valid)

proc call*(call_593973: Call_BlueprintsGet_593966; managementGroupName: string;
          apiVersion: string; blueprintName: string): Recallable =
  ## blueprintsGet
  ## Get a blueprint definition.
  ##   managementGroupName: string (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   blueprintName: string (required)
  ##                : name of the blueprint.
  var path_593974 = newJObject()
  var query_593975 = newJObject()
  add(path_593974, "managementGroupName", newJString(managementGroupName))
  add(query_593975, "api-version", newJString(apiVersion))
  add(path_593974, "blueprintName", newJString(blueprintName))
  result = call_593973.call(path_593974, query_593975, nil, nil, nil)

var blueprintsGet* = Call_BlueprintsGet_593966(name: "blueprintsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}",
    validator: validate_BlueprintsGet_593967, base: "", url: url_BlueprintsGet_593968,
    schemes: {Scheme.Https})
type
  Call_BlueprintsDelete_593988 = ref object of OpenApiRestCall_593425
proc url_BlueprintsDelete_593990(protocol: Scheme; host: string; base: string;
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

proc validate_BlueprintsDelete_593989(path: JsonNode; query: JsonNode;
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
  var valid_593991 = path.getOrDefault("managementGroupName")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "managementGroupName", valid_593991
  var valid_593992 = path.getOrDefault("blueprintName")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "blueprintName", valid_593992
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593993 = query.getOrDefault("api-version")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "api-version", valid_593993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593994: Call_BlueprintsDelete_593988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a blueprint definition.
  ## 
  let valid = call_593994.validator(path, query, header, formData, body)
  let scheme = call_593994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593994.url(scheme.get, call_593994.host, call_593994.base,
                         call_593994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593994, url, valid)

proc call*(call_593995: Call_BlueprintsDelete_593988; managementGroupName: string;
          apiVersion: string; blueprintName: string): Recallable =
  ## blueprintsDelete
  ## Delete a blueprint definition.
  ##   managementGroupName: string (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   blueprintName: string (required)
  ##                : name of the blueprint.
  var path_593996 = newJObject()
  var query_593997 = newJObject()
  add(path_593996, "managementGroupName", newJString(managementGroupName))
  add(query_593997, "api-version", newJString(apiVersion))
  add(path_593996, "blueprintName", newJString(blueprintName))
  result = call_593995.call(path_593996, query_593997, nil, nil, nil)

var blueprintsDelete* = Call_BlueprintsDelete_593988(name: "blueprintsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}",
    validator: validate_BlueprintsDelete_593989, base: "",
    url: url_BlueprintsDelete_593990, schemes: {Scheme.Https})
type
  Call_ArtifactsList_593998 = ref object of OpenApiRestCall_593425
proc url_ArtifactsList_594000(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactsList_593999(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594001 = path.getOrDefault("managementGroupName")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "managementGroupName", valid_594001
  var valid_594002 = path.getOrDefault("blueprintName")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "blueprintName", valid_594002
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594003 = query.getOrDefault("api-version")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "api-version", valid_594003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594004: Call_ArtifactsList_593998; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifacts for a given Blueprint.
  ## 
  let valid = call_594004.validator(path, query, header, formData, body)
  let scheme = call_594004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594004.url(scheme.get, call_594004.host, call_594004.base,
                         call_594004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594004, url, valid)

proc call*(call_594005: Call_ArtifactsList_593998; managementGroupName: string;
          apiVersion: string; blueprintName: string): Recallable =
  ## artifactsList
  ## List artifacts for a given Blueprint.
  ##   managementGroupName: string (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   blueprintName: string (required)
  ##                : name of the blueprint.
  var path_594006 = newJObject()
  var query_594007 = newJObject()
  add(path_594006, "managementGroupName", newJString(managementGroupName))
  add(query_594007, "api-version", newJString(apiVersion))
  add(path_594006, "blueprintName", newJString(blueprintName))
  result = call_594005.call(path_594006, query_594007, nil, nil, nil)

var artifactsList* = Call_ArtifactsList_593998(name: "artifactsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/artifacts",
    validator: validate_ArtifactsList_593999, base: "", url: url_ArtifactsList_594000,
    schemes: {Scheme.Https})
type
  Call_ArtifactsCreateOrUpdate_594019 = ref object of OpenApiRestCall_593425
proc url_ArtifactsCreateOrUpdate_594021(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactsCreateOrUpdate_594020(path: JsonNode; query: JsonNode;
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
  var valid_594022 = path.getOrDefault("artifactName")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "artifactName", valid_594022
  var valid_594023 = path.getOrDefault("managementGroupName")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "managementGroupName", valid_594023
  var valid_594024 = path.getOrDefault("blueprintName")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "blueprintName", valid_594024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594025 = query.getOrDefault("api-version")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "api-version", valid_594025
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

proc call*(call_594027: Call_ArtifactsCreateOrUpdate_594019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update Blueprint artifact.
  ## 
  let valid = call_594027.validator(path, query, header, formData, body)
  let scheme = call_594027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594027.url(scheme.get, call_594027.host, call_594027.base,
                         call_594027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594027, url, valid)

proc call*(call_594028: Call_ArtifactsCreateOrUpdate_594019; artifactName: string;
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
  var path_594029 = newJObject()
  var query_594030 = newJObject()
  var body_594031 = newJObject()
  add(path_594029, "artifactName", newJString(artifactName))
  add(path_594029, "managementGroupName", newJString(managementGroupName))
  if artifact != nil:
    body_594031 = artifact
  add(query_594030, "api-version", newJString(apiVersion))
  add(path_594029, "blueprintName", newJString(blueprintName))
  result = call_594028.call(path_594029, query_594030, nil, nil, body_594031)

var artifactsCreateOrUpdate* = Call_ArtifactsCreateOrUpdate_594019(
    name: "artifactsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/artifacts/{artifactName}",
    validator: validate_ArtifactsCreateOrUpdate_594020, base: "",
    url: url_ArtifactsCreateOrUpdate_594021, schemes: {Scheme.Https})
type
  Call_ArtifactsGet_594008 = ref object of OpenApiRestCall_593425
proc url_ArtifactsGet_594010(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactsGet_594009(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594011 = path.getOrDefault("artifactName")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "artifactName", valid_594011
  var valid_594012 = path.getOrDefault("managementGroupName")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "managementGroupName", valid_594012
  var valid_594013 = path.getOrDefault("blueprintName")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "blueprintName", valid_594013
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594014 = query.getOrDefault("api-version")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "api-version", valid_594014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594015: Call_ArtifactsGet_594008; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Blueprint artifact.
  ## 
  let valid = call_594015.validator(path, query, header, formData, body)
  let scheme = call_594015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594015.url(scheme.get, call_594015.host, call_594015.base,
                         call_594015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594015, url, valid)

proc call*(call_594016: Call_ArtifactsGet_594008; artifactName: string;
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
  var path_594017 = newJObject()
  var query_594018 = newJObject()
  add(path_594017, "artifactName", newJString(artifactName))
  add(path_594017, "managementGroupName", newJString(managementGroupName))
  add(query_594018, "api-version", newJString(apiVersion))
  add(path_594017, "blueprintName", newJString(blueprintName))
  result = call_594016.call(path_594017, query_594018, nil, nil, nil)

var artifactsGet* = Call_ArtifactsGet_594008(name: "artifactsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/artifacts/{artifactName}",
    validator: validate_ArtifactsGet_594009, base: "", url: url_ArtifactsGet_594010,
    schemes: {Scheme.Https})
type
  Call_ArtifactsDelete_594032 = ref object of OpenApiRestCall_593425
proc url_ArtifactsDelete_594034(protocol: Scheme; host: string; base: string;
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

proc validate_ArtifactsDelete_594033(path: JsonNode; query: JsonNode;
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
  var valid_594035 = path.getOrDefault("artifactName")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "artifactName", valid_594035
  var valid_594036 = path.getOrDefault("managementGroupName")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "managementGroupName", valid_594036
  var valid_594037 = path.getOrDefault("blueprintName")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "blueprintName", valid_594037
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594038 = query.getOrDefault("api-version")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "api-version", valid_594038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594039: Call_ArtifactsDelete_594032; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Blueprint artifact.
  ## 
  let valid = call_594039.validator(path, query, header, formData, body)
  let scheme = call_594039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594039.url(scheme.get, call_594039.host, call_594039.base,
                         call_594039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594039, url, valid)

proc call*(call_594040: Call_ArtifactsDelete_594032; artifactName: string;
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
  var path_594041 = newJObject()
  var query_594042 = newJObject()
  add(path_594041, "artifactName", newJString(artifactName))
  add(path_594041, "managementGroupName", newJString(managementGroupName))
  add(query_594042, "api-version", newJString(apiVersion))
  add(path_594041, "blueprintName", newJString(blueprintName))
  result = call_594040.call(path_594041, query_594042, nil, nil, nil)

var artifactsDelete* = Call_ArtifactsDelete_594032(name: "artifactsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/artifacts/{artifactName}",
    validator: validate_ArtifactsDelete_594033, base: "", url: url_ArtifactsDelete_594034,
    schemes: {Scheme.Https})
type
  Call_PublishedBlueprintsList_594043 = ref object of OpenApiRestCall_593425
proc url_PublishedBlueprintsList_594045(protocol: Scheme; host: string; base: string;
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

proc validate_PublishedBlueprintsList_594044(path: JsonNode; query: JsonNode;
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
  var valid_594046 = path.getOrDefault("managementGroupName")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "managementGroupName", valid_594046
  var valid_594047 = path.getOrDefault("blueprintName")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "blueprintName", valid_594047
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594048 = query.getOrDefault("api-version")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "api-version", valid_594048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594049: Call_PublishedBlueprintsList_594043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List published versions of given Blueprint.
  ## 
  let valid = call_594049.validator(path, query, header, formData, body)
  let scheme = call_594049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594049.url(scheme.get, call_594049.host, call_594049.base,
                         call_594049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594049, url, valid)

proc call*(call_594050: Call_PublishedBlueprintsList_594043;
          managementGroupName: string; apiVersion: string; blueprintName: string): Recallable =
  ## publishedBlueprintsList
  ## List published versions of given Blueprint.
  ##   managementGroupName: string (required)
  ##                      : ManagementGroup where blueprint stores.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   blueprintName: string (required)
  ##                : name of the blueprint.
  var path_594051 = newJObject()
  var query_594052 = newJObject()
  add(path_594051, "managementGroupName", newJString(managementGroupName))
  add(query_594052, "api-version", newJString(apiVersion))
  add(path_594051, "blueprintName", newJString(blueprintName))
  result = call_594050.call(path_594051, query_594052, nil, nil, nil)

var publishedBlueprintsList* = Call_PublishedBlueprintsList_594043(
    name: "publishedBlueprintsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions",
    validator: validate_PublishedBlueprintsList_594044, base: "",
    url: url_PublishedBlueprintsList_594045, schemes: {Scheme.Https})
type
  Call_PublishedBlueprintsCreate_594064 = ref object of OpenApiRestCall_593425
proc url_PublishedBlueprintsCreate_594066(protocol: Scheme; host: string;
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

proc validate_PublishedBlueprintsCreate_594065(path: JsonNode; query: JsonNode;
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
  var valid_594067 = path.getOrDefault("managementGroupName")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "managementGroupName", valid_594067
  var valid_594068 = path.getOrDefault("versionId")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "versionId", valid_594068
  var valid_594069 = path.getOrDefault("blueprintName")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "blueprintName", valid_594069
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594070 = query.getOrDefault("api-version")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "api-version", valid_594070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594071: Call_PublishedBlueprintsCreate_594064; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Publish a new version of the Blueprint with the latest artifacts. Published Blueprints are immutable.
  ## 
  let valid = call_594071.validator(path, query, header, formData, body)
  let scheme = call_594071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594071.url(scheme.get, call_594071.host, call_594071.base,
                         call_594071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594071, url, valid)

proc call*(call_594072: Call_PublishedBlueprintsCreate_594064;
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
  var path_594073 = newJObject()
  var query_594074 = newJObject()
  add(path_594073, "managementGroupName", newJString(managementGroupName))
  add(path_594073, "versionId", newJString(versionId))
  add(query_594074, "api-version", newJString(apiVersion))
  add(path_594073, "blueprintName", newJString(blueprintName))
  result = call_594072.call(path_594073, query_594074, nil, nil, nil)

var publishedBlueprintsCreate* = Call_PublishedBlueprintsCreate_594064(
    name: "publishedBlueprintsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions/{versionId}",
    validator: validate_PublishedBlueprintsCreate_594065, base: "",
    url: url_PublishedBlueprintsCreate_594066, schemes: {Scheme.Https})
type
  Call_PublishedBlueprintsGet_594053 = ref object of OpenApiRestCall_593425
proc url_PublishedBlueprintsGet_594055(protocol: Scheme; host: string; base: string;
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

proc validate_PublishedBlueprintsGet_594054(path: JsonNode; query: JsonNode;
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
  var valid_594056 = path.getOrDefault("managementGroupName")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "managementGroupName", valid_594056
  var valid_594057 = path.getOrDefault("versionId")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "versionId", valid_594057
  var valid_594058 = path.getOrDefault("blueprintName")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "blueprintName", valid_594058
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594059 = query.getOrDefault("api-version")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "api-version", valid_594059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594060: Call_PublishedBlueprintsGet_594053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a published Blueprint.
  ## 
  let valid = call_594060.validator(path, query, header, formData, body)
  let scheme = call_594060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594060.url(scheme.get, call_594060.host, call_594060.base,
                         call_594060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594060, url, valid)

proc call*(call_594061: Call_PublishedBlueprintsGet_594053;
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
  var path_594062 = newJObject()
  var query_594063 = newJObject()
  add(path_594062, "managementGroupName", newJString(managementGroupName))
  add(path_594062, "versionId", newJString(versionId))
  add(query_594063, "api-version", newJString(apiVersion))
  add(path_594062, "blueprintName", newJString(blueprintName))
  result = call_594061.call(path_594062, query_594063, nil, nil, nil)

var publishedBlueprintsGet* = Call_PublishedBlueprintsGet_594053(
    name: "publishedBlueprintsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions/{versionId}",
    validator: validate_PublishedBlueprintsGet_594054, base: "",
    url: url_PublishedBlueprintsGet_594055, schemes: {Scheme.Https})
type
  Call_PublishedBlueprintsDelete_594075 = ref object of OpenApiRestCall_593425
proc url_PublishedBlueprintsDelete_594077(protocol: Scheme; host: string;
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

proc validate_PublishedBlueprintsDelete_594076(path: JsonNode; query: JsonNode;
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
  var valid_594078 = path.getOrDefault("managementGroupName")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "managementGroupName", valid_594078
  var valid_594079 = path.getOrDefault("versionId")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "versionId", valid_594079
  var valid_594080 = path.getOrDefault("blueprintName")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "blueprintName", valid_594080
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594081 = query.getOrDefault("api-version")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "api-version", valid_594081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594082: Call_PublishedBlueprintsDelete_594075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a published Blueprint.
  ## 
  let valid = call_594082.validator(path, query, header, formData, body)
  let scheme = call_594082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594082.url(scheme.get, call_594082.host, call_594082.base,
                         call_594082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594082, url, valid)

proc call*(call_594083: Call_PublishedBlueprintsDelete_594075;
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
  var path_594084 = newJObject()
  var query_594085 = newJObject()
  add(path_594084, "managementGroupName", newJString(managementGroupName))
  add(path_594084, "versionId", newJString(versionId))
  add(query_594085, "api-version", newJString(apiVersion))
  add(path_594084, "blueprintName", newJString(blueprintName))
  result = call_594083.call(path_594084, query_594085, nil, nil, nil)

var publishedBlueprintsDelete* = Call_PublishedBlueprintsDelete_594075(
    name: "publishedBlueprintsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions/{versionId}",
    validator: validate_PublishedBlueprintsDelete_594076, base: "",
    url: url_PublishedBlueprintsDelete_594077, schemes: {Scheme.Https})
type
  Call_PublishedArtifactsList_594086 = ref object of OpenApiRestCall_593425
proc url_PublishedArtifactsList_594088(protocol: Scheme; host: string; base: string;
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

proc validate_PublishedArtifactsList_594087(path: JsonNode; query: JsonNode;
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
  var valid_594089 = path.getOrDefault("managementGroupName")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "managementGroupName", valid_594089
  var valid_594090 = path.getOrDefault("versionId")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "versionId", valid_594090
  var valid_594091 = path.getOrDefault("blueprintName")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "blueprintName", valid_594091
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594092 = query.getOrDefault("api-version")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "api-version", valid_594092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594093: Call_PublishedArtifactsList_594086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List artifacts for a published Blueprint.
  ## 
  let valid = call_594093.validator(path, query, header, formData, body)
  let scheme = call_594093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594093.url(scheme.get, call_594093.host, call_594093.base,
                         call_594093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594093, url, valid)

proc call*(call_594094: Call_PublishedArtifactsList_594086;
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
  var path_594095 = newJObject()
  var query_594096 = newJObject()
  add(path_594095, "managementGroupName", newJString(managementGroupName))
  add(path_594095, "versionId", newJString(versionId))
  add(query_594096, "api-version", newJString(apiVersion))
  add(path_594095, "blueprintName", newJString(blueprintName))
  result = call_594094.call(path_594095, query_594096, nil, nil, nil)

var publishedArtifactsList* = Call_PublishedArtifactsList_594086(
    name: "publishedArtifactsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions/{versionId}/artifacts",
    validator: validate_PublishedArtifactsList_594087, base: "",
    url: url_PublishedArtifactsList_594088, schemes: {Scheme.Https})
type
  Call_PublishedArtifactsGet_594097 = ref object of OpenApiRestCall_593425
proc url_PublishedArtifactsGet_594099(protocol: Scheme; host: string; base: string;
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

proc validate_PublishedArtifactsGet_594098(path: JsonNode; query: JsonNode;
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
  var valid_594100 = path.getOrDefault("artifactName")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "artifactName", valid_594100
  var valid_594101 = path.getOrDefault("managementGroupName")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "managementGroupName", valid_594101
  var valid_594102 = path.getOrDefault("versionId")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "versionId", valid_594102
  var valid_594103 = path.getOrDefault("blueprintName")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "blueprintName", valid_594103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594104 = query.getOrDefault("api-version")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "api-version", valid_594104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594105: Call_PublishedArtifactsGet_594097; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an artifact for a published Blueprint.
  ## 
  let valid = call_594105.validator(path, query, header, formData, body)
  let scheme = call_594105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594105.url(scheme.get, call_594105.host, call_594105.base,
                         call_594105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594105, url, valid)

proc call*(call_594106: Call_PublishedArtifactsGet_594097; artifactName: string;
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
  var path_594107 = newJObject()
  var query_594108 = newJObject()
  add(path_594107, "artifactName", newJString(artifactName))
  add(path_594107, "managementGroupName", newJString(managementGroupName))
  add(path_594107, "versionId", newJString(versionId))
  add(query_594108, "api-version", newJString(apiVersion))
  add(path_594107, "blueprintName", newJString(blueprintName))
  result = call_594106.call(path_594107, query_594108, nil, nil, nil)

var publishedArtifactsGet* = Call_PublishedArtifactsGet_594097(
    name: "publishedArtifactsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Blueprint/blueprints/{blueprintName}/versions/{versionId}/artifacts/{artifactName}",
    validator: validate_PublishedArtifactsGet_594098, base: "",
    url: url_PublishedArtifactsGet_594099, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
