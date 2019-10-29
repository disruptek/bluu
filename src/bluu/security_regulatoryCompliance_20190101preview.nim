
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
  macServiceName = "security-regulatoryCompliance"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RegulatoryComplianceStandardsList_563777 = ref object of OpenApiRestCall_563555
proc url_RegulatoryComplianceStandardsList_563779(protocol: Scheme; host: string;
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

proc validate_RegulatoryComplianceStandardsList_563778(path: JsonNode;
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
  var valid_563942 = path.getOrDefault("subscriptionId")
  valid_563942 = validateParameter(valid_563942, JString, required = true,
                                 default = nil)
  if valid_563942 != nil:
    section.add "subscriptionId", valid_563942
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563943 = query.getOrDefault("api-version")
  valid_563943 = validateParameter(valid_563943, JString, required = true,
                                 default = nil)
  if valid_563943 != nil:
    section.add "api-version", valid_563943
  var valid_563944 = query.getOrDefault("$filter")
  valid_563944 = validateParameter(valid_563944, JString, required = false,
                                 default = nil)
  if valid_563944 != nil:
    section.add "$filter", valid_563944
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563971: Call_RegulatoryComplianceStandardsList_563777;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Supported regulatory compliance standards details and state
  ## 
  let valid = call_563971.validator(path, query, header, formData, body)
  let scheme = call_563971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563971.url(scheme.get, call_563971.host, call_563971.base,
                         call_563971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563971, url, valid)

proc call*(call_564042: Call_RegulatoryComplianceStandardsList_563777;
          apiVersion: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## regulatoryComplianceStandardsList
  ## Supported regulatory compliance standards details and state
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_564043 = newJObject()
  var query_564045 = newJObject()
  add(query_564045, "api-version", newJString(apiVersion))
  add(path_564043, "subscriptionId", newJString(subscriptionId))
  add(query_564045, "$filter", newJString(Filter))
  result = call_564042.call(path_564043, query_564045, nil, nil, nil)

var regulatoryComplianceStandardsList* = Call_RegulatoryComplianceStandardsList_563777(
    name: "regulatoryComplianceStandardsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/regulatoryComplianceStandards",
    validator: validate_RegulatoryComplianceStandardsList_563778, base: "",
    url: url_RegulatoryComplianceStandardsList_563779, schemes: {Scheme.Https})
type
  Call_RegulatoryComplianceStandardsGet_564084 = ref object of OpenApiRestCall_563555
proc url_RegulatoryComplianceStandardsGet_564086(protocol: Scheme; host: string;
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

proc validate_RegulatoryComplianceStandardsGet_564085(path: JsonNode;
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
  var valid_564096 = path.getOrDefault("regulatoryComplianceStandardName")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "regulatoryComplianceStandardName", valid_564096
  var valid_564097 = path.getOrDefault("subscriptionId")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "subscriptionId", valid_564097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564098 = query.getOrDefault("api-version")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "api-version", valid_564098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564099: Call_RegulatoryComplianceStandardsGet_564084;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Supported regulatory compliance details state for selected standard
  ## 
  let valid = call_564099.validator(path, query, header, formData, body)
  let scheme = call_564099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564099.url(scheme.get, call_564099.host, call_564099.base,
                         call_564099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564099, url, valid)

proc call*(call_564100: Call_RegulatoryComplianceStandardsGet_564084;
          regulatoryComplianceStandardName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## regulatoryComplianceStandardsGet
  ## Supported regulatory compliance details state for selected standard
  ##   regulatoryComplianceStandardName: string (required)
  ##                                   : Name of the regulatory compliance standard object
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_564101 = newJObject()
  var query_564102 = newJObject()
  add(path_564101, "regulatoryComplianceStandardName",
      newJString(regulatoryComplianceStandardName))
  add(query_564102, "api-version", newJString(apiVersion))
  add(path_564101, "subscriptionId", newJString(subscriptionId))
  result = call_564100.call(path_564101, query_564102, nil, nil, nil)

var regulatoryComplianceStandardsGet* = Call_RegulatoryComplianceStandardsGet_564084(
    name: "regulatoryComplianceStandardsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/regulatoryComplianceStandards/{regulatoryComplianceStandardName}",
    validator: validate_RegulatoryComplianceStandardsGet_564085, base: "",
    url: url_RegulatoryComplianceStandardsGet_564086, schemes: {Scheme.Https})
type
  Call_RegulatoryComplianceControlsList_564103 = ref object of OpenApiRestCall_563555
proc url_RegulatoryComplianceControlsList_564105(protocol: Scheme; host: string;
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

proc validate_RegulatoryComplianceControlsList_564104(path: JsonNode;
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
  var valid_564106 = path.getOrDefault("regulatoryComplianceStandardName")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "regulatoryComplianceStandardName", valid_564106
  var valid_564107 = path.getOrDefault("subscriptionId")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "subscriptionId", valid_564107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564108 = query.getOrDefault("api-version")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = nil)
  if valid_564108 != nil:
    section.add "api-version", valid_564108
  var valid_564109 = query.getOrDefault("$filter")
  valid_564109 = validateParameter(valid_564109, JString, required = false,
                                 default = nil)
  if valid_564109 != nil:
    section.add "$filter", valid_564109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564110: Call_RegulatoryComplianceControlsList_564103;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## All supported regulatory compliance controls details and state for selected standard
  ## 
  let valid = call_564110.validator(path, query, header, formData, body)
  let scheme = call_564110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564110.url(scheme.get, call_564110.host, call_564110.base,
                         call_564110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564110, url, valid)

proc call*(call_564111: Call_RegulatoryComplianceControlsList_564103;
          regulatoryComplianceStandardName: string; apiVersion: string;
          subscriptionId: string; Filter: string = ""): Recallable =
  ## regulatoryComplianceControlsList
  ## All supported regulatory compliance controls details and state for selected standard
  ##   regulatoryComplianceStandardName: string (required)
  ##                                   : Name of the regulatory compliance standard object
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_564112 = newJObject()
  var query_564113 = newJObject()
  add(path_564112, "regulatoryComplianceStandardName",
      newJString(regulatoryComplianceStandardName))
  add(query_564113, "api-version", newJString(apiVersion))
  add(path_564112, "subscriptionId", newJString(subscriptionId))
  add(query_564113, "$filter", newJString(Filter))
  result = call_564111.call(path_564112, query_564113, nil, nil, nil)

var regulatoryComplianceControlsList* = Call_RegulatoryComplianceControlsList_564103(
    name: "regulatoryComplianceControlsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/regulatoryComplianceStandards/{regulatoryComplianceStandardName}/regulatoryComplianceControls",
    validator: validate_RegulatoryComplianceControlsList_564104, base: "",
    url: url_RegulatoryComplianceControlsList_564105, schemes: {Scheme.Https})
type
  Call_RegulatoryComplianceControlsGet_564114 = ref object of OpenApiRestCall_563555
proc url_RegulatoryComplianceControlsGet_564116(protocol: Scheme; host: string;
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

proc validate_RegulatoryComplianceControlsGet_564115(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Selected regulatory compliance control details and state
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   regulatoryComplianceStandardName: JString (required)
  ##                                   : Name of the regulatory compliance standard object
  ##   regulatoryComplianceControlName: JString (required)
  ##                                  : Name of the regulatory compliance control object
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `regulatoryComplianceStandardName` field"
  var valid_564117 = path.getOrDefault("regulatoryComplianceStandardName")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "regulatoryComplianceStandardName", valid_564117
  var valid_564118 = path.getOrDefault("regulatoryComplianceControlName")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "regulatoryComplianceControlName", valid_564118
  var valid_564119 = path.getOrDefault("subscriptionId")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "subscriptionId", valid_564119
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564120 = query.getOrDefault("api-version")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "api-version", valid_564120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564121: Call_RegulatoryComplianceControlsGet_564114;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Selected regulatory compliance control details and state
  ## 
  let valid = call_564121.validator(path, query, header, formData, body)
  let scheme = call_564121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564121.url(scheme.get, call_564121.host, call_564121.base,
                         call_564121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564121, url, valid)

proc call*(call_564122: Call_RegulatoryComplianceControlsGet_564114;
          regulatoryComplianceStandardName: string; apiVersion: string;
          regulatoryComplianceControlName: string; subscriptionId: string): Recallable =
  ## regulatoryComplianceControlsGet
  ## Selected regulatory compliance control details and state
  ##   regulatoryComplianceStandardName: string (required)
  ##                                   : Name of the regulatory compliance standard object
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   regulatoryComplianceControlName: string (required)
  ##                                  : Name of the regulatory compliance control object
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_564123 = newJObject()
  var query_564124 = newJObject()
  add(path_564123, "regulatoryComplianceStandardName",
      newJString(regulatoryComplianceStandardName))
  add(query_564124, "api-version", newJString(apiVersion))
  add(path_564123, "regulatoryComplianceControlName",
      newJString(regulatoryComplianceControlName))
  add(path_564123, "subscriptionId", newJString(subscriptionId))
  result = call_564122.call(path_564123, query_564124, nil, nil, nil)

var regulatoryComplianceControlsGet* = Call_RegulatoryComplianceControlsGet_564114(
    name: "regulatoryComplianceControlsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/regulatoryComplianceStandards/{regulatoryComplianceStandardName}/regulatoryComplianceControls/{regulatoryComplianceControlName}",
    validator: validate_RegulatoryComplianceControlsGet_564115, base: "",
    url: url_RegulatoryComplianceControlsGet_564116, schemes: {Scheme.Https})
type
  Call_RegulatoryComplianceAssessmentsList_564125 = ref object of OpenApiRestCall_563555
proc url_RegulatoryComplianceAssessmentsList_564127(protocol: Scheme; host: string;
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

proc validate_RegulatoryComplianceAssessmentsList_564126(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Details and state of assessments mapped to selected regulatory compliance control
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   regulatoryComplianceStandardName: JString (required)
  ##                                   : Name of the regulatory compliance standard object
  ##   regulatoryComplianceControlName: JString (required)
  ##                                  : Name of the regulatory compliance control object
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `regulatoryComplianceStandardName` field"
  var valid_564128 = path.getOrDefault("regulatoryComplianceStandardName")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "regulatoryComplianceStandardName", valid_564128
  var valid_564129 = path.getOrDefault("regulatoryComplianceControlName")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "regulatoryComplianceControlName", valid_564129
  var valid_564130 = path.getOrDefault("subscriptionId")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "subscriptionId", valid_564130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564131 = query.getOrDefault("api-version")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "api-version", valid_564131
  var valid_564132 = query.getOrDefault("$filter")
  valid_564132 = validateParameter(valid_564132, JString, required = false,
                                 default = nil)
  if valid_564132 != nil:
    section.add "$filter", valid_564132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564133: Call_RegulatoryComplianceAssessmentsList_564125;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Details and state of assessments mapped to selected regulatory compliance control
  ## 
  let valid = call_564133.validator(path, query, header, formData, body)
  let scheme = call_564133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564133.url(scheme.get, call_564133.host, call_564133.base,
                         call_564133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564133, url, valid)

proc call*(call_564134: Call_RegulatoryComplianceAssessmentsList_564125;
          regulatoryComplianceStandardName: string; apiVersion: string;
          regulatoryComplianceControlName: string; subscriptionId: string;
          Filter: string = ""): Recallable =
  ## regulatoryComplianceAssessmentsList
  ## Details and state of assessments mapped to selected regulatory compliance control
  ##   regulatoryComplianceStandardName: string (required)
  ##                                   : Name of the regulatory compliance standard object
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   regulatoryComplianceControlName: string (required)
  ##                                  : Name of the regulatory compliance control object
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_564135 = newJObject()
  var query_564136 = newJObject()
  add(path_564135, "regulatoryComplianceStandardName",
      newJString(regulatoryComplianceStandardName))
  add(query_564136, "api-version", newJString(apiVersion))
  add(path_564135, "regulatoryComplianceControlName",
      newJString(regulatoryComplianceControlName))
  add(path_564135, "subscriptionId", newJString(subscriptionId))
  add(query_564136, "$filter", newJString(Filter))
  result = call_564134.call(path_564135, query_564136, nil, nil, nil)

var regulatoryComplianceAssessmentsList* = Call_RegulatoryComplianceAssessmentsList_564125(
    name: "regulatoryComplianceAssessmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/regulatoryComplianceStandards/{regulatoryComplianceStandardName}/regulatoryComplianceControls/{regulatoryComplianceControlName}/regulatoryComplianceAssessments",
    validator: validate_RegulatoryComplianceAssessmentsList_564126, base: "",
    url: url_RegulatoryComplianceAssessmentsList_564127, schemes: {Scheme.Https})
type
  Call_RegulatoryComplianceAssessmentsGet_564137 = ref object of OpenApiRestCall_563555
proc url_RegulatoryComplianceAssessmentsGet_564139(protocol: Scheme; host: string;
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

proc validate_RegulatoryComplianceAssessmentsGet_564138(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Supported regulatory compliance details and state for selected assessment
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   regulatoryComplianceStandardName: JString (required)
  ##                                   : Name of the regulatory compliance standard object
  ##   regulatoryComplianceAssessmentName: JString (required)
  ##                                     : Name of the regulatory compliance assessment object
  ##   regulatoryComplianceControlName: JString (required)
  ##                                  : Name of the regulatory compliance control object
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `regulatoryComplianceStandardName` field"
  var valid_564140 = path.getOrDefault("regulatoryComplianceStandardName")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "regulatoryComplianceStandardName", valid_564140
  var valid_564141 = path.getOrDefault("regulatoryComplianceAssessmentName")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "regulatoryComplianceAssessmentName", valid_564141
  var valid_564142 = path.getOrDefault("regulatoryComplianceControlName")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "regulatoryComplianceControlName", valid_564142
  var valid_564143 = path.getOrDefault("subscriptionId")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "subscriptionId", valid_564143
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564144 = query.getOrDefault("api-version")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "api-version", valid_564144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564145: Call_RegulatoryComplianceAssessmentsGet_564137;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Supported regulatory compliance details and state for selected assessment
  ## 
  let valid = call_564145.validator(path, query, header, formData, body)
  let scheme = call_564145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564145.url(scheme.get, call_564145.host, call_564145.base,
                         call_564145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564145, url, valid)

proc call*(call_564146: Call_RegulatoryComplianceAssessmentsGet_564137;
          regulatoryComplianceStandardName: string; apiVersion: string;
          regulatoryComplianceAssessmentName: string;
          regulatoryComplianceControlName: string; subscriptionId: string): Recallable =
  ## regulatoryComplianceAssessmentsGet
  ## Supported regulatory compliance details and state for selected assessment
  ##   regulatoryComplianceStandardName: string (required)
  ##                                   : Name of the regulatory compliance standard object
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   regulatoryComplianceAssessmentName: string (required)
  ##                                     : Name of the regulatory compliance assessment object
  ##   regulatoryComplianceControlName: string (required)
  ##                                  : Name of the regulatory compliance control object
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  var path_564147 = newJObject()
  var query_564148 = newJObject()
  add(path_564147, "regulatoryComplianceStandardName",
      newJString(regulatoryComplianceStandardName))
  add(query_564148, "api-version", newJString(apiVersion))
  add(path_564147, "regulatoryComplianceAssessmentName",
      newJString(regulatoryComplianceAssessmentName))
  add(path_564147, "regulatoryComplianceControlName",
      newJString(regulatoryComplianceControlName))
  add(path_564147, "subscriptionId", newJString(subscriptionId))
  result = call_564146.call(path_564147, query_564148, nil, nil, nil)

var regulatoryComplianceAssessmentsGet* = Call_RegulatoryComplianceAssessmentsGet_564137(
    name: "regulatoryComplianceAssessmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/regulatoryComplianceStandards/{regulatoryComplianceStandardName}/regulatoryComplianceControls/{regulatoryComplianceControlName}/regulatoryComplianceAssessments/{regulatoryComplianceAssessmentName}",
    validator: validate_RegulatoryComplianceAssessmentsGet_564138, base: "",
    url: url_RegulatoryComplianceAssessmentsGet_564139, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
