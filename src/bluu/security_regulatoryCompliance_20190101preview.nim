
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "security-regulatoryCompliance"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RegulatoryComplianceStandardsList_593646 = ref object of OpenApiRestCall_593424
proc url_RegulatoryComplianceStandardsList_593648(protocol: Scheme; host: string;
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

proc validate_RegulatoryComplianceStandardsList_593647(path: JsonNode;
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
  var valid_593809 = path.getOrDefault("subscriptionId")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = nil)
  if valid_593809 != nil:
    section.add "subscriptionId", valid_593809
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593810 = query.getOrDefault("api-version")
  valid_593810 = validateParameter(valid_593810, JString, required = true,
                                 default = nil)
  if valid_593810 != nil:
    section.add "api-version", valid_593810
  var valid_593811 = query.getOrDefault("$filter")
  valid_593811 = validateParameter(valid_593811, JString, required = false,
                                 default = nil)
  if valid_593811 != nil:
    section.add "$filter", valid_593811
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593838: Call_RegulatoryComplianceStandardsList_593646;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Supported regulatory compliance standards details and state
  ## 
  let valid = call_593838.validator(path, query, header, formData, body)
  let scheme = call_593838.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593838.url(scheme.get, call_593838.host, call_593838.base,
                         call_593838.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593838, url, valid)

proc call*(call_593909: Call_RegulatoryComplianceStandardsList_593646;
          apiVersion: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## regulatoryComplianceStandardsList
  ## Supported regulatory compliance standards details and state
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Filter: string
  ##         : OData filter. Optional.
  var path_593910 = newJObject()
  var query_593912 = newJObject()
  add(query_593912, "api-version", newJString(apiVersion))
  add(path_593910, "subscriptionId", newJString(subscriptionId))
  add(query_593912, "$filter", newJString(Filter))
  result = call_593909.call(path_593910, query_593912, nil, nil, nil)

var regulatoryComplianceStandardsList* = Call_RegulatoryComplianceStandardsList_593646(
    name: "regulatoryComplianceStandardsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/regulatoryComplianceStandards",
    validator: validate_RegulatoryComplianceStandardsList_593647, base: "",
    url: url_RegulatoryComplianceStandardsList_593648, schemes: {Scheme.Https})
type
  Call_RegulatoryComplianceStandardsGet_593951 = ref object of OpenApiRestCall_593424
proc url_RegulatoryComplianceStandardsGet_593953(protocol: Scheme; host: string;
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

proc validate_RegulatoryComplianceStandardsGet_593952(path: JsonNode;
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
  var valid_593963 = path.getOrDefault("regulatoryComplianceStandardName")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "regulatoryComplianceStandardName", valid_593963
  var valid_593964 = path.getOrDefault("subscriptionId")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "subscriptionId", valid_593964
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593965 = query.getOrDefault("api-version")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "api-version", valid_593965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593966: Call_RegulatoryComplianceStandardsGet_593951;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Supported regulatory compliance details state for selected standard
  ## 
  let valid = call_593966.validator(path, query, header, formData, body)
  let scheme = call_593966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593966.url(scheme.get, call_593966.host, call_593966.base,
                         call_593966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593966, url, valid)

proc call*(call_593967: Call_RegulatoryComplianceStandardsGet_593951;
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
  var path_593968 = newJObject()
  var query_593969 = newJObject()
  add(query_593969, "api-version", newJString(apiVersion))
  add(path_593968, "regulatoryComplianceStandardName",
      newJString(regulatoryComplianceStandardName))
  add(path_593968, "subscriptionId", newJString(subscriptionId))
  result = call_593967.call(path_593968, query_593969, nil, nil, nil)

var regulatoryComplianceStandardsGet* = Call_RegulatoryComplianceStandardsGet_593951(
    name: "regulatoryComplianceStandardsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/regulatoryComplianceStandards/{regulatoryComplianceStandardName}",
    validator: validate_RegulatoryComplianceStandardsGet_593952, base: "",
    url: url_RegulatoryComplianceStandardsGet_593953, schemes: {Scheme.Https})
type
  Call_RegulatoryComplianceControlsList_593970 = ref object of OpenApiRestCall_593424
proc url_RegulatoryComplianceControlsList_593972(protocol: Scheme; host: string;
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

proc validate_RegulatoryComplianceControlsList_593971(path: JsonNode;
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
  var valid_593973 = path.getOrDefault("regulatoryComplianceStandardName")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "regulatoryComplianceStandardName", valid_593973
  var valid_593974 = path.getOrDefault("subscriptionId")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "subscriptionId", valid_593974
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593975 = query.getOrDefault("api-version")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "api-version", valid_593975
  var valid_593976 = query.getOrDefault("$filter")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "$filter", valid_593976
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593977: Call_RegulatoryComplianceControlsList_593970;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## All supported regulatory compliance controls details and state for selected standard
  ## 
  let valid = call_593977.validator(path, query, header, formData, body)
  let scheme = call_593977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593977.url(scheme.get, call_593977.host, call_593977.base,
                         call_593977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593977, url, valid)

proc call*(call_593978: Call_RegulatoryComplianceControlsList_593970;
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
  var path_593979 = newJObject()
  var query_593980 = newJObject()
  add(query_593980, "api-version", newJString(apiVersion))
  add(path_593979, "regulatoryComplianceStandardName",
      newJString(regulatoryComplianceStandardName))
  add(path_593979, "subscriptionId", newJString(subscriptionId))
  add(query_593980, "$filter", newJString(Filter))
  result = call_593978.call(path_593979, query_593980, nil, nil, nil)

var regulatoryComplianceControlsList* = Call_RegulatoryComplianceControlsList_593970(
    name: "regulatoryComplianceControlsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/regulatoryComplianceStandards/{regulatoryComplianceStandardName}/regulatoryComplianceControls",
    validator: validate_RegulatoryComplianceControlsList_593971, base: "",
    url: url_RegulatoryComplianceControlsList_593972, schemes: {Scheme.Https})
type
  Call_RegulatoryComplianceControlsGet_593981 = ref object of OpenApiRestCall_593424
proc url_RegulatoryComplianceControlsGet_593983(protocol: Scheme; host: string;
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

proc validate_RegulatoryComplianceControlsGet_593982(path: JsonNode;
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
  var valid_593984 = path.getOrDefault("regulatoryComplianceStandardName")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "regulatoryComplianceStandardName", valid_593984
  var valid_593985 = path.getOrDefault("subscriptionId")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "subscriptionId", valid_593985
  var valid_593986 = path.getOrDefault("regulatoryComplianceControlName")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "regulatoryComplianceControlName", valid_593986
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593987 = query.getOrDefault("api-version")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "api-version", valid_593987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593988: Call_RegulatoryComplianceControlsGet_593981;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Selected regulatory compliance control details and state
  ## 
  let valid = call_593988.validator(path, query, header, formData, body)
  let scheme = call_593988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593988.url(scheme.get, call_593988.host, call_593988.base,
                         call_593988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593988, url, valid)

proc call*(call_593989: Call_RegulatoryComplianceControlsGet_593981;
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
  var path_593990 = newJObject()
  var query_593991 = newJObject()
  add(query_593991, "api-version", newJString(apiVersion))
  add(path_593990, "regulatoryComplianceStandardName",
      newJString(regulatoryComplianceStandardName))
  add(path_593990, "subscriptionId", newJString(subscriptionId))
  add(path_593990, "regulatoryComplianceControlName",
      newJString(regulatoryComplianceControlName))
  result = call_593989.call(path_593990, query_593991, nil, nil, nil)

var regulatoryComplianceControlsGet* = Call_RegulatoryComplianceControlsGet_593981(
    name: "regulatoryComplianceControlsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/regulatoryComplianceStandards/{regulatoryComplianceStandardName}/regulatoryComplianceControls/{regulatoryComplianceControlName}",
    validator: validate_RegulatoryComplianceControlsGet_593982, base: "",
    url: url_RegulatoryComplianceControlsGet_593983, schemes: {Scheme.Https})
type
  Call_RegulatoryComplianceAssessmentsList_593992 = ref object of OpenApiRestCall_593424
proc url_RegulatoryComplianceAssessmentsList_593994(protocol: Scheme; host: string;
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

proc validate_RegulatoryComplianceAssessmentsList_593993(path: JsonNode;
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
  var valid_593995 = path.getOrDefault("regulatoryComplianceStandardName")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "regulatoryComplianceStandardName", valid_593995
  var valid_593996 = path.getOrDefault("subscriptionId")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "subscriptionId", valid_593996
  var valid_593997 = path.getOrDefault("regulatoryComplianceControlName")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "regulatoryComplianceControlName", valid_593997
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $filter: JString
  ##          : OData filter. Optional.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593998 = query.getOrDefault("api-version")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "api-version", valid_593998
  var valid_593999 = query.getOrDefault("$filter")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "$filter", valid_593999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594000: Call_RegulatoryComplianceAssessmentsList_593992;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Details and state of assessments mapped to selected regulatory compliance control
  ## 
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_RegulatoryComplianceAssessmentsList_593992;
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
  var path_594002 = newJObject()
  var query_594003 = newJObject()
  add(query_594003, "api-version", newJString(apiVersion))
  add(path_594002, "regulatoryComplianceStandardName",
      newJString(regulatoryComplianceStandardName))
  add(path_594002, "subscriptionId", newJString(subscriptionId))
  add(path_594002, "regulatoryComplianceControlName",
      newJString(regulatoryComplianceControlName))
  add(query_594003, "$filter", newJString(Filter))
  result = call_594001.call(path_594002, query_594003, nil, nil, nil)

var regulatoryComplianceAssessmentsList* = Call_RegulatoryComplianceAssessmentsList_593992(
    name: "regulatoryComplianceAssessmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/regulatoryComplianceStandards/{regulatoryComplianceStandardName}/regulatoryComplianceControls/{regulatoryComplianceControlName}/regulatoryComplianceAssessments",
    validator: validate_RegulatoryComplianceAssessmentsList_593993, base: "",
    url: url_RegulatoryComplianceAssessmentsList_593994, schemes: {Scheme.Https})
type
  Call_RegulatoryComplianceAssessmentsGet_594004 = ref object of OpenApiRestCall_593424
proc url_RegulatoryComplianceAssessmentsGet_594006(protocol: Scheme; host: string;
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

proc validate_RegulatoryComplianceAssessmentsGet_594005(path: JsonNode;
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
  var valid_594007 = path.getOrDefault("regulatoryComplianceStandardName")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "regulatoryComplianceStandardName", valid_594007
  var valid_594008 = path.getOrDefault("subscriptionId")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "subscriptionId", valid_594008
  var valid_594009 = path.getOrDefault("regulatoryComplianceAssessmentName")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "regulatoryComplianceAssessmentName", valid_594009
  var valid_594010 = path.getOrDefault("regulatoryComplianceControlName")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "regulatoryComplianceControlName", valid_594010
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594011 = query.getOrDefault("api-version")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "api-version", valid_594011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594012: Call_RegulatoryComplianceAssessmentsGet_594004;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Supported regulatory compliance details and state for selected assessment
  ## 
  let valid = call_594012.validator(path, query, header, formData, body)
  let scheme = call_594012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594012.url(scheme.get, call_594012.host, call_594012.base,
                         call_594012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594012, url, valid)

proc call*(call_594013: Call_RegulatoryComplianceAssessmentsGet_594004;
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
  var path_594014 = newJObject()
  var query_594015 = newJObject()
  add(query_594015, "api-version", newJString(apiVersion))
  add(path_594014, "regulatoryComplianceStandardName",
      newJString(regulatoryComplianceStandardName))
  add(path_594014, "subscriptionId", newJString(subscriptionId))
  add(path_594014, "regulatoryComplianceAssessmentName",
      newJString(regulatoryComplianceAssessmentName))
  add(path_594014, "regulatoryComplianceControlName",
      newJString(regulatoryComplianceControlName))
  result = call_594013.call(path_594014, query_594015, nil, nil, nil)

var regulatoryComplianceAssessmentsGet* = Call_RegulatoryComplianceAssessmentsGet_594004(
    name: "regulatoryComplianceAssessmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Security/regulatoryComplianceStandards/{regulatoryComplianceStandardName}/regulatoryComplianceControls/{regulatoryComplianceControlName}/regulatoryComplianceAssessments/{regulatoryComplianceAssessmentName}",
    validator: validate_RegulatoryComplianceAssessmentsGet_594005, base: "",
    url: url_RegulatoryComplianceAssessmentsGet_594006, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
