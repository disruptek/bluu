
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2018-06-01-preview
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
  Call_QuotaByCounterKeysListByService_596680 = ref object of OpenApiRestCall_596458
proc url_QuotaByCounterKeysListByService_596682(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "quotaCounterKey" in path, "`quotaCounterKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/quotas/"),
               (kind: VariableSegment, value: "quotaCounterKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuotaByCounterKeysListByService_596681(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a collection of current quota counter periods associated with the counter-key configured in the policy on the specified service instance. The api does not support paging yet.
  ## 
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   quotaCounterKey: JString (required)
  ##                  : Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key="boo" in the policy, then it’s accessible by "boo" counter key. But if it’s defined as counter-key="@("b"+"a")" then it will be accessible by "ba" key
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `quotaCounterKey` field"
  var valid_596842 = path.getOrDefault("quotaCounterKey")
  valid_596842 = validateParameter(valid_596842, JString, required = true,
                                 default = nil)
  if valid_596842 != nil:
    section.add "quotaCounterKey", valid_596842
  var valid_596843 = path.getOrDefault("resourceGroupName")
  valid_596843 = validateParameter(valid_596843, JString, required = true,
                                 default = nil)
  if valid_596843 != nil:
    section.add "resourceGroupName", valid_596843
  var valid_596844 = path.getOrDefault("subscriptionId")
  valid_596844 = validateParameter(valid_596844, JString, required = true,
                                 default = nil)
  if valid_596844 != nil:
    section.add "subscriptionId", valid_596844
  var valid_596845 = path.getOrDefault("serviceName")
  valid_596845 = validateParameter(valid_596845, JString, required = true,
                                 default = nil)
  if valid_596845 != nil:
    section.add "serviceName", valid_596845
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596846 = query.getOrDefault("api-version")
  valid_596846 = validateParameter(valid_596846, JString, required = true,
                                 default = nil)
  if valid_596846 != nil:
    section.add "api-version", valid_596846
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596873: Call_QuotaByCounterKeysListByService_596680;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a collection of current quota counter periods associated with the counter-key configured in the policy on the specified service instance. The api does not support paging yet.
  ## 
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  let valid = call_596873.validator(path, query, header, formData, body)
  let scheme = call_596873.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596873.url(scheme.get, call_596873.host, call_596873.base,
                         call_596873.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596873, url, valid)

proc call*(call_596944: Call_QuotaByCounterKeysListByService_596680;
          quotaCounterKey: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## quotaByCounterKeysListByService
  ## Lists a collection of current quota counter periods associated with the counter-key configured in the policy on the specified service instance. The api does not support paging yet.
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  ##   quotaCounterKey: string (required)
  ##                  : Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key="boo" in the policy, then it’s accessible by "boo" counter key. But if it’s defined as counter-key="@("b"+"a")" then it will be accessible by "ba" key
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_596945 = newJObject()
  var query_596947 = newJObject()
  add(path_596945, "quotaCounterKey", newJString(quotaCounterKey))
  add(path_596945, "resourceGroupName", newJString(resourceGroupName))
  add(query_596947, "api-version", newJString(apiVersion))
  add(path_596945, "subscriptionId", newJString(subscriptionId))
  add(path_596945, "serviceName", newJString(serviceName))
  result = call_596944.call(path_596945, query_596947, nil, nil, nil)

var quotaByCounterKeysListByService* = Call_QuotaByCounterKeysListByService_596680(
    name: "quotaByCounterKeysListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/quotas/{quotaCounterKey}",
    validator: validate_QuotaByCounterKeysListByService_596681, base: "",
    url: url_QuotaByCounterKeysListByService_596682, schemes: {Scheme.Https})
type
  Call_QuotaByCounterKeysUpdate_596986 = ref object of OpenApiRestCall_596458
proc url_QuotaByCounterKeysUpdate_596988(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "quotaCounterKey" in path, "`quotaCounterKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/quotas/"),
               (kind: VariableSegment, value: "quotaCounterKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuotaByCounterKeysUpdate_596987(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates all the quota counter values specified with the existing quota counter key to a value in the specified service instance. This should be used for reset of the quota counter values.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   quotaCounterKey: JString (required)
  ##                  : Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key="boo" in the policy, then it’s accessible by "boo" counter key. But if it’s defined as counter-key="@("b"+"a")" then it will be accessible by "ba" key
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `quotaCounterKey` field"
  var valid_597006 = path.getOrDefault("quotaCounterKey")
  valid_597006 = validateParameter(valid_597006, JString, required = true,
                                 default = nil)
  if valid_597006 != nil:
    section.add "quotaCounterKey", valid_597006
  var valid_597007 = path.getOrDefault("resourceGroupName")
  valid_597007 = validateParameter(valid_597007, JString, required = true,
                                 default = nil)
  if valid_597007 != nil:
    section.add "resourceGroupName", valid_597007
  var valid_597008 = path.getOrDefault("subscriptionId")
  valid_597008 = validateParameter(valid_597008, JString, required = true,
                                 default = nil)
  if valid_597008 != nil:
    section.add "subscriptionId", valid_597008
  var valid_597009 = path.getOrDefault("serviceName")
  valid_597009 = validateParameter(valid_597009, JString, required = true,
                                 default = nil)
  if valid_597009 != nil:
    section.add "serviceName", valid_597009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597010 = query.getOrDefault("api-version")
  valid_597010 = validateParameter(valid_597010, JString, required = true,
                                 default = nil)
  if valid_597010 != nil:
    section.add "api-version", valid_597010
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

proc call*(call_597012: Call_QuotaByCounterKeysUpdate_596986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates all the quota counter values specified with the existing quota counter key to a value in the specified service instance. This should be used for reset of the quota counter values.
  ## 
  let valid = call_597012.validator(path, query, header, formData, body)
  let scheme = call_597012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597012.url(scheme.get, call_597012.host, call_597012.base,
                         call_597012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597012, url, valid)

proc call*(call_597013: Call_QuotaByCounterKeysUpdate_596986;
          quotaCounterKey: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode; serviceName: string): Recallable =
  ## quotaByCounterKeysUpdate
  ## Updates all the quota counter values specified with the existing quota counter key to a value in the specified service instance. This should be used for reset of the quota counter values.
  ##   quotaCounterKey: string (required)
  ##                  : Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key="boo" in the policy, then it’s accessible by "boo" counter key. But if it’s defined as counter-key="@("b"+"a")" then it will be accessible by "ba" key
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The value of the quota counter to be applied to all quota counter periods.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597014 = newJObject()
  var query_597015 = newJObject()
  var body_597016 = newJObject()
  add(path_597014, "quotaCounterKey", newJString(quotaCounterKey))
  add(path_597014, "resourceGroupName", newJString(resourceGroupName))
  add(query_597015, "api-version", newJString(apiVersion))
  add(path_597014, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597016 = parameters
  add(path_597014, "serviceName", newJString(serviceName))
  result = call_597013.call(path_597014, query_597015, nil, nil, body_597016)

var quotaByCounterKeysUpdate* = Call_QuotaByCounterKeysUpdate_596986(
    name: "quotaByCounterKeysUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/quotas/{quotaCounterKey}",
    validator: validate_QuotaByCounterKeysUpdate_596987, base: "",
    url: url_QuotaByCounterKeysUpdate_596988, schemes: {Scheme.Https})
type
  Call_QuotaByPeriodKeysGet_597017 = ref object of OpenApiRestCall_596458
proc url_QuotaByPeriodKeysGet_597019(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "quotaCounterKey" in path, "`quotaCounterKey` is a required path parameter"
  assert "quotaPeriodKey" in path, "`quotaPeriodKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/quotas/"),
               (kind: VariableSegment, value: "quotaCounterKey"),
               (kind: ConstantSegment, value: "/periods/"),
               (kind: VariableSegment, value: "quotaPeriodKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QuotaByPeriodKeysGet_597018(path: JsonNode; query: JsonNode;
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
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   quotaPeriodKey: JString (required)
  ##                 : Quota period key identifier.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `quotaCounterKey` field"
  var valid_597020 = path.getOrDefault("quotaCounterKey")
  valid_597020 = validateParameter(valid_597020, JString, required = true,
                                 default = nil)
  if valid_597020 != nil:
    section.add "quotaCounterKey", valid_597020
  var valid_597021 = path.getOrDefault("resourceGroupName")
  valid_597021 = validateParameter(valid_597021, JString, required = true,
                                 default = nil)
  if valid_597021 != nil:
    section.add "resourceGroupName", valid_597021
  var valid_597022 = path.getOrDefault("quotaPeriodKey")
  valid_597022 = validateParameter(valid_597022, JString, required = true,
                                 default = nil)
  if valid_597022 != nil:
    section.add "quotaPeriodKey", valid_597022
  var valid_597023 = path.getOrDefault("subscriptionId")
  valid_597023 = validateParameter(valid_597023, JString, required = true,
                                 default = nil)
  if valid_597023 != nil:
    section.add "subscriptionId", valid_597023
  var valid_597024 = path.getOrDefault("serviceName")
  valid_597024 = validateParameter(valid_597024, JString, required = true,
                                 default = nil)
  if valid_597024 != nil:
    section.add "serviceName", valid_597024
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

proc call*(call_597026: Call_QuotaByPeriodKeysGet_597017; path: JsonNode;
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

proc call*(call_597027: Call_QuotaByPeriodKeysGet_597017; quotaCounterKey: string;
          resourceGroupName: string; apiVersion: string; quotaPeriodKey: string;
          subscriptionId: string; serviceName: string): Recallable =
  ## quotaByPeriodKeysGet
  ## Gets the value of the quota counter associated with the counter-key in the policy for the specific period in service instance.
  ## Document describing how to configure the quota policies.
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-product-with-rules#a-namepolicies-ato-configure-call-rate-limit-and-quota-policies
  ##   quotaCounterKey: string (required)
  ##                  : Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key="boo" in the policy, then it’s accessible by "boo" counter key. But if it’s defined as counter-key="@("b"+"a")" then it will be accessible by "ba" key
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   quotaPeriodKey: string (required)
  ##                 : Quota period key identifier.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597028 = newJObject()
  var query_597029 = newJObject()
  add(path_597028, "quotaCounterKey", newJString(quotaCounterKey))
  add(path_597028, "resourceGroupName", newJString(resourceGroupName))
  add(query_597029, "api-version", newJString(apiVersion))
  add(path_597028, "quotaPeriodKey", newJString(quotaPeriodKey))
  add(path_597028, "subscriptionId", newJString(subscriptionId))
  add(path_597028, "serviceName", newJString(serviceName))
  result = call_597027.call(path_597028, query_597029, nil, nil, nil)

var quotaByPeriodKeysGet* = Call_QuotaByPeriodKeysGet_597017(
    name: "quotaByPeriodKeysGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/quotas/{quotaCounterKey}/periods/{quotaPeriodKey}",
    validator: validate_QuotaByPeriodKeysGet_597018, base: "",
    url: url_QuotaByPeriodKeysGet_597019, schemes: {Scheme.Https})
type
  Call_QuotaByPeriodKeysUpdate_597030 = ref object of OpenApiRestCall_596458
proc url_QuotaByPeriodKeysUpdate_597032(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "quotaCounterKey" in path, "`quotaCounterKey` is a required path parameter"
  assert "quotaPeriodKey" in path, "`quotaPeriodKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/quotas/"),
               (kind: VariableSegment, value: "quotaCounterKey"),
               (kind: ConstantSegment, value: "/periods/"),
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
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   quotaPeriodKey: JString (required)
  ##                 : Quota period key identifier.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `quotaCounterKey` field"
  var valid_597033 = path.getOrDefault("quotaCounterKey")
  valid_597033 = validateParameter(valid_597033, JString, required = true,
                                 default = nil)
  if valid_597033 != nil:
    section.add "quotaCounterKey", valid_597033
  var valid_597034 = path.getOrDefault("resourceGroupName")
  valid_597034 = validateParameter(valid_597034, JString, required = true,
                                 default = nil)
  if valid_597034 != nil:
    section.add "resourceGroupName", valid_597034
  var valid_597035 = path.getOrDefault("quotaPeriodKey")
  valid_597035 = validateParameter(valid_597035, JString, required = true,
                                 default = nil)
  if valid_597035 != nil:
    section.add "quotaPeriodKey", valid_597035
  var valid_597036 = path.getOrDefault("subscriptionId")
  valid_597036 = validateParameter(valid_597036, JString, required = true,
                                 default = nil)
  if valid_597036 != nil:
    section.add "subscriptionId", valid_597036
  var valid_597037 = path.getOrDefault("serviceName")
  valid_597037 = validateParameter(valid_597037, JString, required = true,
                                 default = nil)
  if valid_597037 != nil:
    section.add "serviceName", valid_597037
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597038 = query.getOrDefault("api-version")
  valid_597038 = validateParameter(valid_597038, JString, required = true,
                                 default = nil)
  if valid_597038 != nil:
    section.add "api-version", valid_597038
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

proc call*(call_597040: Call_QuotaByPeriodKeysUpdate_597030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing quota counter value in the specified service instance.
  ## 
  let valid = call_597040.validator(path, query, header, formData, body)
  let scheme = call_597040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597040.url(scheme.get, call_597040.host, call_597040.base,
                         call_597040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597040, url, valid)

proc call*(call_597041: Call_QuotaByPeriodKeysUpdate_597030;
          quotaCounterKey: string; resourceGroupName: string; apiVersion: string;
          quotaPeriodKey: string; subscriptionId: string; parameters: JsonNode;
          serviceName: string): Recallable =
  ## quotaByPeriodKeysUpdate
  ## Updates an existing quota counter value in the specified service instance.
  ##   quotaCounterKey: string (required)
  ##                  : Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key="boo" in the policy, then it’s accessible by "boo" counter key. But if it’s defined as counter-key="@("b"+"a")" then it will be accessible by "ba" key
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   quotaPeriodKey: string (required)
  ##                 : Quota period key identifier.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The value of the Quota counter to be applied on the specified period.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  var path_597042 = newJObject()
  var query_597043 = newJObject()
  var body_597044 = newJObject()
  add(path_597042, "quotaCounterKey", newJString(quotaCounterKey))
  add(path_597042, "resourceGroupName", newJString(resourceGroupName))
  add(query_597043, "api-version", newJString(apiVersion))
  add(path_597042, "quotaPeriodKey", newJString(quotaPeriodKey))
  add(path_597042, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_597044 = parameters
  add(path_597042, "serviceName", newJString(serviceName))
  result = call_597041.call(path_597042, query_597043, nil, nil, body_597044)

var quotaByPeriodKeysUpdate* = Call_QuotaByPeriodKeysUpdate_597030(
    name: "quotaByPeriodKeysUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/quotas/{quotaCounterKey}/periods/{quotaPeriodKey}",
    validator: validate_QuotaByPeriodKeysUpdate_597031, base: "",
    url: url_QuotaByPeriodKeysUpdate_597032, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
