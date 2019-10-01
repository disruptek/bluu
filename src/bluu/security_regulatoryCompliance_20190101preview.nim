
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Security Center
## version: 2019-01-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## API spec for Microsoft.Security (Azure Security Center) resource provider
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
  macServiceName = "security-regulatoryCompliance"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RegulatoryComplianceStandardsList_567879 = ref object of OpenApiRestCall_567657
proc url_RegulatoryComplianceStandardsList_567881(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/regulatoryComplianceStandards")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegulatoryComplianceStandardsList_567880(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Supported regulatory compliance standards details and state
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568042 = path.getOrDefault("subscriptionId")
  valid_568042 = validateParameter(valid_568042, JString, required = true,
                                 default = nil)
  if valid_568042 != nil:
    section.add "subscriptionId", valid_568042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568043 = query.getOrDefault("api-version")
  valid_568043 = validateParameter(valid_568043, JString, required = true,
                                 default = nil)
  if valid_568043 != nil:
    section.add "api-version", valid_568043
  var valid_568044 = query.getOrDefault("$filter")
  valid_568044 = validateParameter(valid_568044, JString, required = false,
                                 default = nil)
  if valid_568044 != nil:
    section.add "$filter", valid_568044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568071: Call_RegulatoryComplianceStandardsList_567879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Supported regulatory compliance standards details and state
  ## 
  let valid = call_568071.validator(path, query, header, formData, body)
  let scheme = call_568071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568071.url(scheme.get, call_568071.host, call_568071.base,
                         call_568071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568071, url, valid)

proc call*(call_568142: Call_RegulatoryComplianceStandardsList_567879;
          apiVersion: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## regulatoryComplianceStandardsList
  ## Supported regulatory compliance standards details and state
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568143 = newJObject()
  var query_568145 = newJObject()
  add(query_568145, "api-version", newJString(apiVersion))
  add(path_568143, "subscriptionId", newJString(subscriptionId))
  add(query_568145, "$filter", newJString(Filter))
  result = call_568142.call(path_568143, query_568145, nil, nil, nil)

var regulatoryComplianceStandardsList* = Call_RegulatoryComplianceStandardsList_567879(
    name: "regulatoryComplianceStandardsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/regulatoryComplianceStandards",
    validator: validate_RegulatoryComplianceStandardsList_567880, base: "",
    url: url_RegulatoryComplianceStandardsList_567881, schemes: {Scheme.Https})
type
  Call_RegulatoryComplianceStandardsGet_568184 = ref object of OpenApiRestCall_567657
proc url_RegulatoryComplianceStandardsGet_568186(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "regulatoryComplianceStandardName" in path,
        "`regulatoryComplianceStandardName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/regulatoryComplianceStandards/"), (
        kind: VariableSegment, value: "regulatoryComplianceStandardName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegulatoryComplianceStandardsGet_568185(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Supported regulatory compliance details state for selected standard
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   regulatoryComplianceStandardName: JString (required)
  ##                                   : Name of the regulatory compliance standard object
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `regulatoryComplianceStandardName` field"
  var valid_568196 = path.getOrDefault("regulatoryComplianceStandardName")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "regulatoryComplianceStandardName", valid_568196
  var valid_568197 = path.getOrDefault("subscriptionId")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "subscriptionId", valid_568197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568198 = query.getOrDefault("api-version")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "api-version", valid_568198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568199: Call_RegulatoryComplianceStandardsGet_568184;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Supported regulatory compliance details state for selected standard
  ## 
  let valid = call_568199.validator(path, query, header, formData, body)
  let scheme = call_568199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568199.url(scheme.get, call_568199.host, call_568199.base,
                         call_568199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568199, url, valid)

proc call*(call_568200: Call_RegulatoryComplianceStandardsGet_568184;
          apiVersion: string; regulatoryComplianceStandardName: string;
          subscriptionId: string): Recallable =
  ## regulatoryComplianceStandardsGet
  ## Supported regulatory compliance details state for selected standard
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   regulatoryComplianceStandardName: string (required)
  ##                                   : Name of the regulatory compliance standard object
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_568201 = newJObject()
  var query_568202 = newJObject()
  add(query_568202, "api-version", newJString(apiVersion))
  add(path_568201, "regulatoryComplianceStandardName",
      newJString(regulatoryComplianceStandardName))
  add(path_568201, "subscriptionId", newJString(subscriptionId))
  result = call_568200.call(path_568201, query_568202, nil, nil, nil)

var regulatoryComplianceStandardsGet* = Call_RegulatoryComplianceStandardsGet_568184(
    name: "regulatoryComplianceStandardsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/regulatoryComplianceStandards/{regulatoryComplianceStandardName}",
    validator: validate_RegulatoryComplianceStandardsGet_568185, base: "",
    url: url_RegulatoryComplianceStandardsGet_568186, schemes: {Scheme.Https})
type
  Call_RegulatoryComplianceControlsList_568203 = ref object of OpenApiRestCall_567657
proc url_RegulatoryComplianceControlsList_568205(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "regulatoryComplianceStandardName" in path,
        "`regulatoryComplianceStandardName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/regulatoryComplianceStandards/"), (
        kind: VariableSegment, value: "regulatoryComplianceStandardName"),
               (kind: ConstantSegment, value: "/regulatoryComplianceControls")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegulatoryComplianceControlsList_568204(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## All supported regulatory compliance controls details and state for selected standard
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   regulatoryComplianceStandardName: JString (required)
  ##                                   : Name of the regulatory compliance standard object
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `regulatoryComplianceStandardName` field"
  var valid_568206 = path.getOrDefault("regulatoryComplianceStandardName")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "regulatoryComplianceStandardName", valid_568206
  var valid_568207 = path.getOrDefault("subscriptionId")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "subscriptionId", valid_568207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568208 = query.getOrDefault("api-version")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "api-version", valid_568208
  var valid_568209 = query.getOrDefault("$filter")
  valid_568209 = validateParameter(valid_568209, JString, required = false,
                                 default = nil)
  if valid_568209 != nil:
    section.add "$filter", valid_568209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568210: Call_RegulatoryComplianceControlsList_568203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## All supported regulatory compliance controls details and state for selected standard
  ## 
  let valid = call_568210.validator(path, query, header, formData, body)
  let scheme = call_568210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568210.url(scheme.get, call_568210.host, call_568210.base,
                         call_568210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568210, url, valid)

proc call*(call_568211: Call_RegulatoryComplianceControlsList_568203;
          apiVersion: string; regulatoryComplianceStandardName: string;
          subscriptionId: string; Filter: string = ""): Recallable =
  ## regulatoryComplianceControlsList
  ## All supported regulatory compliance controls details and state for selected standard
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   regulatoryComplianceStandardName: string (required)
  ##                                   : Name of the regulatory compliance standard object
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568212 = newJObject()
  var query_568213 = newJObject()
  add(query_568213, "api-version", newJString(apiVersion))
  add(path_568212, "regulatoryComplianceStandardName",
      newJString(regulatoryComplianceStandardName))
  add(path_568212, "subscriptionId", newJString(subscriptionId))
  add(query_568213, "$filter", newJString(Filter))
  result = call_568211.call(path_568212, query_568213, nil, nil, nil)

var regulatoryComplianceControlsList* = Call_RegulatoryComplianceControlsList_568203(
    name: "regulatoryComplianceControlsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/regulatoryComplianceStandards/{regulatoryComplianceStandardName}/regulatoryComplianceControls",
    validator: validate_RegulatoryComplianceControlsList_568204, base: "",
    url: url_RegulatoryComplianceControlsList_568205, schemes: {Scheme.Https})
type
  Call_RegulatoryComplianceControlsGet_568214 = ref object of OpenApiRestCall_567657
proc url_RegulatoryComplianceControlsGet_568216(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "regulatoryComplianceStandardName" in path,
        "`regulatoryComplianceStandardName` is a required path parameter"
  assert "regulatoryComplianceControlName" in path,
        "`regulatoryComplianceControlName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/regulatoryComplianceStandards/"), (
        kind: VariableSegment, value: "regulatoryComplianceStandardName"), (
        kind: ConstantSegment, value: "/regulatoryComplianceControls/"), (
        kind: VariableSegment, value: "regulatoryComplianceControlName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegulatoryComplianceControlsGet_568215(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Selected regulatory compliance control details and state
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   regulatoryComplianceStandardName: JString (required)
  ##                                   : Name of the regulatory compliance standard object
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   regulatoryComplianceControlName: JString (required)
  ##                                  : Name of the regulatory compliance control object
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `regulatoryComplianceStandardName` field"
  var valid_568217 = path.getOrDefault("regulatoryComplianceStandardName")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "regulatoryComplianceStandardName", valid_568217
  var valid_568218 = path.getOrDefault("subscriptionId")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "subscriptionId", valid_568218
  var valid_568219 = path.getOrDefault("regulatoryComplianceControlName")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "regulatoryComplianceControlName", valid_568219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568220 = query.getOrDefault("api-version")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "api-version", valid_568220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568221: Call_RegulatoryComplianceControlsGet_568214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Selected regulatory compliance control details and state
  ## 
  let valid = call_568221.validator(path, query, header, formData, body)
  let scheme = call_568221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568221.url(scheme.get, call_568221.host, call_568221.base,
                         call_568221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568221, url, valid)

proc call*(call_568222: Call_RegulatoryComplianceControlsGet_568214;
          apiVersion: string; regulatoryComplianceStandardName: string;
          subscriptionId: string; regulatoryComplianceControlName: string): Recallable =
  ## regulatoryComplianceControlsGet
  ## Selected regulatory compliance control details and state
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   regulatoryComplianceStandardName: string (required)
  ##                                   : Name of the regulatory compliance standard object
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   regulatoryComplianceControlName: string (required)
  ##                                  : Name of the regulatory compliance control object
  var path_568223 = newJObject()
  var query_568224 = newJObject()
  add(query_568224, "api-version", newJString(apiVersion))
  add(path_568223, "regulatoryComplianceStandardName",
      newJString(regulatoryComplianceStandardName))
  add(path_568223, "subscriptionId", newJString(subscriptionId))
  add(path_568223, "regulatoryComplianceControlName",
      newJString(regulatoryComplianceControlName))
  result = call_568222.call(path_568223, query_568224, nil, nil, nil)

var regulatoryComplianceControlsGet* = Call_RegulatoryComplianceControlsGet_568214(
    name: "regulatoryComplianceControlsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/regulatoryComplianceStandards/{regulatoryComplianceStandardName}/regulatoryComplianceControls/{regulatoryComplianceControlName}",
    validator: validate_RegulatoryComplianceControlsGet_568215, base: "",
    url: url_RegulatoryComplianceControlsGet_568216, schemes: {Scheme.Https})
type
  Call_RegulatoryComplianceAssessmentsList_568225 = ref object of OpenApiRestCall_567657
proc url_RegulatoryComplianceAssessmentsList_568227(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "regulatoryComplianceStandardName" in path,
        "`regulatoryComplianceStandardName` is a required path parameter"
  assert "regulatoryComplianceControlName" in path,
        "`regulatoryComplianceControlName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/regulatoryComplianceStandards/"), (
        kind: VariableSegment, value: "regulatoryComplianceStandardName"), (
        kind: ConstantSegment, value: "/regulatoryComplianceControls/"), (
        kind: VariableSegment, value: "regulatoryComplianceControlName"), (
        kind: ConstantSegment, value: "/regulatoryComplianceAssessments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegulatoryComplianceAssessmentsList_568226(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Details and state of assessments mapped to selected regulatory compliance control
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   regulatoryComplianceStandardName: JString (required)
  ##                                   : Name of the regulatory compliance standard object
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   regulatoryComplianceControlName: JString (required)
  ##                                  : Name of the regulatory compliance control object
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `regulatoryComplianceStandardName` field"
  var valid_568228 = path.getOrDefault("regulatoryComplianceStandardName")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "regulatoryComplianceStandardName", valid_568228
  var valid_568229 = path.getOrDefault("subscriptionId")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "subscriptionId", valid_568229
  var valid_568230 = path.getOrDefault("regulatoryComplianceControlName")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "regulatoryComplianceControlName", valid_568230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568231 = query.getOrDefault("api-version")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "api-version", valid_568231
  var valid_568232 = query.getOrDefault("$filter")
  valid_568232 = validateParameter(valid_568232, JString, required = false,
                                 default = nil)
  if valid_568232 != nil:
    section.add "$filter", valid_568232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568233: Call_RegulatoryComplianceAssessmentsList_568225;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Details and state of assessments mapped to selected regulatory compliance control
  ## 
  let valid = call_568233.validator(path, query, header, formData, body)
  let scheme = call_568233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568233.url(scheme.get, call_568233.host, call_568233.base,
                         call_568233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568233, url, valid)

proc call*(call_568234: Call_RegulatoryComplianceAssessmentsList_568225;
          apiVersion: string; regulatoryComplianceStandardName: string;
          subscriptionId: string; regulatoryComplianceControlName: string;
          Filter: string = ""): Recallable =
  ## regulatoryComplianceAssessmentsList
  ## Details and state of assessments mapped to selected regulatory compliance control
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   regulatoryComplianceStandardName: string (required)
  ##                                   : Name of the regulatory compliance standard object
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   regulatoryComplianceControlName: string (required)
  ##                                  : Name of the regulatory compliance control object
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_568235 = newJObject()
  var query_568236 = newJObject()
  add(query_568236, "api-version", newJString(apiVersion))
  add(path_568235, "regulatoryComplianceStandardName",
      newJString(regulatoryComplianceStandardName))
  add(path_568235, "subscriptionId", newJString(subscriptionId))
  add(path_568235, "regulatoryComplianceControlName",
      newJString(regulatoryComplianceControlName))
  add(query_568236, "$filter", newJString(Filter))
  result = call_568234.call(path_568235, query_568236, nil, nil, nil)

var regulatoryComplianceAssessmentsList* = Call_RegulatoryComplianceAssessmentsList_568225(
    name: "regulatoryComplianceAssessmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/regulatoryComplianceStandards/{regulatoryComplianceStandardName}/regulatoryComplianceControls/{regulatoryComplianceControlName}/regulatoryComplianceAssessments",
    validator: validate_RegulatoryComplianceAssessmentsList_568226, base: "",
    url: url_RegulatoryComplianceAssessmentsList_568227, schemes: {Scheme.Https})
type
  Call_RegulatoryComplianceAssessmentsGet_568237 = ref object of OpenApiRestCall_567657
proc url_RegulatoryComplianceAssessmentsGet_568239(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "regulatoryComplianceStandardName" in path,
        "`regulatoryComplianceStandardName` is a required path parameter"
  assert "regulatoryComplianceControlName" in path,
        "`regulatoryComplianceControlName` is a required path parameter"
  assert "regulatoryComplianceAssessmentName" in path,
        "`regulatoryComplianceAssessmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/regulatoryComplianceStandards/"), (
        kind: VariableSegment, value: "regulatoryComplianceStandardName"), (
        kind: ConstantSegment, value: "/regulatoryComplianceControls/"), (
        kind: VariableSegment, value: "regulatoryComplianceControlName"), (
        kind: ConstantSegment, value: "/regulatoryComplianceAssessments/"), (
        kind: VariableSegment, value: "regulatoryComplianceAssessmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegulatoryComplianceAssessmentsGet_568238(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Supported regulatory compliance details and state for selected assessment
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   regulatoryComplianceStandardName: JString (required)
  ##                                   : Name of the regulatory compliance standard object
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   regulatoryComplianceAssessmentName: JString (required)
  ##                                     : Name of the regulatory compliance assessment object
  ##   regulatoryComplianceControlName: JString (required)
  ##                                  : Name of the regulatory compliance control object
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `regulatoryComplianceStandardName` field"
  var valid_568240 = path.getOrDefault("regulatoryComplianceStandardName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "regulatoryComplianceStandardName", valid_568240
  var valid_568241 = path.getOrDefault("subscriptionId")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "subscriptionId", valid_568241
  var valid_568242 = path.getOrDefault("regulatoryComplianceAssessmentName")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "regulatoryComplianceAssessmentName", valid_568242
  var valid_568243 = path.getOrDefault("regulatoryComplianceControlName")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "regulatoryComplianceControlName", valid_568243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568244 = query.getOrDefault("api-version")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "api-version", valid_568244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568245: Call_RegulatoryComplianceAssessmentsGet_568237;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Supported regulatory compliance details and state for selected assessment
  ## 
  let valid = call_568245.validator(path, query, header, formData, body)
  let scheme = call_568245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568245.url(scheme.get, call_568245.host, call_568245.base,
                         call_568245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568245, url, valid)

proc call*(call_568246: Call_RegulatoryComplianceAssessmentsGet_568237;
          apiVersion: string; regulatoryComplianceStandardName: string;
          subscriptionId: string; regulatoryComplianceAssessmentName: string;
          regulatoryComplianceControlName: string): Recallable =
  ## regulatoryComplianceAssessmentsGet
  ## Supported regulatory compliance details and state for selected assessment
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   regulatoryComplianceStandardName: string (required)
  ##                                   : Name of the regulatory compliance standard object
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   regulatoryComplianceAssessmentName: string (required)
  ##                                     : Name of the regulatory compliance assessment object
  ##   regulatoryComplianceControlName: string (required)
  ##                                  : Name of the regulatory compliance control object
  var path_568247 = newJObject()
  var query_568248 = newJObject()
  add(query_568248, "api-version", newJString(apiVersion))
  add(path_568247, "regulatoryComplianceStandardName",
      newJString(regulatoryComplianceStandardName))
  add(path_568247, "subscriptionId", newJString(subscriptionId))
  add(path_568247, "regulatoryComplianceAssessmentName",
      newJString(regulatoryComplianceAssessmentName))
  add(path_568247, "regulatoryComplianceControlName",
      newJString(regulatoryComplianceControlName))
  result = call_568246.call(path_568247, query_568248, nil, nil, nil)

var regulatoryComplianceAssessmentsGet* = Call_RegulatoryComplianceAssessmentsGet_568237(
    name: "regulatoryComplianceAssessmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/regulatoryComplianceStandards/{regulatoryComplianceStandardName}/regulatoryComplianceControls/{regulatoryComplianceControlName}/regulatoryComplianceAssessments/{regulatoryComplianceAssessmentName}",
    validator: validate_RegulatoryComplianceAssessmentsGet_568238, base: "",
    url: url_RegulatoryComplianceAssessmentsGet_568239, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
