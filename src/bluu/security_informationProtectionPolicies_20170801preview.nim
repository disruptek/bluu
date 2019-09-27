
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Security Center
## version: 2017-08-01-preview
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
  macServiceName = "security-informationProtectionPolicies"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_InformationProtectionPoliciesList_593646 = ref object of OpenApiRestCall_593424
proc url_InformationProtectionPoliciesList_593648(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Security/informationProtectionPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InformationProtectionPoliciesList_593647(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Information protection policies of a specific management group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_593808 = path.getOrDefault("scope")
  valid_593808 = validateParameter(valid_593808, JString, required = true,
                                 default = nil)
  if valid_593808 != nil:
    section.add "scope", valid_593808
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593809 = query.getOrDefault("api-version")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = nil)
  if valid_593809 != nil:
    section.add "api-version", valid_593809
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593836: Call_InformationProtectionPoliciesList_593646;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Information protection policies of a specific management group.
  ## 
  let valid = call_593836.validator(path, query, header, formData, body)
  let scheme = call_593836.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593836.url(scheme.get, call_593836.host, call_593836.base,
                         call_593836.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593836, url, valid)

proc call*(call_593907: Call_InformationProtectionPoliciesList_593646;
          apiVersion: string; scope: string): Recallable =
  ## informationProtectionPoliciesList
  ## Information protection policies of a specific management group.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   scope: string (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  var path_593908 = newJObject()
  var query_593910 = newJObject()
  add(query_593910, "api-version", newJString(apiVersion))
  add(path_593908, "scope", newJString(scope))
  result = call_593907.call(path_593908, query_593910, nil, nil, nil)

var informationProtectionPoliciesList* = Call_InformationProtectionPoliciesList_593646(
    name: "informationProtectionPoliciesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Security/informationProtectionPolicies",
    validator: validate_InformationProtectionPoliciesList_593647, base: "",
    url: url_InformationProtectionPoliciesList_593648, schemes: {Scheme.Https})
type
  Call_InformationProtectionPoliciesCreateOrUpdate_593981 = ref object of OpenApiRestCall_593424
proc url_InformationProtectionPoliciesCreateOrUpdate_593983(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "informationProtectionPolicyName" in path,
        "`informationProtectionPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Security/informationProtectionPolicies/"), (
        kind: VariableSegment, value: "informationProtectionPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InformationProtectionPoliciesCreateOrUpdate_593982(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Details of the information protection policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   informationProtectionPolicyName: JString (required)
  ##                                  : Name of the information protection policy.
  ##   scope: JString (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `informationProtectionPolicyName` field"
  var valid_593984 = path.getOrDefault("informationProtectionPolicyName")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = newJString("effective"))
  if valid_593984 != nil:
    section.add "informationProtectionPolicyName", valid_593984
  var valid_593985 = path.getOrDefault("scope")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "scope", valid_593985
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
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

proc call*(call_593987: Call_InformationProtectionPoliciesCreateOrUpdate_593981;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Details of the information protection policy.
  ## 
  let valid = call_593987.validator(path, query, header, formData, body)
  let scheme = call_593987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593987.url(scheme.get, call_593987.host, call_593987.base,
                         call_593987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593987, url, valid)

proc call*(call_593988: Call_InformationProtectionPoliciesCreateOrUpdate_593981;
          apiVersion: string; scope: string;
          informationProtectionPolicyName: string = "effective"): Recallable =
  ## informationProtectionPoliciesCreateOrUpdate
  ## Details of the information protection policy.
  ##   informationProtectionPolicyName: string (required)
  ##                                  : Name of the information protection policy.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   scope: string (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  var path_593989 = newJObject()
  var query_593990 = newJObject()
  add(path_593989, "informationProtectionPolicyName",
      newJString(informationProtectionPolicyName))
  add(query_593990, "api-version", newJString(apiVersion))
  add(path_593989, "scope", newJString(scope))
  result = call_593988.call(path_593989, query_593990, nil, nil, nil)

var informationProtectionPoliciesCreateOrUpdate* = Call_InformationProtectionPoliciesCreateOrUpdate_593981(
    name: "informationProtectionPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Security/informationProtectionPolicies/{informationProtectionPolicyName}",
    validator: validate_InformationProtectionPoliciesCreateOrUpdate_593982,
    base: "", url: url_InformationProtectionPoliciesCreateOrUpdate_593983,
    schemes: {Scheme.Https})
type
  Call_InformationProtectionPoliciesGet_593949 = ref object of OpenApiRestCall_593424
proc url_InformationProtectionPoliciesGet_593951(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "informationProtectionPolicyName" in path,
        "`informationProtectionPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Security/informationProtectionPolicies/"), (
        kind: VariableSegment, value: "informationProtectionPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InformationProtectionPoliciesGet_593950(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Details of the information protection policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   informationProtectionPolicyName: JString (required)
  ##                                  : Name of the information protection policy.
  ##   scope: JString (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `informationProtectionPolicyName` field"
  var valid_593974 = path.getOrDefault("informationProtectionPolicyName")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = newJString("effective"))
  if valid_593974 != nil:
    section.add "informationProtectionPolicyName", valid_593974
  var valid_593975 = path.getOrDefault("scope")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "scope", valid_593975
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593976 = query.getOrDefault("api-version")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "api-version", valid_593976
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593977: Call_InformationProtectionPoliciesGet_593949;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Details of the information protection policy.
  ## 
  let valid = call_593977.validator(path, query, header, formData, body)
  let scheme = call_593977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593977.url(scheme.get, call_593977.host, call_593977.base,
                         call_593977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593977, url, valid)

proc call*(call_593978: Call_InformationProtectionPoliciesGet_593949;
          apiVersion: string; scope: string;
          informationProtectionPolicyName: string = "effective"): Recallable =
  ## informationProtectionPoliciesGet
  ## Details of the information protection policy.
  ##   informationProtectionPolicyName: string (required)
  ##                                  : Name of the information protection policy.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   scope: string (required)
  ##        : Scope of the query, can be subscription (/subscriptions/0b06d9ea-afe6-4779-bd59-30e5c2d9d13f) or management group (/providers/Microsoft.Management/managementGroups/mgName).
  var path_593979 = newJObject()
  var query_593980 = newJObject()
  add(path_593979, "informationProtectionPolicyName",
      newJString(informationProtectionPolicyName))
  add(query_593980, "api-version", newJString(apiVersion))
  add(path_593979, "scope", newJString(scope))
  result = call_593978.call(path_593979, query_593980, nil, nil, nil)

var informationProtectionPoliciesGet* = Call_InformationProtectionPoliciesGet_593949(
    name: "informationProtectionPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.Security/informationProtectionPolicies/{informationProtectionPolicyName}",
    validator: validate_InformationProtectionPoliciesGet_593950, base: "",
    url: url_InformationProtectionPoliciesGet_593951, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
