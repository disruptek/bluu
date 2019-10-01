
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on Quota entity associated with your Azure API Management deployment. To configure call rate limit and quota policies refer to [how to configure call rate limit and quota](https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies).
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

  OpenApiRestCall_596458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596458): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement-apimquotas"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_QuotaByCounterKeysList_596680 = ref object of OpenApiRestCall_596458
proc url_QuotaByCounterKeysList_596682(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "quotaCounterKey" in path, "`quotaCounterKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/quotas/"),
               (kind: VariableSegment, value: "quotaCounterKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuotaByCounterKeysList_596681(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of current quota counter periods associated with the counter-key configured in the policy on the specified service instance. The api does not support paging yet.
  ## 
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   quotaCounterKey: JString (required)
  ##                  : Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key="boo" in the policy, then it’s accessible by "boo" counter key. But if it’s defined as counter-key="@("b"+"a")" then it will be accessible by "ba" key
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `quotaCounterKey` field"
  var valid_596855 = path.getOrDefault("quotaCounterKey")
  valid_596855 = validateParameter(valid_596855, JString, required = true,
                                 default = nil)
  if valid_596855 != nil:
    section.add "quotaCounterKey", valid_596855
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596856 = query.getOrDefault("api-version")
  valid_596856 = validateParameter(valid_596856, JString, required = true,
                                 default = nil)
  if valid_596856 != nil:
    section.add "api-version", valid_596856
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596879: Call_QuotaByCounterKeysList_596680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of current quota counter periods associated with the counter-key configured in the policy on the specified service instance. The api does not support paging yet.
  ## 
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  let valid = call_596879.validator(path, query, header, formData, body)
  let scheme = call_596879.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596879.url(scheme.get, call_596879.host, call_596879.base,
                         call_596879.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596879, url, valid)

proc call*(call_596950: Call_QuotaByCounterKeysList_596680;
          quotaCounterKey: string; apiVersion: string): Recallable =
  ## quotaByCounterKeysList
  ## Lists a collection of current quota counter periods associated with the counter-key configured in the policy on the specified service instance. The api does not support paging yet.
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  ##   quotaCounterKey: string (required)
  ##                  : Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key="boo" in the policy, then it’s accessible by "boo" counter key. But if it’s defined as counter-key="@("b"+"a")" then it will be accessible by "ba" key
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  var path_596951 = newJObject()
  var query_596953 = newJObject()
  add(path_596951, "quotaCounterKey", newJString(quotaCounterKey))
  add(query_596953, "api-version", newJString(apiVersion))
  result = call_596950.call(path_596951, query_596953, nil, nil, nil)

var quotaByCounterKeysList* = Call_QuotaByCounterKeysList_596680(
    name: "quotaByCounterKeysList", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/quotas/{quotaCounterKey}",
    validator: validate_QuotaByCounterKeysList_596681, base: "",
    url: url_QuotaByCounterKeysList_596682, schemes: {Scheme.Https})
type
  Call_QuotaByCounterKeysUpdate_596992 = ref object of OpenApiRestCall_596458
proc url_QuotaByCounterKeysUpdate_596994(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "quotaCounterKey" in path, "`quotaCounterKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/quotas/"),
               (kind: VariableSegment, value: "quotaCounterKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuotaByCounterKeysUpdate_596993(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates all the quota counter values specified with the existing quota counter key to a value in the specified service instance. This should be used for reset of the quota counter values.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   quotaCounterKey: JString (required)
  ##                  : Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key="boo" in the policy, then it’s accessible by "boo" counter key. But if it’s defined as counter-key="@("b"+"a")" then it will be accessible by "ba" key
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `quotaCounterKey` field"
  var valid_597012 = path.getOrDefault("quotaCounterKey")
  valid_597012 = validateParameter(valid_597012, JString, required = true,
                                 default = nil)
  if valid_597012 != nil:
    section.add "quotaCounterKey", valid_597012
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597013 = query.getOrDefault("api-version")
  valid_597013 = validateParameter(valid_597013, JString, required = true,
                                 default = nil)
  if valid_597013 != nil:
    section.add "api-version", valid_597013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The value of the quota counter to be applied to all quota counter periods.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597015: Call_QuotaByCounterKeysUpdate_596992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates all the quota counter values specified with the existing quota counter key to a value in the specified service instance. This should be used for reset of the quota counter values.
  ## 
  let valid = call_597015.validator(path, query, header, formData, body)
  let scheme = call_597015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597015.url(scheme.get, call_597015.host, call_597015.base,
                         call_597015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597015, url, valid)

proc call*(call_597016: Call_QuotaByCounterKeysUpdate_596992;
          quotaCounterKey: string; apiVersion: string; parameters: JsonNode): Recallable =
  ## quotaByCounterKeysUpdate
  ## Updates all the quota counter values specified with the existing quota counter key to a value in the specified service instance. This should be used for reset of the quota counter values.
  ##   quotaCounterKey: string (required)
  ##                  : Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key="boo" in the policy, then it’s accessible by "boo" counter key. But if it’s defined as counter-key="@("b"+"a")" then it will be accessible by "ba" key
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   parameters: JObject (required)
  ##             : The value of the quota counter to be applied to all quota counter periods.
  var path_597017 = newJObject()
  var query_597018 = newJObject()
  var body_597019 = newJObject()
  add(path_597017, "quotaCounterKey", newJString(quotaCounterKey))
  add(query_597018, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_597019 = parameters
  result = call_597016.call(path_597017, query_597018, nil, nil, body_597019)

var quotaByCounterKeysUpdate* = Call_QuotaByCounterKeysUpdate_596992(
    name: "quotaByCounterKeysUpdate", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/quotas/{quotaCounterKey}",
    validator: validate_QuotaByCounterKeysUpdate_596993, base: "",
    url: url_QuotaByCounterKeysUpdate_596994, schemes: {Scheme.Https})
type
  Call_QuotaByPeriodKeysGet_597020 = ref object of OpenApiRestCall_596458
proc url_QuotaByPeriodKeysGet_597022(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "quotaCounterKey" in path, "`quotaCounterKey` is a required path parameter"
  assert "quotaPeriodKey" in path, "`quotaPeriodKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/quotas/"),
               (kind: VariableSegment, value: "quotaCounterKey"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "quotaPeriodKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuotaByPeriodKeysGet_597021(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the value of the quota counter associated with the counter-key in the policy for the specific period in service instance.
  ## 
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   quotaCounterKey: JString (required)
  ##                  : Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key="boo" in the policy, then it’s accessible by "boo" counter key. But if it’s defined as counter-key="@("b"+"a")" then it will be accessible by "ba" key
  ##   quotaPeriodKey: JString (required)
  ##                 : Quota period key identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `quotaCounterKey` field"
  var valid_597023 = path.getOrDefault("quotaCounterKey")
  valid_597023 = validateParameter(valid_597023, JString, required = true,
                                 default = nil)
  if valid_597023 != nil:
    section.add "quotaCounterKey", valid_597023
  var valid_597024 = path.getOrDefault("quotaPeriodKey")
  valid_597024 = validateParameter(valid_597024, JString, required = true,
                                 default = nil)
  if valid_597024 != nil:
    section.add "quotaPeriodKey", valid_597024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597025 = query.getOrDefault("api-version")
  valid_597025 = validateParameter(valid_597025, JString, required = true,
                                 default = nil)
  if valid_597025 != nil:
    section.add "api-version", valid_597025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597026: Call_QuotaByPeriodKeysGet_597020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the value of the quota counter associated with the counter-key in the policy for the specific period in service instance.
  ## 
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  let valid = call_597026.validator(path, query, header, formData, body)
  let scheme = call_597026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597026.url(scheme.get, call_597026.host, call_597026.base,
                         call_597026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597026, url, valid)

proc call*(call_597027: Call_QuotaByPeriodKeysGet_597020; quotaCounterKey: string;
          apiVersion: string; quotaPeriodKey: string): Recallable =
  ## quotaByPeriodKeysGet
  ## Gets the value of the quota counter associated with the counter-key in the policy for the specific period in service instance.
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  ##   quotaCounterKey: string (required)
  ##                  : Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key="boo" in the policy, then it’s accessible by "boo" counter key. But if it’s defined as counter-key="@("b"+"a")" then it will be accessible by "ba" key
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   quotaPeriodKey: string (required)
  ##                 : Quota period key identifier.
  var path_597028 = newJObject()
  var query_597029 = newJObject()
  add(path_597028, "quotaCounterKey", newJString(quotaCounterKey))
  add(query_597029, "api-version", newJString(apiVersion))
  add(path_597028, "quotaPeriodKey", newJString(quotaPeriodKey))
  result = call_597027.call(path_597028, query_597029, nil, nil, nil)

var quotaByPeriodKeysGet* = Call_QuotaByPeriodKeysGet_597020(
    name: "quotaByPeriodKeysGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/quotas/{quotaCounterKey}/{quotaPeriodKey}",
    validator: validate_QuotaByPeriodKeysGet_597021, base: "",
    url: url_QuotaByPeriodKeysGet_597022, schemes: {Scheme.Https})
type
  Call_QuotaByPeriodKeysUpdate_597030 = ref object of OpenApiRestCall_596458
proc url_QuotaByPeriodKeysUpdate_597032(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "quotaCounterKey" in path, "`quotaCounterKey` is a required path parameter"
  assert "quotaPeriodKey" in path, "`quotaPeriodKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/quotas/"),
               (kind: VariableSegment, value: "quotaCounterKey"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "quotaPeriodKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuotaByPeriodKeysUpdate_597031(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing quota counter value in the specified service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   quotaCounterKey: JString (required)
  ##                  : Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key="boo" in the policy, then it’s accessible by "boo" counter key. But if it’s defined as counter-key="@("b"+"a")" then it will be accessible by "ba" key
  ##   quotaPeriodKey: JString (required)
  ##                 : Quota period key identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `quotaCounterKey` field"
  var valid_597033 = path.getOrDefault("quotaCounterKey")
  valid_597033 = validateParameter(valid_597033, JString, required = true,
                                 default = nil)
  if valid_597033 != nil:
    section.add "quotaCounterKey", valid_597033
  var valid_597034 = path.getOrDefault("quotaPeriodKey")
  valid_597034 = validateParameter(valid_597034, JString, required = true,
                                 default = nil)
  if valid_597034 != nil:
    section.add "quotaPeriodKey", valid_597034
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597035 = query.getOrDefault("api-version")
  valid_597035 = validateParameter(valid_597035, JString, required = true,
                                 default = nil)
  if valid_597035 != nil:
    section.add "api-version", valid_597035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The value of the Quota counter to be applied on the specified period.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597037: Call_QuotaByPeriodKeysUpdate_597030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing quota counter value in the specified service instance.
  ## 
  let valid = call_597037.validator(path, query, header, formData, body)
  let scheme = call_597037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597037.url(scheme.get, call_597037.host, call_597037.base,
                         call_597037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597037, url, valid)

proc call*(call_597038: Call_QuotaByPeriodKeysUpdate_597030;
          quotaCounterKey: string; apiVersion: string; quotaPeriodKey: string;
          parameters: JsonNode): Recallable =
  ## quotaByPeriodKeysUpdate
  ## Updates an existing quota counter value in the specified service instance.
  ##   quotaCounterKey: string (required)
  ##                  : Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key="boo" in the policy, then it’s accessible by "boo" counter key. But if it’s defined as counter-key="@("b"+"a")" then it will be accessible by "ba" key
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   quotaPeriodKey: string (required)
  ##                 : Quota period key identifier.
  ##   parameters: JObject (required)
  ##             : The value of the Quota counter to be applied on the specified period.
  var path_597039 = newJObject()
  var query_597040 = newJObject()
  var body_597041 = newJObject()
  add(path_597039, "quotaCounterKey", newJString(quotaCounterKey))
  add(query_597040, "api-version", newJString(apiVersion))
  add(path_597039, "quotaPeriodKey", newJString(quotaPeriodKey))
  if parameters != nil:
    body_597041 = parameters
  result = call_597038.call(path_597039, query_597040, nil, nil, body_597041)

var quotaByPeriodKeysUpdate* = Call_QuotaByPeriodKeysUpdate_597030(
    name: "quotaByPeriodKeysUpdate", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/quotas/{quotaCounterKey}/{quotaPeriodKey}",
    validator: validate_QuotaByPeriodKeysUpdate_597031, base: "",
    url: url_QuotaByPeriodKeysUpdate_597032, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
