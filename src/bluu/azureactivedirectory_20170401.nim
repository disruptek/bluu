
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: azureactivedirectory
## version: 2017-04-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Active Directory Client.
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "azureactivedirectory"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DiagnosticSettingsList_567879 = ref object of OpenApiRestCall_567657
proc url_DiagnosticSettingsList_567881(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DiagnosticSettingsList_567880(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the active diagnostic settings list for AadIam.
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
  var valid_568040 = query.getOrDefault("api-version")
  valid_568040 = validateParameter(valid_568040, JString, required = true,
                                 default = nil)
  if valid_568040 != nil:
    section.add "api-version", valid_568040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568063: Call_DiagnosticSettingsList_567879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the active diagnostic settings list for AadIam.
  ## 
  let valid = call_568063.validator(path, query, header, formData, body)
  let scheme = call_568063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568063.url(scheme.get, call_568063.host, call_568063.base,
                         call_568063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568063, url, valid)

proc call*(call_568134: Call_DiagnosticSettingsList_567879; apiVersion: string): Recallable =
  ## diagnosticSettingsList
  ## Gets the active diagnostic settings list for AadIam.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568135 = newJObject()
  add(query_568135, "api-version", newJString(apiVersion))
  result = call_568134.call(nil, query_568135, nil, nil, nil)

var diagnosticSettingsList* = Call_DiagnosticSettingsList_567879(
    name: "diagnosticSettingsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/microsoft.aadiam/diagnosticSettings",
    validator: validate_DiagnosticSettingsList_567880, base: "",
    url: url_DiagnosticSettingsList_567881, schemes: {Scheme.Https})
type
  Call_DiagnosticSettingsCreateOrUpdate_568198 = ref object of OpenApiRestCall_567657
proc url_DiagnosticSettingsCreateOrUpdate_568200(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/microsoft.aadiam/diagnosticSettings/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticSettingsCreateOrUpdate_568199(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates diagnostic settings for AadIam.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the diagnostic setting.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_568201 = path.getOrDefault("name")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "name", valid_568201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568202 = query.getOrDefault("api-version")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "api-version", valid_568202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568204: Call_DiagnosticSettingsCreateOrUpdate_568198;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates diagnostic settings for AadIam.
  ## 
  let valid = call_568204.validator(path, query, header, formData, body)
  let scheme = call_568204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568204.url(scheme.get, call_568204.host, call_568204.base,
                         call_568204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568204, url, valid)

proc call*(call_568205: Call_DiagnosticSettingsCreateOrUpdate_568198;
          apiVersion: string; name: string; parameters: JsonNode): Recallable =
  ## diagnosticSettingsCreateOrUpdate
  ## Creates or updates diagnostic settings for AadIam.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   name: string (required)
  ##       : The name of the diagnostic setting.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the operation.
  var path_568206 = newJObject()
  var query_568207 = newJObject()
  var body_568208 = newJObject()
  add(query_568207, "api-version", newJString(apiVersion))
  add(path_568206, "name", newJString(name))
  if parameters != nil:
    body_568208 = parameters
  result = call_568205.call(path_568206, query_568207, nil, nil, body_568208)

var diagnosticSettingsCreateOrUpdate* = Call_DiagnosticSettingsCreateOrUpdate_568198(
    name: "diagnosticSettingsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/providers/microsoft.aadiam/diagnosticSettings/{name}",
    validator: validate_DiagnosticSettingsCreateOrUpdate_568199, base: "",
    url: url_DiagnosticSettingsCreateOrUpdate_568200, schemes: {Scheme.Https})
type
  Call_DiagnosticSettingsGet_568175 = ref object of OpenApiRestCall_567657
proc url_DiagnosticSettingsGet_568177(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/microsoft.aadiam/diagnosticSettings/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticSettingsGet_568176(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the active diagnostic setting for AadIam.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the diagnostic setting.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_568192 = path.getOrDefault("name")
  valid_568192 = validateParameter(valid_568192, JString, required = true,
                                 default = nil)
  if valid_568192 != nil:
    section.add "name", valid_568192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568193 = query.getOrDefault("api-version")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "api-version", valid_568193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568194: Call_DiagnosticSettingsGet_568175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the active diagnostic setting for AadIam.
  ## 
  let valid = call_568194.validator(path, query, header, formData, body)
  let scheme = call_568194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568194.url(scheme.get, call_568194.host, call_568194.base,
                         call_568194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568194, url, valid)

proc call*(call_568195: Call_DiagnosticSettingsGet_568175; apiVersion: string;
          name: string): Recallable =
  ## diagnosticSettingsGet
  ## Gets the active diagnostic setting for AadIam.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   name: string (required)
  ##       : The name of the diagnostic setting.
  var path_568196 = newJObject()
  var query_568197 = newJObject()
  add(query_568197, "api-version", newJString(apiVersion))
  add(path_568196, "name", newJString(name))
  result = call_568195.call(path_568196, query_568197, nil, nil, nil)

var diagnosticSettingsGet* = Call_DiagnosticSettingsGet_568175(
    name: "diagnosticSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/microsoft.aadiam/diagnosticSettings/{name}",
    validator: validate_DiagnosticSettingsGet_568176, base: "",
    url: url_DiagnosticSettingsGet_568177, schemes: {Scheme.Https})
type
  Call_DiagnosticSettingsDelete_568209 = ref object of OpenApiRestCall_567657
proc url_DiagnosticSettingsDelete_568211(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/microsoft.aadiam/diagnosticSettings/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DiagnosticSettingsDelete_568210(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes existing diagnostic setting for AadIam.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the diagnostic setting.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_568212 = path.getOrDefault("name")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "name", valid_568212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568213 = query.getOrDefault("api-version")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "api-version", valid_568213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568214: Call_DiagnosticSettingsDelete_568209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes existing diagnostic setting for AadIam.
  ## 
  let valid = call_568214.validator(path, query, header, formData, body)
  let scheme = call_568214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568214.url(scheme.get, call_568214.host, call_568214.base,
                         call_568214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568214, url, valid)

proc call*(call_568215: Call_DiagnosticSettingsDelete_568209; apiVersion: string;
          name: string): Recallable =
  ## diagnosticSettingsDelete
  ## Deletes existing diagnostic setting for AadIam.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   name: string (required)
  ##       : The name of the diagnostic setting.
  var path_568216 = newJObject()
  var query_568217 = newJObject()
  add(query_568217, "api-version", newJString(apiVersion))
  add(path_568216, "name", newJString(name))
  result = call_568215.call(path_568216, query_568217, nil, nil, nil)

var diagnosticSettingsDelete* = Call_DiagnosticSettingsDelete_568209(
    name: "diagnosticSettingsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com",
    route: "/providers/microsoft.aadiam/diagnosticSettings/{name}",
    validator: validate_DiagnosticSettingsDelete_568210, base: "",
    url: url_DiagnosticSettingsDelete_568211, schemes: {Scheme.Https})
type
  Call_DiagnosticSettingsCategoryList_568218 = ref object of OpenApiRestCall_567657
proc url_DiagnosticSettingsCategoryList_568220(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DiagnosticSettingsCategoryList_568219(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the diagnostic settings categories for AadIam.
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
  var valid_568221 = query.getOrDefault("api-version")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "api-version", valid_568221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568222: Call_DiagnosticSettingsCategoryList_568218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the diagnostic settings categories for AadIam.
  ## 
  let valid = call_568222.validator(path, query, header, formData, body)
  let scheme = call_568222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568222.url(scheme.get, call_568222.host, call_568222.base,
                         call_568222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568222, url, valid)

proc call*(call_568223: Call_DiagnosticSettingsCategoryList_568218;
          apiVersion: string): Recallable =
  ## diagnosticSettingsCategoryList
  ## Lists the diagnostic settings categories for AadIam.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568224 = newJObject()
  add(query_568224, "api-version", newJString(apiVersion))
  result = call_568223.call(nil, query_568224, nil, nil, nil)

var diagnosticSettingsCategoryList* = Call_DiagnosticSettingsCategoryList_568218(
    name: "diagnosticSettingsCategoryList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/microsoft.aadiam/diagnosticSettingsCategories",
    validator: validate_DiagnosticSettingsCategoryList_568219, base: "",
    url: url_DiagnosticSettingsCategoryList_568220, schemes: {Scheme.Https})
type
  Call_OperationsList_568225 = ref object of OpenApiRestCall_567657
proc url_OperationsList_568227(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_568226(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Operation to return the list of available operations.
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
  var valid_568228 = query.getOrDefault("api-version")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "api-version", valid_568228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568229: Call_OperationsList_568225; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Operation to return the list of available operations.
  ## 
  let valid = call_568229.validator(path, query, header, formData, body)
  let scheme = call_568229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568229.url(scheme.get, call_568229.host, call_568229.base,
                         call_568229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568229, url, valid)

proc call*(call_568230: Call_OperationsList_568225; apiVersion: string): Recallable =
  ## operationsList
  ## Operation to return the list of available operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568231 = newJObject()
  add(query_568231, "api-version", newJString(apiVersion))
  result = call_568230.call(nil, query_568231, nil, nil, nil)

var operationsList* = Call_OperationsList_568225(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/microsoft.aadiam/operations",
    validator: validate_OperationsList_568226, base: "", url: url_OperationsList_568227,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
